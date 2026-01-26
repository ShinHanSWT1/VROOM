package com.gorani.vroom.errander.profile;

import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/errander") // 모든 주소 앞에 /errander가 자동으로 붙음
@RequiredArgsConstructor
public class ErranderController {

    private final ErranderService erranderService;

    //  나의 정보
    @GetMapping("/mypage/profile")
    public String profile(Model model, HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            return "redirect:/auth/login";
        }
        // 로그인 상태
        Long userId = loginUser.getUserId();



        // 서비스 호출 시 user_id 만 넘겨
        ErranderProfileVO profile = erranderService.getErranderProfile(userId);
        if(profile == null){
            //TODO: 라이더 아니면 라이더 등록하게 해야 하는 페이지 필요.
            return "redirect:/errander/register";
        }
        model.addAttribute("profile", profile);
        return "errander/profile";
    }

    // 부름 페이
    @GetMapping("/mypage/pay")
    public String pay() {
        return "errander/pay";
    }

    // 설정
    @GetMapping("/mypage/settings")
    public String settings() {
        return "errander/settings";
    }

    // 나의 거래 상세 심부름 관련 글 누르면 이동
    @GetMapping("/mypage/activity_detail")
    public String activityDetail(@RequestParam("id") Long vroomId, Model model){
        // TODO : vroomID 로 거래 상세 정보 조회해서 담기
        model.addAttribute("vroomId", vroomId);
        return  "errander/activity_detail";
    }
}