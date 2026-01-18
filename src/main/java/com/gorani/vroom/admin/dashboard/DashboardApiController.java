package com.gorani.vroom.admin.dashboard;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/admin/dashboard")
@RequiredArgsConstructor
public class DashboardApiController {

    private final DashboardService service;

    @GetMapping("/errand-status")
    public Map<String, Object> errandStatus(){
        return service.getErrandsStatusData();
    }

    @GetMapping("/errand-category")
    public Map<String, Object> errandCategoryStatus(){
        return service.getErrandsCategoryData();
    }

    @GetMapping("/errand-hourly-trend")
    @ResponseBody
    public Map<String, Object> errandHourlyTrend() {
        return service.getErrandsHourlyTrendData();
    }

    @GetMapping("/issue-summary")
    public Map<String, Object> getIssueSummary() {
        return service.getReportSummaryData();
    }

    @GetMapping("/settlement-summary")
    public Map<String, Object> getSettlementSummary() {
        return service.getSettlementSummaryData();
    }

}
