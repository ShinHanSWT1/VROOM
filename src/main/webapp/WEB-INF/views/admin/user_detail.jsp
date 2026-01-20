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
    <title>VROOM - 사용자 상세 정보</title>

    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet" as="style"
          href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">

    <style>
        /* users.jsp의 기존 스타일 변수 및 공통 스타일 유지 */
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

        /* 레이아웃 (users.jsp와 동일) */
        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

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
        }

        .sidebar.collapsed {
            width: var(--sidebar-collapsed-width);
        }

        .sidebar-header {
            height: var(--header-height);
            padding: 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-logo img {
            width: 150px;
        }

        .sidebar.collapsed .sidebar-logo {
            display: none;
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
            color: white;
            text-decoration: none;
            transition: 0.3s;
            border-left: 4px solid transparent;
        }

        .nav-item:hover, .nav-item.active {
            background: rgba(255, 255, 255, 0.1);
            border-left-color: var(--color-secondary);
        }

        .nav-item-icon {
            margin-right: 10px;
            font-size: 1.2rem;
            min-width: 30px;
            text-align: center;
        }

        .sidebar.collapsed .nav-item-text {
            display: none;
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

        /* 상세 페이지 전용 스타일 시작 */
        .page-content {
            padding: 2rem;
        }

        /* 타이틀 영역 (뒤로가기 버튼 포함) */
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

        /* 공통 카드 스타일 */
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

        /* 1. 기본 정보 그리드 */
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

        /* 2. 활동 요약 (users.jsp summary-card 재사용) */
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
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

        /* 3. 하단 3단 그리드 */
        .bottom-grid {
            display: grid;
            grid-template-columns: 1.2fr 1fr 1fr;
            gap: 1.5rem;
        }

        /* 테이블 스타일 (신고 이력) */
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

        .status-badge-sm {
            font-size: 0.75rem;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-weight: 600;
        }

        .status-badge-sm.WAITING {
            background: #FFF3E0;
            color: #F57C00;
        }

        .status-badge-sm.DONE {
            background: #E8F5E9;
            color: #2E7D32;
        }

        /* 관리자 메모 */
        .memo-textarea {
            width: 100%;
            height: 200px;
            padding: 1rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            resize: none;
            font-family: inherit;
            font-size: 0.95rem;
            margin-bottom: 1rem;
            transition: 0.3s;
        }

        .memo-textarea:focus {
            outline: none;
            border-color: var(--color-secondary);
        }

        .btn-save {
            width: 100%;
            padding: 0.8rem;
            background: var(--color-dark);
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-save:hover {
            background: #1a252f;
        }

        /* 활동 히스토리 타임라인 */
        .timeline {
            list-style: none;
            position: relative;
            padding-left: 1.5rem;
            border-left: 2px solid #eee;
            margin-left: 0.5rem;
        }

        .timeline-item {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -1.95rem;
            top: 0.4rem;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--color-light-gray);
            border: 2px solid white;
            box-shadow: 0 0 0 1px #eee;
        }

        .timeline-item.active::before {
            background: var(--color-secondary);
        }

        .timeline-date {
            font-size: 0.8rem;
            color: var(--color-gray);
            margin-bottom: 0.2rem;
        }

        .timeline-content {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--color-dark);
        }

        .timeline-desc {
            font-size: 0.85rem;
            color: #666;
            margin-top: 0.2rem;
        }

        /* 반응형 */
        @media (max-width: 1200px) {
            .bottom-grid {
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
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item active">
                <span class="nav-item-icon">👥</span>
                <span class="nav-item-text">사용자 관리</span>
            </a>
            <a href="#" class="nav-item">
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

        <main class="page-content">
            <div class="page-header-row">
                <h2 class="page-title">사용자 상세 정보</h2>
                <a href="${pageContext.request.contextPath}/admin/users" class="btn-back">
                    ⬅ 목록으로 돌아가기
                </a>
            </div>

            <section class="detail-card">
                <div class="card-title">기본 정보</div>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="info-label">사용자 ID / 닉네임</span>
                        <span class="info-value highlight">${user.userId} / ${user.nickname}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">이메일</span>
                        <span class="info-value">${user.email}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">휴대폰 번호</span>
                        <span class="info-value">${user.phone != null ? user.phone : '-'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">역할 (Role)</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${user.role eq 'ERRANDER'}">👤 일반 사용자 / 🏃 심부름꾼 </c:when>
                                <c:otherwise>👤 일반 사용자</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">가입일</span>
                        <span class="info-value"><fmt:formatDate value="${user.createdAt}"
                                                                 pattern="yyyy-MM-dd HH:mm"/></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">매너온도</span>
                        <span class="info-value">${user.mannerScore}℃</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">상태</span>
                        <span class="info-value">${user.status}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">최근 로그인 (IP / 시간)</span>
                        <span class="info-value"><fmt:formatDate value="${user.lastLoginAt}"
                                                                 pattern="yyyy-MM-dd HH:mm"/></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">활동 동네 1</span>
                        <span class="info-value">${user.address1 != null ? user.address1 : '미설정'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">활동 동네 2</span>
                        <span class="info-value">${user.address2 != null ? user.address2 : '미설정'}</span>
                    </div>
                </div>
            </section>

            <section class="detail-card">
                <div class="card-title">활동 요약 (한눈에 보기)</div>
                <div class="summary-grid">
                    <div class="summary-item">
                        <div class="summary-label">심부름 등록 횟수</div>
                        <div class="summary-value">${user.errandCount}<span class="summary-unit">회</span></div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">취소율</div>
                        <div class="summary-value" style="color: #E74C3C;">${user.cancelRate}<span
                                class="summary-unit">%</span></div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">신고 당한 횟수</div>
                        <div class="summary-value" style="color: #E74C3C;">${user.reportedCount}<span
                                class="summary-unit">회</span></div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">누적 거래 금액</div>
                        <div class="summary-value" style="color: var(--color-primary);"><fmt:formatNumber
                                value="${user.totalTxAmount}" pattern="#,###"/><span class="summary-unit"> Vpay</span></div>
                    </div>
                </div>
            </section>

            <div class="bottom-grid">

                <section class="detail-card">
                    <div class="card-title">신고 이력 조회</div>
                    <div style="overflow-x: auto; max-height: 300px; overflow-y: auto;">
                        <table class="mini-table">
                            <thead>
                            <tr>
                                <th>아이디</th>
                                <th>날짜</th>
                                <th>유형</th>
                                <th>상태</th>
                                <th>사유</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:if test="${empty user.reportHistory}">
                                <tr>
                                    <td colspan="4" style="text-align:center; padding: 2rem;">신고 내역이 없습니다.</td>
                                </tr>
                            </c:if>

                            <c:forEach var="report" items="${user.reportHistory}">
                                <tr>
                                    <td>${report.ticketId}</td>
                                    <td><fmt:formatDate value="${report.createdAt}" pattern="MM-dd"/></td>
                                    <td>${report.type}</td>
                                    <td>
                                            <span class="status-badge-sm ${report.status == 'DONE' ? 'DONE' : 'WAITING'}">
                                                    ${report.status == 'DONE' ? '처리완료' : '대기중'}
                                            </span>
                                    </td>
                                    <td>${report.reason}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </section>

                <section class="detail-card">
                    <div class="card-title">
                        관리자 메모
                        <span style="font-size: 0.8rem; color: #888; font-weight: normal;">🔒 관리자만 볼 수 있음</span>
                    </div>
                    <form id="memoForm">
                        <textarea class="memo-textarea" id="adminMemo"
                                  placeholder="특이사항을 입력하세요. (예: 욕설 신고 2회, 악의적 취소 반복 등)">일시정지 사유: ${user.suspensionNote} <br> ${user.adminMemo}</textarea>
                        <button type="button" class="btn-save" onclick="saveMemo()">메모 저장</button>
                    </form>
                </section>

                <section class="detail-card">
                    <div class="card-title">최근 활동 히스토리</div>
                    <ul class="timeline">
                        <c:forEach var="history" items="${user.activityHistory}" varStatus="status">
                            <li class="timeline-item ${status.first ? 'active' : ''}">
                                <div class="timeline-date"><fmt:formatDate value="${history.occurredAt}"
                                                                           pattern="yyyy-MM-dd HH:mm"/></div>
                                <div class="timeline-content">${history.type}</div>
                                <div class="timeline-desc">${history.description}</div>
                            </li>
                        </c:forEach>

                    </ul>
                </section>

            </div>
        </main>
    </div>
</div>

<script>
    // Sidebar logic (users.jsp와 동일)
    $(document).ready(function () {
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');
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

    // 메모 저장 기능 (AJAX 예시)
    function saveMemo() {
        const memoContent = document.getElementById('adminMemo').value;
        const userId = '${user.userId}'; // EL로 현재 보고 있는 유저 ID 주입

        if (!userId) {
            alert("유저 정보를 찾을 수 없습니다.");
            return;
        }

        // 실제 API 연동 시 주석 해제 및 수정
        /*
        fetch('
        ${pageContext.request.contextPath}/api/admin/users/' + userId + '/memo', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ memo: memoContent })
        })
        .then(res => res.json())
        .then(data => {
            if(data.result === 'success') alert('메모가 저장되었습니다.');
            else alert('저장 실패');
        });
        */

        // 테스트용 알림
        console.log("저장할 메모:", memoContent);
        alert("관리자 메모가 저장되었습니다. (UI 테스트)");
    }
</script>

</body>
</html>