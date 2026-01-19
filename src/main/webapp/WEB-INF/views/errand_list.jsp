<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
            max-width: 1400px;
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
        
        .write-section {
		    margin: 20px 0;
		}
		
		.write-btn-wrapper {
		    display: flex;
		    justify-content: flex-start;
		}
		
		.write-btn {
		    padding: 10px 18px;
		    background-color: #2d7df4;
		    color: #fff;
		    border-radius: 6px;
		    text-decoration: none;
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
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .task-card {
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
            height: 200px;
            background: linear-gradient(135deg, var(--color-light-gray) 0%, var(--color-white) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            position: relative;
        }

        .task-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
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
                <h1 onclick="location.href='main_updated_2.html'">VROOM</h1>
            </div>
            <nav class="nav-menu">
                <a href="main_updated_2.html" class="nav-item">홈</a>
                <a href="#" class="nav-item">커뮤니티</a>
                <a href="#" class="nav-item">심부름꾼 전환</a>
                <a href="#" class="nav-item nav-login">로그인</a>
                <a href="#" class="nav-item nav-signup">회원가입</a>
                <div class="nav-dropdown">
                    <button class="nav-item nav-user" id="userDropdownBtn">유저</button>
                    <div class="dropdown-menu" id="userDropdownMenu">
                        <a href="my-info.html" class="dropdown-item">나의정보</a>
                        <a href="vroom-pay.html" class="dropdown-item">부름페이</a>
                        <a href="my-activity.html" class="dropdown-item">나의 활동</a>
                        <a href="#" class="dropdown-item">설정</a>
                        <a href="#" class="dropdown-item">고객지원</a>
                        <div class="dropdown-divider"></div>
                        <a href="#" class="dropdown-item logout">로그아웃</a>
                    </div>
                </div>
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
            <div class="filter-bar">
                <div class="filter-group">
                    <span class="filter-label">카테고리</span>
                    <select class="filter-select" id="categoryFilter">
                        <option value="all">전체</option>
                        <option value="delivery">배달</option>
                        <option value="cleaning">청소</option>
                        <option value="assembly">설치/조립</option>
                        <option value="pet">반려동물</option>
                        <option value="line">줄서기</option>
                        <option value="other">기타</option>
                    </select>
                </div>

                <div class="filter-group">
                    <span class="filter-label">정렬</span>
                    <select class="filter-select" id="sortFilter">
                        <option value="recent">최신순</option>
                        <option value="price-high">높은 가격순</option>
                        <option value="price-low">낮은 가격순</option>
                        <option value="distance">가까운 거리순</option>
                    </select>
                </div>

                <div class="filter-group">
                    <span class="filter-label">동네</span>
                    <select class="filter-select" id="neighborhoodFilter">
                        <option value="all">전체</option>
                        <option value="songdo">송도동</option>
                        <option value="yeoksam">역삼동</option>
                        <option value="seocho">서초동</option>
                    </select>
                </div>

                <div class="filter-group">
                    <span class="filter-label">검색</span>
                    <input type="text" id="searchInput" placeholder="심부름 검색">
                    <button id="searchButton">검색</button>
                </div>

                <div class="results-info">
                    총 <span class="results-count">127</span>개의 심부름
                </div>
            </div>


			<div style="padding:10px; background:#ffe;">
			  DEBUG: totalCount=${totalCount}, listSize=${errands.size()}
			</div>
            <div class="tasks-grid">
			    <c:forEach var="e" items="${errands}">
			      <a class="task-card"
			         href="${pageContext.request.contextPath}/errand/detail?errandsId=${e.errandsId}">
			        <div class="task-title">${e.title}</div>
			        <div class="task-meta">
			          <span>${e.dongCode}</span>
			          <span class="task-reward">
			            <fmt:formatNumber value="${e.rewardAmount}" type="number" />원
			          </span>
			        </div>
			      </a>
			    </c:forEach>
			  </div>
			
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
                    <h3>우리동네 심부름</h3>
                    <p>이웃과 함께하는 따뜻한 심부름 커뮤니티</p>
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

        // 요소 선택
        const categoryFilter = document.getElementById('categoryFilter');
        const sortFilter = document.getElementById('sortFilter');
        const neighborhoodFilter = document.getElementById('neighborhoodFilter');
        const searchInput = document.getElementById('searchInput'); // 검색어가 있다면
        const searchButton = document.getElementById('searchButton'); // 검색 버튼이 있다면
        const resultsCount = document.querySelector('.results-count');

        // 필터 이벤트 리스너
        categoryFilter.addEventListener('change', applyFilters);
        sortFilter.addEventListener('change', applyFilters);
        neighborhoodFilter.addEventListener('change', applyFilters);

        // 검색 기능 (있다면)
        if (searchInput && searchButton) {
            searchButton.addEventListener('click', applyFilters);
            searchInput.addEventListener('keyup', (e) => {
                if (e.key === 'Enter') applyFilters();
            });
        }

        // Dropdown Logic
        document.addEventListener('DOMContentLoaded', function () {
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

        function applyFilters() {
            const category = categoryFilter.value;
            const sort = sortFilter.value;
            const neighborhood = neighborhoodFilter.value;
            const keyword = searchInput ? searchInput.value.trim().toLowerCase() : '';

            // 1. 필터링
            filteredTasks = mockTasks.filter(task => {
                // 카테고리
                let categoryMatch = (category === 'all');
                if (!categoryMatch) {
                    if (category === 'delivery' && task.badge === '배달') categoryMatch = true;
                    else if (category === 'cleaning' && task.badge === '청소') categoryMatch = true;
                    else if (category === 'assembly' && task.badge === '설치/조립') categoryMatch = true;
                    else if (category === 'pet' && task.badge === '반려동물') categoryMatch = true;
                    else if (category === 'line' && task.badge === '줄서기') categoryMatch = true;
                    else if (category === 'other' && task.badge === '기타') categoryMatch = true;
                }

                // 동네 (Neighborhood)
                let neighborhoodMatch = (neighborhood === 'all');
                if (!neighborhoodMatch) {
                    if (neighborhood === 'songdo' && task.location.includes('송도동')) neighborhoodMatch = true;
                    else if (neighborhood === 'yeoksam' && task.location.includes('역삼동')) neighborhoodMatch = true;
                    else if (neighborhood === 'seocho' && task.location.includes('서초동')) neighborhoodMatch = true;
                }

                // 검색어
                let keywordMatch = true;
                if (keyword) {
                    keywordMatch = task.title.toLowerCase().includes(keyword) ||
                        task.location.toLowerCase().includes(keyword) ||
                        task.badge.toLowerCase().includes(keyword);
                }

                return categoryMatch && neighborhoodMatch && keywordMatch;
            });

            // 2. 정렬
            if (sort === 'price-high') {
                filteredTasks.sort((a, b) => {
                    const priceA = parseInt(a.price.replace(/,/g, ''));
                    const priceB = parseInt(b.price.replace(/,/g, ''));
                    return priceB - priceA;
                });
            } else if (sort === 'price-low') {
                filteredTasks.sort((a, b) => {
                    const priceA = parseInt(a.price.replace(/,/g, ''));
                    const priceB = parseInt(b.price.replace(/,/g, ''));
                    return priceA - priceB;
                });
            } else if (sort === 'recent') {
                // 시간 파싱이 단순히 텍스트라 어렵지만, mock 데이터 순서를 활용하거나 텍스트 비교
                // 여기서는 간단히 원래 순서(최신이 위라고 가정) 또는 별도 로직 필요
                // mockTasks가 이미 최신순이라면 필터링만 해도 됨. 
                // 임시: 원래 인덱스 순서 유지를 위해 별도 sort 안함 (mockTasks 기준)
            } else if (sort === 'distance') {
                // 거리순 파싱 필요 '0.8km' 등.
                filteredTasks.sort((a, b) => {
                    const distA = parseFloat(a.time.split('·')[1].replace('km', '').trim());
                    const distB = parseFloat(b.time.split('·')[1].replace('km', '').trim());
                    return distA - distB;
                });
            }

            // 3. 결과 수 업데이트
            if (resultsCount) {
                resultsCount.textContent = filteredTasks.length;
            }

            // 4. 페이지 초기화 및 렌더링
            currentPage = 1;
            renderTasks();
            renderPagination();
        }

        function renderTasks() {
            const tasksGrid = document.getElementById('tasksGrid');
            tasksGrid.innerHTML = '';

            // 페이징 처리
            const totalItems = filteredTasks.length;
            const totalPages = Math.ceil(totalItems / tasksPerPage);

            const start = (currentPage - 1) * tasksPerPage;
            const end = start + tasksPerPage;
            const pageTasks = filteredTasks.slice(start, end);

            if (pageTasks.length === 0) {
                tasksGrid.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 3rem;">검색 결과가 없습니다.</div>';
                return;
            }

            pageTasks.forEach(task => {
                const taskCard = document.createElement('div');
                taskCard.className = 'task-card';
                taskCard.innerHTML = `
                    <div class="task-image">
                        ${task.icon}
                    </div>
                    <div class="task-card-content">
                        <div class="task-card-header">
                            <span class="task-badge">${task.badge}</span>
                            <span class="task-time">${task.time}</span>
                        </div>
                        <h3 class="task-card-title">${task.title}</h3>
                        <div class="task-author-info">
                            <div class="author-avatar">👤</div>
                            <span class="author-name">${task.author}</span>
                            <span class="meta-views">👁 ${task.views}</span>
                        </div>
                        <div class="task-meta">
                            <span class="task-location">${task.location}</span>
                            <span class="task-price">${task.price}</span>
                        </div>
                    </div>
                `;
                tasksGrid.appendChild(taskCard);
            });

            scrollToTop();
        }

        function renderPagination() {
            const pagination = document.getElementById('pagination');
            pagination.innerHTML = '';

            const totalItems = filteredTasks.length;
            const totalPages = Math.ceil(totalItems / tasksPerPage);

            if (totalPages <= 1) return; // 1페이지 이하면 숨김

            const prevBtn = document.createElement('button');
            prevBtn.className = 'pagination-btn';
            prevBtn.textContent = '이전';
            prevBtn.disabled = currentPage === 1;
            prevBtn.onclick = () => changePage(currentPage - 1);
            pagination.appendChild(prevBtn);

            const maxVisible = 5;
            let startPage = Math.max(1, currentPage - Math.floor(maxVisible / 2));
            let endPage = Math.min(totalPages, startPage + maxVisible - 1);

            if (endPage - startPage < maxVisible - 1) {
                startPage = Math.max(1, endPage - maxVisible + 1);
            }

            if (startPage > 1) {
                const firstPage = document.createElement('div');
                firstPage.className = 'pagination-number';
                firstPage.textContent = '1';
                firstPage.onclick = () => changePage(1);
                pagination.appendChild(firstPage);

                if (startPage > 2) {
                    const ellipsis = document.createElement('span');
                    ellipsis.className = 'pagination-ellipsis';
                    ellipsis.textContent = '...';
                    pagination.appendChild(ellipsis);
                }
            }

            for (let i = startPage; i <= endPage; i++) {
                const pageNum = document.createElement('div');
                pageNum.className = 'pagination-number';
                if (i === currentPage) {
                    pageNum.classList.add('active');
                }
                pageNum.textContent = i;
                pageNum.onclick = () => changePage(i);
                pagination.appendChild(pageNum);
            }

            if (endPage < totalPages) {
                if (endPage < totalPages - 1) {
                    const ellipsis = document.createElement('span');
                    ellipsis.className = 'pagination-ellipsis';
                    ellipsis.textContent = '...';
                    pagination.appendChild(ellipsis);
                }

                const lastPage = document.createElement('div');
                lastPage.className = 'pagination-number';
                lastPage.textContent = totalPages;
                lastPage.onclick = () => changePage(totalPages);
                pagination.appendChild(lastPage);
            }

            const nextBtn = document.createElement('button');
            nextBtn.className = 'pagination-btn';
            nextBtn.textContent = '다음';
            nextBtn.disabled = currentPage === totalPages;
            nextBtn.onclick = () => changePage(currentPage + 1);
            pagination.appendChild(nextBtn);
        }

        function changePage(page) {
            const totalItems = filteredTasks.length;
            const totalPages = Math.ceil(totalItems / tasksPerPage);

            if (page < 1 || page > totalPages) return;
            currentPage = page;
            renderTasks();
            renderPagination();
        }

        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }

        // 초기 실행
        applyFilters();
    </script>
</body>

</html>