package com.gorani.vroom.community;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommunityServiceImpl implements CommunityService{

    @Autowired
    private CommunityMapper communityMapper;

    @Override
    public List<CategoryVO> getCategoryList() {
        return communityMapper.selectCategoryList();
    }
}
