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

}
