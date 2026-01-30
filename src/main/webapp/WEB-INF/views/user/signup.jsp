<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 우리동네 심부름</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

        .input-guide {
            display: block;
            font-size: 0.85rem;
            margin-top: 0.5rem;
            min-height: 1.2rem;
        }

        .input-guide.success {
            color: var(--color-primary);
        }

        .input-guide.error {
            color: #DC3545;
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

        /* 공통 메시지 */
        .form-msg {
            display: block;
            margin-top: 6px;
            font-size: 0.85rem;
        }

        .form-msg.error {
            color: #D32F2F;
        }

        .form-msg.success {
            color: #2E7D32;
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
            <a href="${pageContext.request.contextPath}/auth/login" class="nav-item nav-login">로그인</a>
            <a href="${pageContext.request.contextPath}/auth/signup" class="nav-item nav-signup">회원가입</a>
            <a href="#" class="nav-item nav-user">유저</a>
        </nav>
    </div>
</header>

<!-- 회원가입 섹션 -->
<section class="auth-page">
    <div class="auth-card">
        <h2 class="auth-title">회원가입</h2>

        <c:if test="${not empty signupError}">
            <div id="globalError" class="form-msg error">
                    ${signupError}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/signup" method="post" enctype="multipart/form-data" id="signupForm">
            <!-- 이메일 입력 -->
            <div class="auth-form-group">
                <label for="signup-email" class="auth-label">이메일</label>
                <input
                        type="email"
                        id="signup-email"
                        name="email"
                        value="${oauthUser.email}"
                        class="auth-input email-input"
                        placeholder="이메일을 입력하세요"
                        autocomplete="email"
                        <c:if test="${not empty oauthUser.email}">readonly</c:if>
                >
                <span id="emailMsg" class="input-guide"></span>
            </div>

            <!-- 비밀번호 입력 -->
            <div class="auth-form-group">
                <label for="signup-password" class="auth-label">비밀번호</label>
                <c:if test="${empty oauthUser}">
                    <input
                            type="password"
                            id="signup-password"
                            name="pwd"
                            class="auth-input password-input"
                            placeholder="비밀번호를 입력하세요"
                            autocomplete="new-password"
                    >
                </c:if>
                <c:if test="${not empty oauthUser}">
                    <input
                            type="password"
                            id="signup-password"
                            disabled
                            class="auth-input password-input"
                            placeholder="카카오 로그인 사용자는 비밀번호가 필요하지 않습니다"
                    >
                </c:if>
            </div>

            <!-- 닉네임 입력 -->
            <div class="auth-form-group">
                <label for="nickname" class="auth-label">닉네임</label>
                <input
                        type="text"
                        id="nickname"
                        name="nickname"
                        value="${oauthUser.nickname}"
                        class="auth-input"
                        placeholder="닉네임을 입력하세요"
                        autocomplete="nickname"
                >
                <span id="nicknameMsg" class="input-guide"></span>
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
                <span id="phoneMsg" class="input-guide"></span>
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
                <span id="addrMsg" class="input-guide error"></span>
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
            <button type="button" class="social-btn kakao-btn" onclick="location.href='${pageContext.request.contextPath}/auth/kakao/login'">
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
    const emailInput = document.getElementById('signup-email');
    const passwordInput = document.getElementById('signup-password');
    const nicknameInput = document.getElementById('nickname');
    const phoneInput = document.getElementById('phone');
    const signupBtn = document.getElementById('signupBtn');

    // 유효성 검사 변수
    let emailValid = false;
    let phoneValid = false;
    let nicknameValid = false;
    let dong1Valid = false;
    let dong2Valid = false;

    // 모든 입력 필드에 대한 이벤트 리스너
    const inputs = [emailInput, passwordInput, nicknameInput, phoneInput];

    inputs.forEach(input => {
        // 입력 처리
        input.addEventListener('input', function() {
            if (this.value.length > 0) {
                this.classList.add('has-value');

                // 비밀번호 특별 처리
                if (this === passwordInput) {
                    const value = this.value;
                    if (value.length >= 4) {
                        this.classList.add('valid');
                    } else {
                        this.classList.remove('valid');
                    }
                }
            } else {
                this.classList.remove('has-value', 'valid');
            }
            validateSignup();
        });

        // 포커스 처리
        input.addEventListener('focus', function() {
            this.style.backgroundColor = 'var(--color-white)';
        });

        input.addEventListener('blur', function() {
            if (!this.value) {
                this.style.backgroundColor = 'var(--color-light-gray)';
            }
        });
    });

    // OAuth 사용자 여부 (서버에서 oauthUser 세션으로 판단)
    const isOAuth = ${not empty oauthUser};

    // 이메일 중복 체크
    let emailTimer = null;
    const contextPath = '${pageContext.request.contextPath}';

    // OAuth 회원가입 시 이메일/닉네임 미리 채워져 있으면 유효 처리
    if (isOAuth) {
        if ($('#signup-email').val().trim()) {
            emailValid = true;
        }
        if ($('#nickname').val().trim()) {
            nicknameValid = true;
        }
    }

    emailInput.addEventListener('input', function () {
        clearTimeout(emailTimer);

        const email = $(this).val().trim();
        if (!email) return;

        emailTimer = setTimeout(() => {
            $.ajax({
                url: contextPath + '/auth/check-email',
                type: 'GET',
                data: { email: email },
                dataType: 'json',
                success: function(exists) {
                    const msg = $('#emailMsg');
                    if (exists) {
                        msg.text('✖ 이미 가입된 이메일입니다');
                        msg.attr('class', 'input-guide error');
                        emailValid = false;
                    } else {
                        msg.text('✔ 사용 가능한 이메일입니다');
                        msg.attr('class', 'input-guide success');
                        emailValid = true;
                    }
                    validateSignup();
                }
            });
        }, 400); // 0.4초 후 실행
    });

    // 전화번호 중복 체크
    phoneInput.addEventListener('blur', function () {
        const phone = $(this).val().trim();
        if (!phone) return;

        $.ajax({
            url: contextPath + '/auth/check-phone',
            type: 'GET',
            data: { phone: phone },
            dataType: 'json',
            success: function(exists) {
                const msg = $('#phoneMsg');
                if (exists) {
                    msg.text('✖ 이미 등록된 번호입니다');
                    msg.attr('class', 'input-guide error');
                    phoneValid = false;
                } else {
                    msg.text('✔ 사용 가능한 번호입니다');
                    msg.attr('class', 'input-guide success');
                    phoneValid = true;
                }
                validateSignup();
            }
        });
    });

    // 닉네임 중복 체크
    let nicknameTimer = null;

    nicknameInput.addEventListener('input', function () {
        clearTimeout(nicknameTimer);

        const nickname = $(this).val().trim();
        const msg = $('#nicknameMsg');

        if (!nickname) {
            msg.text('');
            nicknameValid = false;
            validateSignup();
            return;
        }

        nicknameTimer = setTimeout(() => {
            $.ajax({
                url: contextPath + '/auth/check-nickname',
                type: 'GET',
                data: { nickname: nickname },
                dataType: 'json',
                success: function (exists) {
                    if (exists) {
                        msg.text('✖ 이미 사용 중인 닉네임입니다');
                        msg.attr('class', 'input-guide error');
                        nicknameValid = false;
                    } else {
                        msg.text('✔ 사용 가능한 닉네임입니다');
                        msg.attr('class', 'input-guide success');
                        nicknameValid = true;
                    }
                    validateSignup();
                }
            });
        }, 400);
    });

    // 회원가입 버튼 활성화 체크
    function validateSignup() {
        const addrMsg = $('#addrMsg');

        if (!dong1Valid || !dong2Valid) {
            addrMsg.text('주소 1, 2를 모두 선택해주세요');
        } else {
            addrMsg.text('');
        }

        const passwordValue = $('#signup-password').val() || '';
        let passwordValid;
        if (!isOAuth) {
            passwordValid = passwordValue.length >= 4;
        } else {
            passwordValid = true; // OAuth는 서버에서 처리
        }

        $('#signupBtn').prop('disabled', !(
            emailValid &&
            phoneValid &&
            nicknameValid &&
            passwordValid &&
            dong1Valid &&
            dong2Valid
        ));
    }

    // 주소 선택 관련 변수는 jQuery로 직접 사용

    // 페이지 로드 시 구 목록 로드 (하드코딩)
    function loadGus() {
        const gus = ['강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구', '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'];

        $.each(gus, function(i, gu) {
            $('#gu1').append($('<option>').val(gu).text(gu));
            $('#gu2').append($('<option>').val(gu).text(gu));
        });
    }

    // 구 선택 시 동 목록 로드
    function loadDongs(guSelectId, dongSelectId, dongCodeInputId) {
        const selectedGu = $(guSelectId).val();

        if (!selectedGu) {
            $(dongSelectId).prop('disabled', true).html('<option value="">동 선택</option>');
            $(dongCodeInputId).val('');
            return;
        }

        $.ajax({
            url: contextPath + '/location/getDongs',
            type: 'GET',
            data: { gunguName: selectedGu },
            dataType: 'json',
            success: function(dongs) {
                $(dongSelectId).prop('disabled', false).html('<option value="">동 선택</option>');

                $.each(dongs, function(i, dong) {
                    $(dongSelectId).append(
                        $('<option>')
                            .val(dong.dongCode)
                            .text(dong.dongName)
                    );
                });

                $(dongCodeInputId).val('');
            },
            error: function(err) {
                console.error('동 조회 실패', err);
                alert('동 정보를 불러오지 못했습니다.');
            }
        });
    }

    // 동 선택 시 dongCode 저장
    function handleDongSelect(dongSelectId, dongCodeInputId, which) {
        const dongCode = $(dongSelectId).val();

        if (dongCode) {
            $(dongCodeInputId).val(dongCode);
            $(dongSelectId).addClass('has-value');

            if (which === 1) dong1Valid = true;
            if (which === 2) dong2Valid = true;
        } else {
            $(dongCodeInputId).val('');
            $(dongSelectId).removeClass('has-value');

            if (which === 1) dong1Valid = false;
            if (which === 2) dong2Valid = false;
        }

        validateSignup();
    }

    // 구 선택 이벤트 리스너
    $('#gu1').on('change', function() {
        $(this).addClass('has-value');
        loadDongs('#gu1', '#dong1', '#dongCode1');
        dong1Valid = false;
        validateSignup();
    });

    $('#gu2').on('change', function() {
        $(this).addClass('has-value');
        loadDongs('#gu2', '#dong2', '#dongCode2');
        dong2Valid = false;
        validateSignup();
    });

    // 동 선택 이벤트 리스너
    $('#dong1').on('change', function() {
        handleDongSelect('#dong1', '#dongCode1', 1);
    });

    $('#dong2').on('change', function() {
        handleDongSelect('#dong2', '#dongCode2', 2);
    });

    // 포커스 처리
    $('#gu1, #dong1, #gu2, #dong2').on('focus', function() {
        $(this).css('backgroundColor', 'var(--color-white)');
    }).on('blur', function() {
        if (!$(this).val()) {
            $(this).css('backgroundColor', 'var(--color-light-gray)');
        }
    });

    // 페이지 로드 시 구 목록 로드
    loadGus();

    // OAuth 회원가입 시 초기 버튼 상태 갱신
    if (isOAuth) {
        validateSignup();
    }

    // 회원가입 폼 제출 처리 (AJAX)
    $('#signupForm').on('submit', function(e) {
        e.preventDefault();

        if (!emailValid || !phoneValid || !nicknameValid || !dong1Valid || !dong2Valid) {
            return false;
        }

        const formData = new FormData(this);
        const originalBtnText = $('#signupBtn').text();

        $('#signupBtn').prop('disabled', true).text('처리 중...');

        $.ajax({
            url: contextPath + '/auth/signup',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    window.location.href = contextPath + '/auth/login';
                } else {
                    $('#signupBtn').prop('disabled', false).text(originalBtnText);
                    const errorMsg = response.message || '회원가입 중 오류가 발생했습니다.';
                    $('#globalError').text(errorMsg).show();
                }
            },
            error: function(xhr) {
                $('#signupBtn').prop('disabled', false).text(originalBtnText);
                let errorMsg = '요청을 처리하지 못했습니다. 다시 시도해주세요.';
                try {
                    const response = JSON.parse(xhr.responseText);
                    if (response.message) {
                        errorMsg = response.message;
                    }
                } catch (e) {
                    // JSON 파싱 실패 시 기본 메시지 사용
                }
                $('#globalError').text(errorMsg).show();
            }
        });

        return false;
    });

    // 입력 시작 시 에러 숨김
    document.querySelectorAll("input, select").forEach(el => {
        el.addEventListener("input", () => {
            const globalError = document.getElementById("globalError");
            if (globalError) {
                globalError.style.display = "none";
            }
        });
    });
</script>
</body>
</html>