package com.gorani.vroom.errand.post;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ErrandDetailVO {
    private Long errandsId;
    private Long userId;
    private String title;
    private String description;     // 상세 내용
    private BigDecimal rewardAmount;
    private BigDecimal expenseAmount; // 심부름 비용(있으면)
    private String desiredAt; // 지금은 String으로(나중에 LocalDateTime으로 바꿔도 됨)
    private java.sql.Timestamp  createdAt;    
    private String status;          // WAIT / IN_PROGRESS / DONE 등
    private Long categoryId;
    private String dongCode;
    private String mainImageUrl;
    private java.math.BigDecimal mannerScore; // 또는 Double
    private String nickname;
    
    private String gunguName;
    private String dongName;
    private String dongFullName;
    private String timeAgo;

    private List<String> images; // 모든 이미지 URL 리스트
}
