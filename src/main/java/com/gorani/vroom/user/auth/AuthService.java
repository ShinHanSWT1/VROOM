package com.gorani.vroom.user.auth;

import com.gorani.vroom.user.UserVO;
import org.springframework.web.multipart.MultipartFile;

public interface AuthService {
    int signup(UserVO vo, MultipartFile profile) throws Exception;
    UserVO login(UserVO vo);
}
