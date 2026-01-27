package com.gorani.vroom.user.profile;

import com.gorani.vroom.errander.profile.ErranderProfileVO;
import com.gorani.vroom.errander.profile.ErranderService;
import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class RoleSwitchController {

    private final ErranderService erranderService;

    // 심부름꾼 등록 여부 및 승인 상태 확인
    @ResponseBody
    @GetMapping("/errander/check")
    public ResponseEntity<Map<String, Object>> checkErrander(HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        Map<String, Object> response = new HashMap<>();

        if (loginUser == null) {
            response.put("isRegistered", false);
            return ResponseEntity.ok(response);
        }

        ErranderProfileVO profile = erranderService.getErranderProfile(loginUser.getUserId());
        
        if (profile == null) {
            response.put("isRegistered", false);
        } else {
            response.put("isRegistered", true);
            response.put("approvalStatus", profile.getApprovalStatus());
        }

        return ResponseEntity.ok(response);
    }

    // 심부름꾼으로 전환
    @GetMapping("/errander/switch")
    public String switchToErrander(HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        
        if (loginUser != null) {
            // 전환 전 한 번 더 체크 (선택 사항)
            ErranderProfileVO profile = erranderService.getErranderProfile(loginUser.getUserId());
            if (profile != null && "APPROVED".equals(profile.getApprovalStatus())) {
                loginUser.setRole("ERRANDER");
                session.setAttribute("loginSess", loginUser);
            }
        }
        
        return "redirect:/vroom";
    }

    // 사용자로 전환
    @GetMapping("/user/switch")
    public String switchToUser(HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        
        if (loginUser != null) {
            loginUser.setRole("USER");
            session.setAttribute("loginSess", loginUser);
        }
        
        return "redirect:/vroom";
    }
}
