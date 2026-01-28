package com.gorani.vroom.errander.activity;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ErranderActivityMapper {

    // 일별 수익 합계 조회
    List<ErranderActivityVO> getErranderActivities(@Param("erranderId") Long erranderId,
                                                   @Param("year") int year,
                                                   @Param("month") int month);
}
