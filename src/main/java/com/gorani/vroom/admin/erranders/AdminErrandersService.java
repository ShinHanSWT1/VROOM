package com.gorani.vroom.admin.erranders;


import java.util.Map;

public interface AdminErrandersService {
    Map<String, Object> getSummary();

    Map<String, Object> searchErranders(String keyword, String approveStatus, String activeStatus, Integer reviewScope, int page);

    Map<String, Object> getErranderApprovalDetail(Long id);

    Map<String, Object> approveErrander(Long erranderId, String status);

    Map<String, Object> changeErranderStatus(Long erranderId, String status);
}
