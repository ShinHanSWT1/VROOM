<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="거래 상세 정보 - 부름이 마이 페이지" scope="request"/>
<c:set var="pageCss" value="activity-detail" scope="request"/>
<c:set var="pageCssDir" value="errander" scope="request"/>

<jsp:include page="../common/header.jsp"/>

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
        <a href="activity" class="back-btn">
            <span>←</span>
            <span>목록으로 돌아가기</span>
        </a>
        
        <h2 class="page-title">거래 상세 정보</h2>

        <!-- Requester Information Section -->
        <div class="detail-section">
            <h3 class="detail-section-title">의뢰인 정보</h3>
            <div class="requester-info">
                <div class="requester-avatar">👤</div>
                <div class="requester-details">
                    <div class="requester-name" id="requesterName">홍길동</div>
                    <div class="requester-meta">
                        <span>닉네임: <span id="requesterNickname">길동이</span></span>
                        <span>신뢰도: <span id="requesterTrustScore">95</span>%</span>
                        <span>완료 건수: <span id="requesterCompletedCount">42</span>건</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Schedule Information Section -->
        <div class="detail-section">
            <h3 class="detail-section-title">심부름 날짜·시간 정보</h3>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">작성일</div>
                    <div class="info-value" id="createdDate">2024-01-10</div>
                </div>
                <div class="info-item">
                    <div class="info-label">수행 날짜</div>
                    <div class="info-value" id="scheduledDate">2024-01-15</div>
                </div>
                <div class="info-item">
                    <div class="info-label">수행 시간</div>
                    <div class="info-value" id="scheduledTime">14:30</div>
                </div>
                <div class="info-item">
                    <div class="info-label">완료 시간</div>
                    <div class="info-value" id="completedTime">15:45</div>
                </div>
            </div>
        </div>

        <!-- Location Information Section -->
        <div class="detail-section">
            <h3 class="detail-section-title">심부름 장소 정보</h3>
            <div class="location-info">
                <div class="info-label">출발지</div>
                <div class="info-value" style="margin-bottom: 1rem;" id="startAddress">서울시 강남구 역삼동 123-45</div>
                
                <div class="info-label">도착지</div>
                <div class="info-value" id="endAddress">서울시 강남구 역삼동 678-90</div>
            </div>
        </div>

        <!-- Payment Information Section -->
        <div class="detail-section">
            <h3 class="detail-section-title">페이 거래 내역</h3>
            <div class="payment-info-grid">
                <div class="payment-row">
                    <span class="payment-label">기본 금액</span>
                    <span class="payment-value" id="baseAmount">₩10,000</span>
                </div>
                <div class="payment-row">
                    <span class="payment-label">추가 금액</span>
                    <span class="payment-value" id="additionalAmount">₩5,000</span>
                </div>
                <div class="payment-row">
                    <span class="payment-label">수수료</span>
                    <span class="payment-value">- <span id="fee">₩1,000</span></span>
                </div>
                <div class="payment-row payment-total">
                    <span class="payment-label">최종 수익</span>
                    <span class="payment-value" id="finalAmount">₩14,000</span>
                </div>
            </div>
        </div>

        <!-- Review Information Section -->
        <div class="detail-section">
            <h3 class="detail-section-title">리뷰 정보</h3>
            <div id="reviewContainer">
                <div class="review-rating">
                    <span class="rating-stars">★★★★★</span>
                    <span class="rating-score" id="reviewRating">4.5 / 5.0</span>
                </div>
                <div class="review-content" id="reviewContent">
                    매우 친절하고 빠르게 심부름을 완료해주셨어요! 다음에도 부탁드리고 싶습니다.
                </div>
            </div>
        </div>
    </main>
</div>

<script src="<c:url value='/static/errander/js/activity-detail.js'/>"></script>

<jsp:include page="../common/footer.jsp"/>
