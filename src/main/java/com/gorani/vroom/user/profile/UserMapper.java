package com.gorani.vroom.user.profile;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserMapper {

    // 프로필 조회
    UserProfileVO findById(Long userId);

    // 프로필 수정
    void update(UserProfileVO vo);

    // 프로필 이미지만 수정
    void updateProfileImage(@Param("userId") Long userId, @Param("profileImage") String profileImage);

    // 내가 신청한 심부름 목록 조회
    List<ErrandsVO> findErrandsByUserId(Long userId);

    // 신고 등록
    void insertIssueTicket(IssueTicketVO ticket);

    // errandId로 심부름꾼(errander) ID 조회
    Long findErranderIdByErrandId(Long errandId);

    // 비밀번호 조회
    String findPasswordByUserId(Long userId);

    // 회원 탈퇴 처리
    void withdrawUser(Long userId);

    // role 변경
    void updateRole(
            @Param("userId") Long userId,
            @Param("role") String role
    );
}
