package com.gorani.vroom.Location;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LocationMapper {
    List<String> selectGuList();
    List<LegalDongVO> selectDongList(String gunguName);
}
