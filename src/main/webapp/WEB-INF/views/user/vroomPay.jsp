<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="부름 페이 - VROOM" scope="request"/>
<c:set var="pageCss" value="vroomPay" scope="request"/>
<c:set var="pageCssDir" value="user" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<div class="container">
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li class="sidebar-item"><a href="<c:url value='/member/myInfo'/>" class="sidebar-link">나의 정보</a></li>
                <li class="sidebar-item"><a href="<c:url value='/member/vroomPay'/>" class="sidebar-link active">부름 페이<br>(계좌 관리)</a></li>
                <li class="sidebar-item"><a href="<c:url value='/member/myActivity'/>" class="sidebar-link">나의 활동</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">설정</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">고객지원</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <h2 class="page-title">부름 페이</h2>

            <!-- Profile & Balance Card -->
            <div class="pay-info-card">
                <div class="profile-section">
                    <div class="profile-image-container">
                        온도
                    </div>
                    <div class="profile-details">
                        <span class="profile-nickname">닉네임</span>
                        <button class="option-btn">현질 옵션 [ 내글을 상위 노출 해보세요 ]</button>
                    </div>
                </div>

                <div class="balance-container">
                    <div class="balance-box">
                        <button class="balance-action-btn">충 전</button>
                        <button class="balance-action-btn">출 금</button>
                        <div class="balance-display">
                            <span class="balance-label">잔 액</span>
                            <span class="balance-amount">12 원</span>
                        </div>
                    </div>
                </div>

                <div class="temp-container">
                    <span class="temp-label">온도</span>
                    <div class="temp-bar">
                        <div class="temp-fill"></div>
                    </div>
                    <span class="temp-value">36.5℃</span>
                </div>
            </div>

            <!-- Transaction History -->
            <div class="history-section">
                <div class="history-header">
                    <h3 class="history-title">거래 내역 <span class="history-count">(12)</span></h3>
                </div>

                <div class="history-table-header">
                    <div>제목</div>
                    <div>작성자</div>
                    <div>금액</div>
                </div>

                <div class="history-list" id="transactionList">
                    <!-- JS populated -->
                </div>
            </div>

            <div class="pagination" id="pagination">
                <!-- JS populated -->
            </div>
        </main>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script src="<c:url value='/static/user/js/vroomPay.js'/>"></script>
</body>
</html>
