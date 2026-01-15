package com.gorani.vroom.admin.dashboard;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminDashboardController {

    @GetMapping("/admin/dashboard")
    public String dashbaord(){

        return "admin/dashboard";
    }
}
