package com.gorani.vroom.admin.dashboard;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestAttribute;

@Slf4j
@Controller
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService service;

    @GetMapping("/admin/dashboard")
    public String dashbaord(Model model){
        DashboardSummaryVO dashVO = service.getSummary();
        log.info("[관리자 대시보드 상단요약] " + dashVO);

        model.addAttribute("dashSummary", dashVO);

        return "admin/dashboard";
    }
}
