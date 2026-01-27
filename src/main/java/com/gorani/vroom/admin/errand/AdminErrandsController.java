package com.gorani.vroom.admin.errand;

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

    private final AdminErrandsService errandsService;
    private final LocationService locationService;

    @GetMapping("/admin/errands")
    public String errands(Model model) {

        model.addAttribute("summary", errandsService.getKpi());
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
            @RequestParam(required = false) String dueEnd
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
        params.put("size", 10); // 페이지당 출력 개수

        return errandsService.searchErrands(params);
    }

    @GetMapping("/api/admin/errands/detail")
    @ResponseBody
    public Map<String, Object> getErrandDetail(@RequestParam("id") Long errandsId) {
        log.info("심부름 상세 및 이력 조회 요청 ID: {}", errandsId);

        return errandsService.getErrandDetailWithHistory(errandsId);
    }

    // 정직원 리스트 조회
    @GetMapping("/api/admin/erranders/employees")
    @ResponseBody
    public List<Map<String, Object>> getAvailableEmployees() {
        return errandsService.getAvailableEmployees();
    }

    // 심부름 배정
    @PostMapping("/api/admin/errands/assign")
    @ResponseBody
    public Map<String, Object> assignErrander(@RequestBody Map<String, Object> params) {
        // params: { errandId, erranderId, reason }
        return errandsService.assignErrander(params);
    }

}
