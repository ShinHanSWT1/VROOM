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
    public List<ErrandListVO> getMainErrandList(String dongCode) {
        return mainMapper.selectMainErrandList(dongCode);
    }

    // 커뮤니티 인기 게시글 조회
    @Override
    public List<CommunityPostVO> getMainPopularPostList(String dongCode) {
        return mainMapper.selectMainPopularPostList(dongCode);
    }
}
