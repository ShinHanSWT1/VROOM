<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <title>VROOM - 부름이 상세 정보</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">

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
            font-family: 'Pretendard', sans-serif;
            color: var(--color-dark);
            background-color: #F8F9FA;
            line-height: 1.6;
        }

        /* 레이아웃 */
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


        .nav-item {
            display: flex;
            align-items: center;
            padding: 1rem 1.5rem;
            color: white;
            text-decoration: none;
            transition: 0.3s;
            border-left: 4px solid transparent;
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

        /* 메인 컨텐츠 영역 */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            transition: margin-left 0.3s ease;
        }

        .sidebar.collapsed ~ .main-content {
            margin-left: var(--sidebar-collapsed-width);
        }

        /* 헤더 */
        .admin-header {
            height: var(--header-height);
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 2rem;
            position: sticky;
            top: 0;
            z-index: 999;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            color: white;
        }

        .header-title {
            font-size: 1.5rem;
            font-weight: 700;
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

        /* 상세 페이지 */
        .page-content {
            padding: 2rem;
        }

        /* 타이틀 영역 */
        .page-header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--color-dark);
            margin: 0;
        }

        .btn-back {
            padding: 0.5rem 1.5rem;
            background: var(--color-white);
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            color: var(--color-dark);
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-back:hover {
            border-color: var(--color-gray);
            background: #F0F0F0;
        }

        /* 카드 스타일 */
        .detail-card {
            background: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
            margin-bottom: 1.5rem;
        }

        .card-title {
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 1.2rem;
            border-left: 4px solid var(--color-secondary);
            padding-left: 0.8rem;
            color: var(--color-dark);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* 기본 정보 그리드 */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem 3rem;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
            border-bottom: 1px solid #eee;
            padding-bottom: 0.5rem;
        }

        .info-label {
            font-size: 0.85rem;
            color: var(--color-gray);
            font-weight: 600;
        }

        .info-value {
            font-size: 1rem;
            font-weight: 500;
            color: var(--color-dark);
        }

        .info-value.highlight {
            color: var(--color-primary);
            font-weight: 700;
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

        /* 활동 요약 */
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .summary-item {
            background: #FAFAFA;
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            border: 1px solid #eee;
            transition: 0.3s;
        }

        .summary-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            border-color: var(--color-secondary);
        }

        .summary-label {
            font-size: 0.9rem;
            color: var(--color-gray);
            margin-bottom: 0.5rem;
        }

        .summary-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--color-dark);
        }

        .summary-unit {
            font-size: 1rem;
            font-weight: 400;
            color: var(--color-gray);
            margin-left: 2px;
        }

        /* 3단 그리드 */
        .three-column-grid {
            display: grid;
            grid-template-columns: 1.2fr 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        /* 테이블 스타일 */
        .mini-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        .mini-table th {
            background: #F8F9FA;
            padding: 0.8rem;
            text-align: left;
            font-weight: 600;
            color: var(--color-gray);
            border-bottom: 2px solid #eee;
        }

        .mini-table td {
            padding: 0.8rem;
            border-bottom: 1px solid #eee;
        }

        .btn-more {
            width: 100%;
            padding: 0.75rem;
            background: var(--color-light-gray);
            color: var(--color-dark);
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
            margin-top: 1rem;
        }

        .btn-more:hover {
            background: #D5D8DC;
        }

        /* 반응형 */
        @media (max-width: 1200px) {
            .three-column-grid {
                grid-template-columns: 1fr;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>

<div class="admin-layout">
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">
                <img src="${pageContext.request.contextPath}/static/img/logo2.png" alt="VROOM">
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
            <a href="#" class="nav-item">
                <span class="nav-item-icon">📦</span>
                <span class="nav-item-text">주문/배차 관리</span>
            </a>
            <a href="#" class="nav-item">
                <span class="nav-item-icon">⚠️</span>
                <span class="nav-item-text">신고/이슈 관리</span>
            </a>
            <a href="#" class="nav-item">
                <span class="nav-item-icon">💰</span>
                <span class="nav-item-text">정산 관리</span>
            </a>
            <a href="#" class="nav-item">
                <span class="nav-item-icon">⚙️</span>
                <span class="nav-item-text">시스템 설정</span>
            </a>
        </nav>
    </aside>

    <div class="main-content">
        <header class="admin-header">
            <div class="header-container">
                <h1 class="header-title">관리자 페이지</h1>
            </div>
            <div style="display: flex; gap: 10px; align-items: center;">
                <div class="header-user" onclick="toggleUserDropdown()">
                    <span>👤 관리자</span>
                    <span>▼</span>
                    <div class="user-dropdown" id="userDropdown">
                        <a href="#profile" class="dropdown-item">프로필 설정</a>
                        <a href="#logout" class="dropdown-item">로그아웃</a>
                    </div>
                </div>
            </div>
        </header>

        <main class="page-content">
            <div class="page-header-row">
                <h2 class="page-title">부름이 상세 정보</h2>
                <a href="${pageContext.request.contextPath}/admin/erranders" class="btn-back">
                    ⬅ 목록으로 돌아가기
                </a>
            </div>

            <!-- 기본 정보 영역 -->
            <section class="detail-card">
                <div class="card-title">
                    기본 정보 영역
                    <button class="btn-more" style="width: auto; margin: 0; padding: 0.5rem 1rem;">더보기</button>
                </div>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">사용자 ID / 부름이 ID / 닉네임</span>
                        <span class="info-value highlight" id="helperIdNickname">${empty summary.detail.user_id ? '-' : summary.detail.user_id} / ${empty summary.detail.errander_id ? '-' : summary.detail.errander_id} / ${empty summary.detail.nickname ? '-' : summary.detail.nickname}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">이메일 / 휴대폰</span>
                        <span class="info-value" id="contactInfo">${empty summary.detail.email ? '-' : summary.detail.email} / ${empty summary.detail.phone ? '-' : summary.detail.phone}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">승인 상태 (대기 / 승인 / 거절)</span>
                        <span class="info-value" id="approvalStatus">
                            <span class="status-badge ${summary.detail.approval_status}">${summary.detail.approval_status}</span>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">활동 상태 (활성/비활성)</span>
                        <span class="info-value" id="activityStatus">
                            <span class="status-badge ${summary.detail.active_status}">${summary.detail.active_status}</span>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">부름이 승인일</span>
                        <span class="info-value" id="approvalDate">${empty summary.detail.approved_at ? '-' : summary.detail.approved_at}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">최근 활동일</span>
                        <span class="info-value" id="lastActivityDate">${empty summary.detail.last_active_at ? '-' : summary.detail.last_active_at}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">활동 동네 1</span>
                        <span class="info-value" id="region1">${empty summary.detail.address1 ? '-' : summary.detail.address1}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">활동 동네 2</span>
                        <span class="info-value" id="region2">${empty summary.detail.address2 ? '-' : summary.detail.address2}</span>
                    </div>
                </div>
            </section>

            <!-- 활동 요약 -->
            <section class="detail-card">
                <div class="card-title">통계 요약</div>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="summary-label">총 매칭 건수 / 완료 건수</div>
                        <div class="summary-value"><span id="acceptCount">${empty summary.activity.matched ? '0' : summary.activity.matched}</span> / <span
                                id="completeCount">${empty summary.activity.completed ? '0' : summary.activity.completed}</span><span class="summary-unit">건</span></div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">완료율 / 거절</div>
                        <div class="summary-value"><span id="completeRate">${empty summary.activity.complete_rate ? '0' : summary.activity.complete_rate}</span> / <span
                                id="cancelRate">${empty summary.activity.canceled ? '0' : summary.activity.canceled}</span><span class="summary-unit">%</span></div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">평균 평점</div>
                        <div class="summary-value"><span id="avgRating">${empty summary.activity.rating_avg ? '0' : summary.activity.rating_avg}</span><span class="summary-unit">/5.0</span>
                        </div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">누적 수익</div>
                        <div class="summary-value" style="color: var(--color-primary);"><span id="totalEarning">${empty summary.activity.total_earning ? '0' : summary.activity.total_earning}</span><span
                                class="summary-unit">원</span></div>
                    </div>
                </div>
            </section>

            <!-- 3단 그리드 1 -->
            <div class="three-column-grid">
                <!-- 수행 심부름 목록 -->
                <section class="detail-card">
                    <div class="card-title">수행 심부름 목록</div>
                    <div style="overflow-x: auto; max-height: 400px; overflow-y: auto;">
                        <table class="mini-table">
                            <thead>
                            <tr>
                                <th>최근 N건</th>
                                <th>심부름 ID + 제목</th>
                                <th>날짜</th>
                                <th>상태</th>
                            </tr>
                            </thead>
                            <tbody id="errandListBody">
                            <tr>
                                <td colspan="4" style="text-align:center; padding: 2rem;">데이터가 없습니다.</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <button class="btn-more">더보기</button>
                </section>

                <!-- 정산 내역 -->
                <section class="detail-card">
                    <div class="card-title">정산 내역</div>
                    <div style="display: flex; flex-direction: column; gap: 1rem;">
                        <div class="info-item">
                            <span class="info-label">누적 정산 금액</span>
                            <span class="info-value" id="totalSettlement">0원</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">이번달 정산 완료 금액</span>
                            <span class="info-value" id="completedSettlement">0원</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">정산 대기 금액</span>
                            <span class="info-value" id="pendingSettlement">0원</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">최근 정산 내역</span>
                            <span class="info-value" id="recentSettlement">-</span>
                        </div>
                    </div>
                </section>

                <!-- 리뷰 평점 -->
                <section class="detail-card">
                    <div class="card-title">리뷰 평점</div>
                    <div style="display: flex; flex-direction: column; gap: 1rem;">
                        <div class="info-item">
                            <span class="info-label">평균 평점</span>
                            <span class="info-value" id="reviewAvgRating">0 / 5.0</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">최근 리뷰 N건</span>
                            <div id="recentReviews" style="margin-top: 0.5rem;">
                                <div style="font-size: 0.85rem; color: var(--color-gray);">리뷰가 없습니다.</div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>

            <!-- 3단 그리드 2 -->
            <div class="three-column-grid">
                <!-- 활동 제한 이력 -->
                <section class="detail-card">
                    <div class="card-title">활동 제한 이력</div>
                    <div style="overflow-x: auto; max-height: 300px; overflow-y: auto;">
                        <table class="mini-table">
                            <thead>
                            <tr>
                                <th>활동 정지 이력</th>
                                <th>제한 사유</th>
                                <th>처리 관리자</th>
                            </tr>
                            </thead>
                            <tbody id="restrictionHistoryBody">
                            <tr>
                                <td colspan="3" style="text-align:center; padding: 2rem;">제한 이력이 없습니다.</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </section>

                <!-- 추가 정보 영역 (필요시) -->
                <section class="detail-card">
                    <div class="card-title">관리자 메모</div>
                    <textarea class="memo-textarea" id="adminMemo" placeholder="부름이에 대한 특이사항을 입력하세요..."
                              style="width: 100%; height: 150px; padding: 1rem; border: 2px solid var(--color-light-gray); border-radius: 8px; resize: vertical; font-family: inherit; font-size: 0.95rem;"></textarea>
                    <button class="btn-more" onclick="saveMemo()">메모 저장</button>
                </section>

                <!-- 제출 서류 -->
                <section class="detail-card">
                    <div class="card-title">제출 서류</div>
                    <div id="documentList" style="display: flex; flex-direction: column; gap: 0.75rem;">
                        <div style="text-align: center; padding: 2rem; color: var(--color-gray);">제출된 서류가 없습니다.</div>
                    </div>
                </section>
            </div>
        </main>
    </div>
</div>

<script>
    const currentErranderId = ${summary.detail.errander_id};
    // Sidebar logic
    $(document).ready(function () {
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');

        const savedState = localStorage.getItem('sidebarState');
        if (savedState === 'collapsed') {
            sidebar.classList.add('collapsed');
        }

        sidebarToggle.addEventListener('click', function (e) {
            e.stopPropagation();
            sidebar.classList.toggle('collapsed');
            const isCollapsed = sidebar.classList.contains('collapsed');
            localStorage.setItem('sidebarState', isCollapsed ? 'collapsed' : 'expanded');
        });

        // Load helper detail
        loadErranderDetail();
    });

    // User Dropdown Toggle
    function toggleUserDropdown() {
        const dropdown = document.getElementById('userDropdown');
        dropdown.classList.toggle('show');
    }

    document.addEventListener('click', function (e) {
        const userDropdown = document.getElementById('userDropdown');
        const headerUser = document.querySelector('.header-user');
        if (userDropdown && headerUser && !headerUser.contains(e.target)) {
            userDropdown.classList.remove('show');
        }
    });

    // Load helper detail data
    function loadErranderDetail() {
        if (!currentErranderId) {
            alert('부름이 ID가 없습니다.');
            return;
        }

        // API 호출
        fetch('${pageContext.request.contextPath}/api/admin/erranders/detail',{
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                erranderId: currentErranderId,
                limit: 5
            })
        })
            .then(response => response.json())
            .then(data => {

                console.log(data);

                // 정산 내역
                document.getElementById('totalSettlement').textContent = (data.settlementSummary.total_amount || 0).toLocaleString() + '원';
                document.getElementById('completedSettlement').textContent = (data.settlementSummary.this_month_amount|| 0).toLocaleString() + '원';
                document.getElementById('pendingSettlement').textContent = (data.settlementSummary.settlement_pending_amount || 0).toLocaleString() + '원';
                document.getElementById('recentSettlement').textContent = data.recentSettlement || '-';

                // 리뷰 평점
                document.getElementById('reviewAvgRating').textContent = (data.ratingAvg || 0) + ' / 5.0';

                // 최근 리뷰
                data.recentReviewList.forEach(r => {
                    r.created_at = formatReviewTime(r.created_at);
                });

                if (data.recentReviewList && data.recentReviewList.length > 0) {
                    const reviewsHtml = data.recentReviewList.map(review => `
                        <div style="
                            padding: 0.6rem;
                            background: #F8F9FA;
                            border-radius: 6px;
                            margin-bottom: 0.5rem;
                            display: grid;
                            grid-template-columns: 1fr auto;
                            row-gap: 0.3rem;
                        ">
                            <!-- 1행: 심부름ID / 날짜 -->
                            <div style="font-size: 0.75rem; color: var(--color-gray);">
                                심부름ID: \${review.errand_id}
                            </div>
                            <div style="font-size: 0.75rem; color: var(--color-gray); text-align: right;">
                                ${'${'}review.created_at}
                            </div>

                            <!-- 2행 왼쪽: 평점 -->
                            <div style="
                                font-size: 0.85rem;
                                color: var(--color-dark);
                                font-weight: 600;
                                white-space: nowrap;
                            ">
                                ⭐ \${review.rating}
                            </div>

                            <!-- 2행 오른쪽: 코멘트 -->
                            <div style="
                                font-size: 0.8rem;
                                color: var(--color-gray);
                                line-height: 1.4;
                            ">
                                \${review.comment}
                            </div>
                        </div>
                    `).join('');
                    document.getElementById('recentReviews').innerHTML = reviewsHtml;
                }

                // 수행 심부름 목록
                if (data.recentErrandsList && data.recentErrandsList.length > 0) {
                    const errandTbody = document.getElementById('errandListBody');
                    errandTbody.innerHTML = data.recentErrandsList.map((errand, idx) => `
                        <tr>
                            <td>${idx + 1}</td>
                            <td>${errand.errandId} - ${errand.title}</td>
                            <td>${errand.date}</td>
                            <td><span class="status-badge ${errand.status}">${errand.statusText}</span></td>
                        </tr>
                    `).join('');
                }

                // 활동 제한 이력
                if (data.restrictionHistory && data.restrictionHistory.length > 0) {
                    const restrictionTbody = document.getElementById('restrictionHistoryBody');
                    restrictionTbody.innerHTML = data.restrictionHistory.map(item => `
                        <tr>
                            <td>${item.date}</td>
                            <td>${item.reason}</td>
                            <td>${item.admin}</td>
                        </tr>
                    `).join('');
                }

                // 제출 서류
                if (data.documents && data.documents.length > 0) {
                    const documentsHtml = data.documents.map(doc => {
                        const icon = doc.type.includes('신분증') || doc.type === 'IDCARD' ? '🪪' : '📄';
                        return `
                            <div style="display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem; background: #F8F9FA; border-radius: 8px;">
                                <div style="font-size: 1.5rem;">${icon}</div>
                                <div style="flex: 1;">
                                    <div style="font-size: 0.9rem; font-weight: 600;">${doc.name || doc.type}</div>
                                    <div style="font-size: 0.75rem; color: var(--color-gray);">${doc.type}</div>
                                </div>
                                <button onclick="viewDocument('${doc.url}')" style="padding: 0.375rem 0.75rem; background: var(--color-dark); color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 0.8rem;">보기</button>
                            </div>
                        `;
                    }).join('');
                    document.getElementById('documentList').innerHTML = documentsHtml;
                }

                // 관리자 메모
                if (data.adminMemo) {
                    document.getElementById('adminMemo').value = data.adminMemo;
                }
            })
            .catch(error => {
                console.error('데이터 로드 실패:', error);
            });
    }

    function formatReviewTime(ms) {
        ms = Number(ms);
        const now = Date.now();
        const diff = now - ms;

        const min = 60 * 1000;
        const hour = 60 * min;
        const day = 24 * hour;

        // 방어 코드 (서버/클라 시간차)
        if (diff < 0) return '방금 전';

        // 1일 미만 → 상대시간
        if (diff < min) return '방금 전';
        if (diff < hour) return Math.floor(diff / min) + '분 전';
        if (diff < day) return Math.floor(diff / hour) + '시간 전';

        // 1일 이상 → 날짜로 표시
        const d = new Date(ms);
        const yyyy = d.getFullYear();
        const mm = String(d.getMonth() + 1).padStart(2, '0');
        const dd = String(d.getDate()).padStart(2, '0');

        return yyyy + '-' + mm + '-' + dd;
    }


    function viewDocument(url) {
        if (!url) {
            alert('파일 경로가 존재하지 않습니다.');
            return;
        }
        window.open(url, '_blank');
    }

    function saveMemo() {
        const memo = document.getElementById('adminMemo').value;
        // TODO: API 호출
        alert('메모가 저장되었습니다. (UI 테스트)');
        console.log('저장할 메모:', memo);
    }
</script>

</body>
</html>
