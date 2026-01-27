package com.gorani.vroom.admin.notice;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminNoticeController {

    @GetMapping("/admin/notice")
    public String notice(Model model) {

//        model.addAttribute("summary", settlementService.getKpi());

        return "admin/notice";
    }
}
