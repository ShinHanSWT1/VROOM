package com.gorani.vroom.user.auth;

import org.springframework.web.multipart.MultipartFile;
import java.util.List;


public interface AuthService {
    void signup(UserVO vo, MultipartFile profile) throws Exception;
    UserVO login(UserVO vo);
    boolean existsEmail(String email);
    boolean existsPhone(String phone);
    boolean existsNickname(String nickname);
}