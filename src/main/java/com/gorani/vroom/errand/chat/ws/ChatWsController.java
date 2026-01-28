package com.gorani.vroom.errand.chat.ws;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.gorani.vroom.errand.chat.ChatService;
import com.gorani.vroom.user.auth.UserVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ChatWsController {

    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;

    @MessageMapping("/chat.send") // 클라가 /app/chat.send 로 보냄
    public void send(ChatMessagePayload payload) {
        // 1) sender 정보는 "클라가 준 값" 믿지 말고 서버에서 결정하는 게 안전
        //    지금 프로젝트는 HttpSession 기반이라, 아래 방식 중 하나로 sender를 얻어야 함.
        //    (a) 나중에 HandshakeInterceptor로 userId 주입
        //    (b) 또는 일단 payload.senderUserId를 클라에서 넘기되 서버에서 canAccess로 검증

        Long roomId = payload.getRoomId();
        Long senderUserId = payload.getSenderUserId(); // 일단은 임시(아래 주의사항 참고)

        // 2) 접근 검증 (중요)
        boolean canAccess = chatService.canAccessChatRoomByRoomId(roomId, senderUserId);
        if (!canAccess) return;

        // 3) DB 저장
        chatService.saveChatMessage(roomId, senderUserId, payload.getMessageType(), payload.getContent());

        // 4) 서버가 내려줄 값 세팅
        payload.setCreatedAt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));
        payload.setSenderNickname(chatService.getUserNickname(senderUserId));

        // 5) 해당 방 구독자들에게 브로드캐스트
        messagingTemplate.convertAndSend("/topic/room." + roomId, payload);
    }
}