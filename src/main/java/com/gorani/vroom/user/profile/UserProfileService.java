package com.gorani.vroom.user.profile;

import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface UserProfileService {

    // 프로필 조회
    UserProfileVO getUserProfile(Long userId);

    // 프로필 수정
    void updateProfile(Long userId, UserProfileVO vo);

    // 프로필 이미지 경로 수정
    void updateProfileImage(Long userId, String imagePath);

    // 프로필 이미지 파일 저장 및 DB 업데이트
    String saveProfileImage(Long userId, MultipartFile file) throws IOException;

    // 내가 신청한 심부름 목록 조회
    List<ErrandsVO> getMyErrands(Long userId);

    // 신고 등록
    void createIssueTicket(IssueTicketVO ticket);

    // 회원 탈퇴 (비밀번호 확인 후 탈퇴 처리)
    boolean withdrawUser(Long userId, String password);

    // role 업데이트
    void changeRole(Long userId, String role);
}
