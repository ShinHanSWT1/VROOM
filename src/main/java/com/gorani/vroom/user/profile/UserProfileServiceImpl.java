package com.gorani.vroom.user.profile;

import com.gorani.vroom.config.MvcConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
public class UserProfileServiceImpl implements UserProfileService {

    private final UserMapper userMapper;

    @Autowired
    public UserProfileServiceImpl(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    // 프로필 조회
    @Override
    public UserProfileVO getUserProfile(Long userId) {
        return userMapper.findById(userId);
    }

    // 프로필 수정
    @Override
    public void updateProfile(Long userId, UserProfileVO vo) {
        vo.setUserId(userId);
        userMapper.update(vo);
    }

    // 프로필 이미지 수정
    @Override
    public void updateProfileImage(Long userId, String imagePath) {
        userMapper.updateProfileImage(userId, imagePath);
    }

    // 프로필 이미지 파일 저장 및 DB 업데이트
    public String saveProfileImage(Long userId, MultipartFile file) throws IOException {
        // 저장 디렉토리 생성
        File uploadDir = new File(MvcConfig.UPLOAD_PATH);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 파일명 생성 (UUID + 확장자)
        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String savedFilename = UUID.randomUUID().toString() + extension;

        // 파일 저장
        File destFile = new File(MvcConfig.UPLOAD_PATH + savedFilename);
        file.transferTo(destFile);

        // DB에 이미지 경로 저장 (웹 접근 경로)
        String webPath = "/uploads/profile/" + savedFilename;
        userMapper.updateProfileImage(userId, webPath);

        log.info("프로필 이미지 저장 : userId={}, path={}", userId, webPath);

        return webPath;
    }

    // 내가 신청한 심부름 목록 조회
    @Override
    public List<ErrandsVO> getMyErrands(Long userId) {
        return userMapper.findErrandsByUserId(userId);
    }

    // 신고 등록
    @Override
    public void createIssueTicket(IssueTicketVO ticket) {
        // errandId로 심부름꾼(errander) ID를 조회하여 targetUserId로 설정
        if (ticket.getErrandId() != null) {
            Long erranderId = userMapper.findErranderIdByErrandId(ticket.getErrandId());
            ticket.setTargetUserId(erranderId);
        }

        userMapper.insertIssueTicket(ticket);
        log.info("신고 등록 완료: errandId={}, userId={}, targetUserId={}",
                ticket.getErrandId(), ticket.getUserId(), ticket.getTargetUserId());
    }

    // 회원 탈퇴 (비밀번호 확인 후 탈퇴 처리)
    @Override
    public boolean withdrawUser(Long userId, String password) {
        // DB에서 비밀번호 조회
        String storedPassword = userMapper.findPasswordByUserId(userId);

        // 비밀번호 확인
        if (storedPassword != null && storedPassword.equals(password)) {
            userMapper.withdrawUser(userId);
            log.info("회원 탈퇴 완료: userId={}", userId);
            return true;
        }

        log.warn("회원 탈퇴 실패 - 비밀번호 불일치: userId={}", userId);
        return false;
    }
}
