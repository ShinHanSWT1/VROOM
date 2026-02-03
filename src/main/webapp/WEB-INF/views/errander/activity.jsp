<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="나의 거래 - 부름이 마이 페이지" scope="request" />
<c:set var="pageCss" value="activity" scope="request" />
<c:set var="pageCssDir" value="errander" scope="request" />

<jsp:include page="../common/header.jsp" />

<!-- FullCalendar CSS -->
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css' rel='stylesheet' />

<!-- Mypage Layout -->
<div class="mypage-layout">
    <!-- Sidebar Navigation -->
    <aside class="mypage-sidebar">
        <nav class="sidebar-menu">
            <a href="profile" class="sidebar-item">나의 정보</a>
            <a href="pay" class="sidebar-item">부름 페이</a>
            <a href="activity" class="sidebar-item active">나의 거래</a>
            <a href="settings" class="sidebar-item">설정</a>
            <a href="#" class="sidebar-item">고객지원</a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="mypage-content">
        <h2 class="page-title">나의 거래</h2>

        <div class="activity-layout">
            <!-- Calendar Section (FullCalendar) -->
            <div class="calendar-section">
                <div id="calendar"></div>
            </div>

            <!-- Transaction List -->
            <div class="transaction-list-section" style="margin-top: 2rem;">
                <h3 class="transaction-list-title">심부름 제목, 날짜, 금액</h3>

                <div id="transactionListContainer">
                    <!-- Transaction items will be dynamically inserted here -->
                </div>
            </div>
        </div>
    </main>
</div>

<!-- FullCalendar JS -->
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
<script src="<c:url value='/static/errander/js/activity.js'/>"></script>

<jsp:include page="../common/footer.jsp" />
