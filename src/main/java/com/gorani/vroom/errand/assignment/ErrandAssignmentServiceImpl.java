package com.gorani.vroom.errand.assignment;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gorani.vroom.errand.chat.ChatService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ErrandAssignmentServiceImpl implements ErrandAssignmentService {

    private final ErrandAssignmentMapper errandAssignmentMapper;
    private final ChatService chatService;

    @Override
    @Transactional
    public Long requestStartChat(Long errandsId, Long erranderUserId, Long changedByUserId) {
    	
    	// DB에서 status 재조회
        String status = errandAssignmentMapper.selectErrandStatus(errandsId);
        System.out.println("[ASSIGN] db status before=" + status);

        // WAITING->MATCHED 시도
        int updated = errandAssignmentMapper.updateErrandStatusWaitingToMatched(errandsId);
        System.out.println("[ASSIGN] update rows=" + updated);

        // 업데이트 후 status 재조회
        String after = errandAssignmentMapper.selectErrandStatus(errandsId);
        System.out.println("[ASSIGN] db status after=" + after);

        // 1) WAITING -> MATCHED
        if (updated == 0) {
            throw new IllegalStateException("이미 누군가 선점했거나 요청 불가 상태입니다.");
        }

        // 2) owner 조회
        Long ownerUserId = errandAssignmentMapper.selectOwnerUserId(errandsId);

        // 3) errander profile 조회
        Long erranderId = errandAssignmentMapper.selectErranderIdByUserId(erranderUserId);
        
        System.out.println("[ASSIGN] erranderUserId=" + erranderUserId);
        System.out.println("[ASSIGN] erranderId(from profiles)=" + erranderId);

        System.out.println("[ASSIGN] ownerUserId=" + ownerUserId + ", errandsId=" + errandsId + ", erranderId=" + erranderId);

        // 4) assignment insert
        errandAssignmentMapper.insertMatchedAssignment(ownerUserId, errandsId, erranderId);

        // 5) status history
        errandAssignmentMapper.insertStatusHistory(
            errandsId,
            "WAITING",
            "MATCHED",
            "ERRANDER",
            changedByUserId
        );

        // 6) 채팅방 생성
        Long roomId = chatService.getOrCreateChatRoom(errandsId, erranderUserId);

        return roomId; // 이제 정상
    }
}
