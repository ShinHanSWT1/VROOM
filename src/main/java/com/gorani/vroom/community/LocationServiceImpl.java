package com.gorani.vroom.community;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LocationServiceImpl implements LocationService {

    // 스프링에게 Mapper연결 요청
    @Autowired
    private LocationMapper locationMapper;

    @Override
    public List<String> getGuList() {
        return locationMapper.selectGuList();
    }

    @Override
    public List<LegalDongVO> getDongList(String gunguName) {
        // 매퍼가 가져온 데이터를 그대로 컨트롤러에 전달
        return locationMapper.selectDongList(gunguName);
    }
}
