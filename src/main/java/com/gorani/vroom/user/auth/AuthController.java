package com.gorani.vroom.user.auth;

import com.gorani.vroom.user.UserVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    // 회원가입 처리
    @PostMapping("/auth/signup")
    public String signup(UserVO vo,
                         @RequestParam MultipartFile profile, // DB에 저장할 대상이 아니라, 처리(저장) 후 버려지는 객체
                         HttpServletResponse res,
                         Model model,
                         RedirectAttributes ra,
                         HttpServletRequest req
    ) throws Exception {

        System.out.println("vo:"+vo);
        int r = authService.signup(vo, profile);

        if (r > 0) {
//			model.addAttribute("msg", "회원가입되었습니다.");
//			model.addAttribute("cmd", "move");
//			model.addAttribute("url", "signup");
            ra.addFlashAttribute("msg", "회원가입되었습니다."); // 일회성
        } else {
//			model.addAttribute("msg", "회원가입오류");
//			model.addAttribute("cmd", "back");
            ra.addFlashAttribute("msg", "회원가입오류.");
        }

        //return "common/return";

//		// 서블릿으로 응답
//		res.setContentType("text/html;charset=utf-8");
//		PrintWriter out = res.getWriter();
//		out.print("<script>");
//		if (r > 0) { // 정상적으로 등록
//			out.print("alert('회원가입되었습니다.');");
//			out.print("location.href='signup';");
//		} else {
//			out.print("alert('회원가입오류');");
//			out.print("history.back();");
//		}
//		out.print("</script>");

        return "redirect:/auth/login";
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
        String page = "";
        if (userVo == null) {
            log.warn("로그인 실패 - email: {}", vo.getEmail());// 로그인실패
            model.addAttribute("msg", "아이디 비밀번호가 올바르지 않습니다.");
            model.addAttribute("cmd", "back");
            page = "common/return";
        } else { // 로그인 성공
            log.info("로그인 성공 - userId: {}, email: {}", userVo.getUserId(), userVo.getEmail());
            sess.setAttribute("loginSess", userVo);
            sess.setAttribute("viewMode", "USER");
            page = "redirect:/";
        }
        return page;
    }

    // 로그아웃
    @GetMapping("/auth/logout")
    public String logout(Model model, HttpSession sess) {
        //sess.invalidate(); // 세션초기화
        sess.removeAttribute("loginSess"); // 로그인세션 삭제
        sess.removeAttribute("viewMode");
        model.addAttribute("msg", "로그아웃되었습니다.");
        model.addAttribute("cmd", "move");
        model.addAttribute("url", "/test/user");
        return "common/return";
    }
}