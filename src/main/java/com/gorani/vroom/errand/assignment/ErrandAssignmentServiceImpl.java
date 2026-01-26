package com.gorani.vroom.errand.assignment;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ErrandAssignmentServiceImpl implements ErrandAssignmentService {

    private final ErrandAssignmentMapper errandAssignmentMapper;

    @Override
    @Transactional
    public void requestStartChat(Long errandsId, Long erranderUserId, Long changedByUserId) {

        // 1) WAITING -> MATCHED (동시성 방어)
        int updated = errandAssignmentMapper.updateErrandStatusWaitingToMatched(errandsId);
        if (updated == 0) {
            throw new IllegalStateException("이미 누군가 선점했거나 요청 불가 상태입니다.");
        }

        // 2) 작성자 user_id 조회 (ERRAND_ASSIGNMENTS.user_id NOT NULL)
        Long ownerUserId = errandAssignmentMapper.selectOwnerUserId(errandsId);
        if (ownerUserId == null) {
            throw new IllegalArgumentException("존재하지 않는 심부름입니다.");
        }

        // 3) MEMBERS.user_id -> ERRANDER_PROFILES.errander_id 변환
        Long erranderId = errandAssignmentMapper.selectErranderIdByUserId(erranderUserId);
        if (erranderId == null) {
            throw new IllegalStateException("부름이 프로필(ERRANDER_PROFILES)이 없습니다. 라이더 프로필을 먼저 생성하세요.");
        }

        // 4) 배정 row 생성 (MATCHED) - FK는 errander_id로 넣어야 함
        errandAssignmentMapper.insertMatchedAssignment(ownerUserId, errandsId, erranderId);

        // 5) 상태 이력 저장
        errandAssignmentMapper.insertStatusHistory(
                errandsId,
                "WAITING",
                "MATCHED",
                "ERRANDER",
                changedByUserId
        );
    }
}
