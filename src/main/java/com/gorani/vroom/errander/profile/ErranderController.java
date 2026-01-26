package com.gorani.vroom.errander.profile;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/errander") // 모든 주소 앞에 /errander가 자동으로 붙음
@RequiredArgsConstructor
public class ErranderController {

    private final ErranderService erranderService;

    //  나의 정보
    @GetMapping("/mypage/profile")
    public String profile(Model model) {

        Long userId = 2L; // 테스트용 (TODO: 세션에서 로그인 사용자 ID 가져오기)


        // 서비스 호출 시 user_id 만 넘겨
        ErranderProfileVO profile = erranderService.getErranderProfile(userId);

        // (옵션) 부름이 등록 안 된 유저라면 등록 페이지로 보내기 -> 혹시 필요할까봐.
        if (profile == null) {
            // return "redirect:/errander/register";
        }

        model.addAttribute("profile", profile);
        return "errander/profile";
    }

    // 나의 거래
    @GetMapping("/mypage/activity")
    public String activity() {
        return "errander/activity";
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