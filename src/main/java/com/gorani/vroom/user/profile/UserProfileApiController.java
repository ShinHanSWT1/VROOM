package com.gorani.vroom.user.profile;

import com.gorani.vroom.user.auth.UserVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.PublicKey;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/profile")
public class UserProfileApiController {

    private final UserProfileService userProfileService;

    @Autowired
    public UserProfileApiController(UserProfileService userProfileService) {
        this.userProfileService = userProfileService;
    }

    // 프로필 조회
    @GetMapping
    public ResponseEntity<UserProfileVO> getProfile(HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        Long userId =  loginUser.getUserId();
        UserProfileVO profile = userProfileService.getUserProfile(userId);
        return ResponseEntity.ok(profile);
    }

    // 닉네임 수정
    @PutMapping("/nickname")
    public ResponseEntity<Map<String, Object>> updateNickname(@RequestBody Map<String, String> request,  HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        // 로그인이 안된 상태에서 api 호출하면 응답 보내기.
        if (loginUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
        Long userId = loginUser.getUserId();
        String nickname = request.get("nickname");

        UserProfileVO vo = new UserProfileVO();
        vo.setNickname(nickname);
        userProfileService.updateProfile(userId, vo);

        return ResponseEntity.ok(Map.of("success", true, "nickname", nickname));
    }

    // 프로필 이미지 수정
    @PostMapping("/image")
    public ResponseEntity<Map<String, Object>> updateImage(@RequestParam("file") MultipartFile file) {
        Long userId = 2L; // 테스트용

        // 파일 유효성 검사
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "파일이 없습니다."));
        }

        // 이미지 파일인지 확인
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "이미지 파일만 업로드 가능합니다."));
        }

        try {
            String imagePath = userProfileService.saveProfileImage(userId, file);
            log.info("프로필 이미지 업로드 성공: {}", imagePath);
            return ResponseEntity.ok(Map.of("success", true, "imagePath", imagePath));
        } catch (IOException e) {
            log.error("프로필 이미지 업로드 실패", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("success", false, "message", "파일 저장 중 오류가 발생했습니다."));
        }
    }

    // 내가 신청한 심부름 목록 조회
    @GetMapping("/errands")
    public ResponseEntity<List<ErrandsVO>> getMyErrands() {
        Long userId = 2L; // 테스트용
        List<ErrandsVO> errands = userProfileService.getMyErrands(userId);
        return ResponseEntity.ok(errands);
    }

    // 신고 등록
    @PostMapping("/report")
    public ResponseEntity<Map<String, Object>> createRepost(@RequestBody Map<String, Object> request) {
        Long userId = 2L; // 테스트용

        try {
            // vo 객체 생성 및 데이터 매핑
            IssueTicketVO ticket = new IssueTicketVO();

            // 신고자 ID 설정
            ticket.setUserId(userId);

            // Map에서 데이터 꺼내기
            // JSON으로 넘어온 숫자는 Integer 로 인식이 될 수 있으니 String 변환 후 Long 파싱
            if (request.get("errandId") != null) {
                ticket.setErrandId(Long.valueOf(String.valueOf(request.get("errandId"))));
            }
            ticket.setTitle((String) request.get("title"));
            ticket.setContent((String) request.get("content"));
            ticket.setType((String) request.get("type")); // "ERRAND_ISSUE" 등

            // 기본값 설정
            ticket.setPriority("MEDIUM");
            ticket.setStatus("RECEIVED"); // XML에서 하드코딩 했으므로 생략 가능하나 명시적 세팅 추천

            // 서비스 호출
            // (서비스 내부에서 errandId 를 통해 targetUserId 를 찾아서 저장)
            userProfileService.createIssueTicket(ticket);

            return ResponseEntity.ok(Map.of("success", true, "message", "신고가 접수되었습니다."));
        } catch (Exception e) {
            log.error("신고 등록 실패", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "서버 오류가 발생했습니다."));
        }
    }

    // 회원 탈퇴
    @PostMapping("/withdraw")
    public ResponseEntity<Map<String, Object>> withdrawUser(@RequestBody Map<String, String> request) {
        Long userId = 2L; // 테스트용
        String password = request.get("password");

        if (password == null || password.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "message", "비밀번호를 입력해주세요."));
        }

        boolean result = userProfileService.withdrawUser(userId, password);

        if (result) {
            return ResponseEntity.ok(Map.of("success", true, "message", "회원 탈퇴가 완료되었습니다."));
        } else {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "message", "비밀번호가 일치하지 않습니다."));
        }
    }
}

