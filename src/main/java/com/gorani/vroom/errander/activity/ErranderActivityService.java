package com.gorani.vroom.errander.activity;

import com.gorani.vroom.errand.post.ErrandListVO;

import java.util.List;

public interface ErranderActivityService {

    // 일별 수익 조회
    List<ErranderActivityVO> getErranderActivities(Long userId, int year, int month);

    // 특정 날짜 거래 상세 조회
    List<ErrandListVO> getErranderDetail(Long userId, String date);
}
