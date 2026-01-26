package com.gorani.vroom.admin.errand;

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
public class AdminErrandsController {

    private final AdminErrandsService service;

    @GetMapping("/admin/errands")
    public String erranders(Model model) {

        model.addAttribute("summary", service.getKpi());
        log.info("심부름 요약 정보" + service.getKpi());
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

        return service.searchErrands(params);
    }

}
