package com.gorani.vroom.community;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CommunityServiceImpl implements CommunityService{

    private final CommunityMapper communityMapper;

    @Override
    public List<CategoryVO> getCategoryList() {
        return communityMapper.selectCategoryList();
    }

    @Override
    public List<CommunityPostVO> getPostList(String dongCode, Long categoryId, String searchKeyword) {
        return communityMapper.selectPostList(dongCode, categoryId, searchKeyword);
    }

    @Override
    public List<CommunityPostVO> getPopularPostList(String dongCode, String searchKeyword) {
        return communityMapper.selectPopularPostList(dongCode, searchKeyword);
    }

    @Override
    public CommunityPostVO getPostDetail(int postId) {
        return communityMapper.selectPostDetail(postId);
    }
}
