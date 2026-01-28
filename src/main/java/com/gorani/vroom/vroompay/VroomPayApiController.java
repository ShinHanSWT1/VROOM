package com.gorani.vroom.vroompay;

import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
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

    @PostMapping("/charge")
    public Map<String, Object> charge(@RequestBody Map<String, Object> request, HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        Long userId = loginUser.getUserId();

        if (request.get("amount") == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "충전 금액이 입력되지 않았습니다.");
            return error;
        }

        BigDecimal amount = new BigDecimal(request.get("amount").toString());
        String bankName = (String) request.get("bankName");
        if(bankName == null || bankName.isEmpty()) {
            bankName = "은행";
        }

        return vroomPayService.charge(userId, amount, bankName + "에서 충전");
    }

    @PostMapping("/withdraw")
    public Map<String, Object> withdraw(@RequestBody Map<String, Object> request, HttpSession session) {
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        Long userId = loginUser.getUserId();

        if (request.get("amount") == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "출금 금액이 입력되지 않았습니다.");
            return error;
        }

        BigDecimal amount = new BigDecimal(request.get("amount").toString());
        return vroomPayService.withdraw(userId, amount);
    }
}
