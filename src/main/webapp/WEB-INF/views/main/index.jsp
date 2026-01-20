<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="VROOM - 우리동네 심부름" />
<c:set var="pageCss" value="main" />
<c:set var="pageJs" value="main" />

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
            <div class="menu-item">
                <div class="menu-icon">🚚</div>
                <div class="menu-label">배달</div>
            </div>
            <div class="menu-item">
                <div class="menu-icon">🔧</div>
                <div class="menu-label">설치서비스</div>
            </div>
            <div class="menu-item">
                <div class="menu-icon">🧹</div>
                <div class="menu-label">청소</div>
            </div>
            <div class="menu-item">
                <div class="menu-icon">👶</div>
                <div class="menu-label">돌봄</div>
            </div>
            <div class="menu-item">
                <div class="menu-icon">📦</div>
                <div class="menu-label">이사도움</div>
            </div>
            <div class="menu-item">
                <div class="menu-icon">🎯</div>
                <div class="menu-label">기타</div>
            </div>
        </div>
    </div>
</section>

<!-- Location Search -->
<section class="location-search">
    <div class="container">
        <div class="location-selector">
            <div class="select-group">
                <label class="label-text">지역 선택</label>
                <div class="district-tabs">
                    <button class="district-tab active" onclick="showDong('songpa')">송파구</button>
                    <button class="district-tab" onclick="showDong('gangnam')">강남구</button>
                    <button class="district-tab" onclick="showDong('seocho')">서초구</button>
                    <button class="district-tab" onclick="showDong('gangdong')">강동구</button>
                    <button class="district-tab" onclick="showDong('yeongdeungpo')">영등포구</button>
                    <button class="district-tab" onclick="showDong('mapo')">마포구</button>
                </div>
            </div>
            <div class="select-group">
                <label class="label-text">동 선택</label>
                <div class="dong-grid" id="dongGrid">
                    <!-- JavaScript로 동적 생성 -->
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 진행 중인 부름 -->
<section class="section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">진행 중인 부름</h2>
            <a href="#" class="more-link">더보기 →</a>
        </div>
        <div class="task-grid">
            <c:forEach var="task" items="${taskList}" begin="0" end="2">
                <div class="task-card">
                    <img src="https://picsum.photos/400/200?random=${task.taskNo}" alt="${task.title}" class="task-image">
                    <div class="task-info">
                        <h3 class="task-title">${task.title}</h3>
                        <p class="task-description">${task.description}</p>
                        <div class="task-meta">
                            <span class="task-price">${task.price}원</span>
                            <span class="task-location">${task.location}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- 커뮤니티 인기글 -->
<section class="section">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">커뮤니티 인기글</h2>
            <a href="<c:url value='/community/list'/>" class="more-link">더보기 →</a>
        </div>

        <div class="hot-posts">
            <ul class="hot-post-list">
                <c:forEach var="post" items="${hotPostList}" begin="0" end="5" varStatus="status">
                    <li class="hot-post-item" onclick="goToPostDetail(${post.postNo})">
                        <span class="hot-rank">BEST ${status.index + 1}</span>
                        <span class="hot-title">${post.title}</span>
                    </li>
                </c:forEach>
            </ul>

            <div class="hot-more-wrap">
                <a href="<c:url value='/community/list'/>" class="hot-more-btn">전체보기</a>
            </div>
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

<jsp:include page="../common/footer.jsp" />
