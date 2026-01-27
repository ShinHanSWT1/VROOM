package com.gorani.vroom.admin.errand;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminErrandsMapper {
    Map<String, Object> getSummary();

    // 심부름 목록 필터링 조회
    List<Map<String, Object>> selectErrandList(Map<String, Object> param);

    // 필터링된 전체 개수 조회
    int countErrandList(Map<String, Object> param);

    List<Map<String, Object>> getErrandHistory(Long errandsId);

    Map<String, Object> getErrandDetail(Long errandsId);

    List<Map<String, Object>> getAvailableEmployees();
}
