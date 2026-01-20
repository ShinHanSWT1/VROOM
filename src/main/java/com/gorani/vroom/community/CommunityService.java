package com.gorani.vroom.community;

import java.util.List;

public interface CommunityService {
    // 카테고리 목록 조회
    List<CategoryVO> getCategoryList();

    // 게시글 목록 조회 (필터링 포함)
    List<CommunityPostVO> getPostList(String dongCode, Long categoryId, String searchKeyword);

    // 인기글 조회
    List<CommunityPostVO> getPopularPostList(String dongCode, String searchKeyword);

    // 게시글 상세 데이터 조회
    CommunityPostVO getPostDetail(int postId);

}
