package com.gorani.vroom.user.auth;

import com.gorani.vroom.user.UserMapper;
import com.gorani.vroom.user.UserVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserMapper userMapper;

    // ================= 회원가입 =================
    @Override
    public int signup(UserVO vo, MultipartFile profile) throws Exception {

        // 1. 프로필 이미지 처리 (있다면)
        if (profile != null && !profile.isEmpty()) {
            // 실제 저장 로직은 나중에
            vo.setProfileImage(profile.getOriginalFilename());
        }

        // 2. 기본값 세팅 (ERD 기준)
        vo.setRole("USER");
        vo.setStatus("ACTIVE");
        vo.setProvider("LOCAL");

        // 3. DB INSERT
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
}