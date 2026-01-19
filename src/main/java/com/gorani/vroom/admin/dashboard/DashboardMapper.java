package com.gorani.vroom.admin.dashboard;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface DashboardMapper {
    DashboardSummaryVO getSummary();
    List<Map<String, Object>> getErrandsStatusCount();
    List<Map<String, Object>> getErrandsCategoryCount();
    List<Map<String, Object>> getErrandsHourlyTrend();
    Map<String, Object> getSettlementSummary();
    Map<String, Object> getReportSummary();
    List<Map<String, Object>> getErrandRegionSummaryTop5();
}
