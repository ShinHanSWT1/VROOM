package com.gorani.vroom.admin.users;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminUsersMapper {
    Map<String, Object> getSummary();
    List<Map<String, Object>> searchUsers(Map<String, Object> param);
    int countUsers(Map<String, Object> param);
    void updateUserStatus(Map<String, Object> param);
    AdminUserDetailDTO getUserInfoDetail(Long id);
    List<UserReportHistoryVO> getUserReportHistory(Long id);
    List<UserActivityVO> getUserActivityHistory(Long id);

    void updateAdminMemo(Long userId, String memo);
}
