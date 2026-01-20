package com.gorani.vroom.admin.auth;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AuthMapper {
    AdminVO login(AdminVO vo);
    void updateLastLoginAt(String loginId);

}
