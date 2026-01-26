package com.gorani.vroom.user.profile;

import com.gorani.vroom.user.auth.UserVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;

@Controller
public class RoleSwitchController {

    // 심부름꾼으로 전환
    @GetMapping("/errander/switch")
    public String switchToErrander(HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        
        if (loginUser != null) {
            loginUser.setRole("ERRANDER");
            session.setAttribute("loginSess", loginUser);
        }
        
        return "redirect:/errander/mypage/profile";
    }

    // 사용자로 전환
    @GetMapping("/user/switch")
    public String switchToUser(HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        
        if (loginUser != null) {
            loginUser.setRole("USER");
            session.setAttribute("loginSess", loginUser);
        }
        
        return "redirect:/member/myInfo";
    }
}
