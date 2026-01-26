<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나의 활동 - VROOM</title>
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

        /* Header reused from main */
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
            border: 2px solid var(--color-white);
            cursor: pointer;
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

        /* Dashboard Layout */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1.5rem;
        }

        .dashboard-container {
            display: flex;
            gap: 2rem;
            padding: 3rem 0;
            min-height: 80vh;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            flex-shrink: 0;
        }

        .sidebar-menu {
            list-style: none;
            background-color: var(--color-white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
        }

        .sidebar-item {
            border-bottom: 1px solid var(--color-light-gray);
        }

        .sidebar-item:last-child {
            border-bottom: none;
        }

        .sidebar-link {
            display: block;
            padding: 1.25rem 1.5rem;
            text-decoration: none;
            color: var(--color-dark);
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .sidebar-link:hover {
            background-color: #f8f9fa;
            color: var(--color-primary);
            padding-left: 1.75rem;
        }

        .sidebar-link.active {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
            font-weight: 700;
        }

        /* Main Content */
        .main-content {
            flex-grow: 1;
        }

        /* Activity Page Specific Styles */
        .page-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 2rem;
            color: var(--color-dark);
        }

        .activity-section {
            background-color: var(--color-white);
            border-radius: 16px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
            border: 1px solid var(--color-light-gray);
            overflow: hidden;
            min-height: 300px; /* 최소 높이 설정 */
        }

        .activity-tabs {
            display: flex;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--color-light-gray);
            gap: 1rem;
            background-color: var(--color-white);
        }

        .activity-tab-btn {
            background: none;
            border: none;
            padding: 0.8rem 1.5rem;
            font-size: 1rem;
            font-weight: 600;
            color: var(--color-gray);
            cursor: pointer;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .activity-tab-btn:hover {
            background-color: #f8f9fa;
            color: var(--color-primary);
        }

        .activity-tab-btn.active {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
            box-shadow: 0 4px 6px rgba(107, 142, 35, 0.2);
        }

        /* 리스트 컨테이너 (숨김 처리용) */
        .activity-list-container {
            display: none;
        }
        .activity-list-container.active {
            display: block;
        }

        .activity-list-item {
            background-color: var(--color-white);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--color-light-gray);
            transition: background-color 0.2s ease;
            text-decoration: none; /* a태그일 경우 밑줄 제거 */
            cursor: pointer;
        }

        .activity-list-item:hover {
            background-color: #f8f9fa;
        }

        .activity-list-item:last-child {
            border-bottom: none;
        }

        .item-left {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            flex-grow: 1;
        }

        .item-title {
            font-size: 1.1rem;
            font-weight: 700;
            line-height: 1.4;
            color: var(--color-dark);
            text-decoration: none;
        }

        .item-meta {
            display: flex;
            gap: 0.5rem;
            font-size: 0.85rem;
            color: var(--color-gray);
            align-items: center;
        }

        /* 우측 영역 전체 정렬 */
        .item-right {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding-left: 2rem;
            min-width: 150px;
            justify-content: flex-end;
        }

        /* 썸네일 박스 */
        .item-thumbnail {
            width: 50px;
            height: 50px;
            background-color: #f8f9fa;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid var(--color-light-gray);
            flex-shrink: 0;
        }

        .duck-icon {
            font-size: 1.5rem;
        }

        /* 댓글 박스: 가로 정렬(row) 핵심 */
        .item-comment-box {
            display: flex;
            flex-direction: row; /* 가로로 나란히 */
            align-items: center;
            gap: 0.25rem;
            color: var(--color-gray);
        }

        .comment-count {
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--color-gray);
        }

        .comment-label {
            font-size: 0.95rem;
            color: var(--color-gray);
        }

        .empty-message {
            text-align: center;
            padding: 3rem;
            color: #777;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            .activity-list-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
                padding: 1.5rem;
            }

            .item-right {
                width: 100%;
                justify-content: space-between;
                padding-left: 0;
            }
        }
    </style>
</head>

<body>
<header class="header">
    <div class="header-container">
        <div class="logo">
            <h1 onclick="location.href='${pageContext.request.contextPath}/'">VROOM</h1>
        </div>
        <nav class="nav-menu">
            <a href="main_updated_2.html" class="nav-item">홈</a>
            <a href="#" class="nav-item">커뮤니티</a>
            <a href="#" class="nav-item">심부름꾼 전환</a>
            <div class="nav-dropdown">
                <button class="nav-item nav-user" id="userDropdownBtn">사용자</button>
                <div class="dropdown-menu" id="userDropdownMenu">
                    <a href="myInfo" class="dropdown-item">나의정보</a>
                    <a href="/vroom/pay/vroomPay" class="dropdown-item">부름페이</a>
                    <a href="myActivity" class="dropdown-item">나의 활동</a>
                    <a href="#" class="dropdown-item">설정</a>
                    <a href="#" class="dropdown-item">고객지원</a>
                    <div class="dropdown-divider"></div>
                    <a href="#" class="dropdown-item logout">로그아웃</a>
                </div>
            </div>
        </nav>
    </div>
</header>

