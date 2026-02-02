<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="부름이 등록 - 우리동네 심부름" scope="request"/>
<c:set var="pageCss" value="register" scope="request"/>
<c:set var="pageCssDir" value="errander" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<!-- 부름이 등록 섹션 -->
<section class="auth-page">
    <div class="auth-card">
        <h2 class="auth-title">부름이 등록</h2>
        <p style="text-align: center; color: var(--color-gray); margin-bottom: 2rem; font-size: 0.9rem;">
            부름이로 활동하기 위해 추가 정보를 입력해주세요.<br>
            제출하신 서류는 관리자 승인 후 활동이 가능합니다.
        </p>

        <form action="${pageContext.request.contextPath}/errander/register" method="post" enctype="multipart/form-data" id="registerForm">

            <!-- 주 활동 지역 -->
            <div class="address-group">
                <label class="address-label">주 활동 지역 (필수)</label>
                <div class="address-selects">
                    <span class="address-sido">서울특별시</span>
                    <select name="gu1" id="gu1" class="address-select" required>
                        <option value="">구 선택</option>
                    </select>
                    <select name="dong1" id="dong1" class="address-select" disabled required>
                        <option value="">동 선택</option>
                    </select>
                    <input type="hidden" name="dongCode1" id="dongCode1">
                </div>
            </div>

            <!-- 부 활동 지역 -->
            <div class="address-group">
                <label class="address-label">부 활동 지역 (선택)</label>
                <div class="address-selects">
                    <span class="address-sido">서울특별시</span>
                    <select name="gu2" id="gu2" class="address-select">
                        <option value="">구 선택</option>
                    </select>
                    <select name="dong2" id="dong2" class="address-select" disabled>
                        <option value="">동 선택</option>
                    </select>
                    <input type="hidden" name="dongCode2" id="dongCode2">
                </div>
            </div>

            <div class="auth-form-group">
                <label class="auth-label">신분증 제출(필수)</label>
                <div>
                    <select name="idType" class="auth-label" required>
                        <option value="IDCARD">주민등록증</option>
                        <option value="DRIVER_LICENSE">운전면허증</option>
                        <option value="PASSPORT">여권</option>
                        <option value="ETC">기타 신분증</option>
                    </select>

                    <input type="file" name="idFile" class="auth-input" accept="image/*,.pdf" required>
                </div>
<%--                <small class="text-muted">주민번호 뒷자리는 가리고 업로드해주세요.</small>--%>
            </div>
            <div class="auth-form-group">
                <label for="document2" class="auth-label">통장 사본(필수)</label>
                <input type="file" id="document2" name="bankFile" class="auth-input" accept="image/*,.pdf" required>
            </div>

            <!-- 등록 버튼 -->
            <button type="submit" class="auth-btn" id="registerBtn">부름이 등록 신청</button>
        </form>
    </div>
</section>

<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="<c:url value='/static/errander/js/register.js'/>"></script>

<jsp:include page="../common/footer.jsp"/>
