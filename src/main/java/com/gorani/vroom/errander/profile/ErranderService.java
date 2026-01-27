package com.gorani.vroom.errander.profile;

import java.util.List;

public interface ErranderService {

    // 라이더 프로필 조회랑 통계 조회
    ErranderProfileVO getErranderProfile(Long userId);

    // 부름이 등록
    boolean registerErrander(ErranderProfileVO profileVO, List<String> fileUrls);
}
