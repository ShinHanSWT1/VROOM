package com.gorani.vroom.errander.profile;

import lombok.Data;
import java.util.Date;

@Data
public class ErranderReviewVO {
    private Long reviewId;
    private Long errandId;
    private int rating;
    private String comment;
    private Date createdAt;
    
    // 조인하여 가져올 정보
    private String errandTitle;      // 심부름 제목
    private String reviewerNickname; // 의뢰인(리뷰 작성자) 닉네임
    private String reviewerImage;    // 의뢰인 프로필 이미지
}
