package com.gorani.vroom.community;

import java.util.List;

public interface LocationService {

    // 전체 구 조회
    List<String> getGuList();

    // 특정 구에 속한 법정동 목록 조회
    List<LegalDongVO> getDongList(String gunguName);
}
