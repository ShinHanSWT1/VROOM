package com.gorani.vroom.location;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class LocationServiceImpl implements LocationService {

    private final LocationMapper locationMapper;

    @Override
    public List<String> getGuList() {
        return locationMapper.selectGuList();
    }

    @Override
    public List<LegalDongVO> getDongList(String gunguName) {
        return locationMapper.selectDongList(gunguName);
    }
}
