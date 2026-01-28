package com.gorani.vroom.admin.settlement;

import com.gorani.vroom.admin.issue.AdminIssueService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminSettlementController {

    private final AdminSettlementService settlementService;

    @GetMapping("/admin/settlements")
    public String errands(Model model) {

        model.addAttribute("summary", settlementService.getKpi());

        return "admin/settlement";
    }

    @GetMapping("/api/admin/settlements")
    @ResponseBody
    public Map<String, Object> getSettlementList(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(defaultValue = "1") int page
    ) {
        return settlementService.searchSettlements(keyword, status, startDate, endDate, page);
    }

    // 정산 상세 정보 조회 API
    @GetMapping("/api/admin/settlements/{id}")
    @ResponseBody
    public Map<String, Object> getSettlementDetail(@PathVariable Long id) {
        return settlementService.getSettlementDetail(id);
    }

    // 정산 상태 처리 API (승인/보류/거절)
    @PostMapping("/api/admin/settlements/process")
    @ResponseBody
    public Map<String, Object> processSettlement(@RequestBody Map<String, Object> payload) {
        // payload: { id: 101, action: "COMPLETED", memo: "확인함" }
        return settlementService.processSettlement(payload);
    }


}
