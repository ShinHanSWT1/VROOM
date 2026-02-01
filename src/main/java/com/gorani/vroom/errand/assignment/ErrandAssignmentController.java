package com.gorani.vroom.errand.assignment;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
}
