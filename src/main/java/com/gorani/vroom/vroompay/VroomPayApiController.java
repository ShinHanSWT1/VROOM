package com.gorani.vroom.vroompay;

import com.gorani.vroom.user.auth.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
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

        Map<String, Object> apiResult = vroomPayService.linkAccount(userId, username);

        // VroomPay 계좌 연결 성공 시 로컬 WALLET_ACCOUNTS에도 저장
        if (Boolean.TRUE.equals(apiResult.get("success"))) {
            try {
                // account 객체 안에 nested된 경우 처리
                Map<String, Object> accountData = apiResult;
                if (apiResult.get("account") != null) {
                    accountData = (Map<String, Object>) apiResult.get("account");
                }

                String realAccount = null;
                if (accountData.get("realAccount") != null) {
                    realAccount = accountData.get("realAccount").toString();
                } else if (accountData.get("real_account") != null) {
                    realAccount = accountData.get("real_account").toString();
                }

                BigDecimal balance = BigDecimal.ZERO;
                BigDecimal availBalance = BigDecimal.ZERO;

                if (accountData.get("balance") != null) {
                    balance = new BigDecimal(accountData.get("balance").toString());
                }
                if (accountData.get("availBalance") != null) {
                    availBalance = new BigDecimal(accountData.get("availBalance").toString());
                }

                VroomPayVO walletAccount = new VroomPayVO();
                walletAccount.setUserId(userId);
                walletAccount.setRealAccount(realAccount);
                walletAccount.setBalance(balance);
                walletAccount.setAvailBalance(availBalance);

                vroomPayService.insertWalletAccount(walletAccount);
            } catch (Exception ignored) {
            }
        }

        return apiResult;
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
        String memo = (String) request.get("memo");

        Map<String, Object> result = vroomPayService.charge(userId, amount, memo);

        // 충전 성공 시 거래 이력 저장
        if (Boolean.TRUE.equals(result.get("success"))) {
            try {
                WalletTransactionVO txn = new WalletTransactionVO();
                txn.setTxnType("CHARGE");
                txn.setAmount(amount);
                txn.setUserId(userId);
                txn.setMemo(memo);
                vroomPayService.insertWalletTransactions(txn);
            } catch (Exception ignored) {
            }
        }

        return result;
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
        String memo = (String) request.get("memo");

        // 금액 검증
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "출금 금액은 0원보다 커야 합니다.");
            return error;
        }

        // 잔액 검증 - VroomPay에서 계좌 상태 조회
        Map<String, Object> accountStatus = vroomPayService.getAccountStatus(userId);
        if (Boolean.TRUE.equals(accountStatus.get("success")) && Boolean.TRUE.equals(accountStatus.get("linked"))) {
            Map<String, Object> account = (Map<String, Object>) accountStatus.get("account");
            if (account != null && account.get("balance") != null) {
                BigDecimal currentBalance = new BigDecimal(account.get("balance").toString());
                if (amount.compareTo(currentBalance) > 0) {
                    Map<String, Object> error = new HashMap<>();
                    error.put("success", false);
                    error.put("message", "출금 금액이 잔액보다 큽니다. (현재 잔액: " + currentBalance.intValue() + "원)");
                    return error;
                }
            }
        }

        Map<String, Object> result = vroomPayService.withdraw(userId, amount, memo);

        // 출금 성공 시 거래 이력 저장
        if (Boolean.TRUE.equals(result.get("success"))) {
            try {
                WalletTransactionVO txn = new WalletTransactionVO();
                txn.setTxnType("WITHDRAW");
                txn.setAmount(amount);
                txn.setUserId(userId);
                txn.setMemo(memo);
                vroomPayService.insertWalletTransactions(txn);
            } catch (Exception ignored) {
            }
        }

        return result;
    }

    @GetMapping("/transactions")
    public Map<String, Object> getTransactions(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        UserVO loginUser = (UserVO) session.getAttribute("loginSess");

        if (loginUser == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        Long userId = loginUser.getUserId();

        List<WalletTransactionVO> transactions = vroomPayService.getWalletTransactions(userId, page, size);
        int totalCount = vroomPayService.countWalletTransactions(userId);
        int totalPages = (int) Math.ceil((double) totalCount / size);

        result.put("success", true);
        result.put("transactions", transactions);
        result.put("totalCount", totalCount);
        result.put("totalPages", totalPages);
        result.put("currentPage", page);

        return result;
    }
}
