<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="VROOM - 동네생활" scope="request"/>
<c:set var="pageId" value="community" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<!-- Filter Section -->
<section class="filter-section">
    <div class="filter-container">
        <div class="location-selectors">
            <select id="guSelect" class="location-select" >
                <option value="">구 선택</option>
                <c:forEach var="gungu" items="${gunguList}">
                    <option value="${gungu}" ${gungu == selectedGuName ? 'selected' : ''}>${gungu}</option>
                </c:forEach>
            </select>

            <select id="dongSelect" class="location-select" >
                <option value="">동 선택</option>
            </select>
        </div>
        <%-- 검색박스--%>
        <form id ="searchForm" class="search-wrapper" onsubmit="return false;">
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
        data-dong-code="$selectedDongCode}">
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
                            <c:if test='${not empty selectedDongCode}'>
                                <c:param name='dongCode' value='${selectedDongCode}'/>
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

        <!-- Post List -->
        <div class="post-list">
            <c:choose>
                <c:when test="${not empty postList}">
                    <c:forEach var="post" items="${postList}">
                        <a class="post-card" href="<c:url value='/community/detail/${post.postId}'/>" style="text-decoration: none; color: inherit;">
                            <div class="post-content-wrapper">
                                <div class="post-text-content">
                                    <h3 class="post-title">${post.title}</h3>
                                    <p class="post-description">${post.content}</p>

                                    <div class="post-meta">
                                        <span class="post-meta-item">${post.dongName}</span>
                                        <span class="post-meta-item">•</span>
                                        <span class="post-category-badge">${post.categoryName}</span>
                                        <span class="post-meta-item">•</span>
                                        <span class="post-meta-item">
                                            <fmt:formatDate value="${post.createdAt}" pattern="MM.dd"/>
                                        </span>
                                    </div>

                                    <div class="post-stats">
                                        <span class="post-stat">👍 ${post.likeCount}</span>
                                        <span class="post-stat">👁 ${post.viewCount}</span>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-data">게시글이 없습니다.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<script>
    window.communityFilterConfig = {
        contextPath: '${pageContext.request.contextPath}',
        currentDongCode: '${selectedDongCode}',
        selectedGuName: '${selectedGuName}',
        currentCategoryId: '${selectedCategoryId}',
        currentSearchKeyword: '${searchKeyword}'
    };
</script>
<script src="<c:url value='/static/community/js/communityFilter.js'/>"></script>

<jsp:include page="../common/footer.jsp"/>