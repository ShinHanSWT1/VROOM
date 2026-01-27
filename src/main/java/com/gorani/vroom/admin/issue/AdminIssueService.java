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

    // 심부름 목록 필터링 조회
    public Map<String, Object> searchErrands(Map<String, Object> param) {
        int page = Integer.parseInt(param.get("page").toString());
        int size = 10;
        param.put("limit", size);
        param.put("offset", (page - 1) * size);

        List<Map<String, Object>> list = mapper.selectErrandList(param);
        int totalCount = mapper.countErrandList(param);
        int totalPage = (int) Math.ceil((double) totalCount / size);

        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("errandList", list);
        dataMap.put("totalCount", totalCount);

        Map<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("currentPage", page);
        pageInfo.put("totalPage", totalPage);
        pageInfo.put("startPage", ((page - 1) / 5) * 5 + 1);
        pageInfo.put("endPage", Math.min((((page - 1) / 5) * 5 + 5), totalPage));
        dataMap.put("pageInfo", pageInfo);

        log.info("부름이 목록 정보" + dataMap);

        return dataMap;
    }

    // 상세 조회 시 이력 정보 추가 제공
    public List<Map<String, Object>> getHistory(Long errandsId) {
        return mapper.getErrandHistory(errandsId);
    }

    public Map<String, Object> getErrandDetailWithHistory(Long errandsId) {
        Map<String, Object> result = new HashMap<>();

        // 심부름 기본 상세 정보 조회
        Map<String, Object> detail = mapper.getErrandDetail(errandsId);
        result.put("detail", detail);

        // 해당 심부름의 배정/매칭 이력 조회
        List<Map<String, Object>> history = mapper.getErrandHistory(errandsId);
        result.put("history", history);

        return result;
    }

    public List<Map<String, Object>> getAvailableEmployees() {
        return mapper.getAvailableEmployees();
    }

    public Map<String, Object> assignErrander(Map<String, Object> params) {

        return Map.of();
    }
}
