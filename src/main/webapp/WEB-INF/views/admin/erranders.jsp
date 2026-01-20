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
    <title>VROOM - 부름이 관리</title>
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

        .user-dropdown {
            display: none;
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
            display: block;
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

        .summary-subtitle {
            font-size: 0.875rem;
            font-weight: 600;
            margin-top: 0.5rem;
            color: var(--color-warm);
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

        /* Helper Table */
        .helper-table-section {
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

        .helper-table {
            width: 100%;
            border-collapse: collapse;
        }

        .helper-table thead {
            background-color: #F8F9FA;
        }

        .helper-table th {
            padding: 1rem;
            text-align: left;
            font-weight: 700;
            color: var(--color-dark);
            font-size: 0.875rem;
            border-bottom: 2px solid var(--color-light-gray);
        }

        .helper-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--color-light-gray);
            font-size: 0.9rem;
        }

        .helper-table tbody tr {
            transition: background-color 0.2s ease;
        }

        .helper-table tbody tr:hover {
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

        .status-badge.APPROVED {
            background: #E8F5E9;
            color: #27AE60;
        }

        .status-badge.PENDING {
            background: #FFF9E6;
            color: var(--color-accent);
        }

        .status-badge.REJECTED {
            background: #FDEAEA;
            color: #E74C3C;
        }

        .status-badge.ACTIVE {
            background: #E8F5E9;
            color: #27AE60;
        }

        .status-badge.INACTIVE {
            background: #F0F0F0;
            color: var(--color-gray);
        }

        .status-badge.SUSPENDED {
            background: #FDEAEA;
            color: #E74C3C;
        }

        /* Rating Display */
        .rating-display {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }

        .rating-stars {
            color: var(--color-secondary);
            font-size: 1rem;
        }

        .rating-value {
            font-weight: 700;
            color: var(--color-dark);
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

        .action-button.approve {
            background: linear-gradient(135deg, #27AE60 0%, #2ECC71 100%);
        }

        .action-button.approve:hover {
            box-shadow: 0 2px 4px rgba(39, 174, 96, 0.3);
        }

        /* Approval Modal */
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
            max-width: 600px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 9999;
        }

        .modal-header {
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid var(--color-light-gray);
        }

        .modal-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--color-dark);
        }

        .modal-body {
            margin-bottom: 1.5rem;
        }

        .modal-section {
            margin-bottom: 1.5rem;
        }

        .modal-section-title {
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            color: var(--color-dark);
            border-left: 4px solid var(--color-secondary);
            padding-left: 0.5rem;
        }

        .modal-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .modal-info-item {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }

        .modal-info-label {
            font-size: 0.8rem;
            color: var(--color-gray);
            font-weight: 600;
        }

        .modal-info-value {
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--color-dark);
        }

        .document-list {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .document-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem;
            background: #F8F9FA;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .document-item:hover {
            background: var(--color-light-gray);
        }

        .document-icon {
            font-size: 1.5rem;
            min-width: 40px;
            text-align: center;
        }

        .document-info {
            flex: 1;
        }

        .document-name {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--color-dark);
        }

        .document-type {
            font-size: 0.75rem;
            color: var(--color-gray);
        }

        .document-view-btn {
            padding: 0.375rem 0.75rem;
            background: var(--color-dark);
            color: var(--color-white);
            border: none;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .document-view-btn:hover {
            background: #1a252f;
        }

        .modal-footer {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            padding-top: 1rem;
            border-top: 2px solid var(--color-light-gray);
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

        .modal-button.approve {
            background: linear-gradient(135deg, #27AE60 0%, #2ECC71 100%);
            color: var(--color-white);
        }

        .modal-button.approve:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(39, 174, 96, 0.3);
        }

        .modal-button.reject {
            background: linear-gradient(135deg, #E74C3C 0%, #EC7063 100%);
            color: var(--color-white);
        }

        .modal-button.reject:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
        }

        .modal-button.cancel {
            background: var(--color-light-gray);
            color: var(--color-dark);
        }

        .modal-button.cancel:hover {
            background: #D5D8DC;
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

        .pagination-button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .summary-grid {
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            }

            .modal-info-grid {
                grid-template-columns: 1fr;
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

            .helper-table {
                font-size: 0.8rem;
            }

            .helper-table th,
            .helper-table td {
                padding: 0.5rem;
            }

            .modal {
                width: 95%;
                padding: 1.5rem;
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
                <img src="${pageContext.request.contextPath}/static/img/logo2.png" alt="VROOM" srcset="">
            </div>
            <button class="sidebar-toggle" id="sidebarToggle">☰</button>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
                <span class="nav-item-icon">📊</span>
                <span class="nav-item-text">대시보드</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                <span class="nav-item-icon">👥</span>
                <span class="nav-item-text">사용자 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/erranders" class="nav-item active">
                <span class="nav-item-icon">🏃</span>
                <span class="nav-item-text">부름이 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/assign" class="nav-item">
                <span class="nav-item-icon">📦</span>
                <span class="nav-item-text">주문/배차 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/issue" class="nav-item">
                <span class="nav-item-icon">⚠️</span>
                <span class="nav-item-text">신고/이슈 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/settlements" class="nav-item">
                <span class="nav-item-icon">💰</span>
                <span class="nav-item-text">정산 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/notice" class="nav-item">
                <span class="nav-item-icon">📢</span>
                <span class="nav-item-text">공지/컨텐츠 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item">
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
            <h2 class="page-title">부름이 관리</h2>

            <!-- Summary Section -->
            <section class="summary-section">
                <h3 class="summary-title">간단 요약 제공</h3>
                <div class="summary-grid">
                    <div class="summary-card">
                        <div class="summary-label">전체 부름이</div>
                        <div class="summary-value">${summary.total}명</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">활성 부름이</div>
                        <div class="summary-value">${summary.activated}명</div>
                        <div class="summary-subtitle">정지 ${summary.banned}명 | 승인 대기 ${summary.waiting}명</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">오늘 활동</div>
                        <div class="summary-value">${summary.today_activated}명</div>
                        <div class="summary-subtitle">최근 7일 활동 ${summary.recent7_activated}명</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">평균 완료율</div>
                        <div class="summary-value">${summary.avg_complete_rate}%</div>
                    </div>
                </div>
            </section>

            <!-- Search Section -->
            <section class="search-section">
                <h3 class="search-title">부름이 검색</h3>
                <div class="search-bar">
                    <input type="text" class="search-input" id="searchInput"
                           placeholder="부름이 검색 (ID/닉네임)">
                    <button class="search-button" onclick="searchHelpers()">🔍 검색</button>
                </div>

                <!-- Filters -->
                <div class="filter-row">
                    <div class="filter-group">
                        <label class="filter-label">승인상태</label>
                        <select class="filter-select" id="filterApprovalStatus" onchange="applyFilters()">
                            <option value="">전체</option>
                            <option value="APPROVED">승인</option>
                            <option value="PENDING">승인 대기</option>
                            <option value="REJECTED">반려</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label class="filter-label">활동상태</label>
                        <select class="filter-select" id="filterActivityStatus" onchange="applyFilters()">
                            <option value="">전체</option>
                            <option value="ACTIVE">활성</option>
                            <option value="INACTIVE">비활성</option>
                            <option value="SUSPENDED">일시정지</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label class="filter-label">평점 범위</label>
                        <select class="filter-select" id="filterRating" onchange="applyFilters()">
                            <option value="">전체</option>
                            <option value="5">⭐ 5.0</option>
                            <option value="4">⭐ 4.0 이상</option>
                            <option value="3">⭐ 3.0 이상</option>
                            <option value="2">⭐ 2.0 이상</option>
                        </select>
                    </div>
                </div>
            </section>

            <!-- Helper List Table -->
            <section class="helper-table-section">
                <div class="table-header">
                    <h3 class="table-title">부름이 목록 테이블</h3>
                    <span class="table-count">총 <strong id="totalCount">421</strong>명</span>
                </div>

                <table class="helper-table">
                    <thead>
                    <tr>
                        <th>ID | 닉네임</th>
                        <th>승인+활동</th>
                        <th>취소율</th>
                        <th>평점</th>
                        <th>최근 활동일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody id="helperTableBody">
                    <!-- 데이터는 JavaScript로 동적 렌더링 -->
                    </tbody>
                </table>

                <!-- Pagination -->
                <div class="pagination" id="pagination">
                    <!-- 페이지네이션 버튼은 JavaScript로 동적 생성 -->
                </div>
            </section>
        </main>
    </div>
</div>

<!-- Approval Modal -->
<div class="modal-overlay" id="approvalModal">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title">부름이 승인 관리</h3>
        </div>
        <div class="modal-body">
            <!-- 기본 정보 -->
            <div class="modal-section">
                <div class="modal-section-title">기본 정보</div>
                <div class="modal-info-grid">
                    <div class="modal-info-item">
                        <span class="modal-info-label">사용자 ID / 부름이 ID</span>
                        <span class="modal-info-value" id="modalHelperId">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">닉네임</span>
                        <span class="modal-info-value" id="modalNickname">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">이메일 / 휴대폰</span>
                        <span class="modal-info-value" id="modalContact">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">승인 상태(대기 / 승인 / 거절)</span>
                        <span class="modal-info-value" id="modalApprovalStatus">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">활동 상태(활성/비활성)</span>
                        <span class="modal-info-value" id="modalActivityStatus">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">부름이 승인일</span>
                        <span class="modal-info-value" id="modalApprovalDate">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">최근 활동일</span>
                        <span class="modal-info-value" id="modalLastActivity">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">활동 동네 1 / 2</span>
                        <span class="modal-info-value" id="modalRegions">-</span>
                    </div>
                </div>
            </div>

            <!-- 활동 요약 -->
            <div class="modal-section">
                <div class="modal-section-title">활동 요약 (한눈에 보기)</div>
                <div class="modal-info-grid">
                    <div class="modal-info-item">
                        <span class="modal-info-label">총 수락 건수</span>
                        <span class="modal-info-value" id="modalAcceptCount">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">원금 건수</span>
                        <span class="modal-info-value" id="modalCompleteCount">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">취소율</span>
                        <span class="modal-info-value" id="modalCancelRate">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">누적 수익</span>
                        <span class="modal-info-value" id="modalTotalEarning">-</span>
                    </div>
                </div>
            </div>

            <!-- 제출 서류 -->
            <div class="modal-section">
                <div class="modal-section-title">제출 서류</div>
                <div class="document-list" id="documentList">
                    <!-- 서류는 JavaScript로 동적 생성 -->
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="modal-button cancel" onclick="closeApprovalModal()">닫기</button>
            <button class="modal-button reject" onclick="rejectHelper()">반려</button>
            <button class="modal-button approve" onclick="approveHelper()">승인</button>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        // Sidebar Toggle
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');
        const adminDropdownTrigger = document.getElementById('adminDropdownTrigger');
        const adminDropdown = document.getElementById('adminDropdown');

        // 로컬스토리지에서 상태 불러오기
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

    // Mock Data - 실제로는 서버에서 가져올 데이터
    const mockHelpers = [
        {
            id: 'H001',
            nickname: '빠른배달왕',
            approvalStatus: 'APPROVED',
            activityStatus: 'ACTIVE',
            cancelRate: 2.5,
            rating: 4.8,
            lastActivity: '2026-01-20',
            email: 'helper1@example.com',
            phone: '010-1234-5678',
            approvalDate: '2025-12-01',
            region1: '강남구',
            region2: '서초구',
            acceptCount: 150,
            completeCount: 147,
            totalEarning: 1500000,
            documents: [
                {name: '신분증.jpg', type: '신분증', url: '#'},
                {name: '통장사본.pdf', type: '통장사본', url: '#'}
            ]
        },
        {
            id: 'H002',
            nickname: '친절부름이',
            approvalStatus: 'APPROVED',
            activityStatus: 'ACTIVE',
            cancelRate: 1.2,
            rating: 4.9,
            lastActivity: '2026-01-19',
            email: 'helper2@example.com',
            phone: '010-2345-6789',
            approvalDate: '2025-11-15',
            region1: '송파구',
            region2: '강동구',
            acceptCount: 200,
            completeCount: 198,
            totalEarning: 2100000,
            documents: [
                {name: '신분증_2.jpg', type: '신분증', url: '#'},
                {name: '계좌정보.pdf', type: '통장사본', url: '#'}
            ]
        },
        {
            id: 'H003',
            nickname: '신속심부름',
            approvalStatus: 'PENDING',
            activityStatus: 'INACTIVE',
            cancelRate: 0,
            rating: 0,
            lastActivity: '-',
            email: 'helper3@example.com',
            phone: '010-3456-7890',
            approvalDate: '-',
            region1: '마포구',
            region2: '서대문구',
            acceptCount: 0,
            completeCount: 0,
            totalEarning: 0,
            documents: [
                {name: 'id_card.jpg', type: '신분증', url: '#'},
                {name: 'bank_account.jpg', type: '통장사본', url: '#'}
            ]
        },
        {
            id: 'H004',
            nickname: '믿음직한',
            approvalStatus: 'APPROVED',
            activityStatus: 'SUSPENDED',
            cancelRate: 15.3,
            rating: 3.2,
            lastActivity: '2026-01-10',
            email: 'helper4@example.com',
            phone: '010-4567-8901',
            approvalDate: '2025-10-20',
            region1: '용산구',
            region2: '중구',
            acceptCount: 85,
            completeCount: 72,
            totalEarning: 850000,
            documents: [
                {name: '신분증_4.png', type: '신분증', url: '#'}
            ]
        },
        {
            id: 'H005',
            nickname: '성실부름이',
            approvalStatus: 'APPROVED',
            activityStatus: 'ACTIVE',
            cancelRate: 3.1,
            rating: 4.6,
            lastActivity: '2026-01-20',
            email: 'helper5@example.com',
            phone: '010-5678-9012',
            approvalDate: '2025-09-05',
            region1: '은평구',
            region2: '노원구',
            acceptCount: 120,
            completeCount: 116,
            totalEarning: 1200000,
            documents: [
                {name: '신분증.jpeg', type: '신분증', url: '#'},
                {name: '계좌.pdf', type: '통장사본', url: '#'}
            ]
        }
    ];

    let currentPage = 1;
    let filteredHelpers = [...mockHelpers];
    const itemsPerPage = 10;

    // 페이지 로드 시 초기 렌더링
    $(document).ready(function () {
        renderHelperTable(currentPage);
        renderPagination();
    });

    // 부름이 테이블 렌더링
    function renderHelperTable(page) {
        const tbody = document.getElementById('helperTableBody');
        tbody.innerHTML = '';

        const startIndex = (page - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;
        const pageData = filteredHelpers.slice(startIndex, endIndex);

        if (pageData.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 2rem;">검색 결과가 없습니다.</td></tr>';
            return;
        }

        pageData.forEach(helper => {
            const approvalBadgeClass = helper.approvalStatus;
            const approvalBadgeText = helper.approvalStatus === 'APPROVED' ? '승인' :
                helper.approvalStatus === 'PENDING' ? '승인대기' : '반려';

            const activityBadgeClass = helper.activityStatus;
            const activityBadgeText = helper.activityStatus === 'ACTIVE' ? '활성' :
                helper.activityStatus === 'INACTIVE' ? '비활성' : '일시정지';

            const stars = '⭐'.repeat(Math.floor(helper.rating));
            const ratingDisplay = helper.rating > 0 ?
                `<div class="rating-display"><span class="rating-stars">${'${'}stars}</span> <span class="rating-value">${'${'}helper.rating}</span></div>` :
                '-';

            const row = `
                <tr>
                    <td>${'${'}helper.id} / ${'${'}helper.nickname}</td>
                    <td>
                        <span class="status-badge ${'${'}approvalBadgeClass}">${'${'}approvalBadgeText}</span>
                        <span class="status-badge ${'${'}activityBadgeClass}">${'${'}activityBadgeText}</span>
                    </td>
                    <td>${'${'}helper.cancelRate}%</td>
                    <td>${'${'}ratingDisplay}</td>
                    <td>${'${'}helper.lastActivity}</td>
                    <td>
                        ${'${'}helper.approvalStatus} === 'PENDING' ?
                <button class="action-button approve" onclick="openApprovalModal('${'${'}helper.id}')">승인</button> :
                <button class="action-button" onclick="goToHelperDetail('${'${'}helper.id}')">관리</button>
            }
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        });

        // 총 개수 업데이트
        document.getElementById('totalCount').textContent = filteredHelpers.length;
    }

    // 페이지네이션 렌더링
    function renderPagination() {
        const pagination = document.getElementById('pagination');
        pagination.innerHTML = '';

        const totalPages = Math.ceil(filteredHelpers.length / itemsPerPage);

        // 이전 버튼
        const prevBtn = document.createElement('button');
        prevBtn.className = 'pagination-button';
        prevBtn.innerText = '이전';
        prevBtn.disabled = currentPage === 1;
        prevBtn.onclick = () => {
            if (currentPage > 1) {
                currentPage--;
                renderHelperTable(currentPage);
                renderPagination();
            }
        };
        pagination.appendChild(prevBtn);

        // 페이지 번호 버튼
        const startPage = Math.max(1, currentPage - 2);
        const endPage = Math.min(totalPages, currentPage + 2);

        for (let i = startPage; i <= endPage; i++) {
            const btn = document.createElement('button');
            btn.className = 'pagination-button';
            if (i === currentPage) {
                btn.classList.add('active');
            }
            btn.innerText = i;
            btn.onclick = () => {
                currentPage = i;
                renderHelperTable(currentPage);
                renderPagination();
            };
            pagination.appendChild(btn);
        }

        // 다음 버튼
        const nextBtn = document.createElement('button');
        nextBtn.className = 'pagination-button';
        nextBtn.innerText = '다음';
        nextBtn.disabled = currentPage === totalPages;
        nextBtn.onclick = () => {
            if (currentPage < totalPages) {
                currentPage++;
                renderHelperTable(currentPage);
                renderPagination();
            }
        };
        pagination.appendChild(nextBtn);
    }

    // 검색 기능
    function searchHelpers() {
        const searchValue = document.getElementById('searchInput').value.toLowerCase();
        filteredHelpers = mockHelpers.filter(helper =>
            helper.id.toLowerCase().includes(searchValue) ||
            helper.nickname.toLowerCase().includes(searchValue)
        );
        currentPage = 1;
        renderHelperTable(currentPage);
        renderPagination();
    }

    // Enter 키로 검색
    document.getElementById('searchInput').addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            searchHelpers();
        }
    });

    // 필터 적용
    function applyFilters() {
        const approvalStatus = document.getElementById('filterApprovalStatus').value;
        const activityStatus = document.getElementById('filterActivityStatus').value;
        const rating = document.getElementById('filterRating').value;
        const searchValue = document.getElementById('searchInput').value.toLowerCase();

        filteredHelpers = mockHelpers.filter(helper => {
            const matchesSearch = helper.id.toLowerCase().includes(searchValue) ||
                helper.nickname.toLowerCase().includes(searchValue);
            const matchesApproval = !approvalStatus || helper.approvalStatus === approvalStatus;
            const matchesActivity = !activityStatus || helper.activityStatus === activityStatus;
            const matchesRating = !rating || helper.rating >= parseInt(rating);

            return matchesSearch && matchesApproval && matchesActivity && matchesRating;
        });

        currentPage = 1;
        renderHelperTable(currentPage);
        renderPagination();
    }

    // 승인 모달 열기
    function openApprovalModal(helperId) {
        const helper = mockHelpers.find(h => h.id === helperId);
        if (!helper) return;

        // 모달에 데이터 채우기
        document.getElementById('modalHelperId').textContent = helper.id;
        document.getElementById('modalNickname').textContent = helper.nickname;
        document.getElementById('modalContact').textContent = `${'${'}helper.email} / ${'${'}helper.phone}`;
        document.getElementById('modalApprovalStatus').textContent =
            helper.approvalStatus === 'APPROVED' ? '승인' :
                helper.approvalStatus === 'PENDING' ? '승인 대기' : '반려';
        document.getElementById('modalActivityStatus').textContent =
            helper.activityStatus === 'ACTIVE' ? '활성' :
                helper.activityStatus === 'INACTIVE' ? '비활성' : '일시정지';
        document.getElementById('modalApprovalDate').textContent = helper.approvalDate;
        document.getElementById('modalLastActivity').textContent = helper.lastActivity;
        document.getElementById('modalRegions').textContent = `${'${'}helper.region1} / ${'${'}helper.region2}`;

        document.getElementById('modalAcceptCount').textContent = `${'${'}helper.acceptCount}건`;
        document.getElementById('modalCompleteCount').textContent = `${'${'}helper.completeCount}건`;
        document.getElementById('modalCancelRate').textContent = `${'${'}helper.cancelRate}%`;
        document.getElementById('modalTotalEarning').textContent = `${'${'}helper.totalEarning.toLocaleString()}원`;

        // 제출 서류 렌더링
        const documentList = document.getElementById('documentList');
        documentList.innerHTML = '';
        helper.documents.forEach(doc => {
            const docIcon = doc.type.includes('신분증') ? '🪪' : '📄';
            const docItem = `
                <div class="document-item">
                    <div class="document-icon">${'${'}docIcon}</div>
                    <div class="document-info">
                        <div class="document-name">${'${'}doc.name}</div>
                        <div class="document-type">${'${'}doc.type}</div>
                    </div>
                    <button class="document-view-btn" onclick="viewDocument('${'${'}doc.url}')">보기</button>
                </div>
            `;
            documentList.innerHTML += docItem;
        });

        // 현재 승인 중인 helper ID 저장
        document.getElementById('approvalModal').dataset.helperId = helperId;

        // 모달 표시
        document.getElementById('approvalModal').classList.add('show');
    }

    // 승인 모달 닫기
    function closeApprovalModal() {
        document.getElementById('approvalModal').classList.remove('show');
    }

    // 서류 보기
    function viewDocument(url) {
        // 실제로는 새 창에서 문서를 열거나 뷰어를 표시
        alert('서류 보기 기능 (실제로는 파일 뷰어 또는 다운로드)');
        console.log('Document URL:', url);
    }

    // 부름이 승인
    function approveHelper() {
        const helperId = document.getElementById('approvalModal').dataset.helperId;
        // 실제로는 서버에 승인 요청
        console.log('부름이 승인:', helperId);
        alert(`부름이 ID: ${'${'}helperId}를 승인했습니다.`);

        // Mock 데이터 업데이트
        const helper = mockHelpers.find(h => h.id === helperId);
        if (helper) {
            helper.approvalStatus = 'APPROVED';
            helper.activityStatus = 'ACTIVE';
            helper.approvalDate = new Date().toISOString().split('T')[0];
        }

        closeApprovalModal();
        applyFilters(); // 테이블 새로고침
    }

    // 부름이 반려
    function rejectHelper() {
        const helperId = document.getElementById('approvalModal').dataset.helperId;
        const reason = prompt('반려 사유를 입력하세요:');
        if (!reason) return;

        // 실제로는 서버에 반려 요청
        console.log('부름이 반려:', helperId, '사유:', reason);
        alert(`부름이 ID: ${'${'}helperId}를 반려했습니다.\n사유: ${'${'}reason}`);

        // Mock 데이터 업데이트
        const helper = mockHelpers.find(h => h.id === helperId);
        if (helper) {
            helper.approvalStatus = 'REJECTED';
        }

        closeApprovalModal();
        applyFilters(); // 테이블 새로고침
    }

    // 부름이 상세 페이지로 이동
    function goToHelperDetail(helperId) {
        // 실제로는 상세 페이지로 라우팅
        console.log('부름이 상세 페이지:', helperId);
        window.location.href = `${'${'}pageContext.request.contextPath}/admin/helpers/${'${'}helperId}`;
    }

    // 모달 외부 클릭 시 닫기
    document.getElementById('approvalModal').addEventListener('click', function (e) {
        if (e.target === this) {
            closeApprovalModal();
        }
    });
</script>
</body>

</html>
