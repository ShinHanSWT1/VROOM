package com.gorani.vroom.admin.auth;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import javax.servlet.http.HttpSession;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AuthController {

    private final AuthService service;

    @GetMapping({"/admin/login", "/"})
    public String login() {

        return "admin/login";
    }

    @PostMapping("/admin/login")
    public String login(HttpSession session, @ModelAttribute AdminVO vo, Model model) {

        try {
            AdminVO adminVO = service.login(vo);

            session.setAttribute("loginAdmin", adminVO);
            model.addAttribute("result", "success");
            model.addAttribute("url", "dashboard");
            model.addAttribute("message", "로그인 성공! 관리자 페이지로 이동합니다");
            model.addAttribute("subMessage", "잠시만 기다려주세요...");
        } catch (IllegalArgumentException exception) {

            model.addAttribute("result", "fail");
            model.addAttribute("message", exception.getMessage());
            model.addAttribute("subMessage", "아이디와 비밀번호를 확인해주세요");
            model.addAttribute("url", "login");
        }


        return "common/return";
    }

}
        

