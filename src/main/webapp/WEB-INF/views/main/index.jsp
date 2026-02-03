<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <c:set var="pageTitle" value="VROOM - 우리동네 심부름" scope="request" />
            <c:set var="pageCss" value="main" scope="request" />
            <c:set var="pageJs" value="main" scope="request" />

            <jsp:include page="../common/header.jsp" />

            <!-- Hero Section -->
            <section class="hero-section ${sessionScope.loginSess.role == 'ERRANDER' ? 'hero-rider' : 'hero-user'}">
                <div class="hero-content">
                    <div class="hero-text">
                        <c:choose>
                            <c:when test="${sessionScope.loginSess.role == 'ERRANDER'}">
                                <h1 class="hero-title">원하는 시간에<br>자유로운 수익</h1>
                                <p class="hero-subtitle">우리 동네 이웃을 도우며<br>VROOM과 함께 수익을 만들어보세요.</p>
                            </c:when>
                            <c:otherwise>
                                <h1 class="hero-title"><span id="hero-dynamic-text">가벼운</span><br>심부름을 찾고 계신가요?</h1>
                                <p class="hero-subtitle">동네 이웃과 함께하는 안전하고 따뜻한<br>심부름, VROOM에서 경험해보세요.</p>

                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        const keywords = ["배달", "장보기", "청소", "집안일", "벌레 퇴치", "설치", "조립", "동행", "돌봄", "줄서기", "예약", "서류", "비즈니스", "두쫀쿠"];
                                        const textElement = document.getElementById('hero-dynamic-text');

                                        if (textElement) {
                                            setInterval(() => {
                                                // Fade out
                                                textElement.style.transition = "opacity 0.3s ease";
                                                textElement.style.opacity = "0";

                                                setTimeout(() => {
                                                    // Change text
                                                    const randomIndex = Math.floor(Math.random() * keywords.length);
                                                    textElement.innerText = keywords[randomIndex];

                                                    // Fade in
                                                    textElement.style.opacity = "1";
                                                }, 300);
                                            }, 2000);
                                        }
                                    });
                                </script>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="hero-image">
                       <!--3d UI 렌더링?-->
                        <c:choose>
                            <c:when test="${sessionScope.loginSess.role == 'ERRANDER'}">
                                <canvas id="hero3d"></canvas>
                            </c:when>
                            <c:otherwise>
                                <canvas id="heroUser3d"></canvas>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>

            <!-- Action Menu -->
            <section class="action-menu">
                <div class="container">
                    <div class="menu-grid">
                        <c:forEach var="category" items="${errandsCategoryList}">
                            <a href="<c:url value='/errand/list'><c:param name='categoryId' value='${category.id}'/></c:url>"
                                class="menu-item" style="text-decoration: none;">
                                <div class="menu-icon">
                                    <img src="<c:url value='${category.defaultImageUrl}'/>" alt="${category.name}"
                                        style="width: 48px; height: 48px;">
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
                    <div class="location-selector-wrapper">
                        <div class="gu-chips">
                            <button type="button" class="gu-chip ${empty selectedGuName ? 'active' : ''}" data-gu="">전체</button>
                            <c:forEach var="gungu" items="${gunguList}">
                                <button type="button" class="gu-chip ${gungu == selectedGuName ? 'active' : ''}" data-gu="${gungu}">${gungu}</button>
                            </c:forEach>
                        </div>

                    </div>
                </div>
            </section>

            <!-- 진행 중인 부름 -->
            <section class="section">
                <div class="container">
                    <div class="section-header">
                        <h2 class="section-title">진행 중인 부름</h2>
                        <a id="errandMoreLink" href="<c:url value='/errand/list'><c:if test='${not empty selectedGuName}'><c:param name='guName' value='${selectedGuName}'/></c:if></c:url>"
                            class="more-link">더보기 →</a>
                    </div>
                    <div class="task-grid" id="taskGrid">
                        <c:forEach var="task" items="${errandListVO}">
                            <a href="<c:url value='/errand/detail'><c:param name='errandsId' value='${task.errandsId}'/></c:url>"
                                class="task-card" style="text-decoration: none; color: inherit;">
                                <img src="<c:url value='${task.imageUrl}'/>" alt="${task.title}" class="task-image">
                                <div class="task-info">
                                    <h3 class="task-title">${task.title}</h3>
                                    <div class="task-meta">
                                        <span class="task-price">
                                            <fmt:formatNumber value="${task.rewardAmount}" type="currency"
                                                currencySymbol="₩" />
                                        </span>
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
                        <a id="communityMoreLink" href="<c:url value='/community'><c:if test='${not empty selectedGuName}'><c:param name='guName' value='${selectedGuName}'/></c:if></c:url>"
                            class="more-link">더보기 →</a>
                    </div>

                    <div class="hot-posts">
                        <ul class="hot-post-list" id="hotPostList">
                            <c:forEach var="post" items="${popularPostListVO}" varStatus="status">
                                <a href="<c:url value='/community/detail/${post.postId}'/>" class="hot-post-item"
                                    style="text-decoration: none; color: inherit;">
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
                    <c:if test="${not empty reviewList}">
                    <div class="reviews-carousel">
                        <div class="reviews-container" id="reviewsContainer">
                            <c:forEach var="review" items="${reviewList}">
                                <div class="review-card">
                                    <div class="review-header">
                                        <div class="reviewer-info">
                                            <div class="reviewer-avatar">
                                                <c:choose>
                                                    <c:when test="${not empty review.profileImage}">
                                                        <img src="<c:url value='${review.profileImage}'/>" alt="프로필">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="<c:url value='/static/img/logo3.png'/>" alt="프로필">
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
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
                    </c:if>
                    <c:if test="${empty reviewList}">
                        <p style="text-align: center; color: #999; padding: 2rem 0;">등록된 리뷰가 없습니다.</p>
                    </c:if>
                </div>
            </section>

            <!-- 공지사항 -->
            <section class="notice-section">
                <div class="container">
                    <div class="notice-header" style="margin-bottom: 1.5rem;">
                        <span class="notice-icon">📢</span>
                        <h2 class="notice-title">공지사항</h2>
                    </div>
                    <div id="noticeListArea">
                        <p style="text-align: center; color: #999;">공지사항을 불러오는 중...</p>
                    </div>
                </div>
            </section>

            <script>
                window.mainFilterConfig = {
                    contextPath: '${pageContext.request.contextPath}',
                    selectedGuName: '${selectedGuName}'
                };

                // 알림 메시지 처리
                document.addEventListener('DOMContentLoaded', function () {
                    const message = '${message}';
                    if (message) {
                        alert(message);
                    }
                });

                // 공지사항 로드
                $(document).ready(function() {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/api/notice/published',
                        type: 'GET',
                        success: function(list) {
                            var area = document.getElementById('noticeListArea');
                            if (!list || list.length === 0) {
                                area.innerHTML = '<p style="text-align: center; color: #999;">등록된 공지사항이 없습니다.</p>';
                                return;
                            }
                            var html = '';
                            list.forEach(function(item, idx) {
                                var isImportant = (item.isImportant == 1);
                                var badge = isImportant ? '<span style="display:inline-block; background:#E3F2FD; color:#2196F3; padding:0.25rem 0.6rem; border-radius:12px; font-size:0.75rem; font-weight:600; margin-right:0.5rem;">중요</span>' : '';
                                var startDate = item.startAt ? new Date(item.startAt).toISOString().substring(0, 10) : '';
                                var content = item.content || '';
                                html += '<div class="notice-card" style="margin-bottom: 1rem; cursor: pointer;" onclick="this.querySelector(\'.notice-detail\').style.display = this.querySelector(\'.notice-detail\').style.display === \'none\' ? \'block\' : \'none\';">';
                                html += '  <div style="display: flex; justify-content: space-between; align-items: center;">';
                                html += '    <div style="font-weight: 600; font-size: 1rem;">' + badge + item.title + '</div>';
                                html += '    <span style="color: #999; font-size: 0.85rem;">' + startDate + '</span>';
                                html += '  </div>';
                                html += '  <div class="notice-detail" style="display: ' + (idx === 0 ? 'block' : 'none') + '; margin-top: 1rem; padding-top: 1rem; border-top: 1px dashed #eee;">';
                                html += '    <div style="line-height: 1.8; white-space: pre-line;">' + content + '</div>';
                                html += '  </div>';
                                html += '</div>';
                            });
                            area.innerHTML = html;
                        },
                        error: function() {
                            document.getElementById('noticeListArea').innerHTML = '<p style="text-align: center; color: #999;">공지사항을 불러올 수 없습니다.</p>';
                        }
                    });
                });
            </script>
            <script src="<c:url value='/static/main/js/mainFilter.js'/>"></script>

            <script>
            (function() {
                var container = document.getElementById('reviewsContainer');
                if (!container || container.children.length === 0) return;

                // 원본 카드 복제
                var cards = Array.from(container.children);
                cards.forEach(function(card) {
                    container.appendChild(card.cloneNode(true));
                });

                var speed = 0.5; // px per frame
                var pos = 0;
                var halfWidth = 0;
                var paused = false;

                function getHalfWidth() {
                    var gap = parseFloat(getComputedStyle(container).gap) || 24;
                    halfWidth = cards.length * (cards[0].offsetWidth + gap);
                }

                getHalfWidth();
                window.addEventListener('resize', getHalfWidth);

                container.parentElement.addEventListener('mouseenter', function() { paused = true; });
                container.parentElement.addEventListener('mouseleave', function() { paused = false; });

                function scroll() {
                    if (!paused) {
                        pos -= speed;
                        if (Math.abs(pos) >= halfWidth) {
                            pos = 0;
                        }
                        container.style.transform = 'translateX(' + pos + 'px)';
                    }
                    requestAnimationFrame(scroll);
                }
                requestAnimationFrame(scroll);
            })();
            </script>

            <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
            <c:choose>
                <c:when test="${sessionScope.loginSess.role == 'ERRANDER'}">
                    <script src="<c:url value='/static/main/js/hero3d.js'/>"></script>
                </c:when>
                <c:otherwise>
                    <script src="<c:url value='/static/main/js/heroUser3d.js'/>"></script>
                </c:otherwise>
            </c:choose>

            <jsp:include page="../common/footer.jsp" />