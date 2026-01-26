<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="VROOM - 동네생활 ${empty postDetail ? '글쓰기' : '글수정'}" scope="request"/>
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
        <h2 class="page-title">동네생활 ${empty postDetail ? '글쓰기' : '글수정'}</h2>
    </div>

    <!-- Write Form Container -->
    <div class="write-container">
        <form id="writeForm" method="post" enctype="multipart/form-data" action="<c:url value='/community/${empty postDetail ? "write" : "edit/".concat(postDetail.postId)}'/>">
            <!-- Category Selection -->
            <div class="form-section">
                <label class="form-label">
                    <span class="label-text">카테고리</span>
                    <span class="label-required">*</span>
                </label>
                <div class="category-select-wrapper">
                    <c:forEach var="category" items="${categoryList}">
                        <label class="category-option">
                            <input type="radio" name="categoryId" value="${category.categoryId}" ${postDetail.categoryId == category.categoryId ? 'checked' : ''} required>
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
                    value="${postDetail.title}"
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
                    required>${postDetail.content}</textarea>
                <div class="char-counter">
                    <span class="current-length">0</span> 자
                </div>
            </div>

            <!-- Image Upload -->
            <div class="form-section">
                <label class="form-label">
                    <span class="label-text">사진</span>
                    <span class="label-optional">(최대 3장)</span>
                </label>

                <!-- 기존 이미지 표시 (수정 모드) -->
                <c:if test="${not empty postDetail.images}">
                    <div class="existing-images" id="existingImages">
                        <c:forEach var="image" items="${postDetail.images}">
                            <div class="image-preview-item" data-image-id="${image.imageId}">
                                <img src="${pageContext.request.contextPath}${image.imageUrl}" alt="기존 이미지">
                                <button type="button" class="image-remove-btn" onclick="removeExistingImage(${image.imageId}, this)">X</button>
                                <input type="hidden" name="keepImageIds" value="${image.imageId}">
                            </div>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- 새 이미지 업로드 -->
                <div class="image-upload-wrapper">
                    <div class="image-preview-container" id="imagePreviewContainer"></div>
                    <label class="image-upload-btn" id="imageUploadBtn">
                        <input type="file" name="imageFiles" id="imageInput" accept="image/*" multiple hidden>
                        <span>+ 사진 추가</span>
                    </label>
                </div>
                <p class="image-help-text">JPG, PNG 파일 (최대 10MB)</p>
            </div>

            <!-- Action Buttons -->
            <div class="form-actions">
                <button type="button" class="btn-cancel" onclick="location.href='<c:url value='/community'/>'">
                    취소
                </button>
                <button type="submit" class="btn-submit">
                    <span>${empty postDetail ? '등록하기' : '수정하기'}</span>
                </button>
            </div>
        </form>
    </div>
</main>

<script>
    window.communityWriteConfig = {
        contextPath: '${pageContext.request.contextPath}',
        isEditMode: ${not empty postDetail},
        postDetail: {
            dongCode: '${postDetail.dongCode}',
            gunguName: '${postDetail.gunguName}'
        }
    };
</script>
<script src="<c:url value='/static/community/js/communityWrite.js'/>"></script>

<jsp:include page="../common/footer.jsp"/>
