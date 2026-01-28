package com.gorani.vroom.admin.settings;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminSettingController {

    @GetMapping("/admin/settings")
    public String settings(Model model) {

//        model.addAttribute("summary", settlementService.getKpi());

        return "admin/settings";
    }
}
