package com.gorani.vroom.errander.activity;

import java.util.List;

public interface ErranderActivityService {

    // 일별 수익 조회
    List<ErranderActivityVO> getErranderActivities(Long userId, int year, int month);
}
