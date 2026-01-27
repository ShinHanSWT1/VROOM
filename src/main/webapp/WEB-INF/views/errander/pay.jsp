<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="부름Pay - 부름이 마이 페이지" scope="request"/>
<c:set var="pageCss" value="pay" scope="request"/>
<c:set var="pageCssDir" value="errander" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<!-- Mypage Layout -->
<div class="mypage-layout">
        <!-- Sidebar Navigation -->
        <aside class="mypage-sidebar">
            <nav class="sidebar-menu">
                <a href="profile" class="sidebar-item">나의 정보</a>
                <a href="pay" class="sidebar-item active">부름 페이</a>
                <a href="activity" class="sidebar-item">나의 거래</a>
                <a href="settings" class="sidebar-item">설정</a>
                <a href="#" class="sidebar-item">고객지원</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="mypage-content">
            <h2 class="page-title">부름Pay</h2>

            <!-- Pay Summary Cards -->
            <div class="pay-summary-grid">
                <div class="pay-summary-card">
                    <div class="pay-summary-label">정산 대기 금액</div>
                    <div class="pay-summary-value" id="settlementWaiting">₩0</div>
                </div>
                <div class="pay-summary-card">
                    <div class="pay-summary-label">사용 가능 잔액</div>
                    <div class="pay-summary-value" id="availableBalance">₩0</div>
                </div>
                <div class="pay-summary-card">
                    <div class="pay-summary-label">이번 달 정산 완료 수익</div>
                    <div class="pay-summary-value" id="thisMonthSettled">₩0</div>
                </div>
            </div>

            <!-- Current Settlement Section -->
            <div class="settlement-section">
                <h3 class="settlement-title">현재 정산 처리 중인 심부름</h3>
                
                <div class="settlement-info">
                    <div class="settlement-info-item">
                        <div>수령 예정 금액 <span id="expectedAmount">₩0</span></div>
                    </div>
                    <div class="settlement-info-item">
                        <div>상태: <span id="settlementStatus">대기중</span></div>
                    </div>
                </div>
                
                <button class="withdraw-btn" onclick="requestWithdrawal()">출금 요청</button>
            </div>

            <!-- Settlement History List -->
            <div class="settlement-list">
                <h3 class="settlement-list-title">정산 내역 보기</h3>
                
                <div id="settlementListContainer">
                    <!-- Settlement items will be dynamically inserted here -->
                </div>
                
                <!-- Pagination -->
                <div class="pagination">
                    <button class="page-btn" id="prevBtn" onclick="goToPage(currentPage - 1)">이전</button>
                    
                    <div id="pageNumbers"></div>
                    
                    <button class="page-btn" id="nextBtn" onclick="goToPage(currentPage + 1)">다음</button>
                </div>
            </div>
        </main>
    </div>

<jsp:include page="../common/footer.jsp"/>

<script src="<c:url value='/static/errander/js/pay.js'/>"></script>
</body>
</html>

