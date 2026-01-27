<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="회원가입 - 우리동네 심부름" />
<c:set var="pageCss" value="auth" />
<c:set var="pageJs" value="signup" />

<jsp:include page="../common/header.jsp" />

<!-- 회원가입 섹션 -->
<section class="auth-page">
    <div class="auth-card">
        <h2 class="auth-title">회원가입</h2>

        <form action="${pageContext.request.contextPath}/auth/signup" method="post" enctype="multipart/form-data" id="signupForm">
            <!-- 이메일 입력 -->
            <div class="auth-form-group">
                <label for="signup-email" class="auth-label">이메일</label>
                <input
                        type="email"
                        id="signup-email"
                        name="email"
                        class="auth-input email-input"
                        placeholder="이메일을 입력하세요"
                        autocomplete="email"
                >
            </div>

            <!-- 비밀번호 입력 -->
            <div class="auth-form-group">
                <label for="signup-password" class="auth-label">비밀번호</label>
                <input
                        type="password"
                        id="signup-password"
                        name="pwd"
                        class="auth-input password-input"
                        placeholder="비밀번호를 입력하세요"
                        autocomplete="new-password"
                >
            </div>

            <!-- 닉네임 입력 -->
            <div class="auth-form-group">
                <label for="nickname" class="auth-label">닉네임</label>
                <input
                        type="text"
                        id="nickname"
                        name="nickname"
                        class="auth-input"
                        placeholder="닉네임을 입력하세요"
                        autocomplete="nickname"
                >
            </div>

            <!-- 전화번호 입력 -->
            <div class="auth-form-group">
                <label for="phone" class="auth-label">전화번호</label>
                <input
                        type="tel"
                        id="phone"
                        name="phone"
                        class="auth-input"
                        placeholder="전화번호를 입력하세요"
                        autocomplete="tel"
                >
            </div>

            <!-- 프로필 이미지 업로드 -->
            <div class="auth-form-group">
                <label for="profileImage" class="auth-label">프로필 이미지 (선택)</label>
                <input
                        type="file"
                        id="profileImage"
                        name="profile"
                        class="auth-input"
                        accept="image/*"
                        style="padding: 0.5rem;"
                >
            </div>

            <!-- 주소 1 -->
            <div class="address-group">
                <label class="address-label">주소 1</label>
                <div class="address-selects">
                    <span class="address-sido">서울특별시</span>
                    <select name="gu1" id="gu1" class="address-select">
                        <option value="">구 선택</option>
                    </select>
                    <select name="dong1" id="dong1" class="address-select" disabled>
                        <option value="">동 선택</option>
                    </select>
                    <input type="hidden" name="dongCode1" id="dongCode1">
                </div>
            </div>

            <!-- 주소 2 -->
            <div class="address-group">
                <label class="address-label">주소 2</label>
                <div class="address-selects">
                    <span class="address-sido">서울특별시</span>
                    <select name="gu2" id="gu2" class="address-select">
                        <option value="">구 선택</option>
                    </select>
                    <select name="dong2" id="dong2" class="address-select" disabled>
                        <option value="">동 선택</option>
                    </select>
                    <input type="hidden" name="dongCode2" id="dongCode2">
                </div>
            </div>

            <!-- 회원가입 버튼 -->
            <button type="submit" class="auth-btn" id="signupBtn" disabled>회원가입</button>
        </form>

        <!-- 구분선 -->
        <div class="auth-divider">
            <span class="auth-divider-text">또는</span>
        </div>

        <!-- 소셜 회원가입 -->
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

        <!-- 로그인 링크 -->
        <div class="auth-link-section">
            <p class="auth-link-text">이미 계정이 있으신가요?</p>
            <a href="${pageContext.request.contextPath}/auth/login" class="auth-link">로그인하기 →</a>
        </div>
    </div>
</section>

<jsp:include page="../common/footer.jsp" />
