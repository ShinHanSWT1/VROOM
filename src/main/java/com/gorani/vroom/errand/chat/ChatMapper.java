package com.gorani.vroom.errand.chat;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ChatMapper {
    
    // 채팅방 조회
    ChatRoomVO selectChatRoomByErrandsId(@Param("errandsId") Long errandsId);
    
    ChatRoomVO selectChatRoomById(@Param("roomId") Long roomId);
    
    Long selectErrandsIdByRoomId(@Param("roomId") Long roomId);
    
    // 채팅방 생성
    int insertChatRoom(@Param("errandsId") Long errandsId, 
                       @Param("erranderId") Long erranderId);
    
    // 참여자 조회
    ChatParticipantVO selectParticipant(@Param("roomId") Long roomId, 
                                        @Param("userId") Long userId);
    
    List<ChatParticipantVO> selectParticipantsByRoomId(@Param("roomId") Long roomId);
    
    // 참여자 추가
    int insertParticipant(@Param("roomId") Long roomId, 
                          @Param("userId") Long userId, 
                          @Param("roomRole") String roomRole);
    
    // 참여자 비활성화
    int updateParticipantInactive(@Param("roomId") Long roomId, 
                                   @Param("userId") Long userId);
    
    // 메시지 조회
    List<ChatMessageVO> selectMessagesByRoomId(@Param("roomId") Long roomId, 
                                                @Param("currentUserId") Long currentUserId);
    
    // 메시지 전송
    int insertMessage(ChatMessageVO message);
    
    // 심부름 작성자 userId 조회
    Long selectErrandOwnerUserId(@Param("errandsId") Long errandsId);
    
    // 심부름 정보 조회 (채팅방용)
    ChatRoomVO selectErrandInfoForChat(@Param("errandsId") Long errandsId, 
                                       @Param("userId") Long userId);
    
    // 사용자가 특정 채팅방의 참여자인지 확인
    int countParticipantByErrandsIdAndUserId(@Param("errandsId") Long errandsId,
                                              @Param("userId") Long userId);
    
    List<ChatMessageVO> selectMessagesByRoomId(@Param("roomId") Long roomId);

}
