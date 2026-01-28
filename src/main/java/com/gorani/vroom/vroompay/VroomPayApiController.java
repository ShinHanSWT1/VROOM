package com.gorani.vroom.vroompay;

import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/vroompay")
@RequiredArgsConstructor
public class VroomPayApiController {

    private final VroomPayService vroomPayService;

    @GetMapping("/status")
    public Map<String, Object> getAccountStatus(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");

        if (loginUser == null) {
            result.put("success", false);
            result.put("linked", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        Long userId = loginUser.getUserId();
        return vroomPayService.getAccountStatus(userId);
    }

    @PostMapping("/create")
    public Map<String, Object> createAccount(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");

        if (loginUser == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        Long userId = loginUser.getUserId();
        String username = loginUser.getNickname();

        return vroomPayService.linkAccount(userId, username);
    }
}
