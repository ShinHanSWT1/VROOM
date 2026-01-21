package com.gorani.vroom.common.util;

import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminLoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();

        // AuthController에서 저장한 세션 키값 "loginAdmin" 확인
        if (session.getAttribute("loginAdmin") == null) {

            // 로그인 정보가 없으면 로그인 페이지로 강제 이동
            response.sendRedirect(request.getContextPath() + "/admin/login");

            // 컨트롤러 실행 중단
            return false;
        }

        // 로그인 되어 있으면 컨트롤러 실행
        return true;
    }
}
