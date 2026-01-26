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
        String reason = params.get("reason").toString();

        Map<String, Object> response;

        try {
            response = service.approveErrander(erranderId, status, reason);

        } catch (Exception e) {
            response = Map.of(
                    "result", "fail",
                    "message", e.getMessage()
            );
        }

        return response;
    }

    // 부름이 활성 상태 변경 요청
    @PostMapping("/api/admin/erranders/status")
    @ResponseBody
    public Map<String, Object> changeErranderStatus(
            @RequestBody Map<String, Object> params
    ) {
        Long erranderId = Long.parseLong(params.get("erranderId").toString());
        String status = params.get("activeStatus").toString();

        return service.changeErranderStatus(erranderId, status);
    }

    // 부름이 관리 상세 페이지 요청
    @GetMapping("/admin/erranders/detail/{id}")
    public String erranderDetail(
            @PathVariable("id") Long erranderId,
            Model model
    ) {
        model.addAttribute("summary", service.getDetailSummary(erranderId));
        log.info("부름이 기본 정보: " + service.getDetailSummary(erranderId));

        return "admin/errander_detail";
    }


    @PostMapping("/api/admin/erranders/detail")
    @ResponseBody
    public Map<String, Object> erranderAllInfo(
            @RequestBody Map<String, Object> params
    ) {
        Long erranderId = Long.parseLong(params.get("erranderId").toString());
        int limit = Integer.parseInt(params.get("limit").toString());

        log.info("부름이 상세 정보 요약" + service.getDetailAllInfo(erranderId, limit));
        return service.getDetailAllInfo(erranderId, limit);
    }

    @PostMapping("/api/admin/erranders/savememo")
    @ResponseBody
    public Map<String, Object> saveAdminMemo(
            @RequestBody Map<String, Object> params
    ) {
        Long erranderId = Long.parseLong(params.get("erranderId").toString());
        String memo = params.get("memo").toString();

        return service.saveAdminMemo(erranderId, memo);
    }
}
