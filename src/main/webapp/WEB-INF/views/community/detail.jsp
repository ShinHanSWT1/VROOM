<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageCss" value="community-detail" scope="request"/>
<c:set var="pageJs" value="communityComment"/>
<c:set var="pageTitle" value="VROOM - 동네생활" scope="request"/>
<c:set var="pageId" value="community" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<!-- Filter Section -->
<section class="filter-section">
    <div class="filter-container">
        <div class="location-selectors">
            <select id="guSelect" class="location-select">
                <option value="">구 선택</option>
                <c:forEach var="gungu" items="${gunguList}">
                    <option value="${gungu}" ${gungu == selectedGuName ? 'selected' : ''}>${gungu}</option>
                </c:forEach>
            </select>

            <select id="dongSelect" class="location-select">
                <option value="">동 선택</option>
            </select>
        </div>
        <%-- 검색박스--%>
        <form id="searchForm" class="search-wrapper" onsubmit="return false;">
            <input type="text"
                   id="searchInput"
                   class="search-input"
                   placeholder="검색어를 입력하세요"
                   value="${searchKeyword}">
            <button type="submit" class="search-btn">
                <span>검색</span>
            </button>
        </form>
    </div>
</section>



<!-- Main Content -->
<main class="main-content">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<c:url value='/main'/>">홈</a>
        <span class="breadcrumb-separator"> > </span>
        <a href="<c:url value='/community'/>">동네생활</a>
    </nav>

    <!-- Page Title -->
    <h2 class="page-title" id="pageTitle"
        data-gu="${selectedGuName}"
        data-dong-code="${selectedDongCode}">
        서울특별시 ${not empty selectedGuName ? selectedGuName : ''} 동네생활
    </h2>
    <!-- Content Grid -->
    <div class="content-grid">
        <!-- Category Sidebar -->
        <aside class="category-sidebar">
            <div class="sidebar-section">
                <ul class="category-list">
                    <!-- 전체 카테고리 -->
                    <li class="category-item ${empty selectedCategoryId ? 'active' : ''}">
                        <a href="<c:url value='/community'>
                            <c:if test='${not empty selectedGuName}'>
                                <c:param name='guName' value='${selectedGuName}'/>
                            </c:if>
                            <c:if test = '${not empty selectedDongCode}'>
                                <c:param name="dongCode" value="${selectedDongCode}"/>
                            </c:if>
                        </c:url>">전체</a>
                    </li>
                    <!-- 인기글 카테고리 추가 -->
                    <li class="category-item ${selectedCategoryId == 0 ? 'active' : ''}">
                        <a href="<c:url value='/community'>
                            <c:param name='categoryId' value='0'/>
                            <c:if test='${not empty selectedDongCode}'>
                                <c:param name='dongCode' value='${selectedDongCode}'/>
                            </c:if>
                            <c:if test='${not empty selectedGuName}'>
                                 <c:param name='guName' value='${selectedGuName}'/>
                            </c:if>
                        </c:url>">인기글 🔥</a>
                    </li>
                    <!-- DB에서 가져온 카테고리 목록 -->
                    <c:forEach var="category" items="${categoryList}">
                        <li class="category-item ${selectedCategoryId == category.categoryId ? 'active' : ''}">
                            <a href="<c:url value='/community'>
                                <c:param name='categoryId' value='${category.categoryId}'/>
                                <c:if test='${not empty selectedDongCode}'>
                                    <c:param name='dongCode' value='${selectedDongCode}'/>
                                </c:if>
                                <c:if test='${not empty selectedGuName}'>
                                    <c:param name='guName' value='${selectedGuName}'/>
                                </c:if>
                            </c:url>">${category.categoryName}</a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </aside>


        <!-- Post Detail -->
        <div class="post-detail-container">
            <!-- Post Header -->
            <div class="post-header">
                <span class="post-category-badge">${postDetail.categoryName}</span>

                <div class="post-author-section">
                    <div class="author-avatar">${postDetail.nickname.substring(0, 1)}</div>
                    <div class="author-info">
                        <div>
                            <span class="author-name">${postDetail.nickname}</span>
                        </div>
                        <div class="author-meta">
                            <span>${postDetail.dongName}</span>
                            <span>•</span>
                            <span><fmt:formatDate value="${postDetail.createdAt}" pattern="MM월 dd일 HH:mm"/></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Post Title -->
            <h1 class="post-title">${postDetail.title}</h1>

            <!-- Post Content -->
            <div class="post-content">
                ${postDetail.content}
            </div>

            <!-- Post Actions -->
            <div class="post-actions">
                <div class="actions-left">
                    <button class="action-btn" onclick="toggleLike(this)">
                        <span>👍</span>
                        <span class="like-count">${postDetail.likeCount}</span>
                    </button>
                    <button class="action-btn" onclick="focusCommentForm()">
                        <span>💬</span>
                        <span>댓글</span>
                    </button>
                </div>
                <div class="views-count">조회 ${postDetail.viewCount}</div>
            </div>

            <!-- Comments Section -->
            <div class="comments-section">
                <div class="comments-header">
                    <h3>댓글 ${totalComments}개</h3>
                    <div class="comment-sort-tabs">
                        <button class="sort-btn active" data-sort="latest">최신순</button>
                        <button class="sort-btn" data-sort="oldest">등록순</button>
                    </div>
                </div>

                <!-- Main Comment Form -->
                <div class="comment-form-container" id="mainCommentForm">
                    <div class="comment-avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.profileUrl}">
                                <img src="${sessionScope.user.profileUrl}" alt="profile">
                            </c:when>
                            <c:otherwise>
                                ${sessionScope.user.nickname.substring(0, 1)}
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="comment-input-wrapper">
                        <textarea class="comment-input" placeholder="칭찬과 격려의 댓글은 작성자에게 큰 힘이 됩니다."></textarea>
                        <button class="comment-submit-btn" onclick="submitComment(this)">등록</button>
                    </div>
                </div>

                <!-- Comment List -->
                <div class="comment-list" id="commentList">
                    <c:forEach var="comment" items="${commentList}">
                        <div class="comment-item-wrapper ${comment.depth > 0 ? 'reply' : ''}" data-comment-id="${comment.commentId}" data-group-id="${comment.groupId}">
                            <div class="comment-item">
                                <div class="comment-avatar">
                                    <c:choose>
                                        <c:when test="${not empty comment.profileUrl}">
                                            <img src="${comment.profileUrl}" alt="profile">
                                        </c:when>
                                        <c:otherwise>
                                            ${comment.nickname.substring(0, 1)}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="comment-body">
                                    <div class="comment-author">
                                        <span>${comment.nickname}</span>
                                        <span class="time-ago"> • <fmt:formatDate value="${comment.createdAt}" pattern="M월 d일"/></span>
                                    </div>
                                    <div class="comment-content">${comment.content}</div>
                                    <div class="comment-actions">
                                        <button class="action-btn">👍 <span>${comment.likeCount}</span></button>
                                        <button class="action-btn" onclick="showReplyForm(this, ${comment.commentId}, ${comment.groupId})">답글</button>
                                    </div>
                                </div>
                            </div>
                            <!-- Reply form placeholder -->
                            <div class="reply-form-container" style="display: none;"></div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Related Posts Section -->
            <div class="related-posts-section">
                <div class="related-posts-header">
                    <h3 class="related-posts-title">${postDetail.dongName} 근처 동네생활 인기글</h3>
                    <a href="<c:url value='/community'/>" class="more-link">더보기 →</a>
                </div>
                <div class="related-posts-list">
                    <c:forEach var="relatedPost" items="${relatedPostList}">
                        <div class="related-post-item" onclick="goToPost('${relatedPost.postNo}')">
                            <div class="related-post-title">${relatedPost.title}</div>
                            <div class="related-post-meta">
                                <span>${relatedPost.dong}</span>
                                <span>•</span>
                                <span>${relatedPost.category}</span>
                                <span>•</span>
                                <span><fmt:formatDate value="${relatedPost.regDate}" pattern="MM월 dd일"/></span>
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

<script>
    window.communityConfig = {
        contextPath: '${pageContext.request.contextPath}',
        postId: ${postDetail.postId},
        isUserLoggedIn: ${not empty sessionScope.user}
    };
</script>
<script src="<c:url value='/static/community/js/communityFilter.js'/>"></script>
<script src="<c:url value='/static/community/js/communityComment.js'/>"></script>

<jsp:include page="../common/footer.jsp"/>