package com.gorani.vroom.errander.profile;

import java.util.List;

public interface ErranderService {

    // 라이더 프로필 조회랑 통계 조회
    ErranderProfileVO getErranderProfile(Long userId);

    // 부름이 등록
    boolean registerErrander(ErranderProfileVO profileVO, List<ErranderDocumentVO> fileUrls);

    // 정산 대기 금액 (CONFIRMED1 상태)
    int getSettlementWaitingAmount(Long erranderId);

    // 수령 예정 금액 (CONFIRMED2 상태)
    int getExpectedAmount(Long erranderId);

    // 이번 달 정산 수익 (COMPLETED 상태)
    int getThisMonthSettledAmount(Long erranderId);
}
