<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 날짜 포맷팅을 위해 fmt 태그 라이브러리 추가 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. header.jsp에서 변수를 인식할 수 있도록 scope="request" 설정 --%>
<c:set var="pageTitle" value="VROOM - 동네생활" scope="request" />
<c:set var="pageCss" value="community" scope="request" />
<c:set var="pageId" value="community" scope="request" />

<jsp:include page="../common/header.jsp" />

<main class="container">
    <section class="search-section">
        <div class="location-info">
            <%-- 2. id="pageTitle" 추가: location.js에서 제목을 동적으로 바꿀 때 사용 --%>
            <h2 id="pageTitle">
                서울특별시
                <span class="location-name">${searchVO.gungu_name} ${searchVO.dong_name}</span>
                관련 소식
            </h2>
        </div>

        <div class="filter-container">
            <div class="neighborhood-select">
                <%-- 3. 구 선택: 하드코딩 제거. Controller에서 보낸 gunguList를 JSTL로 출력 --%>
                <%-- onchange="updateDongOptions()"를 통해 동 목록을 AJAX로 호출 --%>
                <select id="guSelect" class="select-box" onchange="updateDongOptions()">
                    <option value="">구 선택</option>
                    <c:forEach var="gungu" items="${gunguList}">
                        <option value="${gungu}" ${gungu == searchVO.gungu_name ? 'selected' : ''}>${gungu}</option>
                    </c:forEach>
                </select>

                <%-- 4. 동 선택: 초기에는 비워둠. location.js가 서버 데이터를 받아 append함 --%>
                <select id="dongSelect" class="select-box" onchange="updatePageTitle()">
                    <option value="">동 선택</option>
                </select>
            </div>

            <div class="category-filter">
                <button class="category-btn active">전체</button>
                <button class="category-btn">맛집</button>
                <button class="category-btn">소식</button>
                <button class="category-btn">질문</button>
            </div>
        </div>
    </section>

    <section class="post-list">
        <c:choose>
            <c:when test="${not empty postList}">
                <c:forEach var="post" items="${postList}">
                    <%-- 5. DB 컬럼명에 맞춰 postNo를 post_id로 변경 --%>
                    <div class="post-item" onclick="location.href='<c:url value="/community/detail?post_id=${post.post_id}"/>'">
                        <div class="post-header">
                            <span class="category-badge">${post.category_name}</span>
                                <%-- 6. dong -> dong_name으로 변경 --%>
                            <span class="post-location">${post.dong_name}</span>
                        </div>
                        <div class="post-title">${post.title}</div>
                        <div class="post-content">${post.content}</div>

                        <div class="post-meta">
                            <div class="user-info">
                                <span class="nickname">${post.nickname}</span>
                            </div>
                            <div class="post-stats">
                                    <%-- 7. regDate -> created_at, viewCount -> view_count 등 DB 컬럼명으로 교체 --%>
                                <span><fmt:formatDate value="${post.created_at}" pattern="yyyy.MM.dd"/></span>
                                <span class="divider">|</span>
                                <span>조회 ${post.view_count}</span>
                                <span class="divider">|</span>
                                <span>좋아요 ${post.like_count}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="no-data">해당 지역에 게시글이 없습니다.</div>
            </c:otherwise>
        </c:choose>
    </section>

    <a href="<c:url value='/community/write'/>" class="write-btn">
        <i class="fas fa-plus"></i> 글쓰기
    </a>
</main>

<jsp:include page="../common/footer.jsp" />