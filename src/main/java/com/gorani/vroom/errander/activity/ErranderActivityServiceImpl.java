package com.gorani.vroom.errander.activity;

import com.gorani.vroom.errander.profile.ErranderMapper;
import com.gorani.vroom.errander.profile.ErranderProfileVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ErranderActivityServiceImpl implements ErranderActivityService {

    private final ErranderActivityMapper activityMapper;
    private final ErranderMapper erranderMapper;

    @Override
    public List<ErranderActivityVO> getErranderActivities(Long userId, int year, int month) {
        // userId로 erranderId 조회
        ErranderProfileVO profile = erranderMapper.getErranderProfile(userId);
        if (profile == null) {
            return Collections.emptyList();
        }

        Long erranderId = profile.getErranderId();
        return activityMapper.getErranderActivities(erranderId, year, month);
    }
}