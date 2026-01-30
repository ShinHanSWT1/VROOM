package com.gorani.vroom.user.auth;

import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpSession;

public interface AuthService {
    void signup(UserVO vo, MultipartFile profile, UserVO oauthUser) throws Exception;

    UserVO login(UserVO vo);
    boolean existsEmail(String email);
    boolean existsPhone(String phone);
    boolean existsNickname(String nickname);

    KakaoLoginResult kakaoLogin(String code, HttpSession session);
}