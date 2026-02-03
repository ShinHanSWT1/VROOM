package com.gorani.vroom.admin.settlement;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class AdminSettlementVO {
    private Long errandId;          // 심부름 ID
    private Long assignmentId;      // 배정 ID
    private Long paymentId;         // 결제 주문 ID (없으면 null)

    private String errandTitle;     // 심부름 제목
    private String requesterNickname; // 요청자 닉네임
    private String memo;

    private String erranderNickname;  // 부름이 닉네임
    private Long erranderUserId;
    private Long erranderProfileId;

    private BigDecimal orderAmount;       // 주문 금액 (사용자 결제액)
    private BigDecimal settlementAmount;  // 정산 금액 (실제 지급액)

    private String status;                // 현재 상태 (CONFIRMED2, HOLD, COMPLETED ...)
    private LocalDateTime requestDate;    // 정산 요청일 (수행 완료 시점)
    private LocalDateTime settledDate;    // 정산 완료일 (지급 시점)
}