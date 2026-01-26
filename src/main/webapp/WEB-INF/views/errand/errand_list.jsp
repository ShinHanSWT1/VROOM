<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>심부름 목록 - VROOM</title>
    <style>
        :root {
            --color-primary: #6B8E23;
            --color-secondary: #F2CB05;
            --color-tertiary: #F2B807;
            --color-accent: #F2A007;
            --color-warm: #D97218;
            --color-dark: #2C3E50;
            --color-gray: #7F8C8D;
            --color-light-gray: #ECF0F1;
            --color-white: #FFFFFF;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont,
                'Segoe UI', 'Malgun Gothic', sans-serif;
            background-color: #FAFAFA;
            color: var(--color-dark);
            line-height: 1.6;
        }

        .header {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo h1 {
            color: var(--color-white);
            font-size: 1.5rem;
            font-weight: 700;
            cursor: pointer;
        }

        .nav-menu {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .nav-item {
            color: var(--color-white);
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .nav-item:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .nav-login,
        .nav-signup {
            background-color: rgba(255, 255, 255, 0.15);
        }

        .nav-user {
            background-color: var(--color-white);
            color: var(--color-primary);
            font-weight: 600;
            cursor: pointer;
            border: 2px solid var(--color-white);
        }

        /* Dropdown Styles */
        .nav-dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            background-color: var(--color-white);
            min-width: 160px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1001;
            border-radius: 8px;
            overflow: hidden;
            margin-top: 0.5rem;
            animation: fadeIn 0.2s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dropdown-menu.active {
            display: block;
        }

        .dropdown-item {
            color: var(--color-dark);
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            font-size: 0.9rem;
            transition: background-color 0.2s;
        }

        .dropdown-item:hover {
            background-color: #f1f1f1;
            color: var(--color-primary);
        }

        .dropdown-divider {
            height: 1px;
            background-color: var(--color-light-gray);
            margin: 4px 0;
        }

        .dropdown-item.logout {
            color: #e74c3c;
        }

        .dropdown-item.logout:hover {
            background-color: #fdeaea;
        }

        .page-header {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            padding: 2.5rem 0;
            text-align: center;
        }

        .page-title {
            font-size: 2rem;
            color: var(--color-white);
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            font-size: 1rem;
            color: var(--color-white);
            opacity: 0.95;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1.5rem;
        }
        
        .write-btn-container {
            text-align: right;
            margin-bottom: 2rem;
        }

        .write-btn {
            display: inline-block;
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
            padding: 0.7rem 1.5rem;
            font-weight: 700;
            border-radius: 8px;
            cursor: pointer;
            border: none;
            box-shadow: 0 4px 8px rgba(107, 142, 35, 0.25);
            transition: all 0.3s ease;
        }

        .write-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(107, 142, 35, 0.3);
        }

        .main-section {
            padding: 3rem 0;
        }

        .filter-bar {
            background-color: var(--color-white);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .filter-group {
            display: flex;
            gap: 0.75rem;
            align-items: center;
        }

        .filter-label {
            font-weight: 600;
            color: var(--color-dark);
            font-size: 0.95rem;
        }

        .filter-select {
            padding: 0.5rem 1rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            background-color: var(--color-white);
            color: var(--color-dark);
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .filter-select:hover,
        .filter-select:focus {
            border-color: var(--color-secondary);
            outline: none;
        }

        .results-info {
            color: var(--color-gray);
            font-size: 0.95rem;
        }

        .results-count {
            font-weight: 700;
            color: var(--color-accent);
        }

        .tasks-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 4rem;
        }

        .task-card {
        	text-decoration: none;
            background-color: var(--color-white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 2px solid transparent;
            cursor: pointer;
        }

        .task-card:hover {
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
            transform: translateY(-4px);
            border-color: var(--color-secondary);
        }

        .task-image {
            width: 100%;
            height: 180px;
            background-color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            position: relative;
        }
        
        /* 업로드 이미지 / 실사 */
		.task-image img.img-cover {
		    width: 100%;
		    height: 100%;
		    object-fit: cover;
		}
		
		/* 카테고리 기본 이미지 (배달, 벌레퇴치 등 아이콘) */
		.task-image img.img-contain {
		    width: 100%;
		    height: 100%;
		    object-fit: contain;
		    padding: 12px;          /* 프레임에 딱 붙지 않게 */
		    box-sizing: border-box;
		    background-color: #fff;
		}

        .task-card-content {
            padding: 1.25rem;
        }

        .task-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
        }

        .task-badge {
            display: inline-block;
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .task-time {
            color: var(--color-gray);
            font-size: 0.8rem;
        }

        .task-card-title {
            font-size: 1rem;
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.5rem;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            line-height: 1.4;
        }

        .task-author-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
        }

        .author-avatar {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.75rem;
        }

        .author-name {
            font-size: 0.85rem;
            color: var(--color-gray);
        }

        .meta-views {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.85rem;
            color: var(--color-gray);
        }

        .task-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 0.75rem;
            border-top: 1px solid var(--color-light-gray);
        }

        .task-location {
            color: var(--color-gray);
            font-size: 0.85rem;
        }

        .task-price {
            color: var(--color-accent);
            font-weight: 700;
            font-size: 1.125rem;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 3rem;
        }

        .pagination-btn {
            padding: 0.75rem 1rem;
            border: 2px solid var(--color-light-gray);
            background-color: var(--color-white);
            color: var(--color-dark);
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .pagination-btn:hover:not(:disabled) {
            border-color: var(--color-secondary);
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-white);
        }

        .pagination-btn:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        .pagination-number {
            min-width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid var(--color-light-gray);
            background-color: var(--color-white);
            color: var(--color-dark);
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .pagination-number:hover {
            border-color: var(--color-secondary);
            background-color: #FFF9E6;
        }

        .pagination-number.active {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-white);
            border-color: var(--color-accent);
        }

        .pagination-ellipsis {
            color: var(--color-gray);
            font-weight: 700;
            padding: 0 0.5rem;
        }

        .footer {
            background-color: var(--color-dark);
            color: var(--color-white);
            padding: 3rem 0 1rem;
            margin-top: 3rem;
        }

        .footer-content {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .footer-info h3 {
            color: var(--color-secondary);
            margin-bottom: 0.5rem;
        }

        .footer-info p {
            color: var(--color-light-gray);
            font-size: 0.9rem;
        }

        .footer-links {
            display: flex;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        .footer-links a {
            color: var(--color-light-gray);
            font-size: 0.9rem;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: var(--color-secondary);
        }

        .footer-copyright {
            text-align: center;
            padding-top: 1rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--color-gray);
            font-size: 0.85rem;
        }

        @media (max-width: 1200px) {
            .tasks-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 900px) {
            .tasks-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {
            .tasks-grid {
                grid-template-columns: 1fr;
            }

            .filter-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-group {
                flex-direction: column;
                align-items: stretch;
            }

            .filter-select,
            #searchInput,
            #searchButton {
                width: 100%;
            }
        }

        #searchInput {
            padding: 0.5rem 1rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            background-color: var(--color-white);
            color: var(--color-dark);
            font-size: 0.9rem;
            font-weight: 500;
            outline: none;
            transition: all 0.3s ease;
        }

        #searchInput:focus {
            border-color: var(--color-secondary);
        }

        #searchButton {
            padding: 0.5rem 1rem;
            background-color: var(--color-secondary);
            color: var(--color-dark);
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        #searchButton:hover {
            background-color: var(--color-accent);
        }
    </style>

    <!-- 글꼴 -->
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet" as="style"
        href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">

