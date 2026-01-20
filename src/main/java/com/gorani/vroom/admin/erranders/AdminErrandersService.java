package com.gorani.vroom.admin.erranders;

import com.gorani.vroom.admin.users.AdminUserDetailDTO;

import java.util.Map;

public interface AdminErrandersService {
    Map<String, Object> getSummary();

    Map<String, Object> searchUsers(String keyword, String status, String role, Integer reportCount, int page);

    void updateUserStatus(Map<String, Object> params);

    AdminUserDetailDTO getUserDetail(Long userId);

    // 관리자 메모 저장 메서드 추가
    void updateAdminMemo(Long userId, String memo);
}
