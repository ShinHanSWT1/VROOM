package com.gorani.vroom.vroompay;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface VroomPayService {

    // 계좌 조회
    Map<String, Object> getAccountStatus(Long userId);

    // 계좌 연결
    Map<String, Object> linkAccount(Long userId, String username);

    // 계좌 충전
    Map<String, Object> charge(Long userId, BigDecimal amount, String memo);

    // 계좌 인출
    Map<String, Object> withdraw(Long userId, BigDecimal amount, String memo);

    // 심부름 정산
    Map<String, Object> settleErrand(Long errandId, Long payerId, Long payeeId, BigDecimal amount);

    // 계좌 변경 이력 등록
    void insertWalletTransactions(WalletTransactionVO walletTransactionVO);

    // 계좌 변경 이력 조회
    List<WalletTransactionVO> getWalletTransactions(Long userId, int page, int size);

    // 계좌 변경 이력 총 개수
    int countWalletTransactions(Long userId);

    // 로컬 지갑 계좌 생성
    void insertWalletAccount(VroomPayVO vroomPayVO);

    // 로컬 지갑 계좌 조회
    VroomPayVO getWalletAccount(Long userId);

    // 로컬 지갑 계좌 잔액 업데이트
    void updateWalletAccount(VroomPayVO vroomPayVO);

}
