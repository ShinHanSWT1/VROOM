package com.gorani.vroom.admin.erranders;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminErrandersMapper {
    Map<String, Object> getSummary();

    List<Map<String, Object>> searchErranders(Map<String, Object> param);

    int countErranders(Map<String, Object> param);

    Map<String, Object> getErranderApprovalDetail(Long id);

}
