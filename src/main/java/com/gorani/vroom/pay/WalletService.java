package com.gorani.vroom.pay;

import java.math.BigDecimal;
import java.util.Map;

public interface WalletService {
    WalletVO getOrCreateAccount(Long userId); // 지갑 조회&생성
    Map<String, Object> charge(Long userId, BigDecimal amount, String memo); // 충전
    Map<String, Object> withdraw(Long userId, BigDecimal amount); // 출금
    Map<String, Object> getTransactionHistory(Long userId, int page, int size); // 거래 내역 조회.
}
