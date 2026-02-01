package com.gorani.vroom.errander.profile;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Map;

@Mapper
public interface ErranderMapper {

    // 라이더 프로필 조회 -> userId로 확인함
    ErranderProfileVO getErranderProfile(@Param("userId") Long userId);

    // 수행 중인 건수
    int getInProgressCount(@Param("erranderId") Long erranderId);
    // 완료 건수
    int getCompletedCount(@Param("erranderId") Long erranderId);
    // 달 수익
    int getMonthEarning(@Param("erranderId") Long erranderId,
                        @Param("year") int year,
                        @Param("month")int month);
    // 평균 평점
    double getErranderAvgRating(@Param("erranderId") Long erranderId);
    // 리뷰 개수
    int getReviewCount(@Param("erranderId") Long erranderId);

    // 부름이 프로필 등록
    int insertErranderProfile(ErranderProfileVO profileVO);

    // 부름이 서류 등록
    int insertErranderDocument(
            @Param("erranderId") Long erranderId,
            @Param("fileUrl") String fileUrl,
            @Param("docType") String docType,
            @Param("name") String name,
            @Param("status") String status
    );

    // 사용자 역할 변경
    int updateUserRole(@Param("userId") Long userId, @Param("role") String role);


}
