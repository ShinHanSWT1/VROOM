<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="VROOM - 동네생활" scope="request"/>
<c:set var="pageId" value="community" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<!-- Filter Section -->
<section class="filter-section">
    <div class="filter-container">
        <div class="location-selectors">
            <select id="guSelect" class="location-select" >
                <option value="">구 선택</option>
                <c:forEach var="gungu" items="${gunguList}">
                    <option value="${gungu}" ${gungu == selectedGuName ? 'selected' : ''}>${gungu}</option>
                </c:forEach>
            </select>

            <select id="dongSelect" class="location-select" >
                <option value="">동 선택</option>
            </select>
        </div>
        <%-- 검색박스--%>
        <form id ="searchForm" class="search-wrapper" onsubmit="return false;">
            <input type="text"
                   id="searchInput"
                   class="search-input"
                   placeholder="검색어를 입력하세요"
                   value="${searchKeyword}">
            <button type="submit" class="search-btn">
                <span>검색</span>
            </button>
        </form>
    </div>
</section>

<!-- Main Content -->
<main class="main-content">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<c:url value='/main'/>">홈</a>
        <span class="breadcrumb-separator"></span>
        <span>동네생활</span>
    </nav>

    <!-- Page Title -->
    <h2 class="page-title" id="pageTitle"
        data-gu="${selectedGuName}"
        data-dong-code="$selectedDongCode}">
        서울특별시 ${not empty selectedGuName ? selectedGuName : ''} 동네생활
    </h2>

    <!-- Content Grid -->
    <div class="content-grid">
        <!-- Category Sidebar -->
        <aside class="category-sidebar">
            <div class="sidebar-section">
                <ul class="category-list">
                    <!-- 전체 카테고리 -->
                    <li class="category-item ${empty selectedCategoryId ? 'active' : ''}">
                        <a href="<c:url value='/community'>
                            <c:if test='${not empty selectedCategoryId}'>
                                <c:param name='dongCode' value='${selectedDongCode}'/>
                            </c:if>
                            <c:if test = '${not empty selectedDongCode}'>
                                <c:param name="dongCode" value="${selectedDongCode}"/>
                            </c:if>
                        </c:url>">전체</a>
                    </li>
                     <!-- 인기글 카테고리 추가 -->
                     <li class="category-item ${selectedCategoryId == 0 ? 'active' : ''}">
                         <a href="<c:url value='/community'>
                            <c:param name='categoryId' value='0'/>
                            <c:if test='${not empty selectedDongCode}'>
                                <c:param name='dongCode' value='${selectedDongCode}'/>
                            </c:if>
                            <c:if test='${not empty selectedGuName}'>
                                 <c:param name='guName' value='${selectedGuName}'/>
                            </c:if>
                        </c:url>">인기글</a>
                     </li>
                    <!-- DB에서 가져온 카테고리 목록 -->
                    <c:forEach var="category" items="${categoryList}">
                        <li class="category-item ${selectedCategoryId == category.categoryId ? 'active' : ''}">
                            <a href="<c:url value='/community'>
                                <c:param name='categoryId' value='${category.categoryId}'/>
                                <c:if test='${not empty selectedDongCode}'>
                                    <c:param name='dongCode' value='${selectedDongCode}'/>
                                </c:if>
                                <c:if test='${not empty selectedGuName}'>
                                    <c:param name='guName' value='${selectedGuName}'/>
                                </c:if>
                            </c:url>">${category.categoryName}</a>
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
                                        <span class="post-meta-item">${post.dongName}</span>
                                        <span class="post-meta-item">•</span>
                                        <span class="post-category-badge">${post.categoryName}</span>
                                        <span class="post-meta-item">•</span>
                                        <span class="post-meta-item">
                                            <fmt:formatDate value="${post.createdAt}" pattern="MM.dd"/>
                                        </span>
                                    </div>

                                    <div class="post-stats">
                                        <span class="post-stat">👍 ${post.likeCount}</span>
                                        <span class="post-stat">👁 ${post.viewCount}</span>
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

<script>
    // 컨텍스트 경로
    var contextPath = '${pageContext.request.contextPath}';

    // 현재 선택된 필터 값 (서버에서 전달)
    var currentDongCode = '${selectedDongCode}';
    var selectedGuName = '${selectedGuName}';
    var currentCategoryId = '${selectedCategoryId}';
    var currentSearchKeyword = '${searchKeyword}';

    // 페이지 로드시 초기화
    $(document).ready(function() {
        // 페이지 새로고침 감지 후, 기본 url로 리다이렉트
        const navigationEntry = performance.getEntriesByType("navigation")[0];
        if(navigationEntry && navigationEntry.type === 'reload') {
            window.location.href = contextPath + '/community';
            return;
        }

        // 이벤트 바인딩
        $('#guSelect').on('change', loadDongOptions);
        $('#dongSelect').on('change', filterPosts);
        $('#searchBtn').on('click', filterPosts);
        $('#searchInput').on('keypress', function(e) {
            if (e.which === 13) filterPosts();
        });

        // 페이지 로드 시: 선택된 구가 있으면 동 목록 로드
        if (selectedGuName) {
            loadDongOptions();
        }

    });

    // 구선택 동선택 ajax
    function loadDongOptions() {
        var selectedGu = $('#guSelect').val();
        var $dongSelect = $('#dongSelect');

        // 동 목록 초기화
        $dongSelect.empty().append('<option value="">동 선택</option>');

        if (!selectedGu) {
            updatePageTitle();
            return;
        }

        // AJAX 요청
        $.ajax({
            url: contextPath + '/location/getDongs',
            type: 'GET',
            data: { gunguName: selectedGu },
            dataType: 'json',
            success: function(data) {
                if (data && data.length > 0) {
                    data.forEach(function(item) {
                        var selected = (item.dongCode === currentDongCode) ? ' selected' : '';
                        var option = '<option value="' + item.dongCode + '"' + selected + '>' + item.dongName + '</option>';
                        $dongSelect.append(option);
                    });
                }
                updatePageTitle();
            },
            error: function(xhr, status, error) {
                console.error('동 목록 조회 실패:', error);
            }
        });
    }

    // 필터링 후 페이지 이동
    function filterPosts() {
        var guName = $('#guSelect').val(); // 구 이름
        var dongCode = $('#dongSelect').val(); // 동 코드
        var searchKeyword = $('#searchInput').val().trim();

        var url = '${pageContext.request.contextPath}/community';
        var params = [];

        if(guName) {
            params.push('guName=' + encodeURIComponent(guName));
        }
        if(dongCode) {
            params.push("dongCode=" + encodeURIComponent(dongCode));
        }
        if(currentCategoryId) {
            params.push("categoryId=" + currentCategoryId);
        }
        if(searchKeyword) {
            params.push("searchKeyword=" + encodeURIComponent(searchKeyword));
        }
        if(params.length>0) {
            url += '?' + params.join('&');
        }
        window.location.href = url;
    }

    // 페이지 타이틀 업데이트
    function updatePageTitle() {
        var guName = $('#guSelect option:selected').text();
        var dongName = $('#dongSelect option:selected').text();
        var $pageTitle = $('#pageTitle');

        if (dongName && dongName !== '동 선택') {
            $pageTitle.text('서울특별시 ' + guName + ' ' + dongName + ' 동네생활');
        } else if (guName && guName !== '구 선택') {
            $pageTitle.text('서울특별시 ' + guName + ' 동네생활');
        } else {
            $pageTitle.text('서울특별시 동네생활');
        }
    }
</script>

<jsp:include page="../common/footer.jsp"/>