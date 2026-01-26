package com.gorani.vroom.pay;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class WalletServiceImpl implements WalletService {

    private final WalletMapper walletMapper;


    @Override
    // 지갑 조회 & 생성
    public WalletVO getOrCreateAccount(Long userId) {
        WalletVO account = walletMapper.getAccountByUserId(userId);
        if (account == null) {
            account = new WalletVO();
            account.setUserId(userId);
            walletMapper.createAccount(account);
            account = walletMapper.getAccountByUserId(userId);
        }
        return account;
    }

    @Override
    @Transactional
    // 충전
    public Map<String, Object> charge(Long userId, BigDecimal amount, String memo) {
        Map<String, Object> result = new HashMap<>();

        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            result.put("success", false);
            result.put("message", "충전 금액은 0보다 커야 합니다.");
            return result;
        }

        getOrCreateAccount(userId);

        // 1. 잔액 증가 (balance+, avail+)
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("amount", amount);
        walletMapper.addBalance(params);

        // 2. 거래 기록 (CHARGE)
        WalletVO txn = new WalletVO();
        txn.setUserId(userId);
        txn.setTxnType("CHARGE");
        txn.setAmount(amount);
        txn.setMemo(memo);
        walletMapper.insertTransaction(txn);

        WalletVO account = walletMapper.getAccountByUserId(userId);
        result.put("success", true);
        result.put("message", amount + "원이 충전되었습니다.");
        result.put("balance", account.getBalance());
        result.put("availBalance", account.getAvailBalance());
        return result;
    }

    @Override
    @Transactional
    // 출금
    public Map<String, Object> withdraw(Long userId, BigDecimal amount) {
        Map<String, Object> result = new HashMap<>();

        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            result.put("success", false);
            result.put("message", "출금 금액은 0보다 커야 합니다.");
            return result;
        }

        WalletVO account = getOrCreateAccount(userId);

        if (account.getAvailBalance().compareTo(amount) < 0) {
            result.put("success", false);
            result.put("message", "잔액이 부족합니다. 사용 가능 잔액: " + account.getAvailBalance() + "원");
            return result;
        }

        // 1. 잔액 감소 (balance-, avail-)
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("amount", amount);
        int updated = walletMapper.subtractBalance(params);

        if (updated == 0) {
            result.put("success", false);
            result.put("message", "출금 처리에 실패했습니다.");
            return result;
        }

        // 2. 거래 기록 (WITHDRAW)
        WalletVO txn = new WalletVO();
        txn.setUserId(userId);
        txn.setTxnType("WITHDRAW");
        txn.setAmount(amount);
        txn.setMemo("출금");
        walletMapper.insertTransaction(txn);

        account = walletMapper.getAccountByUserId(userId);
        result.put("success", true);
        result.put("message", amount + "원이 출금되었습니다.");
        result.put("balance", account.getBalance());
        result.put("availBalance", account.getAvailBalance());
        return result;
    }

    @Override
    // 거래 내역 조회 - 페이징
    public Map<String, Object> getTransactionHistory(Long userId, int page, int size) {
        Map<String, Object> result = new HashMap<>();
        WalletVO account = getOrCreateAccount(userId);

        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("offset", (page - 1) * size);
        params.put("limit", size);

        List<WalletVO> transactions = walletMapper.getTransactions(params);
        int totalCount = walletMapper.getTransactionCount(userId);

        result.put("transactions", transactions);
        result.put("totalCount", totalCount);
        result.put("totalPages", (int) Math.ceil((double) totalCount / size));
        result.put("currentPage", page);
        result.put("balance", account.getBalance());
        result.put("availBalance", account.getAvailBalance());
        return result;
    }
}
