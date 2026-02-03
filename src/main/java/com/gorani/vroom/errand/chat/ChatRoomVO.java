package com.gorani.vroom.errand.chat;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class ChatRoomVO {
    private Long roomId;
    private Long errandsId;
    private Long erranderId;
    private Timestamp createdAt;
    private Long rewardAmount;
    private Long expenseAmount;
    private String status;
    
    // 조인용 추가 필드
    private String errandTitle;
    private String errandDescription;
    private String errandLocation;
    private String errandImageUrl;
    private String categoryDefaultImageUrl;
    private Long partnerUserId;
    private String partnerNickname;  // 상대방 닉네임
    private String partnerProfileImage;
    private java.math.BigDecimal partnerMannerScore;
}