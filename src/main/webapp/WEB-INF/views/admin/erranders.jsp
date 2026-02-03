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
    <script src="${pageContext.request.contextPath}/static/common/util.js"></script>
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
            color: #e77e3c;
        }

        .status-badge.BANNED {
            background: #E74C3C;
            color: #FFFFFF;
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
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0;
        }

        .status-dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            background-color: var(--color-white);
            min-width: 120px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border-radius: 8px;
            overflow: hidden;
            z-index: 100;
            margin-top: 0.5rem;
        }

        .status-dropdown-menu.show {
            display: block;
        }

        .status-dropdown-item {
            padding: 0.75rem 1rem;
            cursor: pointer;
            transition: background 0.2s;
            font-size: 0.9rem;
        }

        .status-dropdown-item:hover {
            background-color: var(--color-light-gray);
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
            display: flex;
            flex-direction: column;
            overflow: hidden;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 9999;
        }

        .modal-header {
            padding: 1rem 0.5rem;
            flex-shrink: 0;
            border-bottom: 2px solid var(--color-light-gray);
            margin-bottom: 0;
        }

        .modal-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--color-dark);
        }

        .modal-body {
            flex: 1;
            overflow-y: auto;
            min-height: 0;

            padding: 1.5rem 2rem;
            margin-bottom: 0;
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
            padding: 1rem 0.5rem 0rem 0.5rem;
            flex-shrink: 0;
            border-top: 2px solid var(--color-light-gray);
            margin-top: 0;
            align-items: center;
            gap: 1rem;
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
            margin-right: auto;
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
            <a href="${pageContext.request.contextPath}/admin/errands" class="nav-item">
                <span class="nav-item-icon">📦</span>
                <span class="nav-item-text">심부름/배정 관리</span>
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
                    <button class="search-button" onclick="searchErranders()">🔍 검색</button>
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
                        <th>승인</th>
                        <th>상태</th>
                        <th>완료율</th>
                        <th>평점</th>
                        <th>승인일자</th>
                        <th>최근 활동일</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody id="helperTableBody">
                    </tbody>
                </table>

                <!-- Pagination -->
                <div class="pagination" id="pagination"> 
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
                        <span class="modal-info-value" id="modalUserId">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">닉네임</span>
                        <span class="modal-info-value" id="modalNickname">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">이메일</span>
                        <span class="modal-info-value" id="modalContactEmail">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">휴대폰</span>
                        <span class="modal-info-value" id="modalContactPhone">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">활동 상태(활성/비활성)</span>
                        <span class="modal-info-value" id="modalActivityStatus">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">최근 활동일</span>
                        <span class="modal-info-value" id="modalLastActivity">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">활동 동네 1</span>
                        <span class="modal-info-value" id="modalRegions1">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">활동 동네 2</span>
                        <span class="modal-info-value" id="modalRegions2">-</span>
                    </div>
                </div>
            </div>

            <!-- 제출 서류 -->
            <div class="modal-section">
                <div class="modal-section-title">제출 서류</div>
                <div class="document-list" id="documentList">
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="modal-button cancel" onclick="closeApprovalModal()">닫기</button>
            <button class="modal-button reject" onclick="rejectHelper()">반려</button>
            <button class="modal-button approve" onclick="approveErrander()">승인</button>
        </div>
    </div>
</div>

<script>
    // 전역 변수
    let currentErranderId = null; // 승인/반려 모달용 ID 저장

    $(document).ready(function ()  {
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');
        const adminDropdownTrigger = document.getElementById('adminDropdownTrigger');
        const adminDropdown = document.getElementById('adminDropdown');

        // 로컬스토리지 상태 적용
        const savedState = localStorage.getItem('sidebarState');
        if (savedState === 'collapsed') {
            sidebar.classList.add('collapsed');
        }

        // 사이드바 토글
        sidebarToggle.addEventListener('click', function (e) {
            e.stopPropagation();
            sidebar.classList.toggle('collapsed');
            localStorage.setItem('sidebarState', sidebar.classList.contains('collapsed') ? 'collapsed' : 'expanded');
        });

        // 관리자 드롭다운
        adminDropdownTrigger.addEventListener('click', function (e) {
            e.stopPropagation();
            adminDropdown.classList.toggle('show');
        });

        window.addEventListener('click', function () {
            if (adminDropdown.classList.contains('show')) {
                adminDropdown.classList.remove('show');
            }
        });

        // 메뉴 활성화
        const currentPath = window.location.hash || '#erranders'; // URL에 맞게 조정
        $('.nav-item').each(function () {
            if ($(this).attr('href').includes('erranders')) {
                $(this).addClass('active');
            } else {
                $(this).removeClass('active');
            }
        });

        // 초기 데이터 로드
        loadErranderList(1);

        // 이벤트 리스너
        // 검색 (엔터키 & 버튼)
        document.querySelector('.search-button').addEventListener('click', () => loadErranderList(1));
        document.getElementById('searchInput').addEventListener('keyup', function (e) {
            if (e.key === 'Enter') loadErranderList(1);
        });

        // 필터 변경 시 자동 검색
        document.getElementById('filterApprovalStatus').addEventListener('change', () => loadErranderList(1));
        document.getElementById('filterActivityStatus').addEventListener('change', () => loadErranderList(1));
        document.getElementById('filterRating').addEventListener('change', () => loadErranderList(1));
    });

    //  부름이 목록 조회
    function loadErranderList(page) {
        const keyword = document.getElementById('searchInput').value;
        const approveStatus = document.getElementById('filterApprovalStatus').value;
        const activeStatus = document.getElementById('filterActivityStatus').value;
        const reviewScope = document.getElementById('filterRating').value;

        // Query String 생성
        const params = new URLSearchParams({
            page: page,
            keyword: keyword,
            approveStatus: approveStatus,
            activeStatus: activeStatus,
            reviewScope: reviewScope
        });

        fetch('${pageContext.request.contextPath}/api/admin/erranders?' + params)
            .then(response => response.json())
            .then(data => {
                // data = { userList: [...], totalCount: 123, pageInfo: {...} }
                renderTable(data.userList);       // 테이블 그리기
                renderPagination(data.pageInfo);  // 페이지네이션 그리기

                // 총 개수 업데이트
                document.getElementById('totalCount').innerText = data.totalCount;
            })
            .catch(error => {
                console.error('데이터 로드 실패:', error);
                // alert('데이터를 불러오는 중 오류가 발생했습니다.');
            });
    }

    // 테이블 HTML 렌더링
    function renderTable(list) {
        const tbody = document.getElementById('helperTableBody');
        tbody.innerHTML = ''; // 초기화

        if (!list || list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 2rem;">검색 결과가 없습니다.</td></tr>';
            return;
        }

        list.forEach(item => {
            const erranderId = item.errander_id;
            const nickname = item.nickname;
            const approvalStatus = item.approval_status;
            const activeStatus = item.active_status;
            const completeRate = item.complete_rate || 0;
            const ratingAvg = item.rating_avg || 0;

            // 날짜 포맷팅 (Timestamp -> YYYY-MM-DD)
            let lastActive = '-';
            if (item.last_active_at) {
                lastActive = formatDateTime(item.last_active_at);
            }

            let approvedAt = '-';
            if (item.approved_at) {
                approvedAt = formatDate(item.approved_at);
            }

            // 배지 텍스트 및 클래스 설정
            let approvalText = approvalStatus === 'APPROVED' ? '승인' : (approvalStatus === 'PENDING' ? '승인대기' : '반려');
            let activityText = '-';
            if (activeStatus === 'ACTIVE') activityText = '활성';
            else if (activeStatus === 'INACTIVE') activityText = '비활성';
            else if (activeStatus === 'SUSPENDED') activityText = '일시정지';
            else if (activeStatus === 'BANNED') activityText = '정지';

            // 별점 표시
            const stars = '⭐'.repeat(Math.floor(ratingAvg));
            const ratingDisplay = ratingAvg > 0 ?
                `<div class="rating-display"><span class="rating-stars">\${stars}</span> <span class="rating-value">\${ratingAvg}</span></div>` : '-';

            // 활동 상태 드롭다운 HTML 생성
            const activityStatusHtml = `
                <div class="status-dropdown">
                    <button class="status-dropdown-toggle" onclick="toggleActivityStatusDropdown(this, event)">
                        <span class="status-badge \${activeStatus}">\${activityText}</span>
                        <span>▼</span>
                    </button>
                    <div class="status-dropdown-menu">
                        <div class="status-dropdown-item" onclick="changeActivityStatus(this, 'ACTIVE', \${erranderId}, event)">활성</div>
                        <div class="status-dropdown-item" onclick="changeActivityStatus(this, 'INACTIVE', \${erranderId}, event)">비활성</div>
                        <div class="status-dropdown-item" onclick="changeActivityStatus(this, 'SUSPENDED', \${erranderId}, event)">일시정지</div>
                        <div class="status-dropdown-item" onclick="changeActivityStatus(this, 'BANNED', \${erranderId}, event)">정지</div>
                    </div>
                </div>
            `;

            // 액션 버튼 (승인 대기중이면 승인버튼, 아니면 관리버튼)
            let actionBtnHtml = '';
            if (approvalStatus === 'APPROVED') {
                actionBtnHtml = `<button class="action-button" onclick="goToDetail(\${erranderId})">관리</button>`;
            } else {
                // 승인 모달 열기
                actionBtnHtml = `<button class="action-button approve" onclick="openApprovalModal(\${erranderId})">승인</button>`;
            }

            const row = `
                <tr>
                    <td>\${erranderId} / \${nickname}</td>
                    <td><span class="status-badge \${approvalStatus}">\${approvalText}</span></td>
                    <td>\${activityStatusHtml}</td>
                    <td>\${completeRate}%</td>
                    <td>\${ratingDisplay}</td>
                    <td>\${approvedAt}</td>
                    <td>\${lastActive}</td>
                    <td>\${actionBtnHtml}</td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    }

    //  페이지네이션 렌더링
    function renderPagination(pageInfo) {
        const pagination = document.getElementById('pagination');
        pagination.innerHTML = '';

        if (!pageInfo) return;

        const { currentPage, startPage, endPage, totalPage } = pageInfo;

        // 이전 버튼
        const prevBtn = document.createElement('button');
        prevBtn.className = 'pagination-button';
        prevBtn.innerText = '이전';
        if (currentPage > 1) {
            prevBtn.onclick = () => loadErranderList(currentPage - 1);
        } else {
            prevBtn.disabled = true;
            prevBtn.classList.add('disabled');
        }
        pagination.appendChild(prevBtn);

        // 번호 버튼
        for (let i = startPage; i <= endPage; i++) {
            const btn = document.createElement('button');
            btn.className = 'pagination-button';
            btn.innerText = i;
            if (i === currentPage) {
                btn.classList.add('active');
            } else {
                btn.onclick = () => loadErranderList(i);
            }
            pagination.appendChild(btn);
        }

        // 다음 버튼
        const nextBtn = document.createElement('button');
        nextBtn.className = 'pagination-button';
        nextBtn.innerText = '다음';
        if (currentPage < totalPage) {
            nextBtn.onclick = () => loadErranderList(currentPage + 1);
        } else {
            nextBtn.disabled = true;
            nextBtn.classList.add('disabled');
        }
        pagination.appendChild(nextBtn);
    }

    //  기타 기능 (모달, 이동 등)

    // 상세 페이지 이동
    function goToDetail(erranderId) {
        window.location.href = '${pageContext.request.contextPath}/admin/erranders/detail/' + erranderId;
    }

    // 승인 모달 열기
    function openApprovalModal(erranderId) {
        currentErranderId = erranderId;

        fetch('${pageContext.request.contextPath}/api/admin/erranders/resume?id=' + erranderId)
            .then(res => {
                if (!res.ok) {
                    throw new Error('서버 응답 에러: ' + res.status);
                }
                return res.json();
            })
            .then(data => {
                // 사용자 id, 심부름 id, 닉네임, 이메일, 휴대폰, 활동 상태, 최근활동일, 활동 동네, 제출 서류
                console.log(data);

                // UI 값 채우기 (목록에 없는 상세 정보는 별도 API 호출 필요)
                document.getElementById('modalUserId').textContent = data.user_id + ' / ' + erranderId;
                // document.getElementById('modalErranderId').textContent = data.errandId;
                document.getElementById('modalNickname').textContent = data.nickname;
                document.getElementById('modalContactPhone').textContent = data.phone || '-';
                document.getElementById('modalContactEmail').textContent = data.email || '-';
                document.getElementById('modalActivityStatus').textContent = data.status || '-';
                document.getElementById('modalLastActivity').textContent = formatDateTime(data.last_login_at);
                document.getElementById('modalRegions1').textContent = data.address1 || '-';
                document.getElementById('modalRegions2').textContent = data.address2 || '-';

                // 제출 서류 렌더링
                const documentList = document.getElementById('documentList');
                documentList.innerHTML = '';
                data.documents.forEach(doc => {
                    let docIcon = '';
                    let docText = '';
                    switch (doc.doc_type){
                        case 'IDCARD':
                            docIcon = '💳';
                            docText = '주민등록증';
                            break;
                        case 'PASSPORT':
                            docIcon = '💷';
                            docText = '여권';
                            break;
                        case 'DRIVER_LICENSE':
                            docIcon = '🚗';
                            docText = '운전면허증';
                            break;
                        case 'ACCOUNT':
                            docIcon = '📄';
                            docText = '통장사본';
                            break;
                        default:
                            docIcon = '📁';
                            docText = '기타';
                            break;
                    }
                    const docItem = `
                        <div class="document-item">
                            <div class="document-icon">${'${'}docIcon}</div>
                            <div class="document-info">
                                <div class="document-type">${'${'}docText}</div>
                            </div>
                            <button class="document-view-btn" onclick="viewDocument('${'${'}doc.file_url}')">보기</button>
                        </div>
                    `;
                    documentList.innerHTML += docItem;
                });
                // 나머지 필드는 목록 API에서 가져오지 않았다면 '로딩중' 또는 '-' 처리
            })
            .catch(error => {
                console.error('데이터 로드 실패:', error);
                // alert('데이터를 불러오는 중 오류가 발생했습니다.');
            });


        document.getElementById('approvalModal').dataset.helperId = erranderId;
        document.getElementById('approvalModal').classList.add('show');


    }

    function closeApprovalModal() {
        document.getElementById('approvalModal').classList.remove('show');
    }

    // 모달 외부 클릭 닫기
    document.getElementById('approvalModal').addEventListener('click', function (e) {
        if (e.target === this) closeApprovalModal();
    });

    // 승인 처리
    function approveErrander() {
        if(!confirm(' 부름이 ID: ' + currentErranderId + '을 승인하시겠습니까?')) return;

        fetch('${pageContext.request.contextPath}/api/admin/erranders/approve', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                erranderId: currentErranderId,
                status: "APPROVED",
                reason: ""
            })
        })
            .then(res => res.json())
            .then(data => {
                if(data.result === 'success'){
                    alert('승인되었습니다.');
                    window.location.reload();
                }
                else {
                    alert('승인 처리 실패했습니다: ' + data.message);
                }

            });

        closeApprovalModal(); // 목록 갱신
    }

    // 반려 처리
    function rejectHelper() {
        const helperId = document.getElementById('approvalModal').dataset.helperId;
        const reason = prompt('반려 사유를 입력하세요:');
        if (!reason) return;

        fetch('${pageContext.request.contextPath}/api/admin/erranders/approve', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                erranderId: currentErranderId,
                status: "REJECTED",
                reason: reason
            })
        })
            .then(res => res.json())
            .then(data => {
                if(data.result === 'success'){
                    alert('반려되었습니다.');
                    window.location.reload();
                }
                else {
                    alert('처리 실패했습니다: ' + data.message);
                }

            });

        closeApprovalModal();
    }

    function viewDocument(url) {
        if (!url) {
            alert('파일 경로가 존재하지 않습니다.');
            return;
        }
        // 새 창에서 해당 URL 열람
        url = '${pageContext.request.contextPath}' + '/' + url;
        window.open(url, '_blank');
    }

    // 활동 상태 드롭다운 토글
    function toggleActivityStatusDropdown(button, event) {
        event.stopPropagation();
        const dropdown = button.nextElementSibling;

        // 다른 열려있는 드롭다운 닫기
        document.querySelectorAll('.status-dropdown-menu.show').forEach(menu => {
            if (menu !== dropdown) {
                menu.classList.remove('show');
            }
        });

        dropdown.classList.toggle('show');
    }

    // 활동 상태 변경
    function changeActivityStatus(item, newStatus, erranderId, event) {
        event.stopPropagation();

        let statusText = '';
        switch(newStatus) {
            case 'ACTIVE': statusText = '활성'; break;
            case 'INACTIVE': statusText = '비활성'; break;
            case 'SUSPENDED': statusText = '일시정지'; break;
            case 'BANNED': statusText = '정지'; break;
            default: statusText = newStatus;
        }

        <%--if (!confirm('부름이 ID: \${erranderId}의 활동 상태를 ${statusText}(으)로 변경하시겠습니까?')) {--%>
        <%--    return;--%>
        <%--}--%>

        // API 호출
        fetch('${pageContext.request.contextPath}/api/admin/erranders/status', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                erranderId: erranderId,
                activeStatus: newStatus
            })
        })
            .then(res => res.json())
            .then(data => {
                if (data.result === 'success') {
                    alert('활동 상태가 변경되었습니다.');
                    window.location.reload();
                } else {
                    alert('상태 변경에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('상태 변경 실패:', error);
                alert(error);
                loadErranderList(1);
            });

        // 드롭다운 닫기
        item.closest('.status-dropdown-menu').classList.remove('show');
    }

    // 전역 클릭 이벤트로 드롭다운 닫기
    document.addEventListener('click', function() {
        document.querySelectorAll('.status-dropdown-menu.show').forEach(menu => {
            menu.classList.remove('show');
        });
    });
</script>
</body>

</html>