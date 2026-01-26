package com.gorani.vroom.admin.errand;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminErrandsService {

    @Autowired
    AdminErrandsMapper mapper;

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

        Map<String, Object> result = new HashMap<>();
        result.put("errandList", list);
        result.put("totalCount", totalCount);

        Map<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("currentPage", page);
        pageInfo.put("totalPage", totalPage);
        pageInfo.put("startPage", ((page - 1) / 5) * 5 + 1);
        pageInfo.put("endPage", Math.min((((page - 1) / 5) * 5 + 5), totalPage));
        result.put("pageInfo", pageInfo);

        return result;
    }

    // 상세 조회 시 이력 정보 추가 제공
    public List<Map<String, Object>> getHistory(Long errandsId) {
        return mapper.getErrandHistory(errandsId);
    }
}
