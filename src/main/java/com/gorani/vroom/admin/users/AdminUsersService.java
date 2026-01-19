package com.gorani.vroom.admin.users;

import com.gorani.vroom.admin.auth.AdminVO;

import java.util.List;
import java.util.Map;

public interface AdminUsersService {
    Map<String, Object> getSummary();

    Map<String, Object> searchUsers(String keyword, String status, String role, Integer reportCount, int page);

    void updateUserStatus(Map<String, Object> params);
}
