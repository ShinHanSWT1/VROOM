package com.gorani.vroom.user.auth;

import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import com.gorani.vroom.user.auth.LegalDongVO;


public interface AuthService {
    int signup(UserVO vo, MultipartFile profile) throws Exception;
    UserVO login(UserVO vo);
    List<LegalDongVO> getDongListByGu(String gu);
}
