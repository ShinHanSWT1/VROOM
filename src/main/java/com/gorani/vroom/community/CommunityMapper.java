package com.gorani.vroom.community;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CommunityMapper {
    // 카테고리 목록 조회
    List<CategoryVO> selectCategoryList();

    // 게시글 목록 조회(카테고리 필터 추가)

}
