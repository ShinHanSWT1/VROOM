package com.gorani.vroom.admin.erranders;

import com.gorani.vroom.admin.users.AdminUserDetailDTO;

import java.util.Map;

public interface AdminErrandersService {
    Map<String, Object> getSummary();

    Map<String, Object> searchErranders(String keyword, String approveStatus, String activeStatus, Integer reviewScope, int page);
}
