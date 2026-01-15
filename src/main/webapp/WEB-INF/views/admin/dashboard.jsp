<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <title>VROOM - 관리자 대시보드</title>
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
            --sidebar-width: 240px;
            --sidebar-collapsed-width: 70px;
            --header-height: 70px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Malgun Gothic', sans-serif;
            color: var(--color-dark);
            line-height: 1.6;
            background-color: #F8F9FA;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            width: var(--sidebar-width);
            background: linear-gradient(180deg, var(--color-primary) 0%, #4A6B1A 100%);
            color: var(--color-white);
            position: fixed;
            left: 0;
            top: 0;
            height: 100vh;
            transition: width 0.3s ease;
            z-index: 1000;
            overflow: hidden;
        }

        .sidebar.collapsed {
            width: var(--sidebar-collapsed-width);
        }

        .sidebar-header {
            padding: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: var(--header-height);
            transition: all 0.3s ease;
        }

        .sidebar-logo {
            font-size: 1.5rem;
            font-weight: 700;
            white-space: nowrap;
            transition: opacity 0.3s ease;
        }

        .sidebar-logo > img {
            width: 150px;
            height: 37.5px;
        }

        .sidebar.collapsed .sidebar-header {
            justify-content: center;
            padding: 1rem 0;
        }

        .sidebar.collapsed .sidebar-logo {
            display: none;
        }

        .sidebar.collapsed .nav-item {
            justify-content: center;
            padding: 1rem 0;
        }

        .sidebar.collapsed .nav-item-icon {
            margin-right: 0;
            min-width: unset;
        }

        .sidebar-toggle {
            z-index: 1001;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 4px;
            border: none;
            color: var(--color-white);
            min-width: 36px;
            width: 36px;
            height: 36px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            transition: all 0.3s ease;
        }

        .sidebar-toggle:hover {
            background: rgba(255, 255, 255, 0.25);
        }

        .sidebar-nav {
            padding: 1rem 0;
        }

        .nav-item {
            display: flex;
            align-items: center;
            padding: 1rem 1.5rem;
            color: var(--color-white);
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            border-left: 4px solid transparent;
        }

        .nav-item:hover {
            background: rgba(255, 255, 255, 0.1);
            border-left-color: var(--color-secondary);
        }

        .nav-item.active {
            background: rgba(255, 255, 255, 0.15);
            border-left-color: var(--color-secondary);
            font-weight: 600;
        }

        .nav-item-icon {
            font-size: 1.5rem;
            min-width: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .nav-item-text {
            white-space: nowrap;
            transition: opacity 0.3s ease;
        }

        .sidebar.collapsed .nav-item-text {
            opacity: 0;
            width: 0;
        }

        /* Main Content Area */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            transition: margin-left 0.3s ease;
        }

        .sidebar.collapsed ~ .main-content {
            margin-left: var(--sidebar-collapsed-width);
        }

        /* Header */
        .admin-header {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
            position: sticky;
            top: 0;
            z-index: 999;
            height: var(--header-height);
        }

        .header-container {
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 100%;
        }

        .header-title {
            color: var(--color-white);
            font-size: 1.5rem;
            font-weight: 700;
        }

        .header-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .header-user {
            position: relative;
            cursor: pointer;
            user-select: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(255, 255, 255, 0.15);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            color: var(--color-white);
            font-weight: 600;
        }

        /* 드롭다운 메뉴 스타일 */
        .user-dropdown {
            display: none; /* 기본적으로 숨김 */
            position: absolute;
            top: calc(100% + 10px);
            right: 0;
            background-color: var(--color-white);
            min-width: 150px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border-radius: 8px;
            overflow: hidden;
            z-index: 1001;
        }

        .user-dropdown.show {
            display: block; /* 클릭 시 표시 */
        }

        .dropdown-item {
            padding: 0.75rem 1rem;
            color: var(--color-dark);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: background 0.2s;
        }

        .dropdown-item:hover {
            background-color: var(--color-light-gray);
            color: var(--color-warm);
        }

        /* Dashboard Content */
        .dashboard-content {
            padding: 2rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 2rem;
            color: var(--color-dark);
        }

        /* KPI Cards */
        .kpi-section {
            margin-bottom: 2rem;
        }

        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .kpi-card {
            background: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .kpi-card:hover {
            border-color: var(--color-secondary);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            transform: translateY(-2px);
        }

        .kpi-label {
            font-size: 0.875rem;
            color: var(--color-gray);
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .kpi-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--color-dark);
            margin-bottom: 0.5rem;
        }

        .kpi-change {
            font-size: 0.875rem;
            font-weight: 600;
        }

        .kpi-change.positive {
            color: #27AE60;
        }

        .kpi-change.negative {
            color: #E74C3C;
        }

        .kpi-change.neutral {
            color: var(--color-accent);
        }

        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
        }

        .dashboard-card {
            background: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .dashboard-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--color-light-gray);
        }

        .dashboard-card-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--color-dark);
        }

        .dashboard-card-action {
            color: var(--color-accent);
            font-size: 0.875rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
        }

        .dashboard-card-action:hover {
            color: var(--color-warm);
        }

        /* Chart Placeholder */
        .chart-placeholder {
            background: linear-gradient(135deg, var(--color-light-gray) 0%, #E0E0E0 100%);
            border-radius: 8px;
            height: 250px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--color-gray);
            font-size: 3rem;
        }

        /* Stats List */
        .stats-list {
            list-style: none;
        }

        .stats-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--color-light-gray);
        }

        .stats-item:last-child {
            border-bottom: none;
        }

        .stats-label {
            font-weight: 600;
            color: var(--color-dark);
        }

        .stats-value {
            font-weight: 700;
            color: var(--color-accent);
            font-size: 1.125rem;
        }

        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .status-badge.pending {
            background: #FFF9E6;
            color: var(--color-accent);
        }

        .status-badge.active {
            background: #E8F5E9;
            color: #27AE60;
        }

        .status-badge.completed {
            background: #E3F2FD;
            color: #2196F3;
        }

        .status-badge.cancelled {
            background: #FDEAEA;
            color: #E74C3C;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }

            .kpi-grid {
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                width: var(--sidebar-collapsed-width);
            }

            .sidebar-logo {
                opacity: 0;
            }

            .nav-item-text {
                opacity: 0;
                width: 0;
            }

            .main-content {
                margin-left: var(--sidebar-collapsed-width);
            }

            .dashboard-content {
                padding: 1rem;
            }

            .kpi-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Table Styles */
        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th,
        .data-table td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid var(--color-light-gray);
        }

        .data-table th {
            background-color: #F8F9FA;
            font-weight: 700;
            color: var(--color-dark);
            font-size: 0.875rem;
        }

        .data-table td {
            font-size: 0.9rem;
        }

        .data-table tbody tr:hover {
            background-color: #F8F9FA;
        }
    </style>

    <!-- 글꼴 -->
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet" as="style"
          href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
