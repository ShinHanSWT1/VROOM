<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="VROOM - 동네생활 글쓰기" scope="request"/>
<c:set var="pageId" value="community" scope="request"/>
<c:set var="pageCss" value="community-write" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<!-- Main Content -->
<main class="main-content">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<c:url value='/vroom'/>">홈</a>
        <span class="breadcrumb-separator"> > </span>
        <a href="<c:url value='/community'/>">동네생활</a>
        <span class="breadcrumb-separator"> > </span>
        <span>글쓰기</span>
    </nav>

    <!-- Page Header -->
    <div class="page-header">
        <h2 class="page-title">동네생활 글쓰기</h2>
    </div>

    <!-- Write Form Container -->
    <div class="write-container">
        <form id="writeForm" method="post" action="<c:url value='/community/write'/>">
            <!-- Category Selection -->
            <div class="form-section">
                <label class="form-label">
                    <span class="label-text">카테고리</span>
                    <span class="label-required">*</span>
                </label>
                <div class="category-select-wrapper">
                    <c:forEach var="category" items="${categoryList}">
                        <label class="category-option">
                            <input type="radio" name="categoryId" value="${category.categoryId}" required>
                            <span class="category-option-text">${category.categoryName}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <!-- Location Selection -->
            <div class="form-section">
                <label class="form-label">
                    <span class="label-text">지역</span>
                    <span class="label-required">*</span>
                </label>
                <div class="location-select-wrapper">
                    <select id="formGuSelect" name="guName" class="form-location-select" required>
                        <option value="">구 선택</option>
                        <c:forEach var="gungu" items="${gunguList}">
                            <option value="${gungu}">${gungu}</option>
                        </c:forEach>
                    </select>
                    <select id="formDongSelect" name="dongCode" class="form-location-select" required>
                        <option value="">동 선택</option>
                    </select>
                </div>
            </div>

            <!-- Title Input -->
            <div class="form-section">
                <label class="form-label">
                    <span class="label-text">제목</span>
                    <span class="label-required">*</span>
                </label>
                <input 
                    type="text" 
                    name="title" 
                    class="form-input" 
                    placeholder="제목을 입력하세요"
                    maxlength="255"
                    required>
                <div class="char-counter">
                    <span class="current-length">0</span> / 255
                </div>
            </div>

            <!-- Content Textarea -->
            <div class="form-section">
                <label class="form-label">
                    <span class="label-text">내용</span>
                    <span class="label-required">*</span>
                </label>
                <textarea 
                    name="content" 
                    class="form-textarea" 
                    placeholder="동네 이웃들과 나누고 싶은 이야기를 자유롭게 작성해주세요.&#10;&#10;• 서로 존중하고 배려하는 마음으로 작성해주세요&#10;• 광고, 욕설, 비방 등은 삼가주세요"
                    required></textarea>
                <div class="char-counter">
                    <span class="current-length">0</span> 자
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="form-actions">
                <button type="button" class="btn-cancel" onclick="location.href='<c:url value='/community'/>'">
                    취소
                </button>
                <button type="submit" class="btn-submit">
                    <span>등록하기</span>
                </button>
            </div>
        </form>
    </div>
</main>

<script>
    window.communityWriteConfig = {
        contextPath: '${pageContext.request.contextPath}'
    };
</script>
<script src="<c:url value='/static/community/js/communityWrite.js'/>"></script>

<jsp:include page="../common/footer.jsp"/>
