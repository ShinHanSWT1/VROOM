package com.gorani.vroom.errand.assignment;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
@RequiredArgsConstructor
public class ErrandAssignmentController {

    private final ErrandAssignmentService errandAssignmentService;

    /**
     * 부름이가 채팅하기 버튼을 눌러 채팅을 시작하는 엔드포인트
     * - WAITING -> MATCHED 전환(성공 시)
     * - 채팅방 생성/조회 후 roomId 반환
     */
    @PostMapping("/errand/assign/request")
    public String requestStartChat(
            @RequestParam("errandsId") Long errandsId,
            HttpSession session
    ) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }

        // 역할 체크: "부름이"만 채팅 시작 가능하게 막기
        String role = loginUser.getRole();
        if (role == null || "OWNER".equals(role)) {
            String msg = URLEncoder.encode("작성자는 채팅 시작 버튼을 누를 수 없습니다.", StandardCharsets.UTF_8);
            return "redirect:/errand/detail?errandsId=" + errandsId + "&message=" + msg;
        }

        Long erranderUserId = loginUser.getUserId();

        try {
            Long roomId = errandAssignmentService.requestStartChat(errandsId, erranderUserId, erranderUserId);

            // roomId가 null이면 상태전환 실패(이미 다른 부름이가 선점 등)로 보고 처리
            if (roomId == null) {
                String msg = URLEncoder.encode("이미 다른 부름이가 채팅을 시작한 심부름입니다.", StandardCharsets.UTF_8);
                return "redirect:/errand/detail?errandsId=" + errandsId + "&message=" + msg;
            }

            return "redirect:/errand/chat/room?roomId=" + roomId;

        } catch (Exception e) {
            // 예외는 사용자에게 부드럽게 안내
            String msg = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
            return "redirect:/errand/detail?errandsId=" + errandsId + "&message=" + msg;
        }
    }
    
    @PostMapping("/errand/chat/assign/complete-proof")
    @ResponseBody
    public ResponseEntity<?> uploadCompleteProof(
            @RequestParam("errandsId") Long errandsId,
            @RequestParam("roomId") Long roomId,
            @RequestParam("file") MultipartFile file,
            HttpSession session
    ) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return ResponseEntity.status(401)
                    .body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }

        if (file == null || file.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "message", "파일이 비었습니다."));
        }

        Long erranderId = loginUser.getUserId();

        try {
            // 모든 로직은 서비스에서
            errandAssignmentService.uploadCompleteProof(
                    errandsId, roomId, erranderId, file
            );

            return ResponseEntity.ok(Map.of("success", true));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body(Map.of("success", false, "message", e.getMessage()));
        }
    }
}
