package com.gorani.vroom.admin.errand;

import com.gorani.vroom.errand.assignment.ErrandAssignmentService;
import com.gorani.vroom.location.LocationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminErrandsController {

    private final AdminErrandsService adminErrandsService;
    private final LocationService locationService;
    private final ErrandAssignmentService errandService;

    @GetMapping("/admin/errands")
    public String errands(Model model) {

        model.addAttribute("summary", adminErrandsService.getKpi());
        model.addAttribute("gunguList", locationService.getGuList());

        return "admin/errands";
    }

    @GetMapping("/api/admin/errands/search")
    @ResponseBody
    public Map<String, Object> searchErrands(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String gu,
            @RequestParam(required = false) String dong,
            @RequestParam(required = false) String regStart,
            @RequestParam(required = false) String regEnd,
            @RequestParam(required = false) String dueStart,
            @RequestParam(required = false) String dueEnd,
            @RequestParam(required = false) String status
    ) {
        Map<String, Object> params = new HashMap<>();
        params.put("page", page);
        params.put("keyword", keyword);
        params.put("gu", gu);
        params.put("dong", dong);
        params.put("regStart", regStart);
        params.put("regEnd", regEnd);
        params.put("dueStart", dueStart);
        params.put("dueEnd", dueEnd);
        params.put("status", status);
        params.put("size", 10); // 페이지당 출력 개수

        return adminErrandsService.searchErrands(params);
    }

    @GetMapping("/api/admin/errands/detail")
    @ResponseBody
    public Map<String, Object> getErrandDetail(
            @RequestParam("id") Long errandsId) {
        log.info("심부름 상세 및 이력 조회 요청 ID: {}", errandsId);

        return adminErrandsService.getErrandDetailWithHistory(errandsId);
    }

    // 정직원 리스트 조회
    @GetMapping("/api/admin/erranders/employees")
    @ResponseBody
    public List<Map<String, Object>> getAvailableEmployees() {
        return adminErrandsService.getAvailableEmployees();
    }

    // 심부름 배정
    @PostMapping("/api/admin/errands/assign")
    @ResponseBody
    public Map<String, Object> assignErrander(
            @RequestBody Map<String, Object> params) {
        // params: { errandId, erranderId, adminId, reason }
        Long errandId = Long.parseLong(params.get("errandId").toString());
        Long erranderId = Long.parseLong(params.get("erranderId").toString());
        Long adminId = Long.parseLong(params.get("adminId").toString());
        String reason = params.get("reason").toString();

        Long res = errandService.assignErranderByAdmin(errandId, erranderId, adminId, reason);

        if(res != null) {
            return Map.of(
                    "result", "success",
                    "resData", res
            );
        }

        return Map.of(
                "result", "fail",
                "message", "오류가 발생했습니다"
        );
    }

}
