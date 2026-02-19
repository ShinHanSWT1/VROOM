package com.gorani.vroom.admin.auth;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@Primary
public class AdminAuthServiceImpl implements AdminAuthService {

    @Autowired
    private AdminAuthMapper mapper;

    @Override
    public AdminVO login(AdminVO vo) {
        AdminVO adminVO = mapper.login(vo);

        // 로그인 실패
        if (adminVO == null) {
            throw new IllegalArgumentException("존재하지 않는 계정입니다");

        } else { // 로그인 성공
            log.info("관리자 로그인: " + adminVO);

            // 마지막 로그인 시간 업데이트
            mapper.updateLastLoginAt(adminVO.getLoginId());
        }

        return adminVO;
    }
}
