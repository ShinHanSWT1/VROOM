<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>

<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script
            src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js">
    </script>
    <title>VROOM - 관리자 로그인</title>
    <style>
        :root {
            --color-primary: #6B8E23;
            --color-secondary: #F2CB05;
            --color-tertiary: #F2B807;
            --color-accent: #F2A007;
            --color-warm: #D97218;
            --color-dark: #2C3E50;
            --color-gray: #7F8C8D;
            --color-light-gray: #ECF0F1;
            --color-white: #FFFFFF;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Malgun Gothic', sans-serif;
            color: var(--color-dark);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: linear-gradient(135deg, #F8F9FA 0%, #E8EAF0 100%);
            position: relative;
            overflow: hidden;
        }

        /* Honeycomb Background Pattern */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image:
                    linear-gradient(30deg, transparent 48%, rgba(242, 203, 5, 0.05) 48%, rgba(242, 203, 5, 0.05) 52%, transparent 52%),
                    linear-gradient(150deg, transparent 48%, rgba(242, 203, 5, 0.05) 48%, rgba(242, 203, 5, 0.05) 52%, transparent 52%),
                    linear-gradient(90deg, transparent 48%, rgba(242, 203, 5, 0.05) 48%, rgba(242, 203, 5, 0.05) 52%, transparent 52%);
            background-size: 60px 104px;
            opacity: 0.5;
            z-index: 0;
        }

        /* Header */
        .login-header {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
            position: relative;
            z-index: 10;
            padding: 1.5rem 2rem;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .header-title {
            color: var(--color-white);
            font-size: 1.75rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .header-icon {
            font-size: 2rem;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        /* Main Content */
        .login-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            position: relative;
            z-index: 1;
        }

        /* Login Container */
        .login-container {
            background: var(--color-white);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            max-width: 480px;
            width: 100%;
            position: relative;
            border: 3px solid transparent;
            background-clip: padding-box;
        }

        .login-container::before {
            content: '';
            position: absolute;
            top: -3px;
            left: -3px;
            right: -3px;
            bottom: -3px;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 50%, var(--color-warm) 100%);
            border-radius: 20px;
            z-index: -1;
        }

        /* Login Header */
        .login-container-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .login-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            display: inline-block;
            animation: buzz 2s ease-in-out infinite;
        }

        @keyframes buzz {
            0%, 100% {
                transform: rotate(0deg);
            }
            10%, 30%, 50%, 70%, 90% {
                transform: rotate(-5deg);
            }
            20%, 40%, 60%, 80% {
                transform: rotate(5deg);
            }
        }

        .login-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--color-dark);
            margin-bottom: 0.5rem;
        }

        .login-subtitle {
            font-size: 0.95rem;
            color: var(--color-gray);
        }

        /* Form */
        .login-form {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .form-label {
            font-weight: 600;
            color: var(--color-dark);
            font-size: 0.95rem;
        }

        .form-input-wrapper {
            position: relative;
        }

        .form-input {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 10px;
            font-size: 1rem;
            font-family: inherit;
            transition: all 0.3s ease;
            background-color: #FAFAFA;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--color-secondary);
            background-color: var(--color-white);
            box-shadow: 0 0 0 4px rgba(242, 203, 5, 0.1);
        }

        .form-input::placeholder {
            color: #BDC3C7;
        }

        /* Password Toggle */
        .password-toggle {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.25rem;
            color: var(--color-gray);
            transition: color 0.3s ease;
        }

        .password-toggle:hover {
            color: var(--color-accent);
        }

        /* Form Options */
        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.875rem;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
        }

        .remember-me input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: var(--color-accent);
        }

        .remember-me label {
            cursor: pointer;
            color: var(--color-dark);
            font-weight: 500;
        }

        .forgot-password {
            color: var(--color-accent);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .forgot-password:hover {
            color: var(--color-warm);
        }

        /* Login Button */
        .login-button {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-dark);
            border: none;
            padding: 1rem;
            border-radius: 10px;
            font-size: 1.125rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(242, 160, 7, 0.3);
            font-family: inherit;
            margin-top: 0.5rem;
        }

        .login-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(242, 160, 7, 0.4);
        }

        .login-button:active {
            transform: translateY(0px);
        }

        /* Help Text */
        .login-help {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px dashed var(--color-light-gray);
        }

        .help-text {
            font-size: 0.875rem;
            color: var(--color-gray);
            margin-bottom: 0.75rem;
        }

        .help-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--color-accent);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .help-link:hover {
            background-color: #FFF9E6;
            color: var(--color-warm);
        }

        /* Decorative Bees */
        .bee-decoration {
            position: absolute;
            font-size: 2rem;
            opacity: 0.15;
            animation: fly 15s ease-in-out infinite;
        }

        .bee-1 {
            top: 10%;
            left: 5%;
            animation-delay: 0s;
        }

        .bee-2 {
            top: 70%;
            right: 8%;
            animation-delay: 5s;
        }

        .bee-3 {
            bottom: 15%;
            left: 10%;
            animation-delay: 10s;
        }

        @keyframes fly {
            0%, 100% {
                transform: translate(0, 0) rotate(0deg);
            }
            25% {
                transform: translate(30px, -20px) rotate(5deg);
            }
            50% {
                transform: translate(-20px, 30px) rotate(-5deg);
            }
            75% {
                transform: translate(40px, 20px) rotate(3deg);
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .login-content {
                padding: 1rem;
            }

            .login-container {
                padding: 2rem 1.5rem;
            }

            .header-title {
                font-size: 1.5rem;
            }

            .login-title {
                font-size: 1.5rem;
            }

            .form-options {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }
        }

        /* Alert Messages */
        .alert {
            padding: 0.875rem 1rem;
            border-radius: 8px;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            display: none;
        }

        .alert.show {
            display: block;
        }

        .alert-error {
            background-color: #FDEAEA;
            color: #E74C3C;
            border: 1px solid #E74C3C;
        }

        .alert-success {
            background-color: #E8F5E9;
            color: #27AE60;
            border: 1px solid #27AE60;
        }
    </style>

    <!-- 글꼴 -->
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet" as="style"
          href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
</head>

<body>
<!-- Decorative Bees -->
<div class="bee-decoration bee-1">🐝</div>
<div class="bee-decoration bee-2">🐝</div>
<div class="bee-decoration bee-3">🐝</div>

<!-- Header -->
<header class="login-header">
    <div class="header-container">
        <h1 class="header-title">
            <span class="header-icon">🐝</span>
            VROOM Management
        </h1>
    </div>
</header>

<!-- Main Content -->
<main class="login-content">
    <div class="login-container">
        <!-- Login Header -->
        <div class="login-container-header">
            <div class="login-icon">🍯</div>
            <h2 class="login-title">관리자 로그인</h2>
            <p class="login-subtitle">관리자 계정으로 로그인하세요</p>
        </div>

        <!-- Alert Message -->
        <div class="alert alert-error" id="alertMessage"></div>

        <!-- Login Form -->
        <form action="${pageContext.request.contextPath}/admin/login" method="post" class="login-form" id="loginForm">
            <div class="form-group">
                <label for="adminId" class="form-label">관리자 ID</label>
                <div class="form-input-wrapper">
                    <input
                            type="text"
                            id="adminId"
                            name="loginId"
                            class="form-input"
                            placeholder="관리자 ID를 입력하세요"
                            required
                            autocomplete="username"
                    >
                </div>
            </div>

            <div class="form-group">
                <label for="adminPassword" class="form-label">비밀번호</label>
                <div class="form-input-wrapper">
                    <input
                            type="password"
                            id="adminPassword"
                            name="password"
                            class="form-input"
                            placeholder="비밀번호를 입력하세요"
                            required
                            autocomplete="current-password"
                    >
                    <button type="button" class="password-toggle" id="passwordToggle">
                        👁️
                    </button>
                </div>
            </div>

            <div class="form-options">
                <div class="remember-me">
                    <input type="checkbox" id="rememberMe" name="rememberMe">
                    <label for="rememberMe">로그인 상태 유지</label>
                </div>
                <a href="#" class="forgot-password">비밀번호 찾기</a>
            </div>

            <button type="submit" class="login-button">
                로그인
            </button>
        </form>

        <!-- Help Section -->
        <div class="login-help">
            <p class="help-text">문제가 있으신가요?</p>
            <a href="#" class="help-link">
                <span>📞</span>
                <span>관리자 지원팀에 문의하기</span>
            </a>
        </div>
    </div>
</main>

<script>
    // Password Toggle
    const passwordInput = document.getElementById('adminPassword');
    const passwordToggle = document.getElementById('passwordToggle');

    passwordToggle.addEventListener('click', function() {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        this.textContent = type === 'password' ? '👁️' : '🙈';
    });

    // Hide alert on input
    document.querySelectorAll('.form-input').forEach(input => {
        input.addEventListener('input', function() {
            alertMessage.classList.remove('show');
        });
    });
</script>
</body>

</html>