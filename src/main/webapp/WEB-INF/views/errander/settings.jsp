<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="설정 - 부름이 마이 페이지" scope="request" />
<c:set var="pageCss" value="settings" scope="request" />
<c:set var="pageCssDir" value="errander" scope="request" />

<jsp:include page="../common/header.jsp" />

<!-- Mypage Layout -->
<div class="mypage-layout">
    <!-- Sidebar Navigation -->
    <aside class="mypage-sidebar">
        <nav class="sidebar-menu">
            <a href="profile" class="sidebar-item">나의 정보</a>
            <a href="pay" class="sidebar-item">부름 페이</a>
            <a href="activity" class="sidebar-item">나의 거래</a>
            <a href="settings" class="sidebar-item active">설정</a>
            <a href="#" class="sidebar-item">고객지원</a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="mypage-content">
        <h2 class="page-title">설정</h2>

        <!-- Preferred Neighborhood Settings -->
        <div class="settings-section">
            <h3 class="settings-section-title">동네 설정</h3>
            
            <form id="locationForm" onsubmit="saveLocationSettings(event)">
                <div class="location-selector">
                    <div class="location-item">
                        <label class="location-label">동네 설정 1</label>
                        <select name="dongCode3" class="location-select" id="location1">
                            <option value="">선택하세요</option>
                            <!-- Options will be populated dynamically -->
                        </select>
                    </div>
                    
                    <div class="location-item">
                        <label class="location-label">동네 설정 2</label>
                        <select name="dongCode4" class="location-select" id="location2">
                            <option value="">선택하세요</option>
                            <!-- Options will be populated dynamically -->
                        </select>
                    </div>
                </div>
                
                <p class="location-help">
                    * 최대 2개의 동네를 설정할 수 있습니다.
                </p>
                
                <button type="submit" class="save-btn">동네 설정 저장</button>
            </form>
        </div>

        <!-- Authentication/Verification Status -->
        <div class="settings-section">
            <h3 class="settings-section-title">인증</h3>
            
            <div class="verification-status">
                <div class="verification-item">
                    <span class="verification-label">본인 인증</span>
                    <span class="verification-badge" id="phoneVerificationBadge">미인증</span>
                </div>
                <div class="verification-item">
                    <span class="verification-label">이메일 인증</span>
                    <span class="verification-badge" id="emailVerificationBadge">미인증</span>
                </div>
            </div>
            
            <a href="#" class="verify-link" onclick="goToVerification()">
                인증 페이지로 이동 →
            </a>
        </div>

        <!-- Blocked Users Management -->
        <div class="settings-section">
            <h3 class="settings-section-title">사용자 차단</h3>
            
            <div class="blocked-users-info">
                <div>
                    <div class="blocked-count">차단된 사용자: <span id="blockedUserCount">0</span>명</div>
                    <p style="margin-top: 0.5rem; color: var(--color-gray); font-size: 0.875rem;">
                        차단한 사용자의 게시글과 심부름 요청이 보이지 않습니다.
                    </p>
                </div>
                <button class="manage-btn" onclick="manageBlockedUsers()">
                    관리하기
                </button>
            </div>
        </div>
    </main>
</div>

<script src="<c:url value='/static/errander/js/settings.js'/>"></script>

<jsp:include page="../common/footer.jsp" />
