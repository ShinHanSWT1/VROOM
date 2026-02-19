package com.gorani.vroom.errander.profile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ErranderServiceImpl implements ErranderService {

    private final ErranderMapper erranderMapper;

    @Override
    public ErranderProfileVO getErranderProfile(Long userId){

        // 사용자 기준으로 부름이 프로필 조회하기
        ErranderProfileVO profile = erranderMapper.getErranderProfile(userId);

        // 라이 더 프로필 null 인경우 -> 등록을 안 한겨
        if (profile == null) {
            return null;
        }

        // 통계하려고 부름이 고유 ID 뽑아.
        Long erranderId = profile.getErranderId();

        // 수행 중 건수 조회 및 세팅
        int inProgressCount = erranderMapper.getInProgressCount(erranderId);
        profile.setInProgressCount(inProgressCount);

        // 완료 건수
        int completedCount = erranderMapper.getCompletedCount(erranderId);
        profile.setCompletedCount(completedCount);


        // 완료율 계산하기 (기존 로직 유지 - 노란색 바)
        int totalErrands = inProgressCount + completedCount;
        double realRate = 0.0;

        if (totalErrands > 0) {
            // (완료 / 총합) * 100
            realRate = (double) completedCount / totalErrands * 100.0;

            // 소수점 첫째 자리 반올림 깔끔하게 처리
            realRate = Math.round(realRate * 10) / 10.0;
        }
        // VO에 계산된 값을 강제로 덮어씌움
        profile.setCompleteRate(realRate);


        // 등급 산정 로직
        if (completedCount >= 100) {
            // 100건 이상: VIP
            profile.setGrade("VIP");
            profile.setMemberTypeLabel("👑 VIP 부름이");

        } else if (completedCount >= 50) {
            // 50건 이상: PREMIUM
            profile.setGrade("PREMIUM");
            profile.setMemberTypeLabel("✨ 프리미엄 부름이");

        } else {
            // 그 외: STANDARD (기본)
            profile.setGrade("STANDARD");
            profile.setMemberTypeLabel("🌱 새내기 부름이");
        }

        // 고객 만족도 평점
        double avgRating = erranderMapper.getErranderAvgRating(erranderId);

        // 소수 첫째 자리 반올림
        avgRating = Math.round(avgRating * 10) / 10.0;
        profile.setRatingAvg(avgRating);

        // 총 리뷰 개수 가져오고
        int reviewCount = erranderMapper.getReviewCount(erranderId);
        profile.setReviewCount(reviewCount);


        // 전체 수익 조회
        int totalEarning = erranderMapper.getTotalEarning(erranderId);
        profile.setTotalEarning((long) totalEarning);


        // 1. 최근 30일 수행 건수 (COMPLETED 기준)
        int last30DaysCount = erranderMapper.getLast30DaysCompletedCount(erranderId);
        profile.setLast30DaysCompletedCount(last30DaysCount);

        // 2. 성공률 (COMPLETED / (COMPLETED + CANCELED)) * 100
        int totalAssigned = erranderMapper.getTotalAssignedCount(erranderId);
        double successRate = 0.0;
        if (totalAssigned > 0) {
            
            // 분모가 0이 아닐 때 계산
            successRate = (double) completedCount / totalAssigned * 100.0;
            successRate = Math.round(successRate * 10) / 10.0;
        } else {
            // 수행 내역이 없으면 100%로 표시하거나 0%로 표시 (정책 결정 필요, 여기선 0으로)
            if (completedCount > 0) successRate = 100.0; // 취소 없이 완료만 있으면 100%
            else successRate = 0.0;
        }
        profile.setSuccessRate(successRate);

        return profile;
    }

    @Override
    @Transactional
    public boolean registerErrander(ErranderProfileVO profileVO, List<ErranderDocumentVO> fileUrls) {
        try {
            //  부름이 프로필 등록
            int result = erranderMapper.insertErranderProfile(profileVO);
            if (result == 0) return false;

            // 생성된 errander_id 가져오기 (useGeneratedKeys 사용)
            Long erranderId = profileVO.getErranderId();

            // 서류 파일 등록
            if (fileUrls != null && !fileUrls.isEmpty()) {
                for (ErranderDocumentVO doc : fileUrls) {
                    erranderMapper.insertErranderDocument(
                            erranderId,
                            doc.getFilePath(),
                            doc.getDocumentType(),
                            doc.getOriginalName(),
                            "SUBMITTED"
                    );
                }
            }
            return true;
        } catch (Exception e) {
            log.error("부름이 등록 중 오류 발생", e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean reRegisterErrander(Long erranderId, ErranderProfileVO profileVO, List<ErranderDocumentVO> documents) {
        try {
            // 1. 기존 서류 삭제
            erranderMapper.deleteErranderDocuments(erranderId);

            // 2. 프로필 상태 업데이트 (PENDING으로, 동네 정보 업데이트)
            int result = erranderMapper.updateErranderProfileForReRegister(
                    erranderId,
                    profileVO.getDongCode1(),
                    profileVO.getDongCode2()
            );
            if (result == 0) return false;

            // 3. 새 서류 등록
            if (documents != null && !documents.isEmpty()) {
                for (ErranderDocumentVO doc : documents) {
                    erranderMapper.insertErranderDocument(
                            erranderId,
                            doc.getFilePath(),
                            doc.getDocumentType(),
                            doc.getOriginalName(),
                            "SUBMITTED"
                    );
                }
            }
            return true;
        } catch (Exception e) {
            log.error("부름이 재신청 중 오류 발생", e);
            return false;
        }
    }

    @Override
    public int getSettlementWaitingAmount(Long erranderId) {
        return erranderMapper.getSettlementWaitingAmount(erranderId);
    }

    @Override
    public int getExpectedAmount(Long erranderId) {
        return erranderMapper.getExpectedAmount(erranderId);
    }

    @Override
    public int getThisMonthSettledAmount(Long erranderId) {
        LocalDate now = LocalDate.now();
        return erranderMapper.getMonthEarning(erranderId, now.getYear(), now.getMonthValue());
    }

    @Override
    public List<ErranderReviewVO> getErranderReviews(Long erranderId, int page, int size) {
        int offset = (page - 1) * size;
        return erranderMapper.getErranderReviews(erranderId, offset, size);
    }

}