</head>

<body>
<div class="admin-layout">
    <!-- Sidebar -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">
                <img src="${pageContext.request.contextPath}/resources/img/logo2.png" alt="VROOM" srcset="">
            </div>
            <button class="sidebar-toggle" id="sidebarToggle">☰</button>
        </div>
        <nav class="sidebar-nav">
            <a href="#dashboard" class="nav-item active">
                <span class="nav-item-icon">📊</span>
                <span class="nav-item-text">대시보드</span>
            </a>
            <a href="#users" class="nav-item">
                <span class="nav-item-icon">👥</span>
                <span class="nav-item-text">사용자 관리</span>
            </a>
            <a href="#helpers" class="nav-item">
                <span class="nav-item-icon">🏃</span>
                <span class="nav-item-text">부름이 관리</span>
            </a>
            <a href="#orders" class="nav-item">
                <span class="nav-item-icon">📦</span>
                <span class="nav-item-text">주문/배차 관리</span>
            </a>
            <a href="#reports" class="nav-item">
                <span class="nav-item-icon">⚠️</span>
                <span class="nav-item-text">신고/이슈 관리</span>
            </a>
            <a href="#settlement" class="nav-item">
                <span class="nav-item-icon">💰</span>
                <span class="nav-item-text">정산 관리</span>
            </a>
            <a href="#content" class="nav-item">
                <span class="nav-item-icon">📢</span>
                <span class="nav-item-text">공지/컨텐츠 관리</span>
            </a>
            <a href="#settings" class="nav-item">
                <span class="nav-item-icon">⚙️</span>
                <span class="nav-item-text">시스템 설정</span>
            </a>
        </nav>
    </aside>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header -->
        <header class="admin-header">
            <div class="header-container">
                <h1 class="header-title">관리자 페이지</h1>
                <div class="header-actions">
                    <div class="header-user" id="adminDropdownTrigger">
                        <span>👤</span>
                        <span>${sessionScope.loginAdmin.name}</span>
                        <span style="font-size: 0.8rem; margin-left: 5px;">▼</span>
                        <div class="user-dropdown" id="adminDropdown">
                            <a href="${pageContext.request.contextPath}/admin/logout" class="dropdown-item">
                                <span>🚪</span> 로그아웃
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Dashboard Content -->
        <main class="dashboard-content">
            <h2 class="page-title">대시보드</h2>

            <!-- KPI Cards -->
            <section class="kpi-section">
                <div class="kpi-grid">
                    <div class="kpi-card">
                        <div class="kpi-label">[총 사용자]</div>
                        <div class="kpi-value">3,421</div>
                        <div class="kpi-change positive">(+12)</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-label">[일간 활성 사용자 수]</div>
                        <div class="kpi-value">3,421</div>
                        <div class="kpi-change positive">(+12)</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-label">[오늘 심부름 수]</div>
                        <div class="kpi-value">96</div>
                        <div class="kpi-change positive">(+18%)</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-label">[심부름 완료율]</div>
                        <div class="kpi-value">91%</div>
                        <div class="kpi-change neutral"></div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-label">[활성 부름이]</div>
                        <div class="kpi-value">182</div>
                        <div class="kpi-change negative">(-3)</div>
                    </div>
                </div>
            </section>

            <!-- Dashboard Grid -->
            <div class="dashboard-grid">
                <!-- 심부름 상태 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <h3 class="dashboard-card-title">심부름 상태<br>(도넛 | 막대그래프)</h3>
                        <a href="#" class="dashboard-card-action">상세보기 →</a>
                    </div>
                    <div class="chart-placeholder">📊</div>
                </div>

                <!-- 지역별 정보 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <h3 class="dashboard-card-title">지역별</h3>
                        <a href="#" class="dashboard-card-action">상세보기 →</a>
                    </div>
                    <ul class="stats-list">
                        <li class="stats-item">
                            <span class="stats-label">지역별 심부름 등록 수 TOP 5</span>
                        </li>
                        <li class="stats-item">
                            <span class="stats-label">지역별 완료율</span>
                        </li>
                        <li class="stats-item">
                            <span class="stats-label">지역별 평균 금액</span>
                        </li>
                    </ul>
                </div>

                <!-- 카테고리 분포 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <h3 class="dashboard-card-title">카테고리 분포</h3>
                        <a href="#" class="dashboard-card-action">상세보기 →</a>
                    </div>
                    <div class="chart-placeholder">📈</div>
                </div>

                <!-- 시간대별 트렌드 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <h3 class="dashboard-card-title">시간대별 트렌드</h3>
                        <a href="#" class="dashboard-card-action">상세보기 →</a>
                    </div>
                    <div class="chart-placeholder">📉</div>
                </div>

                <!-- 신고/이슈 요약 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <h3 class="dashboard-card-title">신고/이슈 요약</h3>
                        <a href="#" class="dashboard-card-action">전체보기 →</a>
                    </div>
                    <ul class="stats-list">
                        <li class="stats-item">
                            <span class="stats-label">미처리 신고</span>
                            <span class="stats-value">12</span>
                        </li>
                        <li class="stats-item">
                            <span class="stats-label">처리중</span>
                            <span class="stats-value">8</span>
                        </li>
                        <li class="stats-item">
                            <span class="stats-label">처리완료</span>
                            <span class="stats-value">45</span>
                        </li>
                    </ul>
                </div>

                <!-- 정산 요약 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <h3 class="dashboard-card-title">정산 요약</h3>
                        <a href="#" class="dashboard-card-action">전체보기 →</a>
                    </div>
                    <ul class="stats-list">
                        <li class="stats-item">
                            <span class="stats-label">오늘 정산 예정</span>
                            <span class="stats-value">1,234,000원</span>
                        </li>
                        <li class="stats-item">
                            <span class="stats-label">정산 대기</span>
                            <span class="stats-value">23건</span>
                        </li>
                        <li class="stats-item">
                            <span class="stats-label">이번 달 총 정산</span>
                            <span class="stats-value">45,678,000원</span>
                        </li>
                    </ul>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    $(document).ready(function () {
        console.log('${loginAdmin}');

        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');
        const adminDropdownTrigger = document.getElementById('adminDropdownTrigger');
        const adminDropdown = document.getElementById('adminDropdown');

        // 1. 사이드바 토글 (이미 구현된 로직 보강)
        sidebarToggle.addEventListener('click', function (e) {
            e.stopPropagation(); // 이벤트 버블링 방지
            sidebar.classList.toggle('collapsed');

            console.log("사이드바 상태:", sidebar.classList.contains('collapsed') ? "접힘" : "펼쳐짐");
        });

        // 2. 관리자 드롭다운 토글
        adminDropdownTrigger.addEventListener('click', function (e) {
            e.stopPropagation();
            adminDropdown.classList.toggle('show');
        });

        // 3. 외부 클릭 시 드롭다운 닫기
        window.addEventListener('click', function () {
            if (adminDropdown.classList.contains('show')) {
                adminDropdown.classList.remove('show');
            }
        });

        // 4. 메뉴 활성화 상태 유지
        const currentPath = window.location.hash || '#dashboard';
        $('.nav-item').each(function () {
            if ($(this).attr('href') === currentPath) {
                $('.nav-item').removeClass('active');
                $(this).addClass('active');
            }
        });
    });
</script>
</body>

</html>