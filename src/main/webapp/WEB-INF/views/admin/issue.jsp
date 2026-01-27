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
    <title>VROOM - 신고 관리</title>
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
        .table-section {
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

        .errand-table {
            width: 100%;
            border-collapse: collapse;
        }

        .errand-table thead {
            background-color: #F8F9FA;
        }

        .errand-table th {
            padding: 1rem;
            text-align: left;
            font-weight: 700;
            color: var(--color-dark);
            font-size: 0.875rem;
            border-bottom: 2px solid var(--color-light-gray);
        }

        .errand-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--color-light-gray);
            font-size: 0.9rem;
        }

        .errand-table tbody tr {
            transition: background-color 0.2s ease;
        }

        .errand-table tbody tr:hover {
            background-color: #F8F9FA;
        }

        .modal-info-full {
            margin-top: 12px;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .modal-textarea {
            width: 100%;
            min-height: 120px;
            resize: none;

            padding: 12px;
            font-size: 0.9rem;
            line-height: 1.5;

            border: 1px solid var(--color-light-gray);
            border-radius: 8px;
            background-color: #f9fafb;

            color: #333;
        }

        .modal-textarea:focus {
            outline: none;
            border-color: var(--color-primary);
            background-color: #fff;
        }

        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-badge.WAITING {
            background: #E8F5E9;
            color: #27AE60;
        }

        .status-badge.MATCHED {
            background: #FFF9E6;
            color: var(--color-accent);
        }

        .status-badge.HOLD {
            background: #FDEAEA;
            color: #E74C3C;
        }

        .status-badge.CONFIRMED1 {
            background: #E8F5E9;
            color: #27AE60;
        }

        .status-badge.COMPLETED {
            background: #F0F0F0;
            color: var(--color-gray);
        }

        .status-badge.CONFIRMED2 {
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

            .errand-table {
                font-size: 0.8rem;
            }

            .errand-table th,
            .errand-table td {
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
            <a href="${pageContext.request.contextPath}/admin/erranders" class="nav-item">
                <span class="nav-item-icon">🏃</span>
                <span class="nav-item-text">부름이 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/errands" class="nav-item">
                <span class="nav-item-icon">📦</span>
                <span class="nav-item-text">심부름/배정 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/issue" class="nav-item active">
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
            <h2 class="page-title">신고/이슈 관리</h2>

            <!-- Summary Section -->
            <section class="summary-section">
                <h3 class="summary-title">간단 요약 제공</h3>
                <div class="summary-grid">
                    <div class="summary-card">
                        <div class="summary-label">오늘 접수된 이슈</div>
                        <div class="summary-value">${summary.today_received}</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">처리 대기 이슈</div>
                        <div class="summary-value">${summary.waiting}</div>
                        <div class="summary-subtitle">처리 완료 이슈 | ${summary.resolved} </div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">긴급 이슈</div>
                        <div class="summary-value">${summary.emergency}</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">신고/이슈 유형별 건수</div>
                        <div class="summary-value">-</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">평균 처리 시간</div>
                        <div class="summary-value">${summary.avg_resolution_time}</div>
                    </div>
                </div>
            </section>

            <!-- Search Section -->
            <section class="search-section">
                <h3 class="search-title">신고이슈 검색</h3>
                <div class="search-bar">
                    <input type="text" class="search-input" id="searchInput"
                           placeholder="검색어 입력 (이슈ID, 제목, 신고자ID)">
                    <button class="search-button" onclick="loadIssueList(1)">🔍 검색</button>
                </div>

                <div class="filter-row">
                    <div class="filter-group">
                        <label class="filter-label">이슈 분류</label>
                        <div style="display: flex; gap: 0.5rem;">
                            <select id="filterType" class="filter-select" onchange="loadContentList(1)">
                                <option value="">유형 전체</option>
                                <option value="USER_REPORT">사용자 신고</option>
                                <option value="ERRANDER_REPORT">부름이 신고</option>
                                <option value="COMPLAINT">편의개선</option>
                                <option value="SETTLEMENT">정산 문의</option>
                                <option value="SYSTEM">시스템 오류</option>
                                <option value="ETC">기타</option>
                            </select>

                            <select id="filterStatus" class="filter-select" onchange="loadContentList(1)">
                                <option value="">상태 전체</option>
                                <option value="RECEIVED">접수</option>
                                <option value="IN_PROGRESS">처리중</option>
                                <option value="RESOLVED">완료</option>
                                <option value="HOLD">보류</option>
                            </select>

                            <select id="filterPriority" class="filter-select" onchange="loadContentList(1)">
                                <option value="">우선순위 전체</option>
                                <option value="HIGH">긴급</option>
                                <option value="MEDIUM">보통</option>
                                <option value="LOW">낮음</option>
                            </select>
                        </div>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label">접수 기간</label>
                        <div style="display: flex; align-items: center; gap: 0.5rem;">
                            <input type="date" id="regStartDate" class="filter-select" onchange="loadContentList(1)">
                            <span>~</span>
                            <input type="date" id="regEndDate" class="filter-select" onchange="loadContentList(1)">
                        </div>
                    </div>
                </div>
            </section>


            <!-- Helper List Table -->
            <section class="table-section">
                <div class="table-header">
                    <h3 class="table-title">신고이슈 목록 테이블</h3>
                    <span class="table-count">총 <strong id="totalCount">0</strong>건</span>
                </div>

                <table class="errand-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>유형</th>
                        <th>신고인ID</th>
                        <th>피신고인ID</th>
                        <th>상태</th>
                        <th>우선순위</th>
                        <th>접수일</th>
                        <th>처리</th>
                    </tr>
                    </thead>
                    <tbody id="TableBody">
                    </tbody>
                </table>

                <!-- Pagination -->
                <div class="pagination" id="pagination">
                </div>
            </section>
        </main>
    </div>
</div>

<!-- Assignment Modal -->
<div class="modal-overlay" id="assignModal">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title">심부름 배정</h3>
        </div>
        <div class="modal-body">
            <div class="modal-section">
                <div class="modal-section-title">작성자 정보</div>
                <div class="modal-info-grid" id="errandSummaryGrid">
                    <div class="modal-info-item">
                        <span class="modal-info-label">작성자 ID</span>
                        <span class="modal-info-value" id="modalUserId">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">작성자 닉네임</span>
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


                </div>
                <br>
                <div class="modal-section-title">심부름 정보</div>
                <div class="modal-info-grid">
                    <div class="modal-info-item">
                        <span class="modal-info-label">심부름 ID</span>
                        <span class="modal-info-value" id="summaryErrandId">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">제목</span>
                        <span class="modal-info-value" id="summaryTitle">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">등록일</span>
                        <span class="modal-info-value" id="summaryUploadDate">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">희망일</span>
                        <span class="modal-info-value" id="summaryDesiredDate">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">심부름값 / 재료비</span>
                        <span class="modal-info-value" id="summaryRewardAmount">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">위치</span>
                        <span class="modal-info-value" id="summaryLocation">-</span>
                    </div>
                </div>

                <div class="modal-info-full">
                    <label class="modal-info-label">심부름 내용</label>
                    <textarea
                            id="summaryContent"
                            class="modal-textarea"
                            readonly
                    ></textarea>
                </div>
            </div>

            <div class="modal-section" id="assignActionSection" style="display:none;">
                <div class="modal-section-title">정직원 부름이 배정</div>
                <div class="search-bar" style="margin-bottom: 10px;">
                    <input type="text" class="search-input" id="erranderSearch" placeholder="부름이 닉네임 검색">
                </div>
                <div style="max-height: 200px; overflow-y: auto; border: 1px solid var(--color-light-gray);">
                    <table class="errand-table" style="font-size: 0.8rem;">
                        <thead>
                        <tr>
                            <th>ID/닉네임</th>
                            <th>상태</th>
                            <th>오늘 배정</th>
                            <th>최근 배정</th>
                            <th>선택</th>
                        </tr>
                        </thead>
                        <tbody id="availableErranderList"></tbody>
                    </table>
                </div>
                <div class="filter-group" style="margin-top: 15px;">
                    <label class="filter-label">배정 사유</label>
                    <input type="text" id="assignReason" class="search-input" placeholder="사유 입력">
                </div>
            </div>

            <div class="modal-section" id="assignedInfoSection" style="display:none;">
                <div class="modal-section-title">배정 정보</div>
                <div class="modal-info-grid">
                    <div class="modal-info-item">
                        <span class="modal-info-label">배정된 부름이</span>
                        <span class="modal-info-value" id="infoErrander">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">배정 시각</span>
                        <span class="modal-info-value" id="infoAssignedAt">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">배정 사유</span>
                        <span class="modal-info-value" id="infoReason">-</span>
                    </div>
                    <div class="modal-info-item">
                        <span class="modal-info-label">배정자(관리자)</span>
                        <span class="modal-info-value" id="infoAdmin">-</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal-footer">
            <button class="modal-button cancel" onclick="closeAssignModal()">닫기</button>
            <button class="modal-button approve" onclick="approveErrander()">승인</button>
        </div>
    </div>
</div>

</body>
<script>
    let currentErrandsId = null; // 승인/반려 모달용 ID 저장

    $(document).ready(function () {
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');
        const adminDropdownTrigger = document.getElementById('adminDropdownTrigger');
        const adminDropdown = document.getElementById('adminDropdown');

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
        const currentPath = window.location.hash || '#issue'; // URL에 맞게 조정
        $('.nav-item').each(function () {
            if ($(this).attr('href').includes('issue')) {
                $(this).addClass('active');
            } else {
                $(this).removeClass('active');
            }
        });

        // 초기 데이터 로드
        loadContentList(1);

        // 이벤트 리스너
        // 검색 (엔터키 & 버튼)
        document.querySelector('.search-button').addEventListener('click', () => loadContentList(1));
        document.getElementById('searchInput').addEventListener('keyup', function (e) {
            if (e.key === 'Enter') loadContentList(1);
        });

    });

    //  목록 조회
    function loadContentList(page) {
        const keyword = document.getElementById('searchInput').value;
        const type = document.getElementById('filterType').value;       // 유형
        const status = document.getElementById('filterStatus').value;   // 상태
        const priority = document.getElementById('filterPriority').value; // 우선순위

        const regStart = document.getElementById('regStartDate').value; // 시작일
        const regEnd = document.getElementById('regEndDate').value;     // 종료일

        // 파라미터 구성
        const params = new URLSearchParams({
            page: page,
            keyword: keyword,
            type: type,
            status: status,
            priority: priority,
            regStart: regStart,
            regEnd: regEnd
        });

        // API 호출
        fetch(`${pageContext.request.contextPath}/api/admin/issues/search?` + params)
            .then(response => response.json())
            .then(data => {
                renderTable(data.issueList);      // 테이블 렌더링
                renderPagination(data.pageInfo);  // 페이지네이션 렌더링
                document.getElementById('totalCount').innerText = data.totalCount; // 총 건수
            })
            .catch(error => {
                console.error('데이터 로드 실패:', error);
                alert('이슈 데이터를 불러오는 중 오류가 발생했습니다.');
            });
    }

    // 테이블 HTML 렌더링
    function renderTable(list) {
        const tbody = document.getElementById('TableBody');
        tbody.innerHTML = '';

        if (!list || list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; padding: 2rem;">검색 결과가 없습니다.</td></tr>';
            return;
        }

        list.forEach(item => {
            // 날짜 포맷팅
            let regDate = '-';
            if (item.created_at) {
                regDate = new Date(item.created_at).toISOString().split('T')[0];
            }

            // 상태(Status) 텍스트 및 배지 클래스
            let statusClass = item.status === 'RECEIVED' ? 'CONFIRMED1' :
                item.status === 'RESOLVED' ? 'COMPLETED' :
                    item.status === 'HOLD' ? 'HOLD' : 'WAITING';

            let statusText = item.status;
            if(item.status === 'RECEIVED') statusText = '접수';
            else if(item.status === 'IN_PROGRESS') statusText = '처리중';
            else if(item.status === 'RESOLVED') statusText = '완료';
            else if(item.status === 'HOLD') statusText = '보류';

            // 우선순위(Priority) 텍스트 및 배지 클래스 설정
            let priorityText = '낮음';
            let priorityClass = 'COMPLETED'; // 기본: 회색

            if (item.priority === 'HIGH') {
                priorityText = '긴급';
                priorityClass = 'BANNED'; // 빨강
            } else if (item.priority === 'MEDIUM') {
                priorityText = '보통';
                priorityClass = 'MATCHED'; // 노랑
            }

            // 우선순위 커스텀 드롭다운 HTML 생성
            const priorityHtml = `
            <div class="status-dropdown">
                <button class="status-dropdown-toggle" onclick="togglePriorityDropdown(this, event)">
                    <span class="status-badge \${priorityClass}">\${priorityText}</span>
                    <span>▼</span>
                </button>
                <div class="status-dropdown-menu">
                    <div class="status-dropdown-item" onclick="changePriority(this, 'HIGH', \${item.id}, event)">긴급</div>
                    <div class="status-dropdown-item" onclick="changePriority(this, 'MEDIUM', \${item.id}, event)">보통</div>
                    <div class="status-dropdown-item" onclick="changePriority(this, 'LOW', \${item.id}, event)">낮음</div>
                </div>
            </div>
        `;

            // 테이블 행 조립
            const row = `
            <tr>
                <td>\${item.id}</td>
                <td>\${item.type}</td>
                <td>\${item.user_id || '-'}</td>
                <td>\${item.target_user_id || '-'}</td>
                <td><span class="status-badge \${statusClass}">\${statusText}</span></td>
                <td>\${priorityHtml}</td> <td>\${regDate}</td>
                <td>
                    <button class="action-button" onclick="openDetailModal(\${item.id})">관리</button>
                </td>
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

        const {currentPage, startPage, endPage, totalPage} = pageInfo;

        // 이전 버튼
        const prevBtn = document.createElement('button');
        prevBtn.className = 'pagination-button';
        prevBtn.innerText = '이전';
        if (currentPage > 1) {
            prevBtn.onclick = () => loadContentList(currentPage - 1);
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
                btn.onclick = () => loadContentList(i);
            }
            pagination.appendChild(btn);
        }

        // 다음 버튼
        const nextBtn = document.createElement('button');
        nextBtn.className = 'pagination-button';
        nextBtn.innerText = '다음';
        if (currentPage < totalPage) {
            nextBtn.onclick = () => loadContentList(currentPage + 1);
        } else {
            nextBtn.disabled = true;
            nextBtn.classList.add('disabled');
        }
        pagination.appendChild(nextBtn);
    }

    // 우선순위 드롭다운 토글 함수
    function togglePriorityDropdown(button, event) {
        event.stopPropagation(); // 이벤트 버블링 방지
        const dropdownMenu = button.nextElementSibling;

        // 다른 열려있는 드롭다운 모두 닫기 (하나만 열리도록)
        document.querySelectorAll('.status-dropdown-menu.show').forEach(menu => {
            if (menu !== dropdownMenu) {
                menu.classList.remove('show');
            }
        });

        // 현재 메뉴 토글
        dropdownMenu.classList.toggle('show');
    }

    function openAssignModal(errandId, status) {
        console.log("openAssignModal: " + errandId + ":" + status);

        fetch('${pageContext.request.contextPath}/api/admin/errands/detail?id=' + errandId)
            .then(res => res.json())
            .then(data => {
                const detail = data.detail;     // 심부름 및 작성자 정보
                const history = data.history;   // 배정/매칭 이력 리스트
                console.log(detail);
                console.log(history);
                // 1. 공통 섹션: 심부름 기본 정보 채우기
                document.getElementById('modalUserId').textContent = detail.user_id;
                document.getElementById('modalNickname').textContent = detail.user_nickname;
                document.getElementById('modalContactEmail').textContent = detail.user_email || '-';
                document.getElementById('modalContactPhone').textContent = detail.user_phone || '-';
                document.getElementById('summaryErrandId').textContent = detail.errands_id;
                document.getElementById('summaryTitle').textContent = detail.title;
                document.getElementById('summaryUploadDate').textContent = new Date(detail.created_at) || '-';
                document.getElementById('summaryDesiredDate').textContent = new Date(detail.desired_at) || '-';
                document.getElementById('summaryRewardAmount').textContent = detail.reward_amount + '원 / ' + detail.expense_amount + '원' || '-';
                document.getElementById('summaryLocation').textContent = detail.dong_full_name || '-';
                document.getElementById('summaryContent').value = detail.description || '내용이 없습니다'

                // 2. 상태별 섹션 제어 및 데이터 바인딩
                const assignSection = document.getElementById('assignActionSection');
                const infoSection = document.getElementById('assignedInfoSection');
                const approveBtn = document.querySelector('.modal-button.approve');

                if (status === 'WAITING') {
                    // [미배정 건] 수동 배정 액션 UI 활성화
                    assignSection.style.display = 'block';
                    infoSection.style.display = 'none';
                    approveBtn.style.display = 'block';
                    approveBtn.textContent = '배정 확정';

                    // 가용 정직원 목록 로드 함수 호출
                    // loadAvailableErranders();
                } else {
                    // [배정 완료 건] 관련 정보 표시 UI 활성화
                    assignSection.style.display = 'none';
                    infoSection.style.display = 'block';
                    approveBtn.style.display = 'none';

                    // 이력 데이터 중 가장 최신(첫 번째) 정보를 상세 섹션에 바인딩
                    if (history && history.length > 0) {
                        const latest = history[0];
                        document.getElementById('infoErrander').textContent = `\${latest.errander_nickname} (\${latest.errander_id || '-'})`;
                        document.getElementById('infoAssignedAt').textContent = new Date(latest.assigned_at);
                        document.getElementById('infoReason').textContent = latest.reason || '사유 없음';
                        document.getElementById('infoAdmin').textContent = latest.admin_name || '시스템 자동';
                    }
                }

                // 3. 모달 표시
                document.getElementById('assignModal').classList.add('show');
            });
    }

    function closeAssignModal() {
        document.getElementById('assignModal').classList.remove('show');
    }

    // 모달 외부 클릭 닫기
    document.getElementById('assignModal').addEventListener('click', function (e) {
        if (e.target === this) closeAssignModal();
    });

    // 우선순위 변경 처리 함수
    function changePriority(item, newPriority, issueId, event) {
        event.stopPropagation();

        // 드롭다운 닫기
        item.closest('.status-dropdown-menu').classList.remove('show');

        // API 호출
        fetch('${pageContext.request.contextPath}/api/admin/issues/priority', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                id: issueId,
                priority: newPriority
            })
        })
            .then(res => res.json())
            .then(data => {
                if (data.result === 'success') {
                    // 변경 성공 시 목록 새로고침 (현재 페이지 유지)
                    const currentPage = document.querySelector('.pagination-button.active')?.innerText || 1;
                    // loadContentList(currentPage);
                    window.location.reload();
                } else {
                    alert('우선순위 변경 실패: ' + data.message);
                }
            })
            .catch(err => {
                console.error('Error updating priority:', err);
                alert('오류가 발생했습니다.');
            });
    }

    document.addEventListener('click', function() {
        document.querySelectorAll('.status-dropdown-menu.show').forEach(menu => {
            menu.classList.remove('show');
        });
    });

    // 배정 처리
    function approveErrander() {
        // 1. 선택된 부름이 확인
        const selectedRadio = document.querySelector('input[name="selectedErrander"]:checked');
        const assignReason = document.getElementById('assignReason').value;

        // 미배정 상태에서 배정 확정 버튼을 누른 경우 체크
        const isAssignMode = document.getElementById('assignActionSection').style.display !== 'none';

        if (isAssignMode) {
            if (!selectedRadio) {
                alert('배정할 부름이를 선택해주세요.');
                return;
            }

            const selectedErranderId = selectedRadio.value;

            if (!confirm('부름이(ID:' + selectedErranderId + ')에게 심부름을 배정하시겠습니까?')) return;

            // 배정 API 호출
            fetch('${pageContext.request.contextPath}/api/admin/errands/assign', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({
                    errandId: currentErrandsId, // 전역변수에 저장된 심부름 ID
                    erranderId: selectedErranderId,
                    reason: assignReason
                })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.result === 'success') {
                        alert('배정이 완료되었습니다.');
                        window.location.reload();
                    } else {
                        alert('배정 실패: ' + data.message);
                    }
                })
                .catch(err => {
                    console.error(err);
                    alert('오류가 발생했습니다.');
                });

        }

        closeAssignModal();
    }

</script>

</html>