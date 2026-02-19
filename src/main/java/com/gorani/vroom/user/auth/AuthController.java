package com.gorani.vroom.user.auth;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.bind.annotation.ResponseBody;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AuthController {

    // 회원가입/인증 비즈니스 로직 담당 서비스
    private final AuthService authService;
    private final KakaoOAuthClient kakaoOAuthClient;

    // =====================================================
    // ====================== SIGNUP =======================
    // =====================================================

    /**
     * 회원가입 화면 진입 (GET)
     *
     * 역할:
     * 1. 일반 회원가입 화면 렌더링
     * 2. OAuth(카카오) 로그인 후 추가 회원가입이 필요한 경우,
     *    콜백 단계에서 session에 임시 저장해둔 oauthSignupUser를
     *    꺼내서 signup.jsp에 전달
     *
     * 주의:
     * - 여기서는 "저장"을 하지 않는다
     * - 이미 session에 저장된 값을 "조회"만 한다
     * - 실제 OAuth 처리 / 분기 판단은 kakaoCallback에서 끝난 상태
     */

    // 회원가입 페이지
    @GetMapping("/auth/signup")
    public String signupForm(HttpSession session, Model model) {

        // OAuth 추가가입용: 카카오 콜백에서 담아둔 값이 있으면 화면에 내려줌
        UserVO oauthUser = (UserVO) session.getAttribute("oauthSignupUser");
        if (oauthUser != null) {    // OAuth 경로로 진입한 경우에만
            // signup.jsp에서 nickname, email 등을 미리 채워주기 위해 model에 전달
            model.addAttribute("oauthUser", oauthUser);
        }

        return "user/signup";
    }

    @PostMapping("/auth/signup")
    @ResponseBody
    public Map<String, Object> signup(UserVO vo,
                                      @RequestParam(required = false) MultipartFile profile,
                                      HttpSession session) {

        System.out.println("🔥 /auth/signup 컨트롤러 진입");

        // =================== OAuth 병합용 세션 조회 ===================
        // - 카카오 콜백에서 임시로 담아둔 oauthSignupUser가 있으면 OAuth 가입 흐름
        // - 여기서는 "조회"만 하고, 병합/저장은 Service에서 처리한다 (책임 분리)
        UserVO oauthUser = (UserVO) session.getAttribute("oauthSignupUser");

        try {
            // =================== 회원가입 처리 (LOCAL / OAuth 공통 진입점) ===================
            System.out.println("🔥 AuthService.signup() 호출 직전");
            authService.signup(vo, profile, oauthUser);
            System.out.println("🔥 AuthService.signup() 정상 종료");

            // =================== OAuth 임시 세션 정리 ===================
            // - OAuth로 들어온 가입이 성공했다면 임시 데이터는 즉시 제거 (중복 가입 방지)
            if (oauthUser != null) {
                session.removeAttribute("oauthSignupUser");
            }

            return Map.of(
                    "success", true,
                    "message", "회원가입이 완료되었습니다."
            );

        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            log.info("catch:" + e.getMessage());
            return Map.of(
                    "success", false,
                    "code", "INVALID_INPUT",
                    "message", e.getMessage()
            );

        } catch (Exception e) {
            e.printStackTrace();
            log.error("회원가입 서버 오류", e);
            return Map.of(
                    "success", false,
                    "code", "SERVER_ERROR",
                    "message", "회원가입 중 오류가 발생했습니다."
            );
        }
    }

    // =====================================================
    // ================ SIGNUP DONE (LANDING) ===============
    // =====================================================

    @GetMapping("/auth/signup-done")
    public String signupDone(HttpSession session, Model model) {

        // OAuth 임시 세션 정리 (최종 성공 지점)
        session.removeAttribute("oauthSignupUser");

        model.addAttribute("message", "회원가입이 완료되었습니다!");
        model.addAttribute("subMessage", "로그인 페이지로 이동합니다.");
        model.addAttribute("result", "success");
        model.addAttribute("url", "auth/login");

        return "common/return";
    }


    // =====================================================
    // ======================= LOGIN =======================
    // =====================================================


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
            model.addAttribute("url", "auth/login");
        } else { // 로그인 성공
            log.info("로그인 성공 - userId: {}, email: {}", userVo.getUserId(), userVo.getEmail());
            userVo.setRole("USER");
            sess.setAttribute("loginSess", userVo);
            sess.setAttribute("viewMode", "USER");

            model.addAttribute("message", "로그인 성공!");
            model.addAttribute("subMessage", "VROOM으로 이동합니다.");
            model.addAttribute("result", "success");
            model.addAttribute("url", "");
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
        model.addAttribute("url", "");
        return "common/return";
    }


    // =====================================================
    // =================== VALIDATION(AJAX) ================
    // =====================================================

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

    // 닉네임 중복 체크
    @GetMapping("/auth/check-nickname")
    @ResponseBody
    public boolean checkNickname(@RequestParam String nickname) {
        return authService.existsNickname(nickname);
    }


    // =====================================================
    // =================== OAuth (Kakao) ===================
    // =====================================================

    /**
     * 카카오 로그인 요청 진입점
     * - 카카오 인증 서버로 리다이렉트
     */
    @GetMapping("/auth/kakao/login")
    public String kakaoLogin(HttpServletRequest request, HttpSession session) {

        // 1) 이번 요청에서 사용할 redirectUri를 동적으로 계산
        String redirectUri = kakaoOAuthClient.buildRedirectUri(request);

        // 2) authorize 단계에서 쓴 redirectUri를 token 단계에서도 써야 하므로 세션에 저장
        session.setAttribute("kakaoRedirectUri", redirectUri);

        // 3) 카카오 인증 URL 생성 (redirectUri를 인자로 넘김)
        return "redirect:" + kakaoOAuthClient.getKakaoAuthUrl(redirectUri);
    }

    /**
     * 카카오 로그인 콜백
     * - 인가 코드(code) 수신
     * - Service에서 로그인 / 회원가입 분기 처리
     * kakao/callback: “OAuth 인증/토큰/유저정보 획득 → 로그인/추가가입 필요 판정 → redirect”
     */
    @GetMapping("/auth/kakao/callback")
    public String kakaoCallback(@RequestParam String code,
                                HttpSession session) {

        KakaoLoginResult result =
                authService.kakaoLogin(code, session);

        if (result == KakaoLoginResult.LOGIN_SUCCESS) {
            return "redirect:/";
        }

        // 추가 정보 입력이 필요한 경우
        return "redirect:/auth/signup";
    }
}