<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="부름 페이 - VROOM" scope="request"/>
<c:set var="pageCss" value="vroomPay" scope="request"/>
<c:set var="pageCssDir" value="user" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<div class="container">
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li class="sidebar-item"><a href="<c:url value='/member/myInfo'/>" class="sidebar-link">나의 정보</a></li>
                <li class="sidebar-item"><a href="<c:url value='/member/vroomPay'/>" class="sidebar-link active">부름 페이<br>(계좌 관리)</a></li>
                <li class="sidebar-item"><a href="<c:url value='/member/myActivity'/>" class="sidebar-link">나의 활동</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">설정</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">고객지원</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <h2 class="page-title">부름 페이</h2>

            <!-- Profile & Balance Card -->
            <div class="pay-info-card">
                <div class="profile-section">
                    <div class="profile-image-container">
                        <c:choose>
                            <c:when test="${not empty profile.profileImage}">
                                <img src="${pageContext.request.contextPath}${profile.profileImage}" alt="Profile" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                            </c:when>
                            <c:otherwise>V</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="profile-details">
                        <span class="profile-nickname">${profile.nickname}</span>
                        <button class="option-btn">내 글 상위 노출</button>
                    </div>
                </div>

                <div class="balance-container">
                    <div class="balance-box">
                        <button class="balance-action-btn">충 전</button>
                        <button class="balance-action-btn">출 금</button>
                        <div class="balance-display">
                            <span class="balance-label">잔 액</span>
                            <span class="balance-amount"><fmt:formatNumber value="${balance}" type="currency" currencySymbol="₩" /></span>
                        </div>
                    </div>
                </div>

                <div class="temp-container">
                    <span class="temp-label">매너온도</span>
                    <div class="temp-bar">
                        <div class="temp-fill" style="width: ${profile.mannerScore}%;"></div>
                    </div>
                    <span class="temp-value">${profile.mannerScore}℃</span>
                </div>
            </div>

            <!-- Transaction History -->
            <div class="history-section">
                <div class="history-header">
                    <h3 class="history-title">거래 내역 <span class="history-count">(${fn:length(transactionList)})</span></h3>
                </div>

                <div class="history-table-header">
                    <div>제목</div>
                    <div>작성자</div>
                    <div>금액</div>
                </div>

                <div class="history-list" id="transactionList">
                    <c:forEach var="transaction" items="${transactionList}">
                        <div class="history-item">
                            <div class="item-title">${transaction.title}</div>
                            <div class="item-author">${transaction.author}</div>
                            <div class="item-amount"><fmt:formatNumber value="${transaction.amount}" type="currency" currencySymbol="₩" /></div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="pagination" id="pagination">
                <!-- Pagination can be added here if needed -->
            </div>
        </main>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<%-- <script src="<c:url value='/static/user/js/vroomPay.js'/>"></script> --%>
</body>
</html>
