<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="pageTitle" value="로그인 - 우리동네 심부름" />
<c:set var="pageCss" value="login" />
<c:set var="pageCssDir" value="user" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- 로그인 섹션 -->
<section class="auth-page">
    <div class="auth-card">
        <h2 class="auth-title">로그인</h2>

        <form action="${pageContext.request.contextPath}/auth/login" method="post" id="loginForm">
            <!-- 이메일 입력 -->
            <div class="auth-form-group">
                <label for="email" class="auth-label">이메일</label>
                <input
                        type="email"
                        id="email"
                        name="email"
                        class="auth-input email-input"
                        placeholder="이메일을 입력하세요"
                        autocomplete="email"
                >
            </div>

            <!-- 비밀번호 입력 -->
            <div class="auth-form-group">
                <label for="password" class="auth-label">비밀번호</label>
                <input
                        type="password"
                        id="password"
                        name="pwd"
                        class="auth-input password-input"
                        placeholder="비밀번호를 입력하세요"
                        autocomplete="current-password"
                >
            </div>

            <!-- 로그인 버튼 -->
            <button type="submit" class="auth-btn" id="loginBtn" disabled>로그인</button>
        </form>

        <!-- 구분선 -->
        <div class="auth-divider">
            <span class="auth-divider-text">또는</span>
        </div>

        <!-- 소셜 로그인 -->
        <div class="social-login-section">
            <button type="button" class="social-btn kakao-btn">
                <span class="kakao-icon"></span>
                <span>카카오로 시작하기</span>
            </button>

            <button type="button" class="social-btn naver-btn">
                <span class="naver-icon">N</span>
                <span>네이버로 시작하기</span>
            </button>

            <button type="button" class="social-btn google-btn">
                <span class="google-icon"></span>
                <span>Google로 계속하기</span>
            </button>
        </div>

        <!-- 회원가입 링크 -->
        <div class="auth-link-section">
            <p class="auth-link-text">아직 계정이 없으신가요?</p>
            <a href="${pageContext.request.contextPath}/auth/signup" class="auth-link">회원가입하기 →</a>
        </div>
    </div>
</section>

<script src="<c:url value='/static/user/js/login.js'/>"></script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>