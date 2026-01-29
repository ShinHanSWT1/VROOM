package com.gorani.vroom.errand.chat.ws;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.gorani.vroom.errand.chat.ChatService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ChatWsController {

    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;

    @MessageMapping("/chat.send") // 클라가 /app/chat.send 로 보냄
    public void send(ChatMessagePayload payload) {

        Long roomId = payload.getRoomId();
        Long senderUserId = payload.getSenderUserId();

        // 2) 접근 검증
        if (!chatService.canAccessChatRoomByRoomId(roomId, senderUserId)) {
            return;
        }

        // 3) DB 저장
        chatService.sendMessage(roomId, senderUserId, payload.getMessageType(), payload.getContent());

        // 4) 서버가 내려줄 값 세팅
        payload.setCreatedAt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
        
        // 5) 해당 방 구독자들에게 브로드캐스트
        messagingTemplate.convertAndSend("/topic/room." + roomId, payload);
    }
}