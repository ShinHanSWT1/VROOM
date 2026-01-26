<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="VROOM - 우리동네 심부름" scope="request" />
<c:set var="pageCss" value="main" scope="request" />
<c:set var="pageJs" value="main" scope="request" />

<jsp:include page="../common/header.jsp" />

<!-- Hero Section -->
<section class="hero-section">
    <div class="hero-content">
        <h1 class="hero-title">우리동네 심부름, VROOM</h1>
        <p class="hero-subtitle">이웃과 함께하는 따뜻한 커뮤니티</p>
        <div class="hero-notice">
            <span class="notice-badge">서비스 안내</span>
            <p>
                안녕하세요! 우리동네 심부름 서비스는<br>
                지역 주민들이 서로 도우며 함께 성장하는<br>
                따뜻한 커뮤니티 플랫폼입니다.
            </p>
        </div>
    </div>
</section>

<!-- Action Menu -->
<section class="action-menu">
    <div class="container">
        <div class="menu-grid">
            <c:forEach var="category" items="${errandsCategoryList}">
                <a href="<c:url value='/errand/list'><c:param name='categoryId' value='${category.id}'/></c:url>" class="menu-item" style="text-decoration: none;">
                    <div class="menu-icon">
                        <img src="<c:url value='${category.defaultImageUrl}'/>" alt="${category.name}" style="width: 48px; height: 48px;">
                    </div>
                    <div class="menu-label">${category.name}</div>
                </a>
            </c:forEach>
        </div>
    </div>
</section>

<!-- Location Search -->
<section class="location-search">
    <div class="container">
        <div class="location-selector-wrapper" style="background-color: var(--color-white); padding: 2rem; border-radius: 12px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); text-align: center;">
            <h3 style="margin-bottom: 1.5rem; color: var(--color-dark);">우리 동네 설정하기</h3>

            <div class="location-selectors" style="display: flex; justify-content: center; gap: 1rem;">
                <select id="guSelect" class="location-select" style="padding: 0.75rem 1.25rem; border: 2px solid var(--color-light-gray); border-radius: 8px; font-size: 1rem;">
                    <option value="">구 선택</option>
                    <c:forEach var="gungu" items="${gunguList}">
                        <option value="${gungu}" ${gungu == selectedGuName ? 'selected' : ''}>${gungu}</option>
                    </c:forEach>
                </select>

                <select id="dongSelect" class="location-select" style="padding: 0.75rem 1.25rem; border: 2px solid var(--color-light-gray); border-radius: 8px; font-size: 1rem;">
                    <option value="">동 선택</option>
                </select>
            </div>
        </div>
    </div>
</section>

<!-- 진행 중인 부름 -->
<section class="section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">진행 중인 부름</h2>
            <a href="<c:url value='/errand/list'><c:if test='${not empty selectedDongCode}'><c:param name='dongCode' value='${selectedDongCode}'/></c:if></c:url>" class="more-link">더보기 →</a>
        </div>
        <div class="task-grid">
            <c:forEach var="task" items="${errandListVO}">
                <a href="<c:url value='/errand/detail'><c:param name='errandsId' value='${task.errandsId}'/></c:url>" class="task-card" style="text-decoration: none; color: inherit;">
                    <img src="<c:url value='${task.imageUrl}'/>" alt="${task.title}" class="task-image">
                    <div class="task-info">
                        <h3 class="task-title">${task.title}</h3>
                        <div class="task-meta">
                            <span class="task-price"><fmt:formatNumber value="${task.rewardAmount}" type="currency" currencySymbol="₩" /></span>
                            <span class="task-location">${task.dongFullName}</span>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>
</section>

<!-- 커뮤니티 인기글 -->
<section class="section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">커뮤니티 인기글</h2>
            <a href="<c:url value='/community'><c:if test='${not empty selectedDongCode}'><c:param name='dongCode' value='${selectedDongCode}'/></c:if></c:url>" class="more-link">더보기 →</a>
        </div>

        <div class="hot-posts">
            <ul class="hot-post-list">
                <c:forEach var="post" items="${popularPostListVO}" varStatus="status">
                    <a href="<c:url value='/community/detail/${post.postId}'/>" class="hot-post-item" style="text-decoration: none; color: inherit;">
                        <span class="hot-rank">BEST ${status.index + 1}</span>
                        <span class="hot-title">${post.title}</span>
                    </a>
                </c:forEach>
            </ul>
        </div>
    </div>
</section>

<!-- 우수 부름이 리뷰 -->
<section class="section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">우수 부름이 리뷰</h2>
        </div>
        <div class="reviews-carousel">
            <div class="reviews-container">
                <c:forEach var="review" items="${reviewList}">
                    <div class="review-card">
                        <div class="review-header">
                            <div class="reviewer-info">
                                <div class="reviewer-avatar">👤</div>
                                <div class="reviewer-details">
                                    <span class="reviewer-name">${review.reviewerName}</span>
                                </div>
                            </div>
                            <div class="review-rating">
                                <span class="rating-score">${review.rating}</span>
                                <span class="rating-star">★</span>
                            </div>
                        </div>
                        <div class="review-task">
                            <span class="task-label">${review.taskCategory} 님이 추천해요!</span>
                        </div>
                        <div class="review-content">
                            <p>${review.content}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</section>

<!-- 공지사항 -->
<section class="notice-section">
    <div class="container">
        <div class="notice-card">
            <div class="notice-header">
                <span class="notice-icon">📢</span>
                <h2 class="notice-title">공지사항</h2>
            </div>
            <div class="notice-body">
                <p class="notice-greeting">안녕하세요, VROOM 이용자 여러분!</p>
                <p class="notice-content">
                    항상 저희 서비스를 이용해주셔서 감사드립니다.<br>
                    더 나은 서비스 제공을 위한 서버 업데이트를 진행하오니 아래 일정을 확인해주시기 바랍니다.
                </p>
                <div class="notice-schedule">
                    <div class="schedule-label">서버 점검 일정</div>
                    <div class="schedule-detail">
                        📅 2025년 2월 11일 (화)<br>
                        ⏰ 오후 6시 ~ 자정 (18:00 ~ 24:00)
                    </div>
                </div>
                <p class="notice-content" style="margin-top: 1rem;">
                    점검 시간 동안에는 일시적으로 서비스 이용이 불가하오니<br>
                    이용에 참고 부탁드리며, 불편을 드려 죄송합니다.
                </p>
            </div>
        </div>
    </div>
</section>

<script>
    window.mainFilterConfig = {
        contextPath: '${pageContext.request.contextPath}',
        selectedDongCode: '${selectedDongCode}',
        selectedGuName: '${selectedGuName}'
    };
</script>
<script src="<c:url value='/static/main/js/mainFilter.js'/>"></script>

<jsp:include page="../common/footer.jsp" />
