package com.gorani.vroom.pay;

import lombok.Data;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
public class WalletVO {

    // Wallet_accounts
    private long userId; // 사용자 id
    private BigDecimal balance; // 잔액
    private BigDecimal availBalance; // 가용 잔액
    private Timestamp updatedAt; // 수정일
    private String realAccount; // 실제 계좌

    // Wallet_transactions
    private Long id; // 아이디
    private String txnType;  // 거래 유형     // CHARGE(충전), HOLD(심부름 매칭 시 금액 보류), RELEASE(보류 해제), PAYOUT(정산), WITHDRAW(출금), REFUND(환불)
    private BigDecimal amount; // 금액
    private Long errandId; // 심부름 아이디
    private Timestamp createdAt; // 거래 발생일
    private String memo; // 메모
    private Long paymentId; // 거래 아이디

}
