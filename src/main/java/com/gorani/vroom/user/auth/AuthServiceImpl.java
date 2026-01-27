package com.gorani.vroom.user.auth;

import com.gorani.vroom.common.util.MD5Util;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.math.BigDecimal;

import java.io.File;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AuthUserMapper authUserMapper;
    // ================= 회원가입 =================
    @Override
    public void signup(UserVO vo, MultipartFile profile) throws Exception {

        // 0. 이메일 중복 체크
        if (existsEmail(vo.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        // 1. 전화번호 중복 체크
        if (existsPhone(vo.getPhone())) {
            throw new IllegalArgumentException("이미 가입된 전화번호입니다.");
        }

        // 2. 닉네임 중복 체크
        if (existsNickname(vo.getNickname())) {
            throw new IllegalArgumentException("이미 사용 중인 닉네임입니다.");
        }

        // 3. 주소 검증
        if (vo.getDongCode1() == null || vo.getDongCode1().isBlank()) {
            throw new IllegalArgumentException("주소 1은 필수입니다.");
        }

        if (vo.getDongCode2() == null || vo.getDongCode2().isBlank()) {
            throw new IllegalArgumentException("주소 2는 필수입니다.");
        }


        // 4. 프로필 이미지 처리
        if (profile != null && !profile.isEmpty()) {
            String fileName = saveFile(profile);
            vo.setProfileImage(fileName);
        }

        // 5. 기본값 세팅
        vo.setRole("USER");
        vo.setStatus("ACTIVE");
        vo.setProvider("LOCAL");

        if (vo.getMannerScore() == null) {
            vo.setMannerScore(new BigDecimal("36.5"));
        }
        if (vo.getCancelRate() == null) {
            vo.setCancelRate(BigDecimal.ZERO);
        }

        // 6. 비밀번호 암호화
        vo.setPwd(MD5Util.md5(vo.getPwd()));

        // 7. DB INSERT
        int result = authUserMapper.insertUser(vo);

        if (result != 1) {
            throw new RuntimeException("회원가입 DB 저장 실패");
        }
    }

    // ================= 로그인 =================
    @Override
    public UserVO login(UserVO vo) {

        // email / pwd 기반 로그인 (ERD 조건 포함)
        UserVO loginUser = authUserMapper.login(vo);

        // 로그인 성공 시 마지막 로그인 시간 갱신
        if (loginUser != null) {
            authUserMapper.updateLastLoginAt(loginUser.getUserId());
        }

        return loginUser;
    }

    // ================= 중복 체크 (Validation용 조회) =================

    @Override
    public boolean existsEmail(String email) {
        return authUserMapper.existsEmail(email) != null;
    }

    @Override
    public boolean existsPhone(String phone) {
        return authUserMapper.existsPhone(phone) != null;
    }

    @Override
    public boolean existsNickname(String nickname) {
        return authUserMapper.existsNickname(nickname) != null;
    }

    // ================= 파일 저장 =================
    private String saveFile(MultipartFile file) throws Exception {
        String uploadDir = "C:/upload/profile/";

        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String originalName = file.getOriginalFilename();
        if (originalName == null || !originalName.contains(".")) {
            throw new IllegalArgumentException("잘못된 파일 형식입니다.");
        }

        String ext = originalName.substring(originalName.lastIndexOf("."));
        String savedName = UUID.randomUUID() + ext;

        file.transferTo(new File(uploadDir + savedName));
        return savedName;
    }
}