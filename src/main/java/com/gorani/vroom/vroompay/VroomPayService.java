package com.gorani.vroom.vroompay;

import org.springframework.transaction.annotation.Transactional;

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

    @Transactional
    Map<String, Object> settleErrandManual(Long errandId, Long userId, Long erranderId, BigDecimal amount);

    // 주문서 생성
    @Transactional
    Map<String, Object> createAndHoldPaymentOrder(PaymentOrderVO payment);

    // TODO: payment 취소로 업데이트
    @Transactional
    Map<String, Object> cancelPayment(Long errandsId);

    // TODO: payment erranderId 업데이트
    Map<String, Object> updatePaymentErranderMatched(Long errandsId, Long erranderId);

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
    int updateWalletAccount(VroomPayVO vroomPayVO);

    @Transactional
    int syncWalletAccount(Long userId);

    // TODO: payment 취소로 업데이트

    // TODO: payment erranderId 업데이트
}
