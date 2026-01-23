package com.gorani.vroom.errander.profile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

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


        // 완료율 계산하기
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




        // 서비스 내부에서 현재 날짜 구하기
        LocalDate now = LocalDate.now();
        int year = now.getYear();
        int month = now.getMonthValue();

        // 달 별 수익
        int monthEarning = erranderMapper.getMonthEarning(erranderId, now.getYear(), now.getMonthValue());

        // 이번달의 돈
        profile.setThisMonthEarning((long) monthEarning);

        return profile;
    }
}
