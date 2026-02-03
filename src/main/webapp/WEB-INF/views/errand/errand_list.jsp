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

        <!-- Write Button -->
        <div class="write-btn-wrapper">
            <a href="#" class="write-btn" id="writeBtn"
               data-is-logged-in="${not empty sessionScope.loginSess}"
               data-user-role="${sessionScope.loginSess.role}"
               data-login-url="${pageContext.request.contextPath}/auth/login"
               data-create-url="${pageContext.request.contextPath}/errand/create">
                <img src="${pageContext.request.contextPath}/static/img/common/write-btn.png" alt="글쓰기">
            </a>
        </div>

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
			  <c:if test="${totalPages > 1}">
				  <div class="pagination">
				    <c:set var="baseUrl" value="${pageContext.request.contextPath}/errand/list" />

				    <!-- 현재 페이지 방어 -->
				    <c:set var="currentPage" value="${page}" />
				    <c:if test="${currentPage < 1}">
				      <c:set var="currentPage" value="1" />
				    </c:if>
				    <c:if test="${currentPage > totalPages}">
				      <c:set var="currentPage" value="${totalPages}" />
				    </c:if>

				    <!-- 표시 범위: 현재 기준 -2 ~ +2 -->
				    <c:set var="startPage" value="${currentPage - 2}" />
				    <c:set var="endPage" value="${currentPage + 2}" />

				    <c:if test="${startPage < 1}">
				      <c:set var="startPage" value="1" />
				    </c:if>
				    <c:if test="${endPage > totalPages}">
				      <c:set var="endPage" value="${totalPages}" />
				    </c:if>

				    <!-- 이전 버튼 -->
				    <c:choose>
				      <c:when test="${currentPage == 1}">
				        <button class="pagination-btn" disabled>이전</button>
				      </c:when>
				      <c:otherwise>
				        <a class="pagination-btn"
				           href="${baseUrl}?page=${currentPage-1}&q=${q}&categoryId=${categoryId}&dongCode=${dongCode}&sort=${sort}">
				          이전
				        </a>
				      </c:otherwise>
				    </c:choose>

				    <!-- 1 페이지는 항상 보여주기 + 앞쪽 ... -->
				    <c:if test="${startPage > 1}">
				      <a class="pagination-number"
				         href="${baseUrl}?page=1&q=${q}&categoryId=${categoryId}&dongCode=${dongCode}&sort=${sort}">
				        1
				      </a>

				      <c:if test="${startPage > 2}">
				        <span class="pagination-ellipsis">…</span>
				      </c:if>
				    </c:if>

				    <!-- 가운데 범위 페이지들 -->
				    <c:forEach var="p" begin="${startPage}" end="${endPage}">
				      <c:choose>
				        <c:when test="${p == currentPage}">
				          <span class="pagination-number active">${p}</span>
				        </c:when>
				        <c:otherwise>
				          <a class="pagination-number"
				             href="${baseUrl}?page=${p}&q=${q}&categoryId=${categoryId}&dongCode=${dongCode}&sort=${sort}">
				            ${p}
				          </a>
				        </c:otherwise>
				      </c:choose>
				    </c:forEach>

				    <!-- 뒤쪽 ... + 마지막 페이지 -->
				    <c:if test="${endPage < totalPages}">
				      <c:if test="${endPage < totalPages - 1}">
				        <span class="pagination-ellipsis">…</span>
				      </c:if>

				      <a class="pagination-number"
				         href="${baseUrl}?page=${totalPages}&q=${q}&categoryId=${categoryId}&dongCode=${dongCode}&sort=${sort}">
				        ${totalPages}
				      </a>
				    </c:if>

				    <!-- 다음 버튼 -->
				    <c:choose>
				      <c:when test="${currentPage == totalPages}">
				        <button class="pagination-btn" disabled>다음</button>
				      </c:when>
				      <c:otherwise>
				        <a class="pagination-btn"
				           href="${baseUrl}?page=${currentPage+1}&q=${q}&categoryId=${categoryId}&dongCode=${dongCode}&sort=${sort}">
				          다음
				        </a>
				      </c:otherwise>
				    </c:choose>

				  </div>
				</c:if>
        </div>
    </div>
</section>

<jsp:include page="../common/footer.jsp"/>

<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="<c:url value='/static/errand/js/errand-list.js'/>"></script>
</body>
</html>