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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        .kpi-value.positive {
            color: #27AE60;
        }

        .kpi-value.negative {
            color: #E74C3C;
        }

        .kpi-value.neutral {
            color: var(--color-accent);
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
            align-items: stretch;
        }

        .dashboard-card {
            background: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            height: 100%;
            position: relative;
        }

        .dashboard-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--color-light-gray);
            flex-shrink: 0;
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

        .no-data-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: var(--color-gray);
            font-size: 1rem;
            font-weight: 600;
            text-align: center;
            z-index: 10;
            pointer-events: none;
        }

        /* Chart Placeholder */
        .chart-placeholder {
            background: linear-gradient(135deg, var(--color-light-gray) 0%, #E0E0E0 100%);
            border-radius: 8px;
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--color-gray);
            font-size: 3rem;
            position: relative;
        }

        .chart-placeholder canvas {
            max-width: 100%;
            max-height: 100%;
        }

        .region-content-body {
            display: flex;
            flex-direction: row;
            gap: 1.5rem;
            flex: 1;                /* 남은 높이 채우기 */
            min-height: 0;          /* 내부 스크롤 버그 방지 */
        }

        .region-chart-wrapper {
            position: relative;
            height: auto;
        }

        .region-table-wrapper {
            flex: 1;
            overflow-y: auto;
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

            .dashboard-card.region-card {
                grid-column: span 2;
            }

            .region-content-body {
                flex-direction: column;
                align-items: stretch;
            }

            .region-chart-wrapper {
                flex: 1;     /* 1:1 비율 (필요시 flex: 0 0 40% 등으로 조절 가능) */
                width: 50%;  /* 차트 리사이징을 위한 명시적 너비 */
                margin-bottom: 0;
            }

            .region-table-wrapper {
                flex: 1;     /* 1:1 비율 */
                width: 50%;
                border-left: 1px solid var(--color-light-gray); /* 구분선 추가 */
                padding-left: 1.5rem;
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
        <main class="dashboard-content*">
            <h2 class="page-title">대시보드</h2>

            <!-- KPI Cards -->
            <section class="kpi-section">
                <div class="kpi-grid">
                    <div class="kpi-card">
                        <div class="kpi-label">[총 사용자]</div>
                        <div class="kpi-value">${dashSummary.totalUserCount}</div>
                        <div class="kpi-change ${dashSummary.totalUserDelta > 0 ? 'positive' : (dashSummary.totalUserDelta < 0 ? 'negative' : 'neutral')}">
                            <c:choose>
                                <c:when test="${dashSummary.totalUserDelta > 0}">(+${dashSummary.totalUserDelta})</c:when>
                                <c:when test="${dashSummary.totalUserDelta < 0}">(${dashSummary.totalUserDelta})</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-label">[일간 활성 사용자 수]</div>
                        <div class="kpi-value">${dashSummary.dauToday}</div>
                        <div class="kpi-change ${dashSummary.dauDelta > 0 ? 'positive' : (dashSummary.dauDelta < 0 ? 'negative' : 'neutral')}">
                            <c:choose>
                                <c:when test="${dashSummary.dauDelta > 0}">(+${dashSummary.dauDelta})</c:when>
                                <c:when test="${dashSummary.dauDelta < 0}">(${dashSummary.dauDelta})</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-label">[오늘 심부름 수]</div>
                        <div class="kpi-value">${dashSummary.errandsToday}</div>
                        <div class="kpi-change ${dashSummary.errandsDiffRate > 0 ? 'positive' : (dashSummary.errandsDiffRate < 0 ? 'negative' : 'neutral')}">
                            <c:choose>
                                <c:when test="${dashSummary.errandsDiffRate > 0}">(+${dashSummary.errandsDiffRate}%)</c:when>
                                <c:when test="${dashSummary.errandsDiffRate < 0}">(${dashSummary.errandsDiffRate}%)</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-label">[심부름 완료율]</div>
                        <div class="kpi-value ${dashSummary.activeErranderDelta > 60 ? 'positive' : (dashSummary.activeErranderDelta < 40 ? 'negative' : 'neutral')}">
                            ${dashSummary.completionRate}%
                        </div>
                        <div class="kpi-change neutral"></div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-label">[활성 부름이]</div>
                        <div class="kpi-value">${dashSummary.activeErranderToday}</div>
                        <div class="kpi-change ${dashSummary.activeErranderDelta > 0 ? 'positive' : (dashSummary.activeErranderDelta < 0 ? 'negative' : 'neutral')}">
                            <c:choose>
                                <c:when test="${dashSummary.activeErranderDelta > 0}">(+${dashSummary.activeErranderDelta})</c:when>
                                <c:when test="${dashSummary.activeErranderDelta < 0}">(${dashSummary.activeErranderDelta})</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Dashboard Grid -->
            <div class="dashboard-grid">
                <!-- 심부름 상태 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <h3 class="dashboard-card-title">심부름 상태</h3>
                        <a href="#" class="dashboard-card-action">상세보기 →</a>
                    </div>
                    <div class="chart-placeholder">
                        <canvas id="errandStatusChart"></canvas>
                        <div id="noDataTextErrandStatus" class="no-data-text" style="display:none;">
                            데이터가 없습니다
                        </div>
                    </div>
                </div>

                <!-- 지역별 정보 -->
                <div class="dashboard-card region-card"> <div class="dashboard-card-header">
                    <h3 class="dashboard-card-title">지역별 심부름 등록 수 TOP 5</h3>
                    <a href="#" class="dashboard-card-action">상세보기 →</a>
                </div>

                    <div class="region-content-body">

                        <div class="region-chart-wrapper">
                            <canvas id="errandRegionChart"></canvas>
                            <div id="noDataTextRegion" class="no-data-text" style="display:none;">
                                데이터가 없습니다
                            </div>
                        </div>

                        <div class="region-table-wrapper">
                            <table class="region-table data-table"> <thead>
                            <tr>
                                <th>지역</th>
                                <th>등록 수</th>
                                <th>완료율</th>
                                <th>평균 금액</th>
                            </tr>
                            </thead>
                                <tbody id="regionSummaryBody">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- 카테고리 분포 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <h3 class="dashboard-card-title">카테고리 분포</h3>
                        <a href="#" class="dashboard-card-action">상세보기 →</a>
                    </div>
                    <div class="chart-placeholder">
                        <canvas id="errandCategoryChart"></canvas>
                        <div id="noDataTextErrandCategory" class="no-data-text" style="display:none;">
                            데이터가 없습니다
                        </div>
                    </div>
                </div>

                <!-- 시간대별 트렌드 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-header">
                        <h3 class="dashboard-card-title">시간대별 트렌드</h3>
                        <a href="#" class="dashboard-card-action">상세보기 →</a>
                    </div>
                    <div class="chart-placeholder">
                        <canvas id="hourlyTrendChart"></canvas>
                        <div id="noDataTexthourlyTrendChart" class="no-data-text" style="display:none;">
                            데이터가 없습니다
                        </div>
                    </div>
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
                            <span id="issuePending" class="stats-value" style="color: #E74C3C;">-</span>
                        </li>
                        <li class="stats-item">
                            <span class="stats-label">처리중</span>
                            <span id="issueProcessing" class="stats-value" style="color: #F2A007;">-</span>
                        </li>
                        <li class="stats-item">
                            <span class="stats-label">처리완료</span>
                            <span id="issueCompleted" class="stats-value" style="color: #27AE60;">-</span>
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
                            <span id="settleToday" class="stats-value">-</span>
                        </li>
                        <li class="stats-item">
                            <span class="stats-label">정산 대기</span>
                            <span id="settleWaiting" class="stats-value">-</span>
                        </li>
                        <li class="stats-item">
                            <span class="stats-label">이번 달 총 정산</span>
                            <span id="settleMonth" class="stats-value">-</span>
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

    fetch('${pageContext.request.contextPath}/api/admin/dashboard/errand-status')
        .then(res => res.json())
        .then(data => {
            const statusColorMap = {
                WAITING: '#FFC107',
                MATCHED: '#03A9F4',
                CONFIRMED1: '#4CAF50',
                CONFIRMED2: '#FF9800',
                COMPLETED: '#9E9E9E',
                CANCELED: '#F44336',
                HOLD: '#4c54af'
            };

            const ctx = document.getElementById('errandStatusChart');

            const total = data.values.reduce((a, b) => a + b, 0);

            let chartLabels;
            let chartValues;
            let chartColors;

            if (total === 0) {
                // 데이터 없음
                chartLabels = ['데이터 없음'];
                chartValues = [1];               // 도넛을 채우기 위한 더미값
                chartColors = ['#E0E0E0'];        // 연한 회색
                showNoDataText('noDataTextErrandStatus');                // 옆 텍스트 표시
            } else {
                chartLabels = data.labels;
                chartValues = data.values;
                chartColors = data.labels.map(status => statusColorMap[status]);
                hideNoDataText('noDataTextErrandStatus');
            }

            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: chartLabels,
                    datasets: [{
                        data: chartValues,
                        backgroundColor: chartColors,
                        hoverOffset: 8
                    }]
                },
                options: {
                    cutout: '65%',
                    layout: {
                        padding: 20 // 차트 주변 여백 확보
                    },
                    plugins: {
                        legend: {
                            display: total !== 0   // 데이터 없으면 범례 숨김
                        },
                        tooltip: {
                            enabled: total !== 0   // 데이터 없으면 툴팁 숨김
                        }
                    }
                }
            });
        });

    fetch('${pageContext.request.contextPath}/api/admin/dashboard/errand-category')
        .then(res => res.json())
        .then(data => {
            console.log(data);
            const CATEGORY_COLORS = [
                '#FCB9AA',
                '#FFDBCC',
                '#ECEAE4',
                '#A2E1DB',
                '#55CBCD',
                '#C6DBDA',
                '#F6EAC2',
                '#CCE2CB'
            ];

            const ctx = document.getElementById('errandCategoryChart');
            const total = data.values.reduce((a, b) => a + b, 0);

            let chartLabels;
            let chartValues;

            if (total === 0) {
                // 데이터 없음
                chartLabels = ['데이터 없음'];
                chartValues = [0];               // 도넛을 채우기 위한 더미값
                showNoDataText('noDataTextErrandCategory');                // 옆 텍스트 표시
            } else {
                chartLabels = data.labels;
                chartValues = data.values;
                hideNoDataText('noDataTextErrandCategory');
            }

            const barColors = chartLabels.map((_, index) => {
                return CATEGORY_COLORS[index % CATEGORY_COLORS.length];
            });

            const barHoverColors = barColors.map(color => {
                return color + 'CC'; // 투명도 추가 (HEX + alpha)
            });

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: chartLabels,
                    datasets: [{
                        data: chartValues,
                        backgroundColor: barColors,
                        hoverBackgroundColor: barHoverColors,
                        borderWidth: 1,

                        borderRadius: 6,          // 둥근 막대
                        barThickness: 28,         // 막대 두께 고정
                        maxBarThickness: 32,
                        categoryPercentage: 0.6,  // 카테고리 간격
                        barPercentage: 0.8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,

                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            enabled: total !== 0,
                            backgroundColor: '#2C3E50',
                            titleColor: '#FFFFFF',
                            bodyColor: '#FFFFFF',
                            padding: 10,
                            cornerRadius: 6,
                            callbacks: {
                                label: function (ctx) {
                                    console.log(ctx);
                                    return ` ${'${'}ctx.raw.toLocaleString()}건`;
                                }
                            }
                        }
                    },

                    scales: {
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                color: '#7F8C8D',
                                font: {
                                    size: 11,
                                    weight: '500'
                                }
                            }
                        },
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0,0,0,0.05)'
                            },
                            ticks: {
                                precision: 0,
                                color: '#7F8C8D',
                                font: {
                                    size: 11
                                }
                            }
                        }
                    },

                    layout: {
                        padding: {
                            top: 10,
                            left: 8,
                            right: 8,
                            bottom: 0
                        }
                    }
                }
            });

        });

    fetch('${pageContext.request.contextPath}/api/admin/dashboard/errand-region')
        .then(res => res.json())
        .then(data => {
            console.log(data);
            const ctx = document.getElementById('errandRegionChart');
            const tbody = document.getElementById('regionSummaryBody');

            // 1. 데이터 확인
            const hasData = data && data.chart && data.chart.labels && data.chart.labels.length > 0;

            // 2. 차트 설정 준비
            let chartLabels, chartValues, chartTitle;

            if (hasData) {
                // 데이터 있음
                chartLabels = data.chart.labels;
                chartValues = data.chart.values;
                hideNoDataText('noDataTextRegion');
            } else {
                // 데이터 없음: 기본 지역명 표시하되 값은 0
                chartLabels = ['서울', '경기', '인천', '부산', '대구'];
                chartValues = [0, 0, 0, 0, 0]; // 막대 높이 0

                // 안내 텍스트 표시
                showNoDataText('noDataTextRegion');
                document.getElementById('noDataTextRegion').innerText = "데이터가 집계되지 않았습니다.";
            }

            // 3. 차트 그리기
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: chartLabels,
                    datasets: [{
                        label: '등록 건수',
                        data: chartValues,
                        backgroundColor: hasData ? '#FFC107' : '#F5F5F5', // 데이터 없으면 회색바
                        borderColor: hasData ? '#FFB300' : '#E0E0E0',
                        borderWidth: 1,
                        borderRadius: 4,
                        barPercentage: 0.5
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: { enabled: hasData } // 데이터 없으면 툴팁 끔
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            suggestedMax: hasData ? undefined : 10, // 데이터 없을 때 눈금 0~10 표시
                            grid: { color: 'rgba(0, 0, 0, 0.05)' },
                            ticks: { precision: 0, font: { size: 11 } }
                        },
                        x: {
                            grid: { display: false },
                            ticks: { font: { size: 11 } }
                        }
                    }
                }
            });

            // 4. 테이블 채우기
            tbody.innerHTML = '';
            if (hasData) {
                data.table.forEach((row, index) => {
                    tbody.innerHTML += `
                        <tr>
                            <td style="font-weight: 600;">
                                <span style="color:var(--color-accent); margin-right:4px;">
                                    ${'${'}index + 1}.
                                </span> ${'${'}row.region}
                            </td>
                            <td>${'${'}row.total.toLocaleString()}건</td>
                            <td>
                                <div style="display:flex; align-items:center; gap:5px;">
                                    <div style="width:50px; height:4px; background:#eee; border-radius:2px;">
                                        <div style="width:${'${'}row.completionRate}%; height:100%; background:#27AE60; border-radius:2px;"></div>
                                    </div>
                                    <span style="font-size:0.8rem">${'${'}row.completionRate}%</span>
                                </div>
                            </td>
                            <td>${'${'}row.avgPrice.toLocaleString()}원</td>
                        </tr>
                    `;
                });
            } else {
                // 빈 테이블 표시
                tbody.innerHTML = `
                    <tr>
                        <td colspan="4" style="text-align: center; color: var(--color-gray); padding: 2rem 1rem;">
                            <div style="font-size: 2rem; margin-bottom: 0.5rem;">📭</div>
                            <div>아직 등록된 심부름 데이터가 없습니다.</div>
                        </td>
                    </tr>
                `;
            }
        })
        .catch(err => console.error('지역별 데이터 로드 실패:', err));

    fetch('${pageContext.request.contextPath}/api/admin/dashboard/errand-hourly-trend')
        .then(res => res.json())
        .then(data => {
            const ctx = document.getElementById('hourlyTrendChart');

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: '시간대별 심부름 등록',
                        data: data.values,
                        borderColor: '#FFC107',
                        backgroundColor: 'rgba(255,193,7,0.2)',
                        tension: 0.3,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                precision: 0
                            }
                        }
                    }
                }
            });
        });

    fetch('${pageContext.request.contextPath}/api/admin/dashboard/issue-summary')
        .then(res => res.json())
        .then(data => {
            document.getElementById('issuePending').innerText = data.pending || 0;
            document.getElementById('issueProcessing').innerText = data.processing || 0;
            document.getElementById('issueCompleted').innerText = data.completed || 0;
        })
        .catch(err => console.error('이슈 요약 로드 실패:', err));

    fetch('${pageContext.request.contextPath}/api/admin/dashboard/settlement-summary')
        .then(res => res.json())
        .then(data => {
            const formatMoney = (num) => (num || 0).toLocaleString() + '원';
            const formatCount = (num) => (num || 0).toLocaleString() + '건';

            document.getElementById('settleToday').innerText = formatMoney(data.today_amount);
            document.getElementById('settleWaiting').innerText = formatCount(data.pending_count);
            document.getElementById('settleMonth').innerText = formatMoney(data.month_amount);
        })
        .catch(err => console.error('정산 요약 로드 실패:', err));

    function showNoDataText(element) {
        document.getElementById(element).style.display = 'block';
    }

    function hideNoDataText(element) {
        document.getElementById(element).style.display = 'none';
    }



</script>
</body>

</html>