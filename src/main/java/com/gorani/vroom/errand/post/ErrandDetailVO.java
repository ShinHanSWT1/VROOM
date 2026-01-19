package com.gorani.vroom.errand.post;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ErrandDetailVO {
    private Long errandsId;
    private String title;
    private String description;     // 상세 내용
    private BigDecimal rewardAmount;
    private BigDecimal expenseAmount; // 심부름 비용(있으면)
    private String dongCode;
    private String desiredAt;       // 지금은 String으로(나중에 LocalDateTime으로 바꿔도 됨)
    private String status;          // WAIT / IN_PROGRESS / DONE 등
}
