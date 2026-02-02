<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="pageTitle" value="로그인 - 우리동네 심부름" scope="request"/>
<c:set var="pageCss" value="login" scope="request"/>
<c:set var="pageCssDir" value="user" scope="request"/>

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
                        value="${email}"
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
                <c:if test="${not empty loginError}">
                    <small class="form-msg error">
                            ${loginError}
                    </small>
                </c:if>
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

        <!-- 회원가입 링크 -->
        <div class="auth-link-section">
            <p class="auth-link-text">아직 계정이 없으신가요?</p>
            <a href="${pageContext.request.contextPath}/auth/signup" class="auth-link">회원가입하기 →</a>
        </div>
    </div>
</section>

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

    // 로그인 버튼 로딩 처리
    document.getElementById("loginForm").addEventListener("submit", () => {
        loginBtn.disabled = true;
        loginBtn.innerText = "처리 중...";
    });
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>