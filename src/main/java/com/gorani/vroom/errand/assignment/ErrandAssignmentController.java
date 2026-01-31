package com.gorani.vroom.errand.assignment;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import com.gorani.vroom.user.auth.UserVO;

import lombok.RequiredArgsConstructor;

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

        Long runnerUserId = loginUser.getUserId();

        try {
            Long roomId = errandAssignmentService.requestStartChat(errandsId, runnerUserId, runnerUserId);

            // roomId가 null이면 상태전환 실패(이미 다른 부름이가 선점 등)로 보고 처리
            if (roomId == null) {
                String msg = URLEncoder.encode("이미 다른 부름이가 채팅을 시작한 심부름입니다.", StandardCharsets.UTF_8);
                return "redirect:/errand/detail?errandsId=" + errandsId + "&message=" + msg;
            }

            return "redirect:/errand/chat/room?roomId=" + roomId;

        } catch (Exception e) {
            // 예외는 사용자에게 부드럽게 안내
            String msg = URLEncoder.encode("채팅 시작에 실패했습니다. 잠시 후 다시 시도해주세요.", StandardCharsets.UTF_8);
            return "redirect:/errand/detail?errandsId=" + errandsId + "&message=" + msg;
        }
    }
    
    /**
     * 부름이 거래완료(인증사진 업로드)
     * - CONFIRMED1 상태에서만 업로드 가능
     * - 업로드 성공 시 CONFIRMED2로 변경(주인님 설계대로)
     */
    @PostMapping("/errand/assign/complete-proof")
    @ResponseBody
    public Map<String, Object> uploadCompleteProof(
            @RequestParam("errandsId") Long errandsId,
            @RequestParam("roomId") Long roomId,
            @RequestParam("proofImage") MultipartFile proofImage,
            HttpSession session
    ) {
        Map<String, Object> result = new HashMap<>();

        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            result.put("success", false);
            result.put("error", "로그인이 필요합니다.");
            return result;
        }

        // RUNNER만 가능
        String role = loginUser.getRole();
        if (role == null || "OWNER".equals(role)) {
            result.put("success", false);
            result.put("error", "부름이만 인증 업로드가 가능합니다.");
            return result;
        }

        Long runnerUserId = loginUser.getUserId();

        try {
            errandAssignmentService.uploadCompleteProof(errandsId, roomId, runnerUserId, proofImage);
            result.put("success", true);
            return result;

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("error", e.getMessage());
            return result;
        }
    }
}
