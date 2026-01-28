package com.gorani.vroom.errand.chat;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class ChatParticipantVO {
    private Long participantId;
    private Long roomId;
    private Long userId;
    private String roomRole;        // OWNER (심부름 올린 사람), ERRANDER (부름이)
    private Timestamp joinedAt;
    private Boolean isActive;       // true/false or 1/0
}