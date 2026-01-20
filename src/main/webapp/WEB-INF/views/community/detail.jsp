<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${post.title} - VROOM" />
<c:set var="pageCss" value="community-detail" />
<c:set var="pageJs" value="community-ajax" />
<c:set var="pageId" value="community" />

<jsp:include page="../common/header.jsp" />

<!-- Filter Section -->
<section class="filter-section">
    <div class="filter-container">
        <div class="location-selectors">
            <select class="location-select" id="guSelect" onchange="updateDongOptions()">
                <option value="금천구">금천구</option>
                <option value="송파구">송파구</option>
                <option value="강남구">강남구</option>
                <option value="서초구">서초구</option>
                <option value="강동구">강동구</option>
                <option value="영등포구">영등포구</option>
                <option value="마포구">마포구</option>
            </select>
            <select class="location-select" id="dongSelect" onchange="updateLocation()">
                <option value="가산동">가산동</option>
                <option value="독산동">독산동</option>
                <option value="시흥동">시흥동</option>
            </select>
        </div>
        <div class="search-wrapper">
            <form action="<c:url value='/community/list'/>" method="get" style="display: flex; width: 100%; gap: 0.5rem;">
                <input type="text" class="search-input" name="search" 
                       placeholder="제목을 검색하세요" id="searchInput">
                <button type="submit" class="search-btn">
                    <span>검색</span>
                    <span>→</span>
                </button>
            </form>
        </div>
    </div>
</section>

<!-- Main Content -->
<main class="main-content">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<c:url value='/main'/>">홈</a>
        <span class="breadcrumb-separator">></span>
        <a href="<c:url value='/community/list'/>">동네생활</a>
        <span class="breadcrumb-separator">></span>
        <span>${post.category}</span>
    </nav>

    <!-- Content Grid -->
    <div class="content-grid">
        <!-- Category Sidebar -->
        <aside class="category-sidebar">
            <div class="sidebar-section">
                <h3 class="sidebar-title">🔥 인기글</h3>
            </div>
            <div class="sidebar-section">
                <ul class="category-list">
                    <li class="category-item" onclick="goToCategory('전체')">전체</li>
                    <li class="category-item ${post.category == '맛집' ? 'active' : ''}" onclick="goToCategory('맛집')">맛집</li>
                    <li class="category-item" onclick="goToCategory('동네행사')">동네행사</li>
                    <li class="category-item" onclick="goToCategory('반려동물')">반려동물</li>
                    <li class="category-item" onclick="goToCategory('운동')">운동</li>
                    <li class="category-item" onclick="goToCategory('생활/편의')">생활/편의</li>
                    <li class="category-item" onclick="goToCategory('분실/실종')">분실/실종</li>
                    <li class="category-item" onclick="goToCategory('병원/약국')">병원/약국</li>
                    <li class="category-item" onclick="goToCategory('고민/사건')">고민/사건</li>
                    <li class="category-item" onclick="goToCategory('동네친구')">동네친구</li>
                </ul>
            </div>
        </aside>

        <!-- Post Detail -->
        <div class="post-detail-container">
            <!-- Post Header -->
            <div class="post-header">
                <span class="post-category-badge">${post.category}</span>

                <div class="post-author-section">
                    <div class="author-avatar">${post.nickname.substring(0, 1)}</div>
                    <div class="author-info">
                        <div>
                            <span class="author-name">${post.nickname}</span>
                            <span class="author-temp">${post.temperature}°C</span>
                        </div>
                        <div class="author-meta">
                            <span>${post.dong}</span>
                            <span>•</span>
                            <span><fmt:formatDate value="${post.regDate}" pattern="MM월 dd일 HH:mm" /></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Post Title -->
            <h1 class="post-title">${post.title}</h1>

            <!-- Post Content -->
            <div class="post-content">
                ${post.content}
            </div>

            <!-- Map Placeholder (지도 API 연동 시 사용) -->
            <c:if test="${not empty post.mapLocation}">
                <div class="map-placeholder">
                    <span>🗺 지도 API 영역 (${post.mapLocation})</span>
                </div>
            </c:if>

            <!-- Post Actions -->
            <div class="post-actions">
                <div class="actions-left">
                    <button class="action-btn ${post.userLiked ? 'active' : ''}" onclick="toggleLike(this)">
                        <span>👍</span>
                        <span class="like-count">${post.likeCount}</span>
                    </button>
                    <button class="action-btn" onclick="showCommentForm()">
                        <span>💬</span>
                        <span>댓글</span>
                    </button>
                </div>
                <div class="views-count">조회 ${post.viewCount}</div>
            </div>

            <!-- Comments Section -->
            <div class="comments-section">
                <h3 class="comments-header">댓글</h3>

                <!-- Comment Form (Initially Hidden) -->
                <div class="comment-form" id="mainCommentForm" style="display: none;">
                    <textarea class="comment-input" placeholder="댓글을 입력하세요..."></textarea>
                    <button class="comment-submit-btn" onclick="submitComment()">등록</button>
                </div>

                <!-- Existing Comments -->
                <c:forEach var="comment" items="${commentList}">
                    <div class="comment-item" data-comment-no="${comment.commentNo}">
                        <div class="comment-header">
                            <div class="comment-avatar">${comment.nickname.substring(0, 1)}</div>
                            <div>
                                <span class="comment-author">${comment.nickname}</span>
                            </div>
                        </div>
                        <div class="author-meta" style="margin-left: 3.5rem; margin-bottom: 0.5rem;">
                            <span>${comment.dong}</span>
                            <span>•</span>
                            <span><fmt:formatDate value="${comment.regDate}" pattern="MM월 dd일" /></span>
                        </div>
                        <div class="comment-content">${comment.content}</div>
                        <div class="comment-actions">
                            <button class="comment-action-btn" onclick="toggleCommentLike(this)">
                                <span>👍</span>
                                <span class="like-count">${comment.likeCount}</span>
                            </button>
                            <button class="comment-action-btn" onclick="showReplyForm(this)">
                                <span>💬</span>
                                <span>답글</span>
                            </button>
                        </div>

                        <!-- Reply Comments -->
                        <c:if test="${not empty comment.replies}">
                            <div class="reply-comments">
                                <c:forEach var="reply" items="${comment.replies}">
                                    <div class="reply-item" data-comment-no="${reply.commentNo}">
                                        <div class="comment-header">
                                            <div class="comment-avatar">${reply.nickname.substring(0, 1)}</div>
                                            <div>
                                                <span class="comment-author">${reply.nickname}</span>
                                            </div>
                                        </div>
                                        <div class="author-meta" style="margin-left: 3.5rem; margin-bottom: 0.5rem;">
                                            <span>${reply.dong}</span>
                                            <span>•</span>
                                            <span><fmt:formatDate value="${reply.regDate}" pattern="MM월 dd일" /></span>
                                        </div>
                                        <div class="comment-content">${reply.content}</div>
                                        <div class="comment-actions">
                                            <button class="comment-action-btn" onclick="toggleCommentLike(this)">
                                                <span>👍</span>
                                                <span class="like-count">${reply.likeCount}</span>
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </div>

            <!-- Related Posts Section -->
            <div class="related-posts-section">
                <div class="related-posts-header">
                    <h3 class="related-posts-title">${post.dong} 근처 동네생활 인기글</h3>
                    <a href="<c:url value='/community/list'/>" class="more-link">더보기 →</a>
                </div>
                <div class="related-posts-list">
                    <c:forEach var="relatedPost" items="${relatedPostList}">
                        <div class="related-post-item" onclick="goToPost(${relatedPost.postNo})">
                            <div class="related-post-title">${relatedPost.title}</div>
                            <div class="related-post-meta">
                                <span>${relatedPost.dong}</span>
                                <span>•</span>
                                <span>${relatedPost.category}</span>
                                <span>•</span>
                                <span><fmt:formatDate value="${relatedPost.regDate}" pattern="MM월 dd일" /></span>
                                <div class="related-post-stats">
                                    <span>👍 ${relatedPost.likeCount}</span>
                                    <span>💬 ${relatedPost.commentCount}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />
