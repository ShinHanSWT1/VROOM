package com.gorani.vroom.main;

import com.gorani.vroom.community.CommunityPostVO;
import com.gorani.vroom.errand.post.CategoryVO;
import com.gorani.vroom.errand.post.ErrandListVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MainServiceImpl implements MainService {
    
    private final MainMapper mainMapper;
    
    // 심부름 카테고리 리스트 조회 
    @Override
    public List<CategoryVO> getErrandsCategoryList() {
        return mainMapper.selectErrandsCategoryList();
    }

    // 최근 심부름 게시글 조회
    @Override
    public List<ErrandListVO> getMainErrandList(String guName) {
        return mainMapper.selectMainErrandList(guName);
    }

    // 커뮤니티 인기 게시글 조회
    @Override
    public List<CommunityPostVO> getMainPopularPostList(String guName) {
        return mainMapper.selectMainPopularPostList(guName);
    }

    // 우수 부름이 리뷰 조회
    @Override
    public List<MainReviewVO> getMainTopReviews() {
        return mainMapper.selectMainTopReviews();
    }
}
