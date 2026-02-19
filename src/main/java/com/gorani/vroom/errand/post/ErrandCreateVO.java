package com.gorani.vroom.errand.post;

import lombok.Data;

@Data
public class ErrandCreateVO {
	private Long errandsId;
	private Long userId;
    private String title; //제목
    private Long categoryId; //카테고리
    private Integer rewardAmount; // 심부름값
    private Integer expenseAmount; // 재료비
    private String description; //심부름 설명
    private String dongCode;      // 동네 코드
    private String dongFullName;
    
    private String desiredAt;     // 일단 String으로 받고, 서비스에서 파싱 필요
}
