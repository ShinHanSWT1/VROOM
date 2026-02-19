package com.gorani.vroom.main;

import com.gorani.vroom.community.CommunityPostVO;
import com.gorani.vroom.errand.post.CategoryVO;
import com.gorani.vroom.errand.post.ErrandListVO;

import java.util.List;

public interface MainService {

    // 심부름 카테고리 리스트 조회
    List<CategoryVO> getErrandsCategoryList();

    // 최근 심부름 게시글 조회
    List<ErrandListVO> getMainErrandList(String guName);

    // 인기 커뮤니티 게시글 조회
    List<CommunityPostVO> getMainPopularPostList(String guName);

    // 우수 부름이 리뷰 조회
    List<MainReviewVO> getMainTopReviews();
}
