package com.gorani.vroom.user.profile;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class IssueTicketVO {

    private Long id;                    // 티켓 ID
    private String type;                // USER_REPORT, ERRANDER_REPORT, COMPLAINT, SETTLEMENT, SYSTEM, ETC
    private String title;               // 제목
    private String content;             // 내용
    private String priority;            // 우선순위 : HIGH, MEDIUM, LOW
    private String status;              // 처리상태 : RECEIVED, IN_PROGRESS, RESOLVED, HOLD
    private String resolutionNote;      // 해결 메모
    private String internalMemo;        // 내부 메모
    private LocalDateTime createdAt;    // 생성일
    private LocalDateTime resolvedAt;   // 해결일
    private Long adminId;               // 담당 관리자 ID
    private Long errandId;              // 심부름 ID
    private Long userId;                // 신고자 ID
    private Long targetUserId;          // 신고 대상 ID
}
