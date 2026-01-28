package com.gorani.vroom.admin.settlement;

import com.gorani.vroom.admin.issue.AdminIssueMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class AdminSettlementService {

    @Autowired
    AdminSettlementMapper mapper;

    Map<String, Object> getKpi() {
        return mapper.getSummary();
    }

    // 정산 목록 검색
    public Map<String, Object> searchSettlements(String keyword, String status, String startDate, String endDate, int page) {
        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("status", status);
        params.put("startDate", startDate);
        params.put("endDate", endDate);
        params.put("limit", pageSize);
        params.put("offset", offset);

        // 리스트 조회
        List<Map<String, Object>> settlementList = mapper.searchSettlements(params);
        // 전체 개수 조회
        int totalCount = mapper.countSettlements(params);

        // 페이지네이션 정보 계산
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int startPage = ((page - 1) / 10) * 10 + 1;
        int endPage = Math.min(startPage + 9, totalPage);

        Map<String, Object> pageInfo = new HashMap<>();
        pageInfo.put("currentPage", page);
        pageInfo.put("totalPage", totalPage);
        pageInfo.put("startPage", startPage);
        pageInfo.put("endPage", endPage);

        Map<String, Object> result = new HashMap<>();
        result.put("settlementList", settlementList);
        result.put("totalCount", totalCount);
        result.put("pageInfo", pageInfo);

        return result;
    }

    // 상세 정보 조회
    public Map<String, Object> getSettlementDetail(Long id) {
        return mapper.getSettlementDetail(id);
    }

    // 정산 처리 (상태 변경)
    @Transactional
    public Map<String, Object> processSettlement(Map<String, Object> payload) {
        Map<String, Object> result = new HashMap<>();

        try {
            // id, action(COMPLETED/HOLD/REJECTED), memo
            mapper.updateSettlementStatus(payload);
            result.put("result", "success");
        } catch (Exception e) {
            log.error("정산 처리 실패", e);
            result.put("result", "fail");
            result.put("message", e.getMessage());
        }

        return result;
    }
}
