package com.gorani.vroom.main;

import com.gorani.vroom.community.CommunityPostVO;
import com.gorani.vroom.errand.post.CategoryVO;
import com.gorani.vroom.errand.post.ErrandListVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MainMapper {

    // 심부름 카테고리 리스트 조회
    List<CategoryVO> selectErrandsCategoryList();

    // 최근 심부름 게시글 조회
    List<ErrandListVO> selectMainErrandList(@Param("dongCode") String dongCode);

    // 최근 커뮤니티 인기 게시글 조회
    List<CommunityPostVO> selectMainPopularPostList(@Param("dongCode") String dongCode);
}
