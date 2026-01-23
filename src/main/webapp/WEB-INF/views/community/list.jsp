<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="VROOM - 동네생활" scope="request" />
<c:set var="pageId" value="community" scope="request" />

<jsp:include page="../common/header.jsp" />

<!-- Filter Section -->
<section class="filter-section">
    <div class="filter-container">
        <div class="location-selectors">
            <select id="guSelect" class="location-select" onchange="updateDongOptions()">
                <option value="">구 선택</option>
                <c:forEach var="gungu" items="${gunguList}">
                    <option value="${gungu}">${gungu}</option>
                </c:forEach>
            </select>

            <select id="dongSelect" class="location-select" onchange="updatePageTitle()">
                <option value="">동 선택</option>
            </select>
        </div>
    </div>
</section>

<!-- Main Content -->
<main class="main-content">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<c:url value='/main'/>">홈</a>
        <span class="breadcrumb-separator">></span>
        <span>동네생활</span>
    </nav>

    <!-- Page Title -->
    <h2 class="page-title" id="pageTitle">
        서울특별시 동네생활
    </h2>

    <!-- Content Grid -->
    <div class="content-grid">
        <!-- Category Sidebar -->
        <aside class="category-sidebar">
            <div class="sidebar-section">
                <ul class="category-list">
                    <!-- 전체 카테고리 -->
                    <li class="category-item active">전체</li>

                    <!-- DB에서 가져온 카테고리 목록 -->
                    <c:forEach var="category" items="${categoryList}">
                        <li class="category-item">
                                ${category.categoryName}
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
                        <article class="post-card">
                            <div class="post-content-wrapper">
                                <div class="post-text-content">
                                    <h3 class="post-title">${post.title}</h3>
                                    <p class="post-description">${post.content}</p>

                                    <div class="post-meta">
                                        <span class="post-meta-item">${post.dong_name}</span>
                                        <span class="post-meta-item">•</span>
                                        <span class="post-category-badge">${post.category_name}</span>
                                        <span class="post-meta-item">•</span>
                                        <span class="post-meta-item">
                                            <fmt:formatDate value="${post.created_at}" pattern="MM.dd"/>
                                        </span>
                                    </div>

                                    <div class="post-stats">
                                        <span class="post-stat">👍 ${post.like_count}</span>
                                        <span class="post-stat">👁 ${post.view_count}</span>
                                    </div>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-data">게시글이 없습니다.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="../common/footer.jsp" />