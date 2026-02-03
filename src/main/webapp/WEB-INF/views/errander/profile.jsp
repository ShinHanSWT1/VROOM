<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="나의 정보 - 부름이 마이 페이지" scope="request"/>
<c:set var="pageCss" value="profile" scope="request"/>
<c:set var="pageCssDir" value="errander" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<!-- Mypage Layout -->
<div class="mypage-layout">
    <!-- Sidebar Navigation -->
    <aside class="mypage-sidebar">
        <nav class="sidebar-menu">
            <a href="profile" class="sidebar-item active">나의 정보</a>
            <a href="pay" class="sidebar-item">부름 페이</a>
            <a href="activity" class="sidebar-item">나의 거래</a>
            <a href="settings" class="sidebar-item">설정</a>
            <a href="#" class="sidebar-item">고객지원</a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="mypage-content">
        <!-- Profile Header with Greeting -->
        <div class="profile-header">
            <div style="display: flex; align-items: center; gap: 1.5rem; margin-bottom: 1rem;">
                <c:choose>
                    <c:when test="${not empty profile.profileImage}">
                        <img src="<c:url value='${profile.profileImage}'/>"
                             alt="프로필 이미지"
                             style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid white;">
                    </c:when>
                    <c:otherwise>
                        <div style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%); display: flex; align-items: center; justify-content: center; font-size: 2rem; color: white; border: 3px solid white;">
                            🐝
                        </div>
                    </c:otherwise>
                </c:choose>
                <div>
                    <h2 class="profile-greeting" style="margin-bottom: 0.5rem;"> ${profile.nickname}</h2>
                    <!-- 계정 상태 표시 -->
                    <div class="account-status-badges" style="display: flex; gap: 0.5rem; font-size: 0.85rem;">
                        <span style="padding: 2px 8px; border-radius: 12px; background-color: ${profile.activeStatus eq 'ACTIVE' ? '#e8f5e9' : '#ffebee'}; color: ${profile.activeStatus eq 'ACTIVE' ? '#2e7d32' : '#c62828'};">
                            <c:choose>
                                <c:when test="${profile.activeStatus eq 'ACTIVE'}">활성 계정</c:when>
                                <c:when test="${profile.activeStatus eq 'SUSPENDED'}">정지된 계정</c:when>
                                <c:otherwise>비활성 계정</c:otherwise>
                            </c:choose>
                        </span>
                        <span style="padding: 2px 8px; border-radius: 12px; background-color: ${profile.approvalStatus eq 'APPROVED' ? '#e3f2fd' : '#fff3e0'}; color: ${profile.approvalStatus eq 'APPROVED' ? '#1565c0' : '#ef6c00'};">
                            <c:choose>
                                <c:when test="${profile.approvalStatus eq 'APPROVED'}">인증 완료</c:when>
                                <c:when test="${profile.approvalStatus eq 'PENDING'}">인증 대기</c:when>
                                <c:when test="${profile.approvalStatus eq 'REJECTED'}">승인 거절</c:when>
                                <c:otherwise>미인증</c:otherwise>
                            </c:choose>
                        </span>
                        <span style="padding: 2px 8px; border-radius: 12px; background-color: #f3e5f5; color: ${profile.grade == 'VIP' ? '#9b59b6' : (profile.grade == 'PREMIUM' ? '#f39c12' : '#2c3e50')}; font-weight: bold;">
                            ${profile.memberTypeLabel}
                        </span>
                    </div>
                </div>
            </div>
            
            <!-- Progress Bars -->
            <div class="progress-bar-container">
                <div class="progress-label">
                    <span>심부름 완료율 <span id="completionRate">${profile.completeRate != null ? profile.completeRate : 0}</span>%</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" id="completionRateBar" style="width: ${profile.completeRate != null ? profile.completeRate : 0}%">
                        ${profile.completeRate != null ? profile.completeRate : 0}%
                    </div>
                </div>
            </div>
            
            <!-- Stats Row -->
            <div class="profile-stats">
                <div class="stat-item">
                    <div class="stat-label">[ 수행 중 ]</div>
                    <div class="stat-value" id="inProgressCount">${profile.inProgressCount != null ? profile.inProgressCount : 0}건</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">[ 전체 완료 ]</div>
                    <div class="stat-value" id="completedCount">${profile.completedCount != null ? profile.completedCount : 0}건</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">[ 전체 수익 ]</div>
                    <div class="stat-value" id="totalEarning"><fmt:formatNumber value="${profile.totalEarning != null ? profile.totalEarning : 0}" pattern="#,###"/> 원</div>
                </div>
            </div>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Activity Summary Card (Merged) -->
            <div class="info-card">
                <h3 class="info-card-title">활동 요약</h3>
                <ul class="info-list">
                    <li class="info-list-item">
                        <span>최근 30일 수행</span>
                        <strong id="last30DaysCount">${profile.last30DaysCompletedCount}건</strong>
                    </li>
                    <li class="info-list-item">
                        <span>성공률</span>
                        <strong id="successRate">${profile.successRate}%</strong>
                    </li>
                </ul>
            </div>

            <!-- Customer Satisfaction Card -->
            <div class="info-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                    <h3 class="info-card-title" style="margin-bottom: 0;">고객 만족도</h3>
                    <span style="font-size: 0.9rem; color: #7f8c8d; cursor: pointer;" id="reviewCountBtn">
                        누적 리뷰 <fmt:formatNumber value="${profile.reviewCount}" pattern="#,###"/>건 >
                    </span>
                </div>

                <div style="text-align: center; padding: 1.5rem 0;">
                    <div style="font-size: 3.5rem; font-weight: 800; color: #2c3e50; line-height: 1;">
                        <fmt:formatNumber value="${profile.ratingAvg}" pattern="0.0"/>
                    </div>

                    <div style="margin: 0.5rem 0 1rem 0; font-size: 1.5rem; letter-spacing: 5px;">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= profile.ratingAvg}">
                                    <span style="color: #f1c40f;">★</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #bdc3c7;">★</span>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>

                    <p style="color: #7f8c8d; font-size: 0.95rem; margin: 0;">
                        사용자들에게 받은 평균 평점입니다.
                    </p>
                </div>
            </div>
        </div>

        <!-- Achievements Section -->
        <div class="info-card">
            <h3 class="info-card-title">[ ACHIEVEMENTS ]</h3>
            <div class="achievement-list">
                <div class="achievement-item ${profile.completedCount >= 1 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">🏆</div>
                    <span>첫 심부름 완료</span>
                    <c:if test="${profile.completedCount >= 1}">
                        <span style="margin-left: auto; color: green;">✔</span>
                    </c:if>
                </div>

                <div class="achievement-item ${profile.completedCount >= 10 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">⭐</div>
                    <span>10건 달성</span>
                    <c:if test="${profile.completedCount >= 10}">
                        <span style="margin-left: auto; color: green;">✔</span>
                    </c:if>
                </div>

                <div class="achievement-item ${profile.completedCount >= 50 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">💎</div>
                    <span style="${profile.completedCount >= 50 ? 'font-weight:bold;' : ''}">50건 달성</span>
                    <c:if test="${profile.completedCount >= 50}">
                        <span style="margin-left: auto; color: green;">✔</span>
                    </c:if>
                </div>

                <div class="achievement-item ${profile.completedCount >= 100 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">👑</div>
                    <span>100건 달성</span>
                    <c:if test="${profile.completedCount >= 100}">
                        <span style="margin-left: auto; color: green;">✔</span>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
</div>

<!-- Review Modal -->
<div class="modal-overlay" id="reviewModal">
    <div class="modal-content review-modal-content">
        <div class="modal-header">
            <h3 class="modal-title">받은 리뷰 목록</h3>
            <button class="modal-close" id="closeReviewModal">&times;</button>
        </div>
        <div class="modal-body review-modal-body" id="reviewListContainer">
            <!-- 리뷰 리스트가 여기에 동적으로 추가됨 -->
            <div class="loading-spinner" id="reviewLoading">
                <div class="spinner"></div>
            </div>
        </div>
    </div>
</div>

<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>

<jsp:include page="../common/footer.jsp"/>

<script src="<c:url value='/static/errander/js/profile.js'/>"></script>
</body>
</html>
