package com.gorani.vroom.admin.erranders;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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

    @GetMapping("/api/admin/erranders")
    @ResponseBody
    public Map<String, Object> searchUsers(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String approveStatus,
            @RequestParam(required = false) String activeStatus,
            @RequestParam(required = false) Integer reviewScope,
            @RequestParam(defaultValue = "1") int page
    ) {

        return service.searchErranders(keyword, approveStatus, activeStatus, reviewScope, page);
    }

    // 부름이 상세 페이지 이동
    @GetMapping("/admin/erranders/detail")
    public String getErranderDetail(
            @RequestParam("id") Long erranderId, Model model
    ) {

        return "admin/errander_detail";
    }

    @GetMapping("/api/admin/erranders/resume")
    @ResponseBody
    public Map<String, Object> getErranderResume(
            @RequestParam("id") Long erranderId
    ) {
        return service.getErranderApprovalDetail(erranderId);
    }
}
