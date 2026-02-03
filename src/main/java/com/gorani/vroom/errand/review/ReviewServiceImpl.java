package com.gorani.vroom.errand.review;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gorani.vroom.errand.assignment.ErrandAssignmentMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewMapper reviewMapper;
    private final ErrandAssignmentMapper assignmentMapper;

    @Override
    @Transactional
    public void writeReview(Long errandsId, Long reviewerUserId, int rating, String comment) {

        // 1) 별점 검증
        if (rating < 1 || rating > 5) {
            throw new IllegalArgumentException("별점은 1~5만 가능합니다.");
        }

        // 2) 상태 검증 (ERRANDS.status 기준이어야 함)
        // ※ 주인님 프로젝트에서 이미 selectErrandStatus(errandsId)로 ERRANDS.status 가져오는 mapper가 있으면 그걸 그대로 쓰면 됨
        String status = assignmentMapper.selectErrandStatus(errandsId); // (이미 있는 메소드라고 가정)
        if (!"CONFIRMED2".equals(status) && !"COMPLETED".equals(status)) {
            throw new IllegalStateException("리뷰는 인증완료(CONFIRMED2) 또는 최종완료(COMPLETED) 상태에서만 작성 가능합니다.");
        }

        // 3) 중복 체크
        int exists = reviewMapper.existsReview(errandsId, reviewerUserId);
        if (exists > 0) {
            throw new IllegalStateException("이미 리뷰를 작성했습니다.");
        }

        // 4) 리뷰 대상(부름이) 찾기: ERRAND_ASSIGNMENTS.errander_user_id
        Long revieweeUserId = assignmentMapper.selectRevieweeUserIdByErrandId(errandsId);
        if (revieweeUserId == null) {
            throw new IllegalStateException("리뷰 대상(부름이)을 찾을 수 없습니다.");
        }

        // 5) 저장
        reviewMapper.insertReview(errandsId, rating, comment, reviewerUserId, revieweeUserId);
    }
    
    @Override
    public boolean existsReview(Long errandsId, Long reviewerUserId) {
        return reviewMapper.existsReview(errandsId, reviewerUserId) > 0;
    }
}
