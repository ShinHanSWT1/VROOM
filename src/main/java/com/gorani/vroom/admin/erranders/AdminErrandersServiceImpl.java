package com.gorani.vroom.admin.erranders;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Primary
public class AdminErrandersServiceImpl implements AdminErrandersService {

    @Autowired
    private AdminErrandersMapper mapper;

    @Override
    public Map<String, Object> getSummary() {
        return mapper.getSummary();
    }


    @Override
    public Map<String, Object> searchErranders(String keyword, String approveStatus, String activeStatus, Integer reviewScope, int page) {
        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        Map<String, Object> param = new HashMap<>();
        param.put("keyword", keyword);
        param.put("approveStatus", approveStatus);
        param.put("activeStatus", activeStatus);
        param.put("reviewScope", reviewScope);
        param.put("limit", pageSize);
        param.put("offset", offset);

        List<Map<String, Object>> erranderList = mapper.searchErranders(param);
        int totalCount = mapper.countErranders(param);

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
        dataMap.put("userList", erranderList);
        dataMap.put("totalCount", totalCount);
        dataMap.put("pageInfo", pageInfo);

        return dataMap;
    }

    @Override
    public Map<String, Object> getErranderApprovalDetail(Long id) {

        // {
        //  "user_id": 4,
        //  "nickname": "고라니",
        //   ...
        //  "documents": [
        //    { "file_url": "id_card.jpg" },
        //    { "file_url": "bank_book.png" },
        //    { "file_url": "license.pdf" }
        //  ]
        //}
        return mapper.getErranderApprovalDetail(id);
    }

    @Override
    public Map<String, Object> approveErrander(Long erranderId, String status, String reason) {
        log.info("승인 요청 받음" + erranderId + " : " + status);
        Map<String, Object> dataMap = new HashMap<>();

        int result = mapper.updateErranderApprovalStatus(erranderId, status);
        if (result != 1) {
            throw new IllegalStateException("업데이트 실패");
        } else {
            dataMap.put("result", "success");
            String activeStatus = "";
            if (status.equals("APPROVED")) {
                activeStatus = "ACTIVE";
            } else if (status.equals("REJECTED")) {
                activeStatus = "INACTIVE";
            }
            mapper.updateErranderActiveStatus(erranderId, activeStatus);
        }

        return dataMap;
    }

    @Override
    public Map<String, Object> changeErranderStatus(Long erranderId, String status) {

        int result = mapper.updateErranderActiveStatus(erranderId, status);
        if (result != 1) {
            throw new IllegalStateException("업데이트 실패");
        }

        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("result", "success");

        return dataMap;
    }

    @Override
    public Map<String, Object> getDetailSummary(Long erranderId) {
        Map<String, Object> dataMap = new HashMap<>();

        dataMap.put("detail", mapper.getErranderDetail(erranderId));
        dataMap.put("activity", mapper.getActivitySummary(erranderId));


        return dataMap;
    }

    @Override
    public Map<String, Object> getDetailAllInfo(Long erranderId, int limit) {
        Map<String, Object> dataMap = new HashMap<>();

        dataMap.put("recentErrandsList", mapper.getRecentErrandsWithProof(erranderId, limit));
        dataMap.put("settlementSummary", mapper.getSettlementSummary(erranderId));
        dataMap.put("ratingAvg", mapper.getErranderRatingAvg(erranderId));
        dataMap.put("recentReviewList", mapper.getRecentReviews(erranderId, limit));
        dataMap.put("adminMemo", mapper.getAdminMemo(erranderId));
        dataMap.put("authDocuments", mapper.getDocuments(erranderId));

        return dataMap;
    }

    @Override
    public Map<String, Object> saveAdminMemo(Long erranderId, String text) {

        int result = mapper.updateAdminMemo(erranderId, text);
        if (result != 1) {
            throw new IllegalStateException("업데이트 실패");
        }

        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("result", "success");

        return dataMap;
    }

}
