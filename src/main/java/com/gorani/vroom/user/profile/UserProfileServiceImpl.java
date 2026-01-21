package com.gorani.vroom.user.profile;

import com.gorani.vroom.config.MvcConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
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


    // [수정됨] 프로필 이미지 파일 저장 및 DB 업데이트 (중복 방지 적용)
    public String saveProfileImage(Long userId, MultipartFile file) throws IOException {
        // 1. 저장 디렉토리 확인
        File uploadDir = new File(MvcConfig.PROFILE_UPLOAD_PATH);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 2. 파일 확장자 추출
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }

        try {
            // 3. 파일의 해시값(지문) 계산 -> 이것을 파일명으로 사용!
            String fileHash = calculateFileHash(file);
            String savedFilename = fileHash + extension; // 예: a1b2c3d4...jpg

            File destFile = new File(MvcConfig.PROFILE_UPLOAD_PATH + savedFilename);

            // 4. [핵심] 이미 같은 파일이 있는지 확인
            if (destFile.exists()) {
                log.info("중복된 이미지가 존재하여 기존 파일을 사용합니다: {}", savedFilename);
                // 파일을 새로 저장하지 않음 (transferTo 건너뜀)
            } else {
                log.info("새로운 이미지를 저장합니다: {}", savedFilename);
                file.transferTo(destFile); // 파일이 없을 때만 저장
            }

            // 5. DB에 저장할 웹 경로 생성
            String webPath = "/uploads/profile/" + savedFilename;

            // DB 업데이트
            userMapper.updateProfileImage(userId, webPath);

            return webPath;

        } catch (NoSuchAlgorithmException e) {
            throw new IOException("해시 알고리즘 오류", e);
        }
    }

    // [추가됨] 파일의 내용을 읽어서 SHA-256 해시값(문자열)으로 만드는 메서드
    private String calculateFileHash(MultipartFile file) throws IOException, NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(file.getBytes());

        // 바이트 배열을 16진수 문자열로 변환
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