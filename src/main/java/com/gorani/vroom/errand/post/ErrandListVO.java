package com.gorani.vroom.errand.post;

import lombok.Data;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
public class ErrandListVO {

    private Long errandsId;
    private Long userId;

    private String title;
    private String description;
    private BigDecimal rewardAmount;
    private BigDecimal expenseAmount;

    private Timestamp desiredAt;
    private Timestamp createdAt;
    private String status;

    private Long categoryId;
    private String gunguName;
    private String dongName;
    
    private String categoryName;
    private String dongFullName;
    private String writerNickname;
}
