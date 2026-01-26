<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="pageTitle" value="심부름 목록 - VROOM" scope="request"/>
<c:set var="pageCss" value="errand-list" scope="request"/>
<c:set var="pageCssDir" value="errand" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<!-- Page Header -->
<section class="page-header">
    <div class="container">
        <h1 class="page-title">우리 동네 심부름 목록</h1>
        <p class="page-subtitle">이웃과 함께하는 따뜻한 심부름을 찾아보세요</p>
    </div>
</section>

<!-- Write Button Section -->
<section class="write-section">
    <div class="container">
        <div class="write-btn-wrapper">
            <a href="<c:url value='/errand/create' />" class="write-btn">
                ✏ 글쓰기
            </a>
        </div>
    </div>
</section>

<!-- Main Section -->
<section class="main-section">
    <div class="container">
        <!-- Filter Bar -->
        <form id="filterForm"
              class="filter-bar"
              method="get"
              action="${pageContext.request.contextPath}/errand/list">

            <div class="filter-group">
                <span class="filter-label">카테고리</span>
                <select class="filter-select" id="categoryFilter" name="categoryId">
                    <option value="" ${empty param.categoryId ? 'selected' : ''}>전체</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}" ${param.categoryId == c.id ? 'selected' : ''}>
                            <c:out value="${c.name}" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group">
                <span class="filter-label">정렬</span>
                <select class="filter-select" id="sortFilter" name="sort">
                    <option value="latest" ${empty param.sort || param.sort == 'latest' ? 'selected' : ''}>최신순</option>
                    <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>높은 가격순</option>
                    <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>낮은 가격순</option>
                    <option value="desired_at" ${param.sort == 'desired_at' ? 'selected' : ''}>희망일 빠른순</option>
                </select>
            </div>

            <div class="filter-group">
                <span class="filter-label">동네</span>
                <select class="filter-select" id="neighborhoodFilter" name="dongCode">
                    <option value="" ${empty param.dongCode ? 'selected' : ''}>전체</option>
                    <c:if test="${not empty dongs}">
                        <c:forEach var="d" items="${dongs}">
                            <option value="${d.dongCode}" ${param.dongCode == d.dongCode ? 'selected' : ''}>
                                <c:out value="${d.dongFullName}" />
                            </option>
                        </c:forEach>
                    </c:if>
                </select>
            </div>

            <div class="filter-group">
                <span class="filter-label">검색</span>
                <input type="text" id="searchInput" name="q" placeholder="심부름 검색" value="${param.q}">
                <button id="searchButton" type="submit">검색</button>
            </div>

            <div class="results-info">
                총 <span class="results-count">${totalCount}</span>개의 심부름
            </div>
        </form>

        <!-- Tasks Grid -->
        <div class="tasks-grid">
            <c:forEach var="e" items="${errands}">
                <a class="task-card"
                   href="${pageContext.request.contextPath}/errand/detail?errandsId=${e.errandsId}">

                    <div class="task-image">
                        <img
                            src="${pageContext.request.contextPath}${e.displayImageUrl}"
                            class="${fn:contains(e.displayImageUrl, '/static/img/category/') ? 'img-contain' : 'img-cover'}"
                            alt="심부름 이미지">
                    </div>

                    <div class="task-card-content">
                        <div class="task-card-header">
                            <span class="task-badge">
                                <c:out value="${empty e.categoryName ? '심부름' : e.categoryName}" />
                            </span>
                            <span class="task-time">
                                <c:out value="${empty e.createdAt ? '' : e.createdAt}" />
                            </span>
                        </div>

                        <div class="task-card-title">
                            <c:out value="${e.title}" />
                        </div>

                        <div class="task-author-info">
                            <div class="author-avatar">U</div>
                            <div class="author-name">
                                <c:out value="${empty e.writerNickname ? e.userId : e.writerNickname}" />
                            </div>
                        </div>

                        <div class="task-meta">
                            <div class="task-location">
                                <c:out value="${empty e.dongFullName ? e.dongName : e.dongFullName}" />
                            </div>
                            <div class="task-price">
                                <fmt:formatNumber value="${e.rewardAmount}" type="number" />원
                            </div>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>

        <!-- Pagination -->
        <div class="pagination" id="pagination">
            <!-- Pagination will be generated by JavaScript if needed -->
        </div>
    </div>
</section>

<jsp:include page="../common/footer.jsp"/>

<script src="<c:url value='/static/errand/js/errand-list.js'/>"></script>
</body>
</html>