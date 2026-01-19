package com.gorani.vroom.admin.users;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Primary
public class AdminUsersServiceImpl implements AdminUsersService {

    @Autowired
    private AdminUsersMapper mapper;

    @Override
    public Map<String, Object> getSummary() {
        return mapper.getSummary();
    }

    @Override
    public List<Map<String, Object>> searchUsers(String keyword, String status, String role, Integer reportCount, int page) {

        Map<String, Object> param = new HashMap<>();
        param.put("keyword", keyword);
        param.put("status", status);
        param.put("role", role);
        param.put("reportCount", reportCount);
        param.put("page", page);

        List<Map<String, Object>> data = mapper.searchUsers(param);

        return data;
    }
}
