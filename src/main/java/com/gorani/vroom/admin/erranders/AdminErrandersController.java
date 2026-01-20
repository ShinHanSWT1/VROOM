package com.gorani.vroom.admin.erranders;

import com.gorani.vroom.admin.users.AdminUsersService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminErrandersController {

    private final AdminErrandersService service;

    @GetMapping("/admin/erranders")
    public String erranders(Model model) {
        Map<String, Object> summaryData = service.getSummary();
        model.addAttribute("summary", summaryData);

        return "admin/erranders";
    }


    // 사용자 상세 페이지 이동
    @GetMapping("/admin/erranders/detail")
    public String userDetail(
            @RequestParam("id") Long erranderId, Model model
    ) {

        return "admin/errander_detail";
    }
}
