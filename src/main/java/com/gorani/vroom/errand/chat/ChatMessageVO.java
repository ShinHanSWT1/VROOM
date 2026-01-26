package com.gorani.vroom.errand.chat;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class ChatMessageVO {
    private Long messageId;
    private Long roomId;
    private Long senderUserId;
    private String messageType;     // TEXT, IMAGE, PROOF_IMAGE, SYSTEM
    private String content;
    private Timestamp createdAt;
    private Boolean isDeleted;
    
    // 추가 필드 (조인용)
    private String senderNickname;
    private Boolean isMine;         // 현재 사용자가 보낸 메시지인지
}
