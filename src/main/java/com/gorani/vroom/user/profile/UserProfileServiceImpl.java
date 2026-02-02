package com.gorani.vroom.user.profile;

import com.gorani.vroom.config.MvcConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

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

    // 프로필 이미지 경로만 수정
    @Override
    public void updateProfileImage(Long userId, String imagePath) {
        userMapper.updateProfileImage(userId, imagePath);
    }

    // 프로필 이미지 파일 저장 (중복 방지 적용)
    @Override
    public String saveProfileImage(Long userId, MultipartFile file) throws IOException {

        // 저장 디렉토리 확인
        File uploadDir = new File(MvcConfig.PROFILE_UPLOAD_PATH);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 파일 확장자 추출
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        try {
            // 파일 해시(SHA-256) 계산
            String fileHash = calculateFileHash(file);
            String savedFilename = fileHash + extension;

            File destFile = new File(MvcConfig.PROFILE_UPLOAD_PATH + savedFilename);

            // 중복 파일 체크
            if (destFile.exists()) {
                log.info("중복 이미지 존재 → 기존 파일 사용: {}", savedFilename);
            } else {
                log.info("새 이미지 저장: {}", savedFilename);
                file.transferTo(destFile);
            }

            // DB 저장용 웹 경로
            String webPath = "/uploads/profile/" + savedFilename;
            userMapper.updateProfileImage(userId, webPath);

            return webPath;

        } catch (NoSuchAlgorithmException e) {
            throw new IOException("해시 알고리즘 오류", e);
        }
    }

    // 파일 SHA-256 해시 계산
    private String calculateFileHash(MultipartFile file)
            throws IOException, NoSuchAlgorithmException {

        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(file.getBytes());

        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }

        return sb.toString();
    }

    // 내가 신청한 심부름 목록 조회
    @Override
    public List<ErrandsVO> getMyErrands(Long userId) {
        return userMapper.findErrandsByUserId(userId);
    }

    // 신고 등록
    @Override
    public void createIssueTicket(IssueTicketVO ticket) {

        // errandId로 심부름꾼 ID 조회
        if (ticket.getErrandId() != null) {
            Long erranderId =
                    userMapper.findErranderIdByErrandId(ticket.getErrandId());
            ticket.setTargetUserId(erranderId);
        }

        userMapper.insertIssueTicket(ticket);

        log.info(
                "신고 등록 완료: errandId={}, userId={}, targetUserId={}",
                ticket.getErrandId(),
                ticket.getUserId(),
                ticket.getTargetUserId()
        );
    }

    // 회원 탈퇴 (비밀번호 확인 후 처리)
    @Override
    public boolean withdrawUser(Long userId, String password) {

        // DB 비밀번호 조회
        String storedPassword = userMapper.findPasswordByUserId(userId);

        // 비밀번호 검증
        if (storedPassword != null && storedPassword.equals(password)) {
            userMapper.withdrawUser(userId);
            log.info("회원 탈퇴 완료: userId={}", userId);
            return true;
        }

        log.warn("회원 탈퇴 실패 - 비밀번호 불일치: userId={}", userId);
        return false;
    }

    @Override
    public void changeRole(Long userId, String role) {
        userMapper.updateRole(userId, role);
    }
}
