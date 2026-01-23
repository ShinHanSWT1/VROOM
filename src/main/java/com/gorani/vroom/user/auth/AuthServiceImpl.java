package com.gorani.vroom.user.auth;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AuthUserMapper userMapper;
    private final LegalDongMapper legalDongMapper;

    // ================= 회원가입 =================
    @Override
    public int signup(UserVO vo, MultipartFile profile) throws Exception {

        // 🔥 0. 이메일 중복 체크
        if (userMapper.findByEmail(vo.getEmail()) != null) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        // 🔥 1. 전화번호 중복 체크
        if (userMapper.findByPhone(vo.getPhone()) != null) {
            throw new IllegalArgumentException("이미 가입된 전화번호입니다.");
        }

        // 2. 프로필 이미지 처리
        if (profile != null && !profile.isEmpty()) {
            String fileName = saveFile(profile);
            vo.setProfileImage(fileName);
        }

        // 3. 기본값 세팅
        vo.setRole("USER");
        vo.setStatus("ACTIVE");
        vo.setProvider("LOCAL");

        // 4. DB INSERT
        return userMapper.insertUser(vo);
    }

    // ================= 로그인 =================
    @Override
    public UserVO login(UserVO vo) {

        // email / pwd 기반 로그인 (ERD 조건 포함)
        UserVO loginUser = userMapper.login(vo);

        // 로그인 성공 시 마지막 로그인 시간 갱신
        if (loginUser != null) {
            userMapper.updateLastLoginAt(loginUser.getUserId());
        }

        return loginUser;
    }

    // ================= 주소(동) 조회 =================
    @Override
    public List<LegalDongVO> getDongListByGu(String gu) {
        return legalDongMapper.selectDongByGu(gu);
    }

    // ================= 파일 저장 =================
    private String saveFile(MultipartFile file) throws Exception {

        // 1. 저장할 디렉토리
        String uploadDir = "C:/upload/profile/";

        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // 2. 원본 파일명
        String originalName = file.getOriginalFilename();

        // 3. 확장자 추출
        String ext = originalName.substring(originalName.lastIndexOf("."));

        // 4. 저장용 파일명
        String savedName = UUID.randomUUID() + ext;

        // 5. 파일 저장
        File savedFile = new File(uploadDir + savedName);
        file.transferTo(savedFile);

        // 6. DB에 저장할 값 반환
        return savedName;
    }
}