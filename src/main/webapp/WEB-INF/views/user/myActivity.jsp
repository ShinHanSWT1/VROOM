<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="나의 활동 - VROOM" scope="request"/>
<c:set var="pageCss" value="myActivity" scope="request"/>
<c:set var="pageCssDir" value="user" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<div class="container">
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li class="sidebar-item"><a href="<c:url value='/member/myInfo'/>" class="sidebar-link">나의 정보</a></li>
                <li class="sidebar-item"><a href="<c:url value='/member/vroomPay'/>" class="sidebar-link">부름 페이<br>(계좌 관리)</a></li>
                <li class="sidebar-item"><a href="<c:url value='/member/myActivity'/>" class="sidebar-link active">나의 활동</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">설정</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">고객지원</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <h2 class="page-title">나의 활동</h2>

            <div class="activity-section">
                <div class="activity-tabs">
                    <button class="activity-tab-btn ${currentType == 'written' ? 'active' : ''}" data-type="written">작성한 글</button>
                    <button class="activity-tab-btn ${currentType == 'commented' ? 'active' : ''}" data-type="commented">댓글단 글</button>
                    <button class="activity-tab-btn ${currentType == 'saved' ? 'active' : ''}" data-type="saved">저장한 글</button>
                </div>

                <div class="activity-list" id="activityList">
                    <c:choose>
                        <c:when test="${not empty activityList}">
                            <c:forEach var="item" items="${activityList}">
                                <div class="activity-list-item">
                                    <div class="item-left">
                                        <div class="item-title">${item.title}</div>
                                        <div class="item-meta">
                                            <span>${item.nickname}</span>
                                            <span style="margin: 0 0.5rem">|</span>
                                            <span><fmt:formatDate value="${item.createdAt}" pattern="yyyy.MM.dd"/></span>
                                            <span style="margin: 0 0.5rem">|</span>
                                            <span>조회 ${item.views}</span>
                                        </div>
                                    </div>
                                    <div class="item-right">
                                        <div class="item-thumbnail">
                                            <c:if test="${not empty item.thumbnailUrl}">
                                                <img src="<c:url value='${item.thumbnailUrl}'/>" alt="thumbnail" style="width:100%; height:100%; object-fit:cover;">
                                            </c:if>
                                        </div>
                                        <div class="item-comment-box">
                                            <span class="comment-count">${item.comments}</span>
                                            <span class="comment-label">댓글</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align:center; padding: 3rem; color: #777;">활동 내역이 없습니다.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>

<jsp:include page="../common/footer.jsp"/>

<script src="<c:url value='/static/user/js/myActivity.js'/>"></script>
</body>
</html>
