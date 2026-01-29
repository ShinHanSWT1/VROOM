package com.gorani.vroom.errand.chat;

import java.util.List;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gorani.vroom.errand.assignment.ErrandAssignmentMapper;
import com.gorani.vroom.errand.chat.ws.ChatMessagePayload;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final ChatMapper chatMapper;
    private final ErrandAssignmentMapper assignmentMapper;
    private final SimpMessagingTemplate messagingTemplate;

    @Override
    @Transactional
    public Long getOrCreateChatRoom(Long errandsId, Long erranderUserId) {
        // 기존 채팅방 확인
        ChatRoomVO existingRoom = chatMapper.selectChatRoomByErrandsId(errandsId);
        if (existingRoom != null) {
            return existingRoom.getRoomId();
        }

        // 부름이 ID 변환 (MEMBERS.user_id -> ERRANDER_PROFILES.errander_id)
        Long erranderId = assignmentMapper.selectErranderIdByUserId(erranderUserId);
        if (erranderId == null) {
            throw new IllegalStateException("부름이 프로필이 없습니다.");
        }

        // 새 채팅방 생성 (VO로 넣고 생성키(room_id) 받기)
        ChatRoomVO room = new ChatRoomVO();
        room.setErrandsId(errandsId);
        room.setErranderId(erranderId);

        chatMapper.insertChatRoom(room);

        // insert 후 useGeneratedKeys로 room_id가 room.roomId에 들어옴
        Long roomId = room.getRoomId();

        // 심부름 작성자 조회
        Long ownerUserId = chatMapper.selectErrandOwnerUserId(errandsId);

        // 참여자 추가 (OWNER - 심부름 올린 사람)
        chatMapper.insertParticipant(roomId, ownerUserId, "OWNER");
        
        // 참여자 추가 (ERRANDER - 부름이)
        chatMapper.insertParticipant(roomId, erranderUserId, "ERRANDER");

        // 시스템 메시지 추가
        ChatMessageVO systemMessage = new ChatMessageVO();
        systemMessage.setRoomId(roomId);
        systemMessage.setSenderUserId(ownerUserId);
        systemMessage.setMessageType("SYSTEM");
        systemMessage.setContent("채팅이 시작되었습니다. 심부름 요청을 확인해주세요.");
        chatMapper.insertMessage(systemMessage);

        return roomId;
    }

    @Override
    public ChatRoomVO getChatRoomInfo(Long roomId, Long currentUserId) {
        return chatMapper.selectChatRoomById(roomId);
    }

    @Override
    @Transactional
    public ChatMessageVO sendMessage(Long roomId, Long senderUserId, String messageType, String content) {

        // 1) 참가자 검증 (selectParticipant 재사용)
        ChatParticipantVO participant = chatMapper.selectParticipant(roomId, senderUserId);
        if (participant == null) {
            // 웹 권한 거절로 쓰기엔 java.nio.file.AccessDeniedException은 결이 달라서 Runtime으로 던지는 걸 권장
            throw new IllegalStateException("Not a participant");
        }
        // isActive 컬럼/필드가 있다면 여기서 체크 (없으면 이 줄은 빼도 됨)
        // if (participant.getIsActive() == 0) throw new IllegalStateException("Inactive participant");

        // 2) 채팅 가능 상태 검증 (assignment/errands로)
        Long errandsId = chatMapper.selectErrandsIdByRoomId(roomId);
        if (!assignmentMapper.canChat(errandsId)) {
            throw new IllegalStateException("Chat is not allowed in current status");
        }

        // 3) messageType 제한
        if (!("TEXT".equals(messageType) || "SYSTEM".equals(messageType))) {
            throw new IllegalArgumentException("Invalid messageType");
        }

        ChatMessageVO message = new ChatMessageVO();
        message.setRoomId(roomId);
        message.setSenderUserId(senderUserId);
        message.setMessageType(messageType);
        message.setContent(content);

        chatMapper.insertMessage(message);
        return message;
    }

    @Override
    @Transactional
    public void acceptErrand(Long errandsId, Long roomId, Long userId) {

    	// 상태 전환: MATCHED -> CONFIRM1 (딱 1번만 성공)
        int updated = assignmentMapper.updateErrandStatusMatchedToConfirm1(errandsId);
        if (updated == 0) {
            throw new IllegalStateException("이미 처리된 요청입니다.");
        }
        
        // 상태 이력 저장 (MATCHED -> CONFIRM1)
        assignmentMapper.insertStatusHistory(
            errandsId,
            "MATCHED",
            "CONFIRM1",
            "USER",
            userId
        );

        // 시스템 메시지 추가
        ChatMessageVO systemMessage = new ChatMessageVO();
        systemMessage.setRoomId(roomId);
        systemMessage.setSenderUserId(0L);
        systemMessage.setMessageType("SYSTEM");
        systemMessage.setContent("심부름이 수락되었습니다! 🎉");
        chatMapper.insertMessage(systemMessage);
        
        // STOMP로 현재 방 구독자(작성자/부름이) 모두에게 뿌림
        ChatMessagePayload payload = new ChatMessagePayload();
        payload.setRoomId(roomId);
        payload.setSenderUserId(0L);           // null 비교/JS 파싱 이슈 피하려면 0L 추천
        payload.setMessageType("SYSTEM");
        payload.setContent("심부름이 수락되었습니다! 🎉");

        messagingTemplate.convertAndSend("/topic/room." + roomId, payload);
    }

    @Override
    @Transactional
    public void rejectErrand(Long errandsId, Long roomId, Long userId, Long erranderUserId) {
    	
    	// 상태 전환: MATCHED -> WAITING (딱 1번만 성공)
        int updated = assignmentMapper.updateErrandStatusMatchedToWaiting(errandsId);
        if (updated == 0) {
            throw new IllegalStateException("이미 처리된 요청입니다.");
        }
        
        // 상태 이력 저장 (MATCHED -> WAITING)
        assignmentMapper.insertStatusHistory(
            errandsId,
            "MATCHED",
            "WAITING",
            "USER",
            userId
        );

        // 채팅방 종료 처리: room 전체 participant 비활성화(권장)
        chatMapper.deactivateParticipantsByRoomId(roomId);
        
        // SYSTEM 메시지 DB 저장 (선택: 종료 전에 남기고 싶으면)
        ChatMessageVO systemMessage = new ChatMessageVO();
        systemMessage.setRoomId(roomId);
        systemMessage.setSenderUserId(0L);
        systemMessage.setMessageType("SYSTEM");
        systemMessage.setContent("심부름이 거절되었습니다. 다시 부름이를 모집합니다.");
        chatMapper.insertMessage(systemMessage);
    }

    @Override
    public String getUserRole(Long roomId, Long userId) {
        ChatParticipantVO participant = chatMapper.selectParticipant(roomId, userId);
        return participant != null ? participant.getRoomRole() : null;
    }

    @Override
    public ChatRoomVO getErrandInfoForChat(Long errandsId, Long currentUserId) {
        return chatMapper.selectErrandInfoForChat(errandsId, currentUserId);
    }

    @Override
    public boolean canAccessChatRoom(Long errandsId, Long userId) {
        ChatRoomVO room = chatMapper.selectChatRoomByErrandsId(errandsId);

        // 방이 없으면: ERRANDER만 방 생성 가능
        if (room == null) {
            Long erranderId = assignmentMapper.selectErranderIdByUserId(userId);
            return erranderId != null; // errander_profiles에 있으면 true
        }

        // 방이 있으면: participant인 사람만 접근 가능 (OWNER/ERRANDER 모두)
        int count = chatMapper.countParticipantByErrandsIdAndUserId(errandsId, userId);
        return count > 0;
    }
    
    @Override
    public ChatRoomVO getChatRoomByErrandsId(Long errandsId) {
        return chatMapper.selectChatRoomByErrandsId(errandsId);
    }
    
    @Override
    public List<ChatMessageVO> getChatMessages(Long roomId, Long userId) {
    	

        // 1) 참가자 검증 (보안/권한)
        ChatParticipantVO participant = chatMapper.selectParticipant(roomId, userId);
        if (participant == null) {
            throw new IllegalStateException("Not a participant");
        }

        // 2) 메시지 조회
        List<ChatMessageVO> list = chatMapper.selectMessagesByRoomId(roomId);

        // 3) 서버 렌더링(JSP)용 isMine 세팅
        for (ChatMessageVO m : list) {
            boolean mine = (m.getSenderUserId() != null && m.getSenderUserId().equals(userId));
            m.setIsMine(mine);
        }

        return list;
    }
    
    @Override
    public Long getOwnerUserIdByErrandsId(Long errandsId) {
        return chatMapper.selectErrandOwnerUserId(errandsId);
    }
    
    @Override
    public boolean canAccessChatRoomByRoomId(Long roomId, Long userId) {
        Long errandsId = chatMapper.selectErrandsIdByRoomId(roomId);
        if (errandsId == null) return false;
        return canAccessChatRoom(errandsId, userId);
    }
}