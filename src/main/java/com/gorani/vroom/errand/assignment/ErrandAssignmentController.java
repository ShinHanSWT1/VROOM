package com.gorani.vroom.errand.assignment;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gorani.vroom.user.auth.UserVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ErrandAssignmentController {

    private final ErrandAssignmentService errandAssignmentService;

    @PostMapping("/errand/assign/request")
    public String requestStartChat(
            @RequestParam("errandsId") Long errandsId,
            HttpSession session
    ) {
        // 세션 키 불일치 대비: loginSess 우선, 없으면 userId fallback
        Long userId = null;

        Object loginSessObj = session.getAttribute("loginSess");
        if (loginSessObj instanceof UserVO) {
            userId = ((UserVO) loginSessObj).getUserId();
        } else {
            Object userIdObj = session.getAttribute("userId");
            if (userIdObj != null) userId = Long.valueOf(userIdObj.toString());
        }

        if (userId == null) {
            return "redirect:/auth/login";
        }

        errandAssignmentService.requestStartChat(errandsId, userId, userId);

        // 채팅 화면으로 리다이렉트
        return "redirect:/errand/chat?errandsId=" + errandsId;
    }

    @GetMapping("/errand/chat")
    public String showChatPage(
            @RequestParam("errandsId") Long errandsId,
            HttpSession session,
            Model model
    ) {
        // 세션 확인
        Long userId = null;

        Object loginSessObj = session.getAttribute("loginSess");
        if (loginSessObj instanceof UserVO) {
            userId = ((UserVO) loginSessObj).getUserId();
        } else {
            Object userIdObj = session.getAttribute("userId");
            if (userIdObj != null) userId = Long.valueOf(userIdObj.toString());
        }

        if (userId == null) {
            return "redirect:/auth/login";
        }

        // 심부름 정보를 모델에 추가 (실제로는 서비스에서 가져와야 함)
        model.addAttribute("errandsId", errandsId);
        model.addAttribute("userId", userId);

        return "errand/errand_chat";
    }
}