package com.gorani.vroom.errand.assignment;

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
     * 채팅방은 ChatController에서 자동 생성됨
     */
    @PostMapping("/errand/assign/request")
    public String requestStartChat(
            @RequestParam("errandsId") Long errandsId,
            HttpSession session
    ) {
        // 세션 확인
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }
        
        Long erranderUserId = loginUser.getUserId();
        System.out.println("errandsId" + errandsId);
        System.out.println("userId = " + loginUser.getUserId());
        System.out.println("role = " + loginUser.getRole());
        
        Long roomId = errandAssignmentService.requestStartChat(errandsId, erranderUserId, erranderUserId);
        return "redirect:/errand/chat/room?roomId=" + roomId;
    }
}