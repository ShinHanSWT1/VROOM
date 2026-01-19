package com.gorani.vroom.admin.users;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminUsersMapper {
    Map<String, Object> getSummary();
    List<Map<String, Object>> searchUsers(Map<String, Object> param);
}
