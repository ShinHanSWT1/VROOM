package com.gorani.vroom.admin.settlement;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminSettlementMapper {

    // 정산 현황 요약 (대기, 보류, 금일 지급액 등)
    Map<String, Object> getSummary();

    // 정산 목록 조회
    List<AdminSettlementVO> selectSettlementList(Map<String, Object> params);

    // 정산 목록 총 개수
    int countSettlements(Map<String, Object> params);

    // 정산 상세 조회
    Map<String, Object> getSettlementDetail(
            @Param("errandId") Long errandId);

    // 정산 상태 및 메모 업데이트
    int updateSettlementStatus(
            @Param("errandId") Long errandId,
            @Param("status") String status,
            @Param("memo") String memo);

    // 상태 변경 이력 추가
    void insertSettlementStatusHistory(
            @Param("errandId") Long errandId,
            @Param("fromStatus") String fromStatus,
            @Param("toStatus") String toStatus);

}
