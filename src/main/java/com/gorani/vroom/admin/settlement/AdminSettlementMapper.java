package com.gorani.vroom.admin.settlement;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminSettlementMapper {
    Map<String, Object> getSummary();

    // 목록 검색
    List<Map<String, Object>> searchSettlements(Map<String, Object> params);

    // 목록 카운트 (페이징용)
    int countSettlements(Map<String, Object> params);

    // 상세 조회
    Map<String, Object> getSettlementDetail(Long id);

    // 상태 업데이트
    void updateSettlementStatus(Map<String, Object> params);

}
