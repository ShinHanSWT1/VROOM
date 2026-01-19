package com.gorani.vroom.community;

import java.util.List;

public interface CommunityService {
    // 카테고리 목록 조회
    List<CategoryVO> getCategoryList();

    // 게시글 목록 조회 (필터링 포함)
    List<CommunityPostVO> getPostList(String dongCode1, Long categoryId, String searchKeyword);




}
