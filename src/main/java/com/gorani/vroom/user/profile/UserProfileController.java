package com.gorani.vroom.user.profile;

import com.gorani.vroom.user.auth.UserVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;

@Slf4j
@Controller
public class UserProfileController {

    // 캡슐화
    private final UserProfileService userProfileService;

    @Autowired
    public UserProfileController(UserProfileService userProfileService) {
        this.userProfileService = userProfileService;
    }

    // 나의 정보 페이지
    @GetMapping("/member/myInfo")
    public String userProfile(Model model) {
        Long userId = 2L; // 테스트용 (성준)
        UserProfileVO profile = userProfileService.getUserProfile(userId);
        model.addAttribute("profile", profile);

        // 내가 신청한 심부름 목록
        model.addAttribute("errands", userProfileService.getMyErrands(userId));

        log.info("조회된 프로필 정보: {}", profile);
        return "user/myInfo";
    }

    // 나의 활동
    @GetMapping("/member/myActivity")
    public String myActivity(Model model) {
        return "user/myActivity";
    }

    // 부름 페이
    @GetMapping("/member/vroomPay")
    public String vroomPay(Model model) {
        return "user/vroomPay";
    }

    // 프로필 수정 페이지
    @GetMapping("/member/edit")
    public String editPage(Model model) {
        // TODO: 세션에서 로그인 사용자 ID 가져오기
        // TODO: 프로필 정보 조회 후 model에 담기
        return "mypage/profileEdit";
    }

    // 사용자로 전환
    @GetMapping("/user/switch")
    public String switchToUser(HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        
        if (loginUser != null) {
            loginUser.setRole("USER");
            session.setAttribute("loginSess", loginUser);
            log.info("Role switched to: {}", loginUser.getRole());
        }
        
        return "redirect:/";
    }
}
