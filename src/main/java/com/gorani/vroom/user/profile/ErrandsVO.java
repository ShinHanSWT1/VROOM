package com.gorani.vroom.user.profile;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class ErrandsVO {

    private Long errandsId;         // 심부름 ID
    private Long userId;            // 신청자 ID
    private Long erranderId;        // 심부름꾼 ID
    private String title;           // 제목
    private String description;     // 설명
    private LocalDateTime desiredAt;    // 희망 시간
    private BigDecimal rewardAmount;    // 보상금
    private BigDecimal expenseAmount;   // 비용
    private String status;          // 상태
    private LocalDateTime createdAt;    // 생성일
    private LocalDateTime updatedAt;    // 수정일
    private Long categoryId;        // 카테고리 ID
    private String dongCode;        // 동 코드
    private String gunguName;       // 구군명
    private String dongName;        // 동명
}
