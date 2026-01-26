package com.gorani.vroom.pay;

import com.gorani.vroom.user.auth.UserVO;
import com.gorani.vroom.user.profile.UserProfileService;
import com.gorani.vroom.user.profile.UserProfileVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/pay")
@RequiredArgsConstructor
public class WalletController {
    private final WalletService walletService;
    private final UserProfileService userProfileService;

    // 부름페이 페이지
    @GetMapping("/vroomPay")
    public String vroomPayPage(HttpSession session,  Model model) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");

        if (loginUser == null) {
            return "redirect:/auth/login";
        }
        Long userId = loginUser.getUserId();

        // 지갑 정보
        WalletVO account = walletService.getOrCreateAccount(userId);
        model.addAttribute("account", account);

        // 프로필 정보 (닉네임, 프로필 이미지, 매너온도)
        UserProfileVO profile = userProfileService.getUserProfile(userId);
        model.addAttribute("profile", profile);

        return "pay/vroomPay";
    }
}
