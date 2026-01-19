<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'VROOM'}</title>
    
    <!-- CSS -->
    <link rel="stylesheet" href="<c:url value='/static/community/css/common.css'/>">
    <link rel="stylesheet" href="<c:url value='/static/community/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/static/community/css/community.css'/>">
    <link rel="stylesheet" href="<c:url value='/static/community/css/community-detail.css'/>">


    <!-- jQuery (AJAX 사용 시) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- 공통 JS -->

</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <div class="logo">
                <h1 onclick="goToPage('<c:url value="/main"/>')">VROOM</h1>
            </div>
            <nav class="nav-menu">
                <a href="<c:url value='/about'/>" class="nav-item">소개</a>
                <a href="<c:url value='/community/list'/>" class="nav-item ${pageId == 'community' ? 'active' : ''}">커뮤니티</a>
                <a href="<c:url value='/event'/>" class="nav-item">이벤트</a>
                
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <!-- 로그인 상태 -->
                        <a href="<c:url value='/mypage'/>" class="nav-item nav-user">${sessionScope.user.nickname}님</a>
                        <a href="<c:url value='/logout'/>" class="nav-item">로그아웃</a>
                    </c:when>
                    <c:otherwise>
                        <!-- 비로그인 상태 -->
                        <a href="<c:url value='/login'/>" class="nav-item nav-login">로그인</a>
                        <a href="<c:url value='/signup'/>" class="nav-item nav-signup">회원가입</a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>
