<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="심부름 등록 - VROOM" scope="request"/>
<c:set var="pageCss" value="errand-create" scope="request"/>
<c:set var="pageCssDir" value="errand" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<section class="main-section">
    <div class="container">
        <div class="form-container">
            <div class="form-header">
                <h1 class="form-title">심부름 등록</h1>
            </div>

            <form class="form-content" id="errandForm" method="post" action="${pageContext.request.contextPath}/errand/create" enctype="multipart/form-data">
                <!-- 카테고리/이미지 등 화면 선택값을 서버로 보내는 hidden들 -->
                <input type="hidden" id="categoryId" name="categoryId" value="">
                <input type="hidden" name="dongFullName" id="dongFullName">

                <!-- Left Column -->
                <div class="form-left">
                    <div class="form-group">
                        <label class="form-label form-label-required">심부름 제목</label>
                        <input type="text" class="form-input" name="title" id="title" placeholder="제목을 입력하세요" maxlength="50" required>
                        <small id="titleCounter">0 / 50</small>
                    </div>

                    <div class="form-group">
                        <label class="form-label form-label-required">카테고리</label>
                        <div class="category-toggle" id="categoryToggle">
                            <div class="category-option" data-category="1">배달/장보기</div>
                            <div class="category-option" data-category="2">청소/집안일</div>
                            <div class="category-option" data-category="3">벌레퇴치</div>
                            <div class="category-option" data-category="4">설치/조립</div>
                            <div class="category-option" data-category="5">동행/돌봄</div>
                            <div class="category-option" data-category="6">줄서기/예약</div>
                            <div class="category-option" data-category="7">서류/비즈니스</div>
                            <div class="category-option" data-category="8">기타</div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label form-label-required">심부름값</label>
                        <input type="number" class="form-input" name="rewardAmount" placeholder="가격을 입력하세요 (원)" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label form-label-required">재료비</label>
                        <input type="number" class="form-input" name="expenseAmount" placeholder="가격을 입력하세요 (원)" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">심부름 이미지</label>
                        <div class="image-upload-area" id="imageUploadArea">
                            <div class="upload-icon">
                                <i class="icon-camera"></i>
                            </div>
                            <div class="upload-text">클릭하여 이미지를 업로드하세요</div>
                            <div class="upload-counter">0/10</div>
                        </div>
                        <input type="file" id="imageInput" name="imageFiles" multiple accept="image/*" style="display: none;">
                    </div>
                </div>

                <!-- Right Column -->
                <div class="form-right">
                    <div class="form-group">
                        <label class="form-label form-label-required">심부름 설명</label>
                        <textarea class="form-textarea" name="description" placeholder="심부름에 대한 자세한 설명을 입력하세요" rows="11" required></textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label form-label-required">심부름 위치</label>
                        <select class="form-input" name="dongCode" id="dongCodeSelect" required>
                            <option value="">동네를 선택하세요</option>
                            <c:forEach var="d" items="${dongs}">
                                <option value="${d.dongCode}" data-fullname="${d.dongFullName}">
                                    ${d.dongFullName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">희망날짜</label>
                        <div class="datetime-group">
                            <input type="date" class="form-input" name="desiredDate">
                            <input type="time" class="form-input" name="desiredTime">
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" 
                        onclick="window.location.href='${pageContext.request.contextPath}/errand/list'">취소</button>
                        <button type="submit" class="btn btn-primary">등록하기</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</section>

<jsp:include page="../common/footer.jsp"/>

<script src="<c:url value='/static/errand/js/errand-create.js'/>"></script>
</body>
</html>