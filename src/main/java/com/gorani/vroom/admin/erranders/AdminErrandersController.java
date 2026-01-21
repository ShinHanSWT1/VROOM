package com.gorani.vroom.admin.erranders;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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

    // 부름이 상세 페이지 이동
    @GetMapping("/admin/erranders/detail")
    public String getErranderDetail(
            @RequestParam("id") Long erranderId, Model model
    ) {

        return "admin/errander_detail";
    }

    // 부름이 목록 조회
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

    // 부름이 승인 요청 정보 조회
    @GetMapping("/api/admin/erranders/resume")
    @ResponseBody
    public Map<String, Object> getErranderResume(
            @RequestParam("id") Long erranderId
    ) {
        return service.getErranderApprovalDetail(erranderId);
    }

    // 부름이 승인 요청
    @PostMapping("/api/admin/erranders/approve")
    @ResponseBody
    public Map<String, Object> approveErrander(
            @RequestBody Map<String, Object> params
    ) {
        Long erranderId = Long.parseLong(params.get("erranderId").toString());
        String status = params.get("status").toString();

        return service.approveErrander(erranderId, status);
    }
}
