package com.gorani.vroom.errand.chat;

import java.util.List;

public interface ChatService {
    
    /**
     * 채팅방 생성 또는 기존 채팅방 조회
     * @param errandsId 심부름 ID
     * @param erranderUserId 부름이 userId
     * @return 채팅방 ID
     */
    Long getOrCreateChatRoom(Long errandsId, Long erranderUserId);
    
    /**
     * 채팅방 정보 조회
     * @param roomId 채팅방 ID
     * @param currentUserId 현재 사용자 ID
     * @return 채팅방 정보
     */
    ChatRoomVO getChatRoomInfo(Long roomId, Long currentUserId);
    
    /**
     * 채팅방 메시지 목록 조회
     * @param roomId 채팅방 ID
     * @param currentUserId 현재 사용자 ID
     * @return 메시지 목록
     */
    List<ChatMessageVO> getChatMessages(Long roomId, Long currentUserId);
    
    /**
     * 메시지 전송
     * @param roomId 채팅방 ID
     * @param senderUserId 발신자 ID
     * @param messageType 메시지 타입
     * @param content 내용
     * @return 생성된 메시지
     */
    ChatMessageVO sendMessage(Long roomId, Long senderUserId, String messageType, String content);
    
    /**
     * 심부름 수락 (사용자가 부름이 수락)
     * @param errandsId 심부름 ID
     * @param roomId 채팅방 ID
     * @param userId 수락하는 사용자 ID
     */
    void acceptErrand(Long errandsId, Long roomId, Long userId);
    
    /**
     * 심부름 거절 (사용자가 부름이 거절)
     * @param errandsId 심부름 ID
     * @param roomId 채팅방 ID
     * @param userId 거절하는 사용자 ID
     * @param erranderUserId 부름이 userId
     */
    void rejectErrand(Long errandsId, Long roomId, Long userId, Long erranderUserId);
    
    /**
     * 현재 사용자의 역할 조회 (OWNER 또는 ERRANDER)
     * @param roomId 채팅방 ID
     * @param userId 사용자 ID
     * @return 역할 (OWNER, ERRANDER)
     */
    String getUserRole(Long roomId, Long userId);
    
    /**
     * 심부름 정보와 함께 채팅방 데이터 조회
     * @param errandsId 심부름 ID
     * @param currentUserId 현재 사용자 ID
     * @return 심부름 정보가 포함된 채팅방 VO
     */
    ChatRoomVO getErrandInfoForChat(Long errandsId, Long currentUserId);
    
    /**
     * 사용자가 채팅방에 접근할 수 있는지 확인
     * @param errandsId 심부름 ID
     * @param userId 사용자 ID
     * @return 접근 가능 여부
     */
    boolean canAccessChatRoom(Long errandsId, Long userId);
    
    ChatRoomVO getChatRoomByErrandsId(Long errandsId);
    
    Long getOwnerUserIdByErrandsId(Long errandsId);
    
    boolean canAccessChatRoomByRoomId(Long roomId, Long userId);
    
    void completeConfirm(Long errandsId, Long ownerUserId);
    
    String getErrandStatus(Long errandsId);
}