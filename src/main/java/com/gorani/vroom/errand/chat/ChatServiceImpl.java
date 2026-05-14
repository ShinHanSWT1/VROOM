package com.gorani.vroom.errand.chat;

import java.time.LocalDateTime;
import java.util.List;

import com.gorani.vroom.notification.NotificationService;
import com.gorani.vroom.vroompay.PaymentOrderVO;
import com.gorani.vroom.vroompay.VroomPayService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gorani.vroom.errand.assignment.ErrandAssignmentMapper;
import com.gorani.vroom.errand.chat.ws.ChatMessagePayload;
import com.gorani.vroom.errander.profile.ErranderMapper;

import lombok.RequiredArgsConstructor;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final ChatMapper chatMapper;
    private final ErrandAssignmentMapper assignmentMapper;
    private final SimpMessagingTemplate messagingTemplate;
    private final ErranderMapper erranderMapper;
    private final NotificationService notificationService;
    private final VroomPayService vroomPayService;
    
    private String toChangedByType(String role) {
        if (role == null) return "SYSTEM";
        switch (role) {
            case "OWNER":
            case "USER": return "USER";
            case "ERRANDER":
            case "RUNNER": return "ERRANDER";
            case "ADMIN": return "ADMIN";
            default: return "SYSTEM";
        }
    }


    @Override
    @Transactional
    public Long getOrCreateChatRoom(Long errandsId, Long erranderUserId) {
    	// 심부름 작성자 조회
        Long ownerUserId = chatMapper.selectErrandOwnerUserId(errandsId);
        
        // 1) userId -> erranderId 변환 (ERRANDER_PROFILES PK)
        Long erranderId = assignmentMapper.selectErranderIdByUserId(erranderUserId);
        if (erranderId == null) {
            throw new IllegalStateException("부름이 프로필이 없습니다.");
        }

        // 2) (errandsId, erranderId)로 기존 방 찾기
        ChatRoomVO existingRoom = chatMapper.selectChatRoomByErrandsIdAndErranderId(errandsId, erranderId);
        if (existingRoom != null) {
            Long roomId = existingRoom.getRoomId();

            // 방 재활용: 참가자 활성화 보장
            // (※ deactivateErrandersByRoomId는 이 방 안에서만 비활성화하므로 유지 가능)
            chatMapper.deactivateErrandersByRoomId(roomId);

            chatMapper.upsertParticipantActive(roomId, ownerUserId, "OWNER");
            chatMapper.upsertParticipantActive(roomId, erranderUserId, "ERRANDER"); // 참가자는 user_id 저장

            return roomId;
        }

        /// 3) 새 채팅방 생성 (CHAT_ROOM에는 errander_id(프로필 PK) 저장)
        ChatRoomVO room = new ChatRoomVO();
        room.setErrandsId(errandsId);
        room.setErranderId(erranderId);
        chatMapper.insertChatRoom(room);

        Long roomId = room.getRoomId();

        // 4) 참여자 추가 (CHAT_PARTICIPANT에는 user_id 저장)
        chatMapper.insertParticipant(roomId, ownerUserId, "OWNER");
        chatMapper.insertParticipant(roomId, erranderUserId, "ERRANDER");

        // 5) 시스템 메시지 추가
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

    	// 상태 전환: MATCHED -> CONFIRMED1 (딱 1번만 성공)
        int updated = assignmentMapper.updateErrandStatusMatchedToConfirmed1(errandsId);
        if (updated == 0) {
            throw new IllegalStateException("이미 처리된 요청입니다.");
        }
        
        // 상태 이력 저장 (MATCHED -> CONFIRMED1)
        assignmentMapper.insertStatusHistory(
            errandsId,
            "MATCHED",
            "CONFIRMED1",
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
    	
    	// 0) erranderUserId(user_id) -> erranderId(errander PK) 변환
    	Long erranderId = assignmentMapper.selectErranderIdByUserId(erranderUserId);
        log.debug("[REJECT] erranderUserId={} -> erranderId={}", erranderUserId, erranderId);
    	if (erranderId == null) {
    	    throw new IllegalStateException("부름이 프로필이 없습니다.");
    	}

        // 1) ERRAND_ASSIGNMENTS: MATCHED -> CANCELED (이 매칭 레코드 종료)
        int canceled = assignmentMapper.updateAssignmentStatusMatchedToCanceled(errandsId, erranderId);
        log.debug("[REJECT] updateAssignmentStatusMatchedToCanceled rows={} (errandsId={}, erranderId={})",
                canceled, errandsId, erranderId);
        if (canceled == 0) {
            // 이미 취소됐거나, 이미 다른 부름이로 바뀌었거나, 매칭 상태가 아닌 경우
            throw new IllegalStateException("이미 처리된 요청입니다.");
        }
    	
    	// 상태 전환: MATCHED -> WAITING (딱 1번만 성공)
        int updated = assignmentMapper.updateErrandMatchedToWaitingClearErrander(errandsId);
        log.debug("[REJECT] updateErrandStatusMatchedToWaiting rows={} (errandsId={})", updated, errandsId);
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
        
        assignmentMapper.insertRejectHistory(errandsId, erranderId);

        Long ownerUserId = chatMapper.selectErrandOwnerUserId(errandsId);

	    // OWNER 유지(없으면 추가/있으면 active=1)
	    chatMapper.upsertParticipantActive(roomId, ownerUserId, "OWNER");
	
	    // 거절된 부름이만 비활성화
	    chatMapper.deactivateParticipant(roomId, erranderUserId);
        
        // SYSTEM 메시지 DB 저장 (선택: 종료 전에 남기고 싶으면)
        ChatMessageVO systemMessage = new ChatMessageVO();
        systemMessage.setRoomId(roomId);
        systemMessage.setSenderUserId(0L);
        systemMessage.setMessageType("SYSTEM");
        systemMessage.setContent("심부름이 거절되었습니다. 다시 부름이를 모집합니다.");
        chatMapper.insertMessage(systemMessage);

        // 주문서 cancel
        vroomPayService.cancelPayment(errandsId);

        // 부름이에게 알림
        notificationService.send(
                erranderUserId,
                "ERRAND",
                "매칭이 취소되었습니다",
                "/errand/list"

        );
    }

    @Override
    public String getUserRole(Long roomId, Long userId) {
        ChatParticipantVO participant = chatMapper.selectParticipant(roomId, userId);
        return participant != null ? participant.getRoomRole() : null;
    }

    @Override
    public ChatRoomVO getErrandInfoForChat(Long errandsId, Long currentUserId) {
        ChatRoomVO info = chatMapper.selectErrandInfoForChat(errandsId); // 기존 심부름 정보
        ChatRoomVO partner = chatMapper.selectPartnerInfoForChat(errandsId, currentUserId);

        if (info != null && partner != null) {
            info.setPartnerNickname(partner.getPartnerNickname());
            info.setPartnerProfileImage(partner.getPartnerProfileImage());
            info.setPartnerMannerScore(partner.getPartnerMannerScore());
        }
        return info;
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
    
    @Override
    @org.springframework.transaction.annotation.Transactional
    public void completeConfirm(Long errandsId, Long ownerUserId) {
        int updated = assignmentMapper.updateErrandStatusConfirmed1ToConfirmed2(errandsId);
        log.debug("[DEBUG] CONFIRMED1->CONFIRMED2 updated={}", updated);
        
        if (updated == 0) {
            throw new IllegalStateException("이미 처리되었거나 현재 상태가 CONFIRMED1이 아닙니다.");
        }

        assignmentMapper.insertStatusHistory(
            errandsId,
            "CONFIRMED1",
            "CONFIRMED2",
            "USER",
            ownerUserId
        );
    }
    
    @Override
    public String getErrandStatus(Long errandsId) {
        return chatMapper.selectErrandStatusByErrandsId(errandsId);
    }
    
    @Override
    public boolean existsChatRoomByErrandsId(Long errandsId) {
        if (errandsId == null) return false;
        return chatMapper.countChatRoomByErrandsId(errandsId) > 0;
    }
    
    @Override
    public Long getErranderUserIdByRoomId(Long roomId) {
        // 채팅 참여자 중 ERRANDER 역할인 user_id를 1명 가져오기
        return chatMapper.selectErranderUserIdByRoomId(roomId);
    }
    
    @Override
    public ChatRoomVO getChatRoomByErrandsIdAndErranderId(Long errandsId, Long erranderId) {
        return chatMapper.selectChatRoomByErrandsIdAndErranderId(errandsId, erranderId);
    }
}