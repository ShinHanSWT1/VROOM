package com.gorani.vroom.admin.users;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
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
}
