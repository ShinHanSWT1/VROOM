<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 우리동네 심부름</title>
    <style>
        /* 전역 변수 및 리셋 */
        :root {
            /* 컬러 팔레트 */
            --color-primary: #6B8E23;
            --color-secondary: #F2CB05;
            --color-tertiary: #F2B807;
            --color-accent: #F2A007;
            --color-warm: #D97218;

            /* 중성 컬러 */
            --color-dark: #2C3E50;
            --color-gray: #7F8C8D;
            --color-light-gray: #ECF0F1;
            --color-white: #FFFFFF;

            /* 소셜 로그인 컬러 */
            --kakao-yellow: #FEE500;
            --naver-green: #03C75A;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Malgun Gothic', sans-serif;
            color: var(--color-dark);
            line-height: 1.6;
            background-color: #FAFAFA;
        }

        /* 헤더 */
        .header {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo h1 {
            color: var(--color-white);
            font-size: 1.5rem;
            font-weight: 700;
        }

        .nav-menu {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .nav-item {
            color: var(--color-white);
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .nav-item:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .nav-login, .nav-signup {
            background-color: rgba(255, 255, 255, 0.15);
        }

        .nav-user {
            background-color: var(--color-white);
            color: var(--color-primary);
            font-weight: 600;
        }

        /* 컨테이너 */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1.5rem;
        }

        /* 푸터 */
        .footer {
            background-color: var(--color-dark);
            color: var(--color-white);
            padding: 3rem 0 1rem;
            margin-top: 3rem;
        }

        .footer-content {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .footer-info h3 {
            color: var(--color-secondary);
            margin-bottom: 0.5rem;
        }

        .footer-info p {
            color: var(--color-light-gray);
            font-size: 0.9rem;
        }

        .footer-links {
            display: flex;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        .footer-links a {
            color: var(--color-light-gray);
            font-size: 0.9rem;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: var(--color-secondary);
        }

        .footer-copyright {
            text-align: center;
            padding-top: 1rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--color-gray);
            font-size: 0.85rem;
        }

        /* 인증 페이지 공통 스타일 */
        .auth-page {
            min-height: calc(100vh - 200px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 1.5rem;
        }

        .auth-card {
            background-color: var(--color-white);
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            padding: 3rem;
            width: 100%;
            max-width: 440px;
        }

        .auth-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--color-dark);
            text-align: center;
            margin-bottom: 2rem;
        }

        /* 입력 필드 */
        .auth-form-group {
            margin-bottom: 1.5rem;
        }

        .auth-label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.5rem;
        }

        .auth-input {
            width: 100%;
            height: 44px;
            padding: 0 1rem;
            border: 1px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 1rem;
            background-color: var(--color-light-gray);
            color: var(--color-gray);
            transition: all 0.2s ease;
        }

        .auth-input:focus {
            outline: none;
            background-color: var(--color-white);
        }

        .auth-input.email-input.has-value,
        .auth-input.has-value:not(.password-input) {
            color: var(--color-primary);
            border-color: var(--color-primary);
            background-color: var(--color-white);
        }

        .auth-input.password-input.has-value {
            border-color: #DC3545;
            background-color: var(--color-white);
        }

        .auth-input.password-input.has-value.valid {
            border-color: var(--color-primary);
        }

        .auth-input[type="file"] {
            cursor: pointer;
            padding: 0.5rem;
            height: auto;
            line-height: 1.5;
        }

        .auth-input[type="file"]:focus {
            border-color: var(--color-primary);
            background-color: var(--color-white);
        }

        /* 주소 선택 */
        .address-group {
            margin-bottom: 1.5rem;
        }

        .address-label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.5rem;
        }

        .address-selects {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .address-sido {
            font-size: 1rem;
            color: var(--color-dark);
            font-weight: 500;
            white-space: nowrap;
            padding: 0 0.5rem;
        }

        .address-select {
            flex: 1;
            min-width: 0;
            height: 44px;
            padding: 0 0.75rem;
            border: 1px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 1rem;
            background-color: var(--color-light-gray);
            color: var(--color-gray);
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .address-select:focus {
            outline: none;
            background-color: var(--color-white);
            border-color: var(--color-primary);
            color: var(--color-primary);
        }

        .address-select.has-value {
            background-color: var(--color-white);
            border-color: var(--color-primary);
            color: var(--color-primary);
        }

        .address-select option {
            background-color: var(--color-white);
            color: var(--color-dark);
        }

        /* 메인 버튼 */
        .auth-btn {
            width: 100%;
            height: 44px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-bottom: 1.5rem;
        }

        .auth-btn:disabled {
            background-color: var(--color-light-gray);
            color: var(--color-gray);
            cursor: not-allowed;
        }

        .auth-btn:not(:disabled) {
            background-color: var(--color-primary);
            color: var(--color-white);
        }

        .auth-btn:not(:disabled):hover {
            background-color: #5a7a1d;
        }

        /* 구분선 */
        .auth-divider {
            display: flex;
            align-items: center;
            margin: 2rem 0;
            text-align: center;
        }

        .auth-divider::before,
        .auth-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background-color: var(--color-light-gray);
        }

        .auth-divider-text {
            padding: 0 1rem;
            color: var(--color-gray);
            font-size: 0.9rem;
        }

        /* 소셜 로그인 버튼 */
        .social-login-section {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .social-btn {
            width: 100%;
            height: 44px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            position: relative;
        }

        .kakao-btn {
            background-color: var(--kakao-yellow);
            color: #000000;
        }

        .kakao-btn:hover {
            background-color: #FDD835;
        }

        .kakao-icon {
            width: 20px;
            height: 20px;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%23000000' d='M12 3c5.799 0 10.5 3.664 10.5 8.185 0 4.52-4.701 8.184-10.5 8.184a13.5 13.5 0 0 1-1.727-.11l-4.408 2.883c-.501.265-.678.236-.472-.413l.892-3.678c-2.88-1.46-4.785-3.99-4.785-6.866C1.5 6.665 6.201 3 12 3z'/%3E%3C/svg%3E");
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
        }

        .naver-btn {
            background-color: var(--naver-green);
            color: var(--color-white);
        }

        .naver-btn:hover {
            background-color: #02B350;
        }

        .naver-icon {
            width: 20px;
            height: 20px;
            background-color: var(--color-white);
            border-radius: 2px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.875rem;
            color: var(--naver-green);
        }

        .google-btn {
            background-color: var(--color-white);
            color: var(--color-dark);
            border: 1px solid var(--color-light-gray);
        }

        .google-btn:hover {
            background-color: #F5F5F5;
        }

        .google-icon {
            width: 20px;
            height: 20px;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%234285F4' d='M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z'/%3E%3Cpath fill='%2334A853' d='M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z'/%3E%3Cpath fill='%23FBBC05' d='M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z'/%3E%3Cpath fill='%23EA4335' d='M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z'/%3E%3C/svg%3E");
            background-size: contain;
            background-repeat: no-repeat;
        }

        /* 링크 */
        .auth-link-section {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid var(--color-light-gray);
        }

        .auth-link-text {
            color: var(--color-gray);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .auth-link {
            color: var(--color-primary);
            font-weight: 600;
            text-decoration: none;
            font-size: 0.95rem;
            transition: color 0.2s ease;
        }

        .auth-link:hover {
            color: var(--color-warm);
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                gap: 1rem;
            }

            .nav-menu {
                flex-wrap: wrap;
                justify-content: center;
            }

            .auth-card {
                padding: 2rem 1.5rem;
            }

            .auth-title {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
<!-- 헤더 -->
<header class="header">
    <div class="header-container">
        <div class="logo">
            <h1>우리동네 심부름</h1>
        </div>
        <nav class="nav-menu">
            <a href="#" class="nav-item">커뮤니티</a>
            <a href="#" class="nav-item">실무블로그 전환</a>
            <a href="../auth/login.html" class="nav-item nav-login">로그인</a>
            <a href="../auth/signup.html" class="nav-item nav-signup">회원가입</a>
            <a href="#" class="nav-item nav-user">유저</a>
        </nav>
    </div>
</header>

<!-- 로그인 섹션 -->
<section class="auth-page">
    <div class="auth-card">
        <h2 class="auth-title">로그인</h2>

        <form action="/auth/login" method="post" id="loginForm">
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
                        name="password"
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
            <a href="../auth/signup.html" class="auth-link">회원가입하기 →</a>
        </div>
    </div>
</section>

<!-- 푸터 -->
<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-info">
                <h3>우리동네 심부름</h3>
                <p>이웃과 함께하는 따뜻한 심부름 커뮤니티</p>
            </div>
            <div class="footer-links">
                <a href="#">회사소개</a>
                <a href="#">이용약관</a>
                <a href="#">개인정보처리방침</a>
                <a href="#">문의하기</a>
            </div>
            <div class="footer-copyright">
                <p>&copy; 2024 우리동네 심부름. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>

<script>
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const loginBtn = document.getElementById('loginBtn');

    // 이메일 입력 처리
    emailInput.addEventListener('input', function() {
        if (this.value.length > 0) {
            this.classList.add('has-value');
        } else {
            this.classList.remove('has-value');
        }
        checkLoginButton();
    });

    // 비밀번호 입력 처리
    passwordInput.addEventListener('input', function() {
        const value = this.value;
        if (value.length > 0) {
            this.classList.add('has-value');
            if (value.length >= 4) {
                this.classList.add('valid');
            } else {
                this.classList.remove('valid');
            }
        } else {
            this.classList.remove('has-value', 'valid');
        }
        checkLoginButton();
    });

    // 로그인 버튼 활성화 체크
    function checkLoginButton() {
        const emailValue = emailInput.value.trim();
        const passwordValue = passwordInput.value;

        if (emailValue.length > 0 && passwordValue.length >= 4) {
            loginBtn.disabled = false;
        } else {
            loginBtn.disabled = true;
        }
    }

    // 포커스 시 배경색 변경
    emailInput.addEventListener('focus', function() {
        this.style.backgroundColor = 'var(--color-white)';
    });

    emailInput.addEventListener('blur', function() {
        if (!this.value) {
            this.style.backgroundColor = 'var(--color-light-gray)';
        }
    });

    passwordInput.addEventListener('focus', function() {
        this.style.backgroundColor = 'var(--color-white)';
    });

    passwordInput.addEventListener('blur', function() {
        if (!this.value) {
            this.style.backgroundColor = 'var(--color-light-gray)';
        }
    });
</script>
</body>
</html>