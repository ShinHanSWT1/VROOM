<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="나의 활동 - VROOM" scope="request"/>
<c:set var="pageCss" value="myActivity" scope="request"/>
<c:set var="pageCssDir" value="user" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<div class="container">
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li class="sidebar-item"><a href="<c:url value='/member/myInfo'/>" class="sidebar-link">나의 정보</a></li>
                <li class="sidebar-item"><a href="<c:url value='/member/vroomPay'/>" class="sidebar-link">부름 페이<br>(계좌 관리)</a></li>
                <li class="sidebar-item"><a href="<c:url value='/member/myActivity'/>" class="sidebar-link active">나의 활동</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">설정</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">고객지원</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <h2 class="page-title">나의 활동</h2>

            <div class="activity-section">
                <div class="activity-tabs">
                    <button class="activity-tab-btn active" data-type="written">작성한 글</button>
                    <button class="activity-tab-btn" data-type="commented">댓글단 글</button>
                    <button class="activity-tab-btn" data-type="saved">저장한 글</button>
                </div>

                <div class="activity-list" id="activityList">
                    <!-- Javascript will populate this -->
                </div>
            </div>
        </main>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script src="<c:url value='/static/user/js/myActivity.js'/>"></script>
</body>
</html>