<div class="container">
    <div class="dashboard-container">
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li class="sidebar-item"><a href="myInfo" class="sidebar-link">나의 정보</a></li>
                <li class="sidebar-item"><a href="/vroom/pay/vroomPay" class="sidebar-link">부름 페이<br>(계좌 관리)</a></li>
                <li class="sidebar-item"><a href="myActivity" class="sidebar-link active">나의 활동</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">설정</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">고객지원</a></li>
            </ul>
        </aside>

        <main class="main-content">
            <h2 class="page-title">나의 활동</h2>

            <div class="activity-section">
                <div class="activity-tabs">
                    <button class="activity-tab-btn active" data-target="list-written">작성한 글</button>
                    <button class="activity-tab-btn" data-target="list-commented">댓글단 글</button>
                    <button class="activity-tab-btn" data-target="list-saved">저장한 글</button>
                </div>

                <div id="list-written" class="activity-list-container active">
                    <c:choose>
                        <c:when test="${not empty myPosts}">
                            <c:forEach var="item" items="${myPosts}">
                                <div class="activity-list-item" onclick="location.href='${pageContext.request.contextPath}/community/detail/${item.postId}'">
                                    <div class="item-left">
                                        <div class="item-title">${item.title}</div>
                                        <div class="item-meta">
                                            <span>${item.nickname}</span>
                                            <span style="margin: 0 0.5rem">|</span>
                                            <span><fmt:formatDate value="${item.createdAt}" pattern="yyyy.MM.dd"/></span>
                                            <span style="margin: 0 0.5rem">|</span>
                                            <span>조회 ${item.viewCount}</span>
                                        </div>
                                    </div>
                                    <div class="item-right">
                                        <div class="item-thumbnail">
                                            <span class="duck-icon">🐥</span>
                                        </div>
                                        <div class="item-comment-box">
                                            <span class="comment-count">${item.commentCount}</span>
                                            <span class="comment-label">댓글</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-message">작성한 글이 없습니다.</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div id="list-commented" class="activity-list-container">
                    <c:choose>
                        <c:when test="${not empty myComments}">
                            <c:forEach var="item" items="${myComments}">
                                <div class="activity-list-item" onclick="location.href='${pageContext.request.contextPath}/community/detail/${item.postId}'">
                                    <div class="item-left">
                                        <div class="item-title">${item.title}</div>
                                        <div class="item-meta">
                                            <span>${item.nickname}</span>
                                            <span style="margin: 0 0.5rem">|</span>
                                            <span><fmt:formatDate value="${item.createdAt}" pattern="yyyy.MM.dd"/></span>
                                            <span style="margin: 0 0.5rem">|</span>
                                            <span>조회 ${item.viewCount}</span>
                                        </div>
                                    </div>
                                    <div class="item-right">
                                        <div class="item-thumbnail">
                                            <span class="duck-icon">🐥</span>
                                        </div>
                                        <div class="item-comment-box">
                                            <span class="comment-count">${item.commentCount}</span>
                                            <span class="comment-label">댓글</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-message">댓글을 단 글이 없습니다.</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div id="list-saved" class="activity-list-container">
                    <c:choose>
                        <c:when test="${not empty myScraps}">
                            <c:forEach var="item" items="${myScraps}">
                                <div class="activity-list-item" onclick="location.href='${pageContext.request.contextPath}/community/detail/${item.postId}'">
                                    <div class="item-left">
                                        <div class="item-title">${item.title}</div>
                                        <div class="item-meta">
                                            <span>${item.nickname}</span>
                                            <span style="margin: 0 0.5rem">|</span>
                                            <span><fmt:formatDate value="${item.createdAt}" pattern="yyyy.MM.dd"/></span>
                                            <span style="margin: 0 0.5rem">|</span>
                                            <span>조회 ${item.viewCount}</span>
                                        </div>
                                    </div>
                                    <div class="item-right">
                                        <div class="item-thumbnail">
                                            <span class="duck-icon">🐥</span>
                                        </div>
                                        <div class="item-comment-box">
                                            <span class="comment-count">${item.commentCount}</span>
                                            <span class="comment-label">댓글</span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-message">저장한 글이 없습니다.</div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </main>
    </div>
</div>

<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-info">
                <h3>우리동네 심부름</h3>
                <p>이웃과 함께하는 따뜻한 심부름 커뮤니티</p>
            </div>
            <div class="footer-links">
                <a href="#">이용약관</a>
                <a href="#">개인정보처리방침</a>
                <a href="#">운영정책</a>
                <a href="#">위치기반서비스 이용약관</a>
                <a href="#">이용자보호 비전과 계획</a>
                <a href="#">청소년보호정책</a>
            </div>
            <div class="footer-copyright">
                <p>&copy; 2024 VROOM. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>

<script>
    // 탭 클릭 이벤트 (단순 화면 전환)
    const tabs = document.querySelectorAll('.activity-tab-btn');
    const lists = document.querySelectorAll('.activity-list-container');

    tabs.forEach(function(tab) {
        tab.addEventListener('click', function () {
            // 1. 모든 탭 버튼 비활성화
            tabs.forEach(function(t) { t.classList.remove('active'); });
            // 2. 현재 클릭한 탭 활성화
            this.classList.add('active');

            // 3. 모든 리스트 숨기기
            lists.forEach(function(list) { list.classList.remove('active'); });

            // 4. data-target에 맞는 리스트만 보이기
            const targetId = this.dataset.target;
            document.getElementById(targetId).classList.add('active');
        });
    });

    // 드롭다운 로직
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
</script>
</body>

</html>