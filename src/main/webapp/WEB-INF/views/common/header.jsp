<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'VROOM'}</title>
    
    <!-- 공통 CSS -->
    <link rel="stylesheet" href="<c:url value='/static/common/css/common.css'/>">

    <!-- 페이지별 CSS -->
    <c:if test="${not empty pageCss}">
        <c:choose>
            <c:when test="${pageCss == 'main'}">
                <link rel="stylesheet" href="<c:url value='/static/main/css/main.css'/>">
            </c:when>
            <c:when test="${pageCss == 'auth'}">
                <link rel="stylesheet" href="<c:url value='/static/user/css/auth.css'/>">
            </c:when>
            <c:when test="${pageCss.startsWith('community')}">
                <link rel="stylesheet" href="<c:url value='/static/community/css/${pageCss}.css'/>">
            </c:when>
            <c:otherwise>
                <link rel="stylesheet" href="<c:url value='/static/${pageCssDir}/css/${pageCss}.css'/>">
            </c:otherwise>
        </c:choose>
    </c:if>

    <!-- 글꼴 -->
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet" as="style" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">

    <!-- jQuery (AJAX 사용 시) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <div class="logo">
                <a href="${pageContext.request.contextPath}/"><h1>VROOM</h1></a>
            </div>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/community/" class="nav-item">커뮤니티</a>

                <c:choose>
                    <c:when test="${sessionScope.loginSess != null}">
                        <!-- 로그인 상태 -->
                        <c:choose>
                            <c:when test="${sessionScope.loginSess.role == 'ERRANDER'}">
                                <a href="${pageContext.request.contextPath}/user/switch" class="nav-item">사용자 전환</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/errander/switch" class="nav-item">심부름꾼 전환</a>
                            </c:otherwise>
                        </c:choose>
                        <div class="nav-dropdown">
                            <button class="nav-item" id="userDropdownBtn">${sessionScope.loginSess.nickname}님</button>
                            <div class="dropdown-menu" id="userDropdownMenu">
                                <a href="<c:url value='/member/myInfo'/>" class="dropdown-item">나의정보</a>
                                <a href="<c:url value='/member/vroomPay'/>" class="dropdown-item">부름페이</a>
                                <a href="<c:url value='/member/myActivity'/>" class="dropdown-item">나의 활동</a>
                                <a href="#" class="dropdown-item">설정</a>
                                <a href="#" class="dropdown-item">고객지원</a>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item">로그아웃</a>
                    </c:when>
                    <c:otherwise>
                        <!-- 비로그인 상태 -->
                        <a href="${pageContext.request.contextPath}/auth/login" class="nav-item">로그인</a>
                        <a href="${pageContext.request.contextPath}/auth/signup" class="nav-item">회원가입</a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>

    <script>
        // Dropdown 기능
        document.addEventListener('DOMContentLoaded', function() {
            const dropdownBtn = document.getElementById('userDropdownBtn');
            const dropdownMenu = document.getElementById('userDropdownMenu');

            if (dropdownBtn && dropdownMenu) {
                dropdownBtn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    dropdownMenu.classList.toggle('active');
                });

                document.addEventListener('click', function(e) {
                    if (!dropdownMenu.contains(e.target) && !dropdownBtn.contains(e.target)) {
                        dropdownMenu.classList.remove('active');
                    }
                });
            }
        });
    </script>

    <!-- 페이지별 JS -->
    <c:if test="${not empty pageJs}">
        <c:choose>
            <c:when test="${pageJs == 'login'}">
                <script src="<c:url value='/static/user/js/login.js'/>"></script>
            </c:when>
            <c:when test="${pageJs == 'signup'}">
                <script src="<c:url value='/static/user/js/signup.js'/>"></script>
            </c:when>
            <c:otherwise>
                <script src="<c:url value='/static/${pageJsDir}/js/${pageJs}.js'/>"></script>
            </c:otherwise>
        </c:choose>
    </c:if>
</body>
</html>