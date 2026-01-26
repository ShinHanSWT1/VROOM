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

        return "redirect:/errand/detail?errandsId=" + errandsId;
    }
}
