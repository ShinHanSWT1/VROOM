package com.gorani.vroom.errand.post;

import lombok.Data;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Data
public class ErrandListVO {

    // PK
    private Long errandsId;

    // 작성자
    private Long userId;

    // 기본 정보
    private String title;
    private BigDecimal rewardAmount;
    private BigDecimal expenseAmount;

    // 일정 / 상태
    private Timestamp desiredAt;
    private Timestamp createdAt;
    private String status;

    // 분류 / 지역
    private Long categoryId;
    private String dongCode;

    /* ===== 목록 확장용(조인 결과) ===== */
    private String categoryName;    // CATEGORIES.name
    private String dongFullName;    // legal_dong.full_name
    private String writerNickname;  // MEMBERS.nickname
}
