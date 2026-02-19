package com.gorani.vroom.admin.issue;

import com.gorani.vroom.admin.errand.AdminErrandsMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class AdminIssueService {

    @Autowired
    AdminIssueMapper mapper;

    Map<String, Object> getKpi() {
        return mapper.getSummary();
    }

    public Map<String, Object> searchIssue(Map<String, Object> param) {
        int page = Integer.parseInt(param.get("page").toString());
        int size = 10;
        param.put("limit", size);
        param.put("offset", (page - 1) * size);

        List<Map<String, Object>> list = mapper.searchIssues(param);
        int totalCount = mapper.countIssue(param);
        int totalPage = (int) Math.ceil((double) totalCount / size);

        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("issueList", list);
        dataMap.put("totalCount", totalCount);

        Map<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("currentPage", page);
        pageInfo.put("totalPage", totalPage);
        pageInfo.put("startPage", ((page - 1) / 5) * 5 + 1);
        pageInfo.put("endPage", Math.min((((page - 1) / 5) * 5 + 5), totalPage));
        dataMap.put("pageInfo", pageInfo);

        return dataMap;
    }

    // 우선순위 변경 서비스 로직
    public Map<String, Object> updatePriority(Map<String, Object> param) {
        int result = mapper.updateIssuePriority(param);
        Map<String, Object> response = new HashMap<>();
        if (result > 0) {
            response.put("result", "success");
        } else {
            response.put("result", "fail");
            response.put("message", "업데이트 중 오류가 발생했습니다.");
        }
        return response;
    }
}
