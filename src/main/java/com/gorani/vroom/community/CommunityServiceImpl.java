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
}
