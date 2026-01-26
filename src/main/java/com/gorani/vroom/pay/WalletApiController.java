package com.gorani.vroom.pay;

import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/wallet")
@RequiredArgsConstructor
public class WalletApiController {

    private final WalletService walletService;

    // 잔액 조회
    @GetMapping("/balance")
    public Map<String, Object> getBalance(HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        // 1. 세션 체크 (UserVO 객체로 형변환)
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");
        if (loginUser == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        Long userId = loginUser.getUserId();

        WalletVO account = walletService.getOrCreateAccount(userId);
        result.put("success", true);
        result.put("balance", account.getBalance());
        result.put("availBalance", account.getAvailBalance());
        return result;
    }

    // 충전
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

        // [수정 1] 값 검증 (null 체크)
        if (request.get("amount") == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "충전 금액이 입력되지 않았습니다.");
            return error;
        }

        BigDecimal amount = new BigDecimal(request.get("amount").toString());

        // [수정 2] JSP에서 'bank'로 보냈으므로 여기서도 'bank'로 받아야 함!
        String bankName = (String) request.get("bank");

        // 은행 선택 안 했을 경우 방어 로직
        if(bankName == null || bankName.isEmpty()) {
            bankName = "은행";
        }

        return walletService.charge(userId, amount, bankName + "에서 충전");
    }

    // 출금
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

        // 값 검증
        if (request.get("amount") == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "출금 금액이 입력되지 않았습니다.");
            return error;
        }

        BigDecimal amount = new BigDecimal(request.get("amount").toString());
        return walletService.withdraw(userId, amount);
    }

    // 거래 내역
    @GetMapping("/transactions")
    public Map<String, Object> getTransactions(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            HttpSession session) {

        UserVO loginUser = (UserVO) session.getAttribute("loginSess");

        if (loginUser == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        Long userId = loginUser.getUserId();

        // 서비스에서 리턴한 Map에 success: true를 덧붙여서 리턴
        Map<String, Object> result = walletService.getTransactionHistory(userId, page, size);
        result.put("success", true);
        return result;
    }
}