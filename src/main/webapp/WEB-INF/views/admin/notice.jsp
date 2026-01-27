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
    <title>VROOM - 공지/컨텐츠 관리</title>
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

        /* Sidebar Styles (기존 유지) */
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

        /* Main Content */
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

        /* Table Section */
        .table-section {
            background: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
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

        /* 공지 상태 배지 */
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

        /* 게시중 */
        .status-badge.SCHEDULED {
            background: #FFF9E6;
            color: #F2A007;
        }

        /* 예약됨 */
        .status-badge.ENDED {
            background: #F0F0F0;
            color: #7F8C8D;
        }

        /* 종료됨 */
        .status-badge.HIDDEN {
            background: #FDEAEA;
            color: #E74C3C;
        }

        /* 비공개 */
        .status-badge.IMPORTANT {
            background: #E3F2FD;
            color: #2196F3;
            margin-right: 5px;
        }

        /* 중요 */

        /* Buttons */
        .action-button {
            padding: 0.4rem 0.8rem;
            background: var(--color-dark);
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            font-size: 0.8rem;
        }

        .action-button:hover {
            background: #1a252f;
        }

        .btn-create-post {
            padding: 0.875rem 2rem;
            background: var(--color-dark);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
            font-size: 1rem;
            transition: background 0.3s;
        }

        .btn-create-post:hover {
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

        .form-group {
            margin-bottom: 1.2rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--color-dark);
            font-size: 0.9rem;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: inherit;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--color-primary);
        }

        .form-textarea {
            min-height: 200px;
            resize: vertical;
        }

        .form-row {
            display: flex;
            gap: 1rem;
        }

        .form-check {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 0.5rem;
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

        .btn-save {
            background: linear-gradient(135deg, #27AE60 0%, #2ECC71 100%);
            color: white;
        }

        .btn-delete {
            background: #FFEBEE;
            color: #D32F2F;
            margin-right: auto;
        }

        /* Pagination (기존 유지) */
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

        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
            }
        }
    </style>

    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet" as="style"
          href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
</head>

<body>
<div class="admin-layout">
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
            <a href="${pageContext.request.contextPath}/admin/settlements" class="nav-item">
                <span class="nav-item-icon">💰</span>
                <span class="nav-item-text">정산 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/notice" class="nav-item active">
                <span class="nav-item-icon">📢</span>
                <span class="nav-item-text">공지/컨텐츠 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item">
                <span class="nav-item-icon">⚙️</span>
                <span class="nav-item-text">시스템 설정</span>
            </a>
        </nav>
    </aside>

    <div class="main-content">
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

        <main class="page-content">
            <h2 class="page-title">공지/컨텐츠 관리</h2>

            <section class="search-section">
                <h3 class="search-title">공지 목록 검색</h3>
                <div class="search-bar">
                    <input type="text" class="search-input" id="searchInput" placeholder="공지 ID 또는 제목 검색">
                    <button class="search-button" onclick="loadNoticeList(1)">🔍 검색</button>
                </div>

                <div class="filter-row">
                    <div class="filter-group">
                        <label class="filter-label">게시 상태</label>
                        <select id="filterStatus" class="filter-select" onchange="loadNoticeList(1)">
                            <option value="">전체</option>
                            <option value="ACTIVE">게시중</option>
                            <option value="SCHEDULED">예약</option>
                            <option value="ENDED">종료</option>
                            <option value="HIDDEN">비공개</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label class="filter-label">게시 대상</label>
                        <select id="filterTarget" class="filter-select" onchange="loadNoticeList(1)">
                            <option value="">전체</option>
                            <option value="ALL">전체 공지</option>
                            <option value="USER">사용자</option>
                            <option value="ERRANDER">부름이</option>
                        </select>
                    </div>
                </div>
            </section>

            <section class="table-section">
                <div class="table-header">
                    <h3 class="table-title">공지 목록 테이블</h3>
                    <span class="table-count">총 <strong id="totalCount">0</strong>건</span>
                </div>

                <table class="common-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th style="width: 40%;">제목</th>
                        <th>대상</th>
                        <th>상태</th>
                        <th>게시 기간</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody id="noticeTableBody">
                    </tbody>
                </table>

                <div id="pagination" class="pagination"></div>
            </section>

            <div style="margin-top: 1rem; text-align: right;">
                <button class="btn-create-post" onclick="openWriteModal()">새 글 쓰기</button>
            </div>

            <section style="margin-top: 2rem; border-top: 1px solid #ddd; padding-top: 1rem; text-align: center;">
                <h4 style="margin-bottom: 1rem;">옵션</h4>
                <div style="display: flex; gap: 1rem; justify-content: center;">
                    <button class="action-button" style="background: #fff; color: #333; border: 1px solid #ddd;">이용가이드
                        관리
                    </button>
                    <button class="action-button" style="background: #fff; color: #333; border: 1px solid #ddd;">FAQ
                        관리
                    </button>
                    <button class="action-button" style="background: #fff; color: #333; border: 1px solid #ddd;">정책 안내
                        관리
                    </button>
                </div>
            </section>
        </main>
    </div>
</div>

<div class="modal-overlay" id="noticeModal">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title" id="modalTitle">공지 작성</h3>
            <button onclick="closeModal()" style="background:none; border:none; font-size:1.5rem; cursor:pointer;">
                &times;
            </button>
        </div>

        <div class="modal-body">
            <input type="hidden" id="modalNoticeId">

            <div class="form-group">
                <label class="form-label">제목 <span style="color:red">*</span></label>
                <input type="text" class="form-input" id="modalTitleInput" placeholder="제목을 입력하세요">
                <div class="form-check">
                    <input type="checkbox" id="modalImportantCheck">
                    <label for="modalImportantCheck" style="font-size: 0.9rem;">중요 공지 (상단 고정)</label>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group" style="flex: 1;">
                    <label class="form-label">대상 설정 <span style="color:red">*</span></label>
                    <select class="form-select" id="modalTargetSelect">
                        <option value="ALL">전체</option>
                        <option value="USER">사용자 전용</option>
                        <option value="ERRANDER">부름이 전용</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label class="form-label">게시 상태</label>
                    <select class="form-select" id="modalStatusSelect">
                        <option value="ACTIVE">즉시 게시</option>
                        <option value="SCHEDULED">예약 게시</option>
                        <option value="HIDDEN">비공개 (임시저장)</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">게시 기간</label>
                <div style="display: flex; gap: 0.5rem; align-items: center;">
                    <input type="date" class="form-input" id="modalStartDate">
                    <span>~</span>
                    <input type="date" class="form-input" id="modalEndDate">
                </div>
                <p style="font-size: 0.8rem; color: #888; margin-top: 5px;">* 종료일을 설정하지 않으면 무기한 게시됩니다.</p>
            </div>

            <div class="form-group">
                <label class="form-label">내용 (에디터)</label>
                <textarea class="form-textarea" id="modalContentInput" placeholder="공지 내용을 입력하세요"></textarea>
            </div>
        </div>

        <div class="modal-footer">
            <button class="modal-btn btn-delete" id="btnDelete" onclick="deleteNotice()" style="display: none;">삭제
            </button>
            <button class="modal-btn btn-cancel" onclick="closeModal()">취소</button>
            <button class="modal-btn btn-save" onclick="saveNotice()">저장</button>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        // 사이드바 및 드롭다운 초기화 로직 (settlement.jsp와 동일)
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');
        const adminDropdownTrigger = document.getElementById('adminDropdownTrigger');
        const adminDropdown = document.getElementById('adminDropdown');
        const savedState = localStorage.getItem('sidebarState');

        if (savedState === 'collapsed') sidebar.classList.add('collapsed');

        sidebarToggle.addEventListener('click', function (e) {
            e.stopPropagation();
            sidebar.classList.toggle('collapsed');
            localStorage.setItem('sidebarState', sidebar.classList.contains('collapsed') ? 'collapsed' : 'expanded');
        });

        adminDropdownTrigger.addEventListener('click', function (e) {
            e.stopPropagation();
            adminDropdown.classList.toggle('show');
        });

        window.addEventListener('click', function () {
            if (adminDropdown.classList.contains('show')) adminDropdown.classList.remove('show');
        });

        // 초기 로드
        loadNoticeList(1);
    });

    // 공지 목록 로드 (Mock Data)
    function loadNoticeList(page) {
        const keyword = document.getElementById('searchInput').value;
        const status = document.getElementById('filterStatus').value;
        const target = document.getElementById('filterTarget').value;

        // 실제 API 호출: fetch(...)

        // [테스트용 더미 데이터]
        const dummyData = [
            {
                id: 12,
                title: '시스템 점검 안내',
                target: 'ALL',
                status: 'ACTIVE',
                startDate: '2026-01-07',
                endDate: '2026-01-08',
                isImportant: true
            },
            {
                id: 11,
                title: '설 연휴 고객센터 운영 안내',
                target: 'ALL',
                status: 'ENDED',
                startDate: '2025-12-25',
                endDate: '2025-12-31',
                isImportant: false
            },
            {
                id: 10,
                title: '부름이 정산 정책 변경 안내',
                target: 'ERRANDER',
                status: 'ACTIVE',
                startDate: '2026-01-01',
                endDate: '',
                isImportant: true
            },
            {
                id: 9,
                title: '신규 가입 이벤트',
                target: 'USER',
                status: 'HIDDEN',
                startDate: '2026-02-01',
                endDate: '2026-02-28',
                isImportant: false
            },
        ];

        renderTable(dummyData);
        document.getElementById('totalCount').innerText = dummyData.length;
    }

    function renderTable(list) {
        const tbody = document.getElementById('noticeTableBody');
        tbody.innerHTML = '';

        if (!list || list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding:2rem;">등록된 공지가 없습니다.</td></tr>';
            return;
        }

        list.forEach(item => {
            let statusBadge = '';
            let statusText = '';
            switch (item.status) {
                case 'ACTIVE':
                    statusBadge = 'ACTIVE';
                    statusText = '게시중';
                    break;
                case 'SCHEDULED':
                    statusBadge = 'SCHEDULED';
                    statusText = '예약';
                    break;
                case 'ENDED':
                    statusBadge = 'ENDED';
                    statusText = '종료';
                    break;
                case 'HIDDEN':
                    statusBadge = 'HIDDEN';
                    statusText = '비공개';
                    break;
            }

            let targetText = '';
            switch (item.target) {
                case 'ALL':
                    targetText = '전체';
                    break;
                case 'USER':
                    targetText = '사용자';
                    break;
                case 'ERRANDER':
                    targetText = '부름이';
                    break;
            }

            let titleHtml = item.title;
            if (item.isImportant) {
                titleHtml = '<span class="status-badge IMPORTANT">중요</span> ' + item.title;
            }

            let period = item.startDate;
            if (item.endDate) period += ' ~ ' + item.endDate;
            else period += ' ~ (무기한)';

            const row = `
                <tr>
                    <td>\${item.id}</td>
                    <td style="font-weight: 500;">\${titleHtml}</td>
                    <td>\${targetText}</td>
                    <td><span class="status-badge \${statusBadge}">\${statusText}</span></td>
                    <td>\${period}</td>
                    <td><button class="action-button" onclick="openEditModal(\${item.id})">수정</button></td>
                </tr>
            `;
            tbody.innerHTML += row;
        });
    }

    // 모달 제어
    function openWriteModal() {
        // 초기화
        document.getElementById('modalTitle').innerText = '공지 작성';
        document.getElementById('modalNoticeId').value = '';
        document.getElementById('modalTitleInput').value = '';
        document.getElementById('modalContentInput').value = '';
        document.getElementById('modalImportantCheck').checked = false;
        document.getElementById('modalTargetSelect').value = 'ALL';
        document.getElementById('modalStatusSelect').value = 'ACTIVE';
        document.getElementById('modalStartDate').value = new Date().toISOString().split('T')[0];
        document.getElementById('modalEndDate').value = '';

        // 삭제 버튼 숨김
        document.getElementById('btnDelete').style.display = 'none';

        document.getElementById('noticeModal').classList.add('show');
    }

    function openEditModal(id) {
        // 실제로는 API로 상세 정보 조회 필요 (mock data 사용)
        document.getElementById('modalTitle').innerText = '공지 수정';
        document.getElementById('modalNoticeId').value = id;

        // Mock Data Loading...
        document.getElementById('modalTitleInput').value = '시스템 점검 안내'; // 예시
        document.getElementById('modalImportantCheck').checked = true;
        document.getElementById('modalTargetSelect').value = 'ALL';
        document.getElementById('modalStatusSelect').value = 'ACTIVE';
        document.getElementById('modalStartDate').value = '2026-01-07';
        document.getElementById('modalEndDate').value = '2026-01-08';
        document.getElementById('modalContentInput').value = '시스템 점검이 예정되어 있습니다...';

        // 삭제 버튼 표시
        document.getElementById('btnDelete').style.display = 'block';

        document.getElementById('noticeModal').classList.add('show');
    }

    function closeModal() {
        document.getElementById('noticeModal').classList.remove('show');
    }

    function saveNotice() {
        const id = document.getElementById('modalNoticeId').value;
        const mode = id ? '수정' : '등록';

        if (!document.getElementById('modalTitleInput').value) {
            alert('제목을 입력해주세요.');
            return;
        }

        if (confirm(mode + ' 하시겠습니까?')) {
            // API 호출 로직...
            alert('저장되었습니다.');
            closeModal();
            loadNoticeList(1);
        }
    }

    function deleteNotice() {
        if (confirm('정말 삭제하시겠습니까?')) {
            // API 호출...
            alert('삭제되었습니다.');
            closeModal();
            loadNoticeList(1);
        }
    }
</script>
</body>
</html>