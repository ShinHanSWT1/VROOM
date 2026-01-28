package com.gorani.vroom.errand.chat.ws;

import lombok.Data;

@Data
public class ChatMessagePayload {
    private Long roomId;
    private String messageType;   // TEXT, SYSTEM 등
    private String content;

    // 아래는 서버가 채워서 다시 뿌려주면 UI가 편함
    private Long senderUserId;
    private String senderNickname;
    private String createdAt;     // 문자열로 보내도 OK
}
