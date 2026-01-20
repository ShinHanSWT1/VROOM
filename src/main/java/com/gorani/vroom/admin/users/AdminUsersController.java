package com.gorani.vroom.admin.users;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminUsersController {

    private final AdminUsersService service;

    @GetMapping("/admin/users")
    public String users(Model model) {
        Map<String, Object> summaryData = service.getSummary();
        model.addAttribute("summary", summaryData);

        return "admin/users";
    }

    @GetMapping("/api/admin/users")
    @ResponseBody
    public Map<String, Object> searchUsers(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String role,
            @RequestParam(required = false) Integer reportCount,
            @RequestParam(defaultValue = "1") int page
    ) {

        return service.searchUsers(keyword, status, role, reportCount, page);
    }

    @PostMapping("/api/admin/users/status")
    @ResponseBody
    public Map<String, String> updateUserStatus(
            @RequestBody Map<String, Object> payload
    ) {
        Long userId = Long.valueOf(payload.get("userId").toString());
        String status = (String) payload.get("status");

        service.updateUserStatus(payload);

        // TODO: 결과 따로 처리하는 로직
        return Map.of("result", "success");
    }

    // 사용자 상세 페이지 이동
    @GetMapping("/admin/users/detail")
    public String userDetail(
            @RequestParam("id") Long userId, Model model
    ) {
        AdminUserDetailDTO userDetail = service.getUserDetail(userId);
        model.addAttribute("user", userDetail);

        return "admin/user_detail";
    }
}
