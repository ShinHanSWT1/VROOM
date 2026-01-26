package com.gorani.vroom.user.auth;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.bind.annotation.ResponseBody;
import java.util.List;
import java.util.Map;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AuthController {

    // 회원가입/인증 비즈니스 로직 담당 서비스
    private final AuthService authService;

    // ===================== 회원가입 =====================

    // 회원가입 페이지
    @GetMapping("/auth/signup")
    public String signupForm() {
        return "user/signup";
    }

    @PostMapping("/auth/signup")
    @ResponseBody
    public Map<String, Object> signup(UserVO vo,
                                      @RequestParam(required = false) MultipartFile profile) {

        try {
            authService.signup(vo, profile);

            return Map.of(
                    "success", true,
                    "message", "회원가입이 완료되었습니다."
            );

        } catch (IllegalArgumentException e) {
            log.info("catch:"+e.getMessage());
            return Map.of(
                    "success", false,
                    "code", "INVALID_INPUT",
                    "message", e.getMessage()
            );

        } catch (Exception e) {
            log.error("회원가입 서버 오류", e);
            log.error("회원가입 오류", e);
            return Map.of(
                    "success", false,
                    "code", "SERVER_ERROR",
                    "message", "회원가입 중 오류가 발생했습니다."
            );
        }
    }


    // ===================== 로그인 =====================

    // 로그인 페이지
    @GetMapping("/auth/login")
    public String loginForm() {
        return "user/login";
    }

    // 로그인 처리
    @PostMapping("/auth/login")
    public String login(UserVO vo, Model model, HttpSession sess) {
        UserVO userVo = authService.login(vo);

        if (userVo == null) {
            log.warn("로그인 실패 - email: {}", vo.getEmail());// 로그인실패
            model.addAttribute("message", "아이디 비밀번호가 올바르지 않습니다.");
            model.addAttribute("subMessage", "로그인 창으로 이동합니다.");
            model.addAttribute("result", "fail");
            model.addAttribute("url", "/auth/login");
        } else { // 로그인 성공
            log.info("로그인 성공 - userId: {}, email: {}", userVo.getUserId(), userVo.getEmail());
            sess.setAttribute("loginSess", userVo);
            sess.setAttribute("viewMode", "USER");

            model.addAttribute("message", "로그인 성공!");
            model.addAttribute("subMessage", "VROOM으로 이동합니다.");
            model.addAttribute("result", "success");
            model.addAttribute("url", "/");
        }

        return "common/return";
    }

    // 로그아웃
    @GetMapping("/auth/logout")
    public String logout(Model model, HttpSession sess) {
        //sess.invalidate(); // 세션초기화
        sess.removeAttribute("loginSess"); // 로그인세션 삭제
        sess.removeAttribute("viewMode");
        model.addAttribute("message", "로그아웃되었습니다.");
        model.addAttribute("subMessage", "VROOM으로 이동합니다.");
        model.addAttribute("result", "success");
        model.addAttribute("url", "/");
        return "common/return";
    }

    // ===================== 중복 체크 (AJAX) =====================

    // 이메일 중복 체크
    @GetMapping("/auth/check-email")
    @ResponseBody
    public boolean checkEmail(@RequestParam String email) {
        return authService.existsEmail(email);
    }

    // 전화번호 중복 체크
    @GetMapping("/auth/check-phone")
    @ResponseBody
    public boolean checkPhone(@RequestParam String phone) {
        return authService.existsPhone(phone);
    }

}