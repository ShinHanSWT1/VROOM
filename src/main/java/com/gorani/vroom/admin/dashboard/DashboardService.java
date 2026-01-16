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

    private Map<String, Object> convErrandStatusToMapData(List<Map<String, Object>> data){

        // 결과
        Map<String, Object> dataMap = new HashMap<>();

        // 상태 순서 고정
        List<String> statusOrder = List.of(
                "WAITING", "MATCHED", "CONFIRMED", "IN_PROGRESS", "COMPLETED", "CANCELED"
        );

        Map<String, Integer> countMap = new HashMap<>();

        if(data != null){
            for (Map<String, Object> row : data) {
                String status = row.get("status").toString();
                int cnt = ((Number) row.get("cnt")).intValue();
                countMap.put(status, cnt);
            }
        }

        List<String> labels = new ArrayList<>();
        List<Integer> values = new ArrayList<>();

        for(String status : statusOrder){
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

}
