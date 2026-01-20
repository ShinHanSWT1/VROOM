package com.gorani.vroom.admin.users;

import lombok.Data;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Data
public class AdminUserDetailDTO {
    private Long userId;
    private String email;
    private String nickname;
    private String role;
    private String status;
    private String phone;
    private String profileImage;
    private BigDecimal mannerScore;
    private Date createdAt;
    private Date lastLoginAt;
    private String provider;
    private String adminMemo;
    private String suspensionNote;
    private BigDecimal cancelRate;

    private int errandCount;           // 심부름 등록 횟수
    private int reportedCount;         // 신고 당한 횟수
    private BigDecimal totalTxAmount;  // 누적 거래(결제) 금액

    private String address1;
    private String address2;

    // 신고 이력 리스트
    private List<UserReportHistoryVO> reportHistory;
    // 최근 활동 히스토리 리스트
    private List<UserActivityVO> activityHistory;
}