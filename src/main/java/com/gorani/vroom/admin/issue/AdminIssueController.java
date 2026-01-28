package com.gorani.vroom.admin.issue;

import com.gorani.vroom.admin.errand.AdminErrandsService;
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
public class AdminIssueController {

    private final AdminIssueService issueService;

    @GetMapping("/admin/issue")
    public String errands(Model model) {

        model.addAttribute("summary", issueService.getKpi());

        return "admin/issue";
    }

    @GetMapping("/api/admin/issues/search") // JSP fetch 경로와 일치시킴
    @ResponseBody
    public Map<String, Object> searchIssue(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String priority,
            @RequestParam(required = false) String regStart,
            @RequestParam(required = false) String regEnd
    ) {
        Map<String, Object> params = new HashMap<>();
        params.put("page", page);
        params.put("keyword", keyword);
        params.put("type", type);
        params.put("status", status);
        params.put("priority", priority);
        params.put("regStart", regStart);
        params.put("regEnd", regEnd);

        return issueService.searchIssue(params);
    }

    // 우선순위 변경
    @PostMapping("/api/admin/issues/priority")
    @ResponseBody
    public Map<String, Object> updatePriority(@RequestBody Map<String, Object> params) {
        // params: { id, priority }
        return issueService.updatePriority(params);
    }




}
