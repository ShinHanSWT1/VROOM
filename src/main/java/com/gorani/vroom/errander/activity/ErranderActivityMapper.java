package com.gorani.vroom.errander.activity;

import com.gorani.vroom.errand.post.ErrandListVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ErranderActivityMapper {

    // 일별 수익 합계 조회
    List<ErranderActivityVO> getErranderActivities(@Param("erranderId") Long erranderId,
                                                   @Param("year") int year,
                                                   @Param("month") int month);
    // 특정 날짜의 거래 상세 목록 조회하기
    List<ErrandListVO> getErranderDailyDetail(@Param("erranderId") Long erranderId,
                                              @Param("date") String date);
}