</head>

<body>
    <header class="header">
	  <div class="header-container">
	    <div class="logo">
	      <h1 onclick="location.href='${pageContext.request.contextPath}/'">VROOM</h1>
	    </div>
	
	    <nav class="nav-menu">
	      <a href="${pageContext.request.contextPath}/" class="nav-item">홈</a>
	      <a href="${pageContext.request.contextPath}/community" class="nav-item">커뮤니티</a>
	      <a href="${pageContext.request.contextPath}/member/myInfo" class="nav-item">심부름꾼 전환</a>
	
	      <c:choose>
	        <c:when test="${empty sessionScope.loginSess}">
	          <a href="${pageContext.request.contextPath}/auth/login" class="nav-item nav-login">로그인</a>
	          <a href="${pageContext.request.contextPath}/auth/join" class="nav-item nav-signup">회원가입</a>
	        </c:when>
	
	        <c:otherwise>
	          <div class="nav-dropdown">
	            <button class="nav-item nav-user" id="userDropdownBtn">
	              <c:out value="${sessionScope.loginSess.nickname}" />님
	            </button>
	
	            <div class="dropdown-menu" id="userDropdownMenu">
	              <a href="${pageContext.request.contextPath}/member/myInfo" class="dropdown-item">나의정보</a>
	              <a href="${pageContext.request.contextPath}/vroomPay" class="dropdown-item">부름페이</a>
	              <a href="${pageContext.request.contextPath}/myActivity" class="dropdown-item">나의 활동</a>
	              <a href="${pageContext.request.contextPath}/settings" class="dropdown-item">설정</a>
	              <a href="${pageContext.request.contextPath}/support" class="dropdown-item">고객지원</a>
	              <div class="dropdown-divider"></div>
	              <a href="${pageContext.request.contextPath}/member/logout" class="dropdown-item logout">로그아웃</a>
	            </div>
	          </div>
	        </c:otherwise>
	      </c:choose>
	    </nav>
	  </div>
	</header>


    <section class="page-header">
        <div class="container">
            <h1 class="page-title">우리 동네 심부름 목록</h1>
            <p class="page-subtitle">이웃과 함께하는 따뜻한 심부름을 찾아보세요</p>
        </div>
    </section>
    
    <section class="write-section">
	    <div class="container">
	        <div class="write-btn-wrapper">
	            <a href="<c:url value='/errand/create' />" class="write-btn">
	                ✏ 글쓰기
	            </a>
	        </div>
	    </div>
	</section>

    <section class="main-section">
        <div class="container">
            <!-- 파일 경로: src/main/webapp/WEB-INF/views/errand/errand_list.jsp -->
			<form id="filterForm"
			      class="filter-bar"
			      method="get"
			      action="${pageContext.request.contextPath}/errand/list">
			
			    <div class="filter-group">
			        <span class="filter-label">카테고리</span>
			        <!-- 서버 파라미터: categoryId -->
			        <select class="filter-select" id="categoryFilter" name="categoryId">
			            <option value="" ${empty param.categoryId ? 'selected' : ''}>전체</option>
			
			            <!-- DB 카테고리 테이블(CATEGORIES) 기반 -->
			            <c:forEach var="c" items="${categories}">
			                <option value="${c.id}" ${param.categoryId == c.id ? 'selected' : ''}>
			                    <c:out value="${c.name}" />
			                </option>
			            </c:forEach>
			        </select>
			    </div>
			
			    <div class="filter-group">
			        <span class="filter-label">정렬</span>
			        <!-- 서버 파라미터: sort (mapper의 choose 값과 일치해야 함) -->
			        <select class="filter-select" id="sortFilter" name="sort">
			            <option value="latest" ${empty param.sort || param.sort == 'latest' ? 'selected' : ''}>최신순</option>
			            <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>높은 가격순</option>
			            <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>낮은 가격순</option>
			            <option value="desired_at" ${param.sort == 'desired_at' ? 'selected' : ''}>희망일 빠른순</option>
			        </select>
			    </div>
			
			    <div class="filter-group">
			        <span class="filter-label">동네</span>
			        <!-- 서버 파라미터: dongCode -->
			        <select class="filter-select" id="neighborhoodFilter" name="dongCode">
			            <option value="" ${empty param.dongCode ? 'selected' : ''}>전체</option>
			
			            <!-- 동네 옵션을 서버에서 내려주면 best
			                 지금은 dongs가 없을 수 있으니, 임시로 하드코딩/또는 삭제 가능 -->
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
			        <!-- 서버 파라미터: q -->
			        <input type="text" id="searchInput" name="q" placeholder="심부름 검색" value="${param.q}">
			        <button id="searchButton" type="submit">검색</button>
			    </div>
			
			    <div class="results-info">
			        총 <span class="results-count">${totalCount}</span>개의 심부름
			    </div>
			</form>
						
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
				        <!-- 카테고리명 있으면 badge로 -->
				        <span class="task-badge">
				          <c:out value="${empty e.categoryName ? '심부름' : e.categoryName}" />
				        </span>
				
				        <!-- createdAt 내려오면 time 표시 -->
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

			
			<!-- <div class="tasks-grid">
			  <c:forEach var="e" items="${errands}">
			    카드 HTML
			  </c:forEach>
			</div>
			 -->
			
			<!-- <div class="tasks-grid">
			  <c:forEach var="e" items="${errands}">
			    <div class="task-card">
			      <div class="task-card-content">
			        <h3 class="task-card-title">${e.title}</h3>
			        <div class="task-meta">
			          <span class="task-price">${e.rewardAmount}원</span>
			        </div>
			      </div>
			    </div>
			  </c:forEach>
			</div> -->

            <div class="pagination" id="pagination">
                <!-- Pagination will be generated by JavaScript -->
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-info">
                    <h3>우리동네 </h3>
                    <p>이웃과 함께하는 따뜻한  커뮤니티</p>
                </div>
                <div class="footer-links">
                    <a href="#">회사소개</a>
                    <a href="#">이용약관</a>
                    <a href="#">개인정보처리방침</a>
                    <a href="#">문의하기</a>
                </div>
                <div class="footer-copyright">
                    <p>&copy; 2024 우리동네 심부름. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <script>
	  document.addEventListener('DOMContentLoaded', function () {
	
	    // 1) 필터/검색: 서버 GET 방식 (form submit)
	    const filterForm = document.getElementById('filterForm');
	    const categoryFilter = document.getElementById('categoryFilter');
	    const sortFilter = document.getElementById('sortFilter');
	    const neighborhoodFilter = document.getElementById('neighborhoodFilter');
	    const searchInput = document.getElementById('searchInput');
	
	    // select 변경 시 자동 submit
	    if (filterForm) {
	      if (categoryFilter) categoryFilter.addEventListener('change', () => filterForm.submit());
	      if (sortFilter) sortFilter.addEventListener('change', () => filterForm.submit());
	      if (neighborhoodFilter) neighborhoodFilter.addEventListener('change', () => filterForm.submit());
	
	      // 검색 input에서 Enter 누르면 submit (기본 submit도 되지만 안전하게)
	      if (searchInput) {
	        searchInput.addEventListener('keyup', (e) => {
	          if (e.key === 'Enter') filterForm.submit();
	        });
	      }
	    }
	
	    // 2) 유저 드롭다운 (기존 유지)
	    const dropdownBtn = document.getElementById('userDropdownBtn');
	    const dropdownMenu = document.getElementById('userDropdownMenu');
	
	    if (dropdownBtn && dropdownMenu) {
	      dropdownBtn.addEventListener('click', function (e) {
	        e.stopPropagation();
	        dropdownMenu.classList.toggle('active');
	      });
	
	      document.addEventListener('click', function (e) {
	        if (!dropdownMenu.contains(e.target) && !dropdownBtn.contains(e.target)) {
	          dropdownMenu.classList.remove('active');
	        }
	      });
	    }
	  });
	</script>
</body>

</html>