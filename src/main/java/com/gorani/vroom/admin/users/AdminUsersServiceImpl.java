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
    public Map<String, Object> searchUsers(String keyword, String status, String role, Integer reportCount, int page) {

        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        Map<String, Object> param = new HashMap<>();
        param.put("keyword", keyword);
        param.put("status", status);
        param.put("role", role);
        param.put("reportCount", reportCount);
        param.put("limit", pageSize);
        param.put("offset", offset);

        List<Map<String, Object>> userList = mapper.searchUsers(param);
        int totalCount = mapper.countUsers(param);

        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int startPage = ((page - 1) / 10) * 10 + 1;
        int endPage = Math.min(startPage + 9, totalPage);

        Map<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("currentPage", page);
        pageInfo.put("pageSize", pageSize);
        pageInfo.put("totalPage", totalPage);
        pageInfo.put("startPage", startPage);
        pageInfo.put("endPage", endPage);

        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("userList", userList);
        dataMap.put("totalCount", totalCount);
        dataMap.put("pageInfo", pageInfo);

        return dataMap;
    }
}
