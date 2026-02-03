package com.gorani.vroom.admin.settlement;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
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

    @ResponseBody
    @GetMapping("/api/admin/settlements")
    public Map<String, Object> getList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

        return settlementService.getSettlementList(page, keyword, status, startDate, endDate);
    }

    // 정산 상세 정보 조회 API
    @ResponseBody
    @GetMapping("/api/admin/settlements/{id}")
    public Map<String, Object> getDetail(@PathVariable Long id) {

        return settlementService.getSettlementDetail(id);
    }

    // 정산 처리
    @ResponseBody
    @PostMapping("/api/admin/settlements/process")
    public Map<String, Object> process(@RequestBody Map<String, Object> params) {
        Map<String, Object> result = new HashMap<>();

        try {
            Long errandId = Long.valueOf(params.get("id").toString());
            String action = (String) params.get("action");
            String memo = (String) params.get("memo");
            BigDecimal amount = new BigDecimal(params.get("amount").toString());

            settlementService.processSettlement(errandId, action, memo, amount);

            result.put("success", true);

        } catch (Exception e) {
            log.error("정산 처리 실패", e);
            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return result;
    }


}
