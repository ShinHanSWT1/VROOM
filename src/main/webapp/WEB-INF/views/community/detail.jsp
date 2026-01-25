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
        <a href="<c:url value='/vroom'/>">홈</a>
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
                    <li class="category-item ${selectedCategoryId == null ? 'active' : ''}">
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
                    <li class="category-item ${selectedCategoryId != null and selectedCategoryId == 0 ? 'active' : ''}">
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
                <div class="post-header-top">
                    <span class="post-category-badge">${postDetail.categoryName}</span>
                    <c:if test="${not empty loginUser and loginUser.userId == postDetail.userId}">
                        <div class="post-manage-btns">
                            <a href="<c:url value='/community/edit/${postDetail.postId}'/>" class="post-edit-btn">수정</a>
                            <form action="<c:url value='/community/delete/${postDetail.postId}'/>" method="post" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                                <button type="submit" class="post-delete-btn">삭제</button>
                            </form>
                        </div>
                    </c:if>
                </div>

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

            <!-- Post Images -->
            <c:if test="${not empty postDetail.images}">
                <div class="post-images">
                    <c:forEach var="image" items="${postDetail.images}">
                        <div class="post-image-item">
                            <img src="${pageContext.request.contextPath}${image.imageUrl}" alt="게시글 이미지">
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Post Actions -->
            <div class="post-actions">
                <div class="actions-left">
                    <button class="action-btn ${isLiked ? 'active' : ''}" id="likeBtn">
                        <span id="likeIcon">${isLiked ? '❤️' : '👍'}</span>
                        <span id="likeCount">${postDetail.likeCount}</span>
                    </button>
                    <button class="action-btn" onclick="focusCommentForm()">
                        <span>💬</span>
                        <span id="comment-count">${totalComments}</span>
                    </button>
                </div>
                <span class="views-count">조회 ${postDetail.viewCount}</span>
            </div>

            <!-- Comments Section -->
            <div class="comments-section">
                <!-- Main Comment Form -->
                <div class="comment-form-container" id="mainCommentForm">
                    <textarea class="comment-input" placeholder="칭찬과 격려의 댓글은 작성자에게 큰 힘이 됩니다."></textarea>
                    <button class="comment-submit-btn" onclick="submitComment(this)">등록</button>
                </div>

<%--                <div class="comment-separator"></div>--%>

                <!-- Comment List -->
                <div class="comment-list" id="commentList">
                    <c:forEach var="comment" items="${commentList}">
                        <div class="comment-item-wrapper ${comment.depth > 0 ? 'reply' : ''}" data-comment-id="${comment.commentId}" data-group-id="${comment.groupId}" data-depth="${comment.depth}" style="${comment.depth > 0 ? 'margin-left: '.concat(comment.depth * 30).concat('px;') : ''}">
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
                                        <button class="action-btn" onclick="showReplyForm(this, ${comment.commentId}, ${comment.groupId})">답글</button>
                                        <c:if test="${not empty loginUser and loginUser.userId == comment.userId}">
                                            <button class="action-btn edit-btn" onclick="editComment(this, ${comment.commentId})">수정</button>
                                            <button class="action-btn delete-btn" onclick="deleteComment(${comment.commentId})">삭제</button>
                                        </c:if>
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
                    <a href="<c:url value='/community?guName=${postDetail.gunguName}&dongCode=${postDetail.dongCode}&
                        categoryId=0'/>" class="more-link">더보기 →</a>
                </div>
                <div class="related-posts-list">
                    <c:choose>
                        <c:when test="${empty nearbyPopularPosts}">
                            <div class="no-related-posts">근처 동네 인기글이 없습니다.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="relatedPost" items="${nearbyPopularPosts}">
                                <a class="related-post-item" href="<c:url value='/community/detail/${relatedPost.postId}'/>" style="text-decoration: none; color: inherit;">
                                    <div class="related-post-title">${relatedPost.title}</div>
                                    <div class="related-post-meta">
                                        <span>${relatedPost.dongName}</span>
                                        <span>•</span>
                                        <span>${relatedPost.categoryName}</span>
                                        <span>•</span>
                                        <span><fmt:formatDate value="${relatedPost.createdAt}" pattern="MM월 dd일"/></span>
                                        <div class="related-post-stats">
                                            <span>👍 ${relatedPost.likeCount}</span>
                                            <span>💬 ${relatedPost.commentCount}</span>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    window.communityConfig = {
        contextPath: '${pageContext.request.contextPath}',
        postId: ${postDetail.postId},
        isUserLoggedIn: ${not empty loginUser},
        isLiked: ${isLiked}
    };
    window.communityFilterConfig = {
        contextPath: '${pageContext.request.contextPath}',
        currentDongCode: '${selectedDongCode}',
        selectedGuName: '${selectedGuName}',
        currentCategoryId: '${selectedCategoryId}'
    };
</script>
<script src="<c:url value='/static/community/js/communityLike.js'/>"></script>
<script src="<c:url value='/static/community/js/communityFilter.js'/>"></script>
<script src="<c:url value='/static/community/js/communityComment.js'/>"></script>

<jsp:include page="../common/footer.jsp"/>