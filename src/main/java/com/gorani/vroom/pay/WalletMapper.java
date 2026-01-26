package com.gorani.vroom.pay;

import java.util.List;
import java.util.Map;

public interface WalletMapper {
    // 계좌
    WalletVO getAccountByUserId(Long userId);
    void createAccount(WalletVO account);

    // balance+, avail+
    int addBalance(Map<String, Object> params);

    //  balance-, avail- (avail >= amount 조건)
    int subtractBalance(Map<String, Object> params);  // 오타 수정

    // HOLD: avail만 감소 (나중에 심부름용)
    int holdBalance(Map<String, Object> params);

    // RELEASE: avail만 증가 (나중에 취소용)
    int releaseBalance(Map<String, Object> params);

    // 거래 기록
    void insertTransaction(WalletVO transaction);
    List<WalletVO> getTransactions(Map<String, Object> params);
    int getTransactionCount(Long userId);
}