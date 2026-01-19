package com.gorani.vroom.community;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommunityMapper {
    // 카테고리 목록 조회
    List<CategoryVO> selectCategoryList();

    // 게시글 목록 조회(카테고리 필터 추가)
    List<CommunityPostVO> selectPostList(
            @Param("dongCode") String dongCode,
            @Param("categoryId") Long categoryId,
            @Param("searchKeyword") String searchKeyword
    );

    List<CommunityPostVO> selectPopularPostList(
            @Param("dongCode") String dongCode,
            @Param("searchKeyword") String searchKeyword
    );
}
