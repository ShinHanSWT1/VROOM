package com.gorani.vroom.batch;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class SettlementTargetVO {
    private Long assignmentId;      // 배정 ID (상태 업데이트용)
    private Long errandsId;         // 심부름 ID
    private Long userId;            // user_id (심부름 요청자)
    private Long erranderId;        // 부름이의  ID (지갑 소유자)
    private BigDecimal amount;      // 정산 금액
}
