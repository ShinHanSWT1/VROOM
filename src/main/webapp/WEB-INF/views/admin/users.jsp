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
    <title>VROOM - 사용자 관리</title>
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

        /* Page Content */
        .page-content {
            padding: 2rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 2rem;
            color: var(--color-dark);
        }

        /* Summary Cards */
        .summary-section {
            margin-bottom: 2rem;
        }

        .summary-title {
            font-size: 1.125rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--color-dark);
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .summary-card {
            background: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .summary-card:hover {
            border-color: var(--color-secondary);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            transform: translateY(-2px);
        }

        .summary-label {
            font-size: 0.875rem;
            color: var(--color-gray);
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .summary-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--color-dark);
        }

        .summary-change {
            font-size: 0.875rem;
            font-weight: 600;
            margin-top: 0.25rem;
        }

        .summary-change.positive {
            color: #27AE60;
        }

        .summary-change.negative {
            color: #E74C3C;
        }

        /* Search Section */
        .search-section {
            background: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .search-title {
            font-size: 1.125rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--color-dark);
        }

        .search-bar {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .search-input {
            flex: 1;
            padding: 0.875rem 1rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 1rem;
            font-family: inherit;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--color-secondary);
        }

        .search-button {
            padding: 0.875rem 2rem;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-dark);
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .search-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(242, 160, 7, 0.3);
        }

        .filter-row {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            padding-top: 1rem;
            border-top: 2px dashed var(--color-light-gray);
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .filter-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--color-dark);
        }

        .filter-select {
            padding: 0.625rem 1rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 0.9rem;
            font-family: inherit;
            background-color: var(--color-white);
            cursor: pointer;
            min-width: 150px;
        }

        .filter-select:focus {
            outline: none;
            border-color: var(--color-secondary);
        }

        /* User Table */
        .user-table-section {
            background: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .table-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--color-dark);
        }

        .table-count {
            color: var(--color-gray);
            font-size: 0.9rem;
        }

        .user-table {
            width: 100%;
            border-collapse: collapse;
        }

        .user-table thead {
            background-color: #F8F9FA;
        }

        .user-table th {
            padding: 1rem;
            text-align: left;
            font-weight: 700;
            color: var(--color-dark);
            font-size: 0.875rem;
            border-bottom: 2px solid var(--color-light-gray);
        }

        .user-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--color-light-gray);
            font-size: 0.9rem;
        }

        .user-table tbody tr {
            transition: background-color 0.2s ease;
        }

        .user-table tbody tr:hover {
            background-color: #F8F9FA;
        }

        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-badge.ACTIVE {
            background: #E8F5E9;
            color: #27AE60;
        }

        .status-badge.BANNED {
            background: #FDEAEA;
            color: #E74C3C;
        }

        .status-badge.SUSPENDED {
            background: #FFF9E6;
            color: var(--color-accent);
        }

        /* Role Badge */
        .role-badge {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
            background: #E3F2FD;
            color: #2196F3;
        }

        .role-badge.errander {
            background: #F3E5F5;
            color: #9C27B0;
        }

        /* Status Dropdown */
        .status-dropdown {
            position: relative;
            display: inline-block;
        }

        .status-dropdown-toggle {
            background: none;
            border: none;
            cursor: pointer;
            padding: 0;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .status-dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            background: var(--color-white);
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            z-index: 100;
            min-width: 150px;
            margin-top: 0.5rem;
        }

        .status-dropdown-menu.show {
            display: block;
        }

        .status-dropdown-item {
            padding: 0.75rem 1rem;
            cursor: pointer;
            transition: background-color 0.2s ease;
            font-size: 0.875rem;
        }

        .status-dropdown-item:hover {
            background-color: #F8F9FA;
        }

        .status-dropdown-item:first-child {
            border-radius: 6px 6px 0 0;
        }

        .status-dropdown-item:last-child {
            border-radius: 0 0 6px 6px;
        }

        /* Suspension Days Modal */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9998;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.show {
            display: flex;
        }

        .modal {
            background: var(--color-white);
            border-radius: 12px;
            padding: 2rem;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 9999;
        }

        .modal-header {
            margin-bottom: 1.5rem;
        }

        .modal-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--color-dark);
        }

        .modal-body {
            margin-bottom: 1.5rem;
        }

        .modal-input-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .modal-label {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--color-dark);
        }

        .modal-input {
            padding: 0.75rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 1rem;
            font-family: inherit;
        }

        .modal-input:focus {
            outline: none;
            border-color: var(--color-secondary);
        }

        .modal-footer {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
        }

        .modal-button {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .modal-button.primary {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-dark);
        }

        .modal-button.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(242, 160, 7, 0.3);
        }

        .modal-button.secondary {
            background: var(--color-light-gray);
            color: var(--color-dark);
        }

        .modal-button.secondary:hover {
            background: #D5D8DC;
        }

        /* Action Button */
        .action-button {
            padding: 0.5rem 1rem;
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
            border: none;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .action-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
        }

        .pagination-button {
            padding: 0.5rem 1rem;
            border: 2px solid var(--color-light-gray);
            background: var(--color-white);
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.875rem;
        }

        .pagination-button:hover {
            border-color: var(--color-secondary);
            background-color: #FFF9E6;
        }

        .pagination-button.active {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            border-color: var(--color-accent);
            color: var(--color-dark);
            font-weight: 700;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .summary-grid {
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

            .page-content {
                padding: 1rem;
            }

            .summary-grid {
                grid-template-columns: 1fr;
            }

            .search-bar {
                flex-direction: column;
            }

            .user-table {
                font-size: 0.8rem;
            }

            .user-table th,
            .user-table td {
                padding: 0.5rem;
            }
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
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
                <span class="nav-item-icon">📊</span>
                <span class="nav-item-text">대시보드</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item active">
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

        <!-- Page Content -->
        <main class="page-content">
            <h2 class="page-title">사용자 관리</h2>

            <!-- Summary Section -->
            <section class="summary-section">
<%--                <h3 class="summary-title">상단 요약 제공</h3>--%>
                <div class="summary-grid">
                    <div class="summary-card">
                        <div class="summary-label">전체 사용자</div>
                        <div class="summary-value">${summary.total}명</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">활성 사용자</div>
                        <div class="summary-value">${summary.activated}명</div>
                        <div class="summary-change positive">최근 7일 활성화 사용자 | ${summary.recent7_activated}명</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">정지</div>
                        <div class="summary-value">${summary.banned}명</div>
                        <div class="summary-change positive">일시정지 | ${summary.suspended}명</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">탈퇴</div>
                        <div class="summary-value">${summary.unsubscribed}명</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">오늘 가입</div>
                        <div class="summary-value">${summary.today_joined}명</div>
                    </div>
                </div>
            </section>

            <!-- Search Section -->
            <section class="search-section">
                <h3 class="search-title">사용자 검색</h3>
                <div class="search-bar">
                    <input type="text" class="search-input" placeholder="사용자 검색 (ID/닉네임)" id="searchInput">
                    <button class="search-button" onclick="searchUsers()">🔍 검색</button>
                </div>
                <div class="filter-row">
                    <div class="filter-group">
                        <label class="filter-label">상태</label>
                        <select class="filter-select" id="filterStatus">
                            <option value="">전체</option>
                            <option value="ACTIVE">정상</option>
                            <option value="SUSPENDED">일시정지</option>
                            <option value="BANNED">정지</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label class="filter-label">역할</label>
                        <select class="filter-select" id="filterRole">
                            <option value="">전체</option>
                            <option value="user">USER</option>
                            <option value="errander">ERRANDER</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label class="filter-label">신고횟수</label>
                        <select class="filter-select" id="filterReports">
                            <option value="">전체</option>
                            <option value="0">0회</option>
                            <option value="1-5">1-5회</option>
                            <option value="6+">6회 이상</option>
                        </select>
                    </div>
                </div>
            </section>

            <!-- User Table Section -->
            <section class="user-table-section">
                <div class="table-header">
                    <h3 class="table-title">사용자 목록 테이블</h3>
                    <span class="table-count">총 <strong>8</strong>명</span>
                </div>
                <div style="overflow-x: auto;">
                    <table class="user-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>이메일</th>
                            <th>닉네임</th>
                            <th>역할</th>
                            <th>상태</th>
                            <th>신고</th>
                            <th>정지 종료일</th>
                            <th>최근 로그인</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody id="userTableBody">

                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination"></div>
            </section>
        </main>
    </div>
</div>

<!-- Suspension Days Modal -->
<div class="modal-overlay" id="suspensionModal">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title">일시정지 설정</h3>
        </div>
        <div class="modal-body">
            <div class="modal-input-group">
                <label class="modal-label">일시정지 기간 (일)</label>
                <input type="number" class="modal-input" id="suspensionDays" placeholder="일수 입력" min="1" value="7">
            </div>
            <div class="modal-input-group">
                <label class="modal-label">사유 (선택)</label>
                <input type="text" class="modal-input" id="suspensionReason" placeholder="정지 사유">
            </div>
        </div>
        <div class="modal-footer">
            <button class="modal-button secondary" onclick="closeSuspensionModal()">취소</button>
            <button class="modal-button primary" onclick="applySuspension()">확인</button>
        </div>
    </div>
</div>

<script>
    let targetUserId = null;       // 정지 대상 ID
    let targetElement = null;      // UI 업데이트할 배지 요소

    $(document).ready(function () {
        // Sidebar Toggle
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');
        const adminDropdownTrigger = document.getElementById('adminDropdownTrigger');
        const adminDropdown = document.getElementById('adminDropdown');
        const savedState = localStorage.getItem('sidebarState');
        if (savedState === 'collapsed') {
            sidebar.classList.add('collapsed');
        }
        // 1. 사이드바 토글
        sidebarToggle.addEventListener('click', function (e) {
            e.stopPropagation(); // 이벤트 버블링 방지
            sidebar.classList.toggle('collapsed');

            console.log("사이드바 상태:", sidebar.classList.contains('collapsed') ? "접힘" : "펼쳐짐");

            // 상태 저장 로직 추가
            const isCollapsed = sidebar.classList.contains('collapsed');
            localStorage.setItem('sidebarState', isCollapsed ? 'collapsed' : 'expanded');
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
        const currentPath = window.location.hash || '#users';
        $('.nav-item').each(function () {
            if ($(this).attr('href') === currentPath) {
                $('.nav-item').removeClass('active');
                $(this).addClass('active');
            }
        });
    });

    // Navigation Active State
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => {
        item.addEventListener('click', function (e) {
            navItems.forEach(nav => nav.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // Status Dropdown Toggle
    function toggleStatusDropdown(button) {
        const dropdown = button.nextElementSibling;
        const allDropdowns = document.querySelectorAll('.status-dropdown-menu');

        // Close all other dropdowns
        allDropdowns.forEach(d => {
            if (d !== dropdown) {
                d.classList.remove('show');
            }
        });

        dropdown.classList.toggle('show');
        event.stopPropagation();
    }

    // 외부 창 클릭 시 드롭다운 접기
    document.addEventListener('click', function () {
        const allDropdowns = document.querySelectorAll('.status-dropdown-menu');
        allDropdowns.forEach(d => d.classList.remove('show'));
    });

    // 상태 변환
    let currentStatusElement = null;

    // 상태 변경 함수
    function changeStatus(element, newStatus, extraData, userId) {
        // 1. 상태 배지 UI 업데이트
        const dropdown = element.closest('.status-dropdown');
        const statusBadge = dropdown.querySelector('.status-badge');

        statusBadge.className = 'status-badge ' + newStatus;

        // 텍스트 변경 로직
        if (newStatus === 'ACTIVE') statusBadge.textContent = '정상';
        else if (newStatus === 'BANNED') statusBadge.textContent = '정지';
        else if (newStatus === 'SUSPENDED') statusBadge.textContent = '일시정지';

        // 드롭다운 메뉴 닫기
        const menu = dropdown.querySelector('.status-dropdown-menu');
        if (menu) {
            menu.classList.remove('show');
        }

        // API 호출 데이터 구성
        const payload = {
            userId: userId,
            status: newStatus,
            extraData: extraData
        };

        // API 전송
        fetch('${pageContext.request.contextPath}/api/admin/users/status', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
            .then(response => response.json())
            .then(data => {
                if (data.result === 'success') {
                    alert('상태가 변경되었습니다.');
                    window.location.reload(); // 새로고침
                } else {
                    alert('상태 변경 실패');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 통신 중 오류가 발생했습니다.');
            });
    }


    // 일시정지 모달 열기
    function showSuspensionModal(element, status, userId) {
        targetElement = element.closest('.status-dropdown').querySelector('.status-dropdown-toggle');
        targetUserId = userId;

        const modal = document.getElementById('suspensionModal');
        modal.classList.add('show');

        element.closest('.status-dropdown-menu').classList.remove('show');

        document.getElementById('suspensionDays').value = 7;
        document.getElementById('suspensionReason').value = '';
    }

    // 일시정지 적용
    function applySuspension() {
        const days = document.getElementById('suspensionDays').value;
        const reason = document.getElementById('suspensionReason').value;

        if (!days || days < 1) {
            alert('정지 기간을 입력해주세요.');
            return;
        }

        console.log(targetElement, { days: days, reason: reason }, targetUserId);
        changeStatus(targetElement, 'SUSPENDED', { days: days, reason: reason }, targetUserId);

        closeSuspensionModal();
    }

    // 일시정지 모달 close
    function closeSuspensionModal() {
        const modal = document.getElementById('suspensionModal');
        modal.classList.remove('show');
        currentStatusElement = null;
    }





    // 상세 페이지 이동
    function goToDetail(userId) {
        alert('사용자 ID ' + userId + '의 상세 페이지로 이동합니다.\n(admin-user-detail.html?id=' + userId + ')');
        // window.location.href = 'admin-user-detail.html?id=' + userId;
    }

    // 페이지 로드 시 초기 목록 조회
    document.addEventListener('DOMContentLoaded', function () {
        loadUserList(1);
    });

    // 검색 버튼 클릭
    function searchUsers() {
        loadUserList(1);
    }

    // 엔터키 입력 시 검색
    document.getElementById('searchInput').addEventListener('keyup', function (e) {
        if (e.key === 'Enter') searchUsers();
    });

    // 필터 변경 시 자동 검색
    document.getElementById('filterStatus').addEventListener('change', () => loadUserList(1));
    document.getElementById('filterRole').addEventListener('change', () => loadUserList(1));
    document.getElementById('filterReports').addEventListener('change', () => loadUserList(1));

    // 실제 데이터를 가져와 렌더링하는 함수
    function loadUserList(page) {
        const keyword = document.getElementById('searchInput').value;
        const status = document.getElementById('filterStatus').value;
        const role = document.getElementById('filterRole').value;
        const reportFilter = document.getElementById('filterReports').value;

        // 쿼리 스트링 생성
        const params = new URLSearchParams({
            page: page,
            keyword: keyword,
            status: status,
            role: role,
            reportCount: reportFilter
        });

        fetch(`${pageContext.request.contextPath}/api/admin/users?` + params)
            .then(response => response.json())
            .then(data => {
                console.log(data);
                renderTable(data.userList);      // 테이블 그리기
                renderPagination(data.pageInfo); // 페이지네이션 그리기 (필요 시 구현)

                // 총 인원 수 업데이트
                document.querySelector('.table-count strong').innerText = data.totalCount;
            })
            .catch(error => {
                console.error('데이터 로드 실패:', error);
                alert('데이터를 불러오는 중 오류가 발생했습니다.');
            });
    }

    // 테이블 HTML 생성 함수
    function renderTable(users) {
        const tbody = document.getElementById('userTableBody');
        tbody.innerHTML = ''; // 기존 목록 비우기

        if (!users || users.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding: 2rem;">검색 결과가 없습니다.</td></tr>';
            return;
        }

        users.forEach(user => {
            // 역할 뱃지 스타일 결정
            const roleBadgeClass = user.role === 'ERRANDER' ? 'role-badge errander' : 'role-badge';

            // 상태 뱃지 스타일 결정
            let statusClass = 'ACTIVE';
            let statusText = '정상';
            if (user.status === 'BANNED') {
                statusClass = 'BANNED';
                statusText = '정지';
            } else if (user.status === 'SUSPENDED') {
                statusClass = 'SUSPENDED';
                statusText = '일시정지';
            }

            // 날짜 포맷팅 (예: 01-07 13:22)
            const lastLogin = user.last_login_at ? new Date(user.last_login_at).toLocaleString('ko-KR', {
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            }) : '-';

            const suspensionEnd = user.suspension_end_at ? new Date(user.suspension_end_at).toLocaleString('ko-KR', {
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            }) : '-';

            const row = `
            <tr>
                <td>${'${'}user.user_id}</td>
                <td>${'${'}user.email}</td>
                <td>${'${'}user.nickname}</td>
                <td><span class="${'${'}roleBadgeClass}">${'${'}user.role}</span></td>
                <td>
                    <div class="status-dropdown">
                        <button class="status-dropdown-toggle" onclick="toggleStatusDropdown(this)">
                            <span class="status-badge ${'${'}statusClass}">${'${'}statusText}</span>
                            <span>▼</span>
                        </button>
                        <div class="status-dropdown-menu">
                            <div class="status-dropdown-item" onclick="changeStatus(this, 'ACTIVE', null, ${'${'}user.user_id})">정상</div>
                            <div class="status-dropdown-item" onclick="showSuspensionModal(this, 'SUSPENDED', ${'${'}user.user_id})">일시정지</div>
                            <div class="status-dropdown-item" onclick="changeStatus(this, 'BANNED', null, ${'${'}user.user_id})">정지</div>
                        </div>
                    </div>
                </td>
                <td>${'${'}user.report_count || 0}</td>
                <td>${'${'}suspensionEnd}</td>
                <td>${'${'}lastLogin}</td>
                <td><button class="action-button" onclick="goToDetail(${'${'}user.user_id})">상세</button></td>
            </tr>
        `;
            tbody.innerHTML += row;
        });
    }

    // 페이지네이션 렌더링
    function renderPagination(pageInfo) {
        const pagination = document.querySelector('.pagination');
        pagination.innerHTML = ''; // 기존 버튼 제거

        const {currentPage, startPage, endPage, totalPage} = pageInfo;

        // 이전 버튼
        const prevBtn = document.createElement('button');
        prevBtn.className = 'pagination-button';
        prevBtn.innerText = '이전';

        if (currentPage > 1) {
            prevBtn.onclick = () => loadUserList(currentPage - 1);
        } else {
            prevBtn.disabled = true;
            prevBtn.classList.add('disabled');
        }
        pagination.appendChild(prevBtn);

        // 페이지 번호 버튼
        for (let i = startPage; i <= endPage; i++) {
            const btn = document.createElement('button');
            btn.className = 'pagination-button';
            btn.innerText = i;

            if (i === currentPage) {
                btn.classList.add('active');
            } else {
                btn.onclick = () => loadUserList(i);
            }

            pagination.appendChild(btn);
        }

        // 다음 버튼
        const nextBtn = document.createElement('button');
        nextBtn.className = 'pagination-button';
        nextBtn.innerText = '다음';

        if (currentPage < totalPage) {
            nextBtn.onclick = () => loadUserList(currentPage + 1);
        } else {
            nextBtn.disabled = true;
            nextBtn.classList.add('disabled');
        }

        pagination.appendChild(nextBtn);
    }
</script>
</body>

</html>