package com.gorani.vroom.user.auth;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AuthUserMapper {

    // 사용자 조회 (로그인용)
    UserVO existsEmail(String email);
    UserVO existsPhone(String phone);
    UserVO existsNickname(String nickname);
    UserVO findBySnsId(String snsId);

    UserVO login(UserVO vo);

    // 회원가입 (LOCAL / SOCIAL 공용)
    int insertUser(UserVO user);

    // 마지막 로그인 시간 갱신
    void updateLastLoginAt(Long userId);
}