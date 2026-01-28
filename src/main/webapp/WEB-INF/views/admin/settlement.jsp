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
    <title>VROOM - 정산 관리</title>
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
            grid-template-columns: repeat(4, 1fr);
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

        /* Search & Filter */
        .search-section {
            background: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
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
            font-weight: 700;
            cursor: pointer;
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
            min-width: 150px;
        }

        /* Table */
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

        .common-table {
            width: 100%;
            border-collapse: collapse;
        }

        .common-table th {
            padding: 1rem;
            text-align: left;
            font-weight: 700;
            background-color: #F8F9FA;
            border-bottom: 2px solid var(--color-light-gray);
        }

        .common-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--color-light-gray);
            font-size: 0.9rem;
        }

        .common-table tr:hover {
            background-color: #F8F9FA;
        }

        /* Status Badges (Settlement Specific) */
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

        /* 정산 대기 (승인됨) */
        .status-badge.HOLD {
            background: #FFF9E6;
            color: #F2A007;
        }

        /* 보류 */
        .status-badge.COMPLETED {
            background: #E3F2FD;
            color: #2196F3;
        }

        /* 지급 완료 */
        .status-badge.REJECTED {
            background: #FDEAEA;
            color: #E74C3C;
        }

        /* 거절 */

        /* Buttons */
        .action-button {
            padding: 0.5rem 1rem;
            background: var(--color-dark);
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            font-size: 0.85rem;
        }

        .action-button:hover {
            background: #1a252f;
        }

        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9998;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.show {
            display: flex;
        }

        .modal {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            max-width: 800px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
            z-index: 9999;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid #eee;
            padding-bottom: 1rem;
        }

        .modal-title {
            font-size: 1.4rem;
            font-weight: 700;
        }

        .modal-grid-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }

        .modal-section-title {
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 1rem;
            border-left: 4px solid var(--color-secondary);
            padding-left: 0.5rem;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-label {
            color: var(--color-gray);
            font-weight: 500;
        }

        .info-value {
            font-weight: 600;
            color: var(--color-dark);
        }

        /* Proof Image Style */
        .proof-image-container {
            width: 100%;
            height: 250px;
            background: #f5f5f5;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border: 1px solid #ddd;
            cursor: pointer;
        }

        .proof-image-container img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .modal-textarea {
            width: 100%;
            height: 100px;
            padding: 0.8rem;
            border: 1px solid #ddd;
            border-radius: 8px;
            resize: none;
            margin-top: 0.5rem;
            font-family: inherit;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 1rem;
            border-top: 1px solid #eee;
        }

        .modal-btn {
            padding: 0.8rem 1.5rem;
            border-radius: 8px;
            font-weight: 700;
            border: none;
            cursor: pointer;
        }

        .btn-cancel {
            background: #eee;
            color: #333;
        }

        .btn-reject {
            background: #FFEBEE;
            color: #D32F2F;
        }

        .btn-hold {
            background: #FFF3E0;
            color: #EF6C00;
        }

        .btn-approve {
            background: linear-gradient(135deg, #27AE60 0%, #2ECC71 100%);
            color: white;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .modal-grid-layout {
                grid-template-columns: 1fr;
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
            <a href="${pageContext.request.contextPath}/admin/issue" class="nav-item">
                <span class="nav-item-icon">⚠️</span>
                <span class="nav-item-text">신고/이슈 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/settlements" class="nav-item active">
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
            <h2 class="page-title">정산 관리</h2>

            <!-- Summary Section -->
            <section class="summary-section">
                <h3 class="summary-title">정산 현황 요약</h3>
                <div class="summary-grid">
                    <div class="summary-card">
                        <div class="summary-label">정산 대기 건수</div>
                        <div class="summary-value" style="color: var(--color-warm);">${summary.waitingCount}건</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">정산 보류 건수</div>
                        <div class="summary-value" style="color: #E74C3C;">${summary.holdCount}건</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">자동 확정 예정 건 수</div>
                        <div class="summary-value">${summary.autoConfirmCount}건</div>
                    </div>
                    <div class="summary-card">
                        <div class="summary-label">오늘 지급 완료 금액</div>
                        <div class="summary-value" style="color: var(--color-primary);">
                            <fmt:formatNumber value="${summary.todayPaidAmount}" pattern="#,###"/>원
                        </div>
                    </div>
                </div>
            </section>

            <!-- Search Section -->
            <section class="search-section">
                <h3 class="search-title">정산 목록 검색</h3>
                <div class="search-bar">
                    <input type="text" class="search-input" id="searchInput" placeholder="심부름 ID 또는 부름이 닉네임 검색">
                    <button class="search-button" onclick="loadSettlementList(1)">🔍 검색</button>
                </div>

                <div class="filter-row">
                    <div class="filter-group">
                        <label class="filter-label">정산 상태</label>
                        <select id="filterStatus" class="filter-select" onchange="loadSettlementList(1)">
                            <option value="">전체</option>
                            <option value="WAITING">정산 대기</option>
                            <option value="HOLD">보류</option>
                            <option value="COMPLETED">지급 완료</option>
                            <option value="REJECTED">정산 거절</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label">신청일 기준</label>
                        <div style="display: flex; gap: 0.5rem; align-items: center;">
                            <input type="date" id="startDate" class="filter-select">
                            <span>~</span>
                            <input type="date" id="endDate" class="filter-select">
                        </div>
                    </div>
                </div>
            </section>

            <section class="table-section">
                <div class="table-header">
                    <h3 class="summary-title">정산 목록 테이블</h3>
                    <span class="table-count">총 <strong id="totalCount">0</strong>건</span>
                </div>

                <table class="common-table">
                    <thead>
                    <tr>
                        <th>심부름 ID</th>
                        <th>부름이</th>
                        <th>금액(원)</th>
                        <th>신청일</th>
                        <th>상태</th>
                        <th>사유</th>
                        <th>처리</th>
                    </tr>
                    </thead>
                    <tbody id="settlementTableBody">
                    </tbody>
                </table>

                <div style="display: flex; justify-content: center; margin-top: 1.5rem;" id="pagination"></div>
            </section>
        </main>
    </div>
</div>

<!-- Assignment Modal -->
<div class="modal-overlay" id="settlementModal">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title">정산 상세 내역</h3>
            <button onclick="closeModal()" style="background:none; border:none; font-size:1.5rem; cursor:pointer;">
                &times;
            </button>
        </div>

        <div class="modal-body">
            <div class="modal-grid-layout">
                <div class="left-panel">
                    <div class="modal-section-title">심부름 및 정산 정보</div>
                    <div class="info-row">
                        <span class="info-label">심부름 ID</span>
                        <span class="info-value" id="modalErrandId">-</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">심부름 제목</span>
                        <span class="info-value" id="modalErrandTitle">-</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">부름이</span>
                        <span class="info-value" id="modalErrander">-</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">정산 금액</span>
                        <span class="info-value" id="modalAmount"
                              style="color: var(--color-primary); font-size: 1.1rem;">-</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">현재 상태</span>
                        <span class="info-value" id="modalStatus">-</span>
                    </div>

                    <div class="modal-section-title" style="margin-top: 2rem;">관리자 판단</div>
                    <label class="info-label">처리 메모 / 반려 사유</label>
                    <textarea class="modal-textarea" id="adminMemo"
                              placeholder="보류/반려 시 사유를 입력하세요. (부름이에게 전송됩니다)"></textarea>
                </div>

                <div class="right-panel">
                    <div class="modal-section-title">인증 사진 확인</div>
                    <div class="proof-image-container"
                         onclick="window.open(document.getElementById('modalProofImg').src)">
                        <img id="modalProofImg" src="" alt="인증 사진 없음">
                    </div>
                    <p style="font-size: 0.8rem; color: #888; text-align: center; margin-top: 5px;">클릭하면 원본 이미지가
                        열립니다.</p>

                    <div class="modal-section-title" style="margin-top: 1.5rem;">메세지 (마지막 대화)</div>
                    <div style="background: #f9f9f9; padding: 1rem; border-radius: 8px; font-size: 0.9rem; color: #555;">
                        <strong>부름이:</strong> <span id="modalErranderMsg">완료했습니다! 정산 부탁드려요.</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal-footer">
            <button class="modal-btn btn-cancel" onclick="closeModal()">닫기</button>
            <button class="modal-btn btn-reject" onclick="processSettlement('REJECTED')">정산 거절</button>
            <button class="modal-btn btn-hold" onclick="processSettlement('HOLD')">보류</button>
            <button class="modal-btn btn-approve" onclick="processSettlement('COMPLETED')">정산 확정 (지급)</button>
        </div>
    </div>
</div>

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
        const currentPath = window.location.hash || '#settlements'; // URL에 맞게 조정
        $('.nav-item').each(function () {
            if ($(this).attr('href').includes('settlements')) {
                $(this).addClass('active');
            } else {
                $(this).removeClass('active');
            }
        });

        // 초기 데이터 로드
        loadSettlementList(1);

        // 이벤트 리스너
        // 검색 (엔터키 & 버튼)
        document.querySelector('.search-button').addEventListener('click', () => loadErrandsList(1));
        document.getElementById('searchInput').addEventListener('keyup', function (e) {
            if (e.key === 'Enter') loadErrandsList(1);
        });

        // 필터 변경 시 자동 검색
        document.getElementById('filterGu').addEventListener('change', () => loadErrandsList(1));
        document.getElementById('filterDong').addEventListener('change', () => loadErrandsList(1));
        document.getElementById('regStartDate').addEventListener('change', () => loadErrandsList(1));
        document.getElementById('regEndDate').addEventListener('change', () => loadErrandsList(1));
        document.getElementById('dueStartDate').addEventListener('change', () => loadErrandsList(1));
        document.getElementById('dueEndDate').addEventListener('change', () => loadErrandsList(1));
    });

    //  목록 조회
    function loadSettlementList(page) {
        const keyword = document.getElementById('searchInput').value;
        const status = document.getElementById('filterStatus').value;
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;

        // 실제 API 호출 시 경로 수정 필요
        /*
        fetch(`
        ${pageContext.request.contextPath}/api/admin/settlements?page=` + page + `&keyword=` + keyword + ...)
        */

        // [테스트용 더미 데이터]
        const dummyData = [
            {
                id: 101,
                errandId: 3012,
                errander: 'RUNNER_12',
                amount: 15000,
                date: '2026-01-27',
                status: 'WAITING',
                reason: '-',
                proof: '/resources/img/sample_proof.jpg'
            },
            {
                id: 102,
                errandId: 3011,
                errander: 'SPEEDY_JO',
                amount: 8500,
                date: '2026-01-26',
                status: 'HOLD',
                reason: '인증 불충분',
                proof: ''
            },
            {
                id: 103,
                errandId: 3009,
                errander: 'GORANI',
                amount: 20000,
                date: '2026-01-25',
                status: 'COMPLETED',
                reason: '-',
                proof: ''
            },
            {
                id: 104,
                errandId: 3005,
                errander: 'RUNNER_12',
                amount: 5000,
                date: '2026-01-24',
                status: 'REJECTED',
                reason: '미수행',
                proof: ''
            }
        ];

        renderTable(dummyData); // 실제로는 fetch response data 사용
        document.getElementById('totalCount').innerText = dummyData.length;
    }

    function renderTable(list) {
        const tbody = document.getElementById('settlementTableBody');
        tbody.innerHTML = '';

        if (!list || list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:2rem;">데이터가 없습니다.</td></tr>';
            return;
        }

        list.forEach(item => {
            let statusBadge = '';
            let statusText = '';

            // 상태별 뱃지 처리
            switch (item.status) {
                case 'WAITING':
                    statusBadge = 'WAITING';
                    statusText = '정산 대기';
                    break;
                case 'HOLD':
                    statusBadge = 'HOLD';
                    statusText = '보류';
                    break;
                case 'COMPLETED':
                    statusBadge = 'COMPLETED';
                    statusText = '지급 완료';
                    break;
                case 'REJECTED':
                    statusBadge = 'REJECTED';
                    statusText = '정산 거절';
                    break;
            }

            const row = `
                <tr>
                    <td>\${item.errandId}</td>
                    <td>\${item.errander}</td>
                    <td>\${item.amount.toLocaleString()}</td>
                    <td>\${item.date}</td>
                    <td><span class="status-badge \${statusBadge}">\${statusText}</span></td>
                    <td>\${item.reason}</td>
                    <td><button class="action-button" onclick="openSettlementModal(\${item.id})">상세</button></td>
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
            prevBtn.onclick = () => loadErrandsList(currentPage - 1);
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
                btn.onclick = () => loadErrandsList(i);
            }
            pagination.appendChild(btn);
        }

        // 다음 버튼
        const nextBtn = document.createElement('button');
        nextBtn.className = 'pagination-button';
        nextBtn.innerText = '다음';
        if (currentPage < totalPage) {
            nextBtn.onclick = () => loadErrandsList(currentPage + 1);
        } else {
            nextBtn.disabled = true;
            nextBtn.classList.add('disabled');
        }
        pagination.appendChild(nextBtn);
    }

    function openSettlementModal(id) {
        currentSettlementId = id;

        // TODO: fetch(`${pageContext.request.contextPath}/api/admin/settlements/` + id) 로 상세 데이터 가져오기

        // [테스트용 데이터 바인딩]
        document.getElementById('modalErrandId').innerText = '3012';
        document.getElementById('modalErrandTitle').innerText = '편의점에서 도시락 사다주세요';
        document.getElementById('modalErrander').innerText = 'RUNNER_12 (김철수)';
        document.getElementById('modalAmount').innerText = '15,000원';
        document.getElementById('modalStatus').innerText = '정산 대기 중';

        // 이미지 세팅 (실제 경로가 없으면 placeholder)
        document.getElementById('modalProofImg').src = 'https://via.placeholder.com/400x300?text=Proof+Image';
        document.getElementById('adminMemo').value = '';

        document.getElementById('settlementModal').classList.add('show');
    }

    function closeModal() {
        document.getElementById('settlementModal').classList.remove('show');
        currentSettlementId = null;
    }

    // 정산 처리 (승인, 보류, 거절)
    function processSettlement(action) {
        const memo = document.getElementById('adminMemo').value;
        const actionText = (action === 'COMPLETED') ? '확정(지급)' : (action === 'HOLD' ? '보류' : '거절');

        if (action !== 'COMPLETED' && !memo) {
            alert(actionText + " 처리를 위해서는 사유(메모) 입력이 필요합니다.");
            return;
        }

        if (!confirm("정말 " + actionText + " 처리 하시겠습니까?")) return;

        // API 호출 로직
        /*
        fetch(`
        ${pageContext.request.contextPath}/api/admin/settlements/process`, {
            method: 'POST',
            body: JSON.stringify({ id: currentSettlementId, action: action, memo: memo })
        })...
        */

        console.log(`Processing Settlement ID: \${currentSettlementId}, Action: \${action}, Memo: \${memo}`);
        alert("처리가 완료되었습니다.");
        closeModal();
        loadSettlementList(1); // 목록 갱신
    }


</script>
</body>

</html>