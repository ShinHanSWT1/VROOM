package com.gorani.vroom.admin.dashboard;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class DashboardService {

    @Autowired
    private DashboardMapper mapper;

    public DashboardSummaryVO getSummary() {
        return mapper.getSummary();
    }

    public Map<String, Object> getErrandsStatusData() {
        List<Map<String, Object>> rows = mapper.getErrandsStatusCount();

        return convErrandStatusToMapData(rows);
    }

    public Map<String, Object> getErrandsCategoryData() {
        List<Map<String, Object>> rows = mapper.getErrandsCategoryCount();

        return convErrandCategoryToMapData(rows);
    }

    public Map<String, Object> getErrandsRegionSummaryData() {
        List<Map<String, Object>> rows = mapper.getErrandRegionSummaryTop5();

        return convErrandRegionToMapData(rows);
    }

    public Map<String, Object> getErrandsHourlyTrendData() {
        List<Map<String, Object>> rows = mapper.getErrandsHourlyTrend();

        return convErrandHourlyTrendToMapData(rows);
    }

    public Map<String, Object> getReportSummaryData() {
        Map<String, Object> row = mapper.getReportSummary();

        Map<String, Object> mapData = new HashMap<>();
        mapData.put("pending", ((Number) row.get("pending")).intValue());
        mapData.put("processing", ((Number) row.get("processing")).intValue());
        mapData.put("completed", ((Number) row.get("completed")).intValue());

        return mapData;
    }

    public Map<String, Object> getSettlementSummaryData() {
        Map<String, Object> row = mapper.getSettlementSummary();

        Map<String, Object> mapData = new HashMap<>();
        mapData.put("todayAmount", ((Number) row.get("today_amount")).longValue());
        mapData.put("pendingCount", ((Number) row.get("pending_count")).intValue());
        mapData.put("monthAmount", ((Number) row.get("month_amount")).longValue());

        return mapData;
    }

    private Map<String, Object> convErrandRegionToMapData(List<Map<String, Object>> data) {
        Map<String, Object> dataMap = new HashMap<>();
        /*
        * {
              "chart": {
                "labels": ["강남구", "서초구", "송파구"],
                "values": [120, 95, 80]
              },
              "table": [
                {
                  "region": "강남구",
                  "total": 120,
                  "completionRate": 92,
                  "avgPrice": 18000
                },
                {
                  "region": "서초구",
                  "total": 95,
                  "completionRate": 88,
                  "avgPrice": 21000
                }
              ]
            }
        * */

        List<String> labels = new ArrayList<>();
        List<Integer> values = new ArrayList<>();
        List<Map<String, Object>> table = new ArrayList<>();

        if (data == null || data.isEmpty()) {
            dataMap.put("chart", Map.of(
                    "labels", List.of("데이터 없음"),
                    "values", List.of(0)
            ));

            for (int i = 0; i < 5; i++) {
                table.add(Map.of(
                        "region", "-",
                        "total", 0,
                        "completionRate", 0,
                        "avgPrice", 0
                ));
            }
        } else {
            for (Map<String, Object> row : data) {
                String region = (String) row.get("region");
                int totalCnt = ((Number) row.get("total_cnt")).intValue();
                int completedCnt = ((Number) row.get("completed_cnt")).intValue();
                int avgPrice = row.get("avg_price") == null
                        ? 0
                        : ((Number) row.get("avg_price")).intValue();

                int completionRate = totalCnt == 0
                        ? 0
                        : (int) Math.round(completedCnt * 100.0 / totalCnt);

                labels.add(region);
                values.add(totalCnt);

                table.add(Map.of(
                        "region", region,
                        "total", totalCnt,
                        "completionRate", completionRate,
                        "avgPrice", avgPrice
                ));

            }
        }

        dataMap.put("chart", Map.of(
                "labels", labels,
                "values", values
        ));
        dataMap.put("table", table);


        return dataMap;
    }


    private Map<String, Object> convErrandStatusToMapData(List<Map<String, Object>> data) {

        // 결과
        Map<String, Object> dataMap = new HashMap<>();

        // 상태 순서 고정
        List<String> statusOrder = List.of(
                "WAITING", "MATCHED", "CONFIRMED1", "CONFIRMED2", "COMPLETED", "CANCELED", "HOLD"
        );

        Map<String, Integer> countMap = new HashMap<>();

        if (data != null) {
            for (Map<String, Object> row : data) {
                String status = row.get("status").toString();
                int cnt = ((Number) row.get("cnt")).intValue();
                countMap.put(status, cnt);
            }
        }

        List<String> labels = new ArrayList<>();
        List<Integer> values = new ArrayList<>();

        for (String status : statusOrder) {
            labels.add(status);
            values.add(countMap.getOrDefault(status, 0));
        }

        dataMap.put("labels", labels);
        dataMap.put("values", values);

        // dataMap 예시
        // {
        //   "labels": ["WAITING", "MATCHED", "CONFIRMED", "IN_PROGRESS", "COMPLETED", "CANCELED"],
        //   "values": [3,5,7,20,1]
        // }

        log.info("ErrandStatusChartData = {}", dataMap);


        return dataMap;
    }

    private Map<String, Object> convErrandCategoryToMapData(List<Map<String, Object>> data) {
        Map<String, Object> dataMap = new HashMap<>();

        List<String> labels = new ArrayList<>();
        List<Integer> values = new ArrayList<>();

        if (data == null || data.isEmpty()) {
            labels.add("none");
            values.add(0);
        } else {
            for (Map<String, Object> row : data) {
                labels.add((String) row.get("name"));
                int value = row.get("category") == null ? 0 : ((Number) row.get("cnt")).intValue();
                values.add(value);
            }
        }

        dataMap.put("labels", labels);
        dataMap.put("values", values);

        return dataMap;
    }

    private Map<String, Object> convErrandHourlyTrendToMapData(List<Map<String, Object>> data) {
        Map<Integer, Integer> countMap = new HashMap<>();

        for (Map<String, Object> row : data) {
            int hour = ((Number) row.get("hour")).intValue();
            int cnt = ((Number) row.get("cnt")).intValue();
            countMap.put(hour, cnt);
        }

        List<String> labels = new ArrayList<>();
        List<Integer> values = new ArrayList<>();

        // 0~23시 고정
        for (int h = 0; h < 24; h++) {
            labels.add(h + "시");
            values.add(countMap.getOrDefault(h, 0));
        }

        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("labels", labels);
        dataMap.put("values", values);

        return dataMap;
    }
}
