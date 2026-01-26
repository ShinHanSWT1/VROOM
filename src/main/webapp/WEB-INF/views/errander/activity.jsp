<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나의 거래 - 부름이 마이 페이지</title>
    <link rel="stylesheet" href="<c:url value='/static/errander/css/styles.css'/>">
    <!-- 달력을 jsp로 구현을 해놨는데 이거 달력을 쓰는 라이브러리 배운적 있었던거 같아서 그거 찾아서 적용함-->
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css' rel='stylesheet' />

    <style>
        .mypage-layout {
            display: flex;
            gap: 2rem;
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }
        
        .mypage-sidebar {
            width: 200px;
            flex-shrink: 0;
        }
        
        .mypage-content {
            flex: 1;
        }
        
        .sidebar-menu {
            background-color: var(--color-white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .sidebar-item {
            display: block;
            padding: 1rem 1.5rem;
            color: var(--color-dark);
            text-decoration: none;
            border-bottom: 1px solid var(--color-light-gray);
            transition: all 0.3s ease;
        }
        
        .sidebar-item:last-child {
            border-bottom: none;
        }
        
        .sidebar-item:hover {
            background-color: var(--color-light-gray);
        }
        
        .sidebar-item.active {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-dark);
            font-weight: 600;
        }
        
        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--color-dark);
            margin-bottom: 2rem;
        }
        
        .activity-layout {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
        }
        
        .calendar-section {
            background-color: var(--color-white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        /* FullCalendar 커스텀 스타일 */
        #calendar {
            margin-bottom: 1.5rem;
        }

        .fc .fc-toolbar-title {
            font-size: 1.25rem;
            font-weight: 600;
        }

        .fc .fc-button-primary {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            border: none;
        }

        .fc .fc-button-primary:hover {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
        }

        .fc .fc-daygrid-day.fc-day-today {
            background-color: rgba(242, 203, 5, 0.2);
        }

        .fc-event {
            cursor: pointer;
            padding: 2px 4px;
            font-size: 0.75rem;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            border: none;
            color: var(--color-dark);
        }
        
        .transaction-list-section {
            background-color: var(--color-white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .transaction-list-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            text-align: center;
            padding: 1rem;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            border-radius: 8px;
        }
        
        .transaction-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.25rem;
            border-bottom: 1px solid var(--color-light-gray);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .transaction-item:last-child {
            border-bottom: none;
        }
        
        .transaction-item:hover {
            background-color: var(--color-light-gray);
        }
        
        .transaction-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .transaction-icon {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            border-radius: 8px;
            font-size: 1.5rem;
        }
        
        .transaction-details {
            display: flex;
            flex-direction: column;
        }
        
        .transaction-name {
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.25rem;
        }
        
        .transaction-date {
            font-size: 0.875rem;
            color: var(--color-gray);
        }
        
        .transaction-amount {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--color-accent);
        }
        
        .detail-info-sidebar {
            background-color: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .detail-info-title {
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        
        .detail-info-list {
            list-style: none;
        }
        
        .detail-info-item {
            padding: 0.75rem;
            margin-bottom: 0.5rem;
            background-color: var(--color-light-gray);
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .detail-info-number {
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            border-radius: 50%;
            font-weight: 600;
            font-size: 0.875rem;
        }
        
        .view-all-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-dark);
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .view-all-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        
        @media (max-width: 768px) {
            .mypage-layout {
                flex-direction: column;
            }
            
            .mypage-sidebar {
                width: 100%;
            }
            
            .sidebar-menu {
                display: flex;
                overflow-x: auto;
            }
            
            .sidebar-item {
                white-space: nowrap;
                border-bottom: none;
                border-right: 1px solid var(--color-light-gray);
            }
            
            .activity-layout {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <div class="logo">
                <h1>VROOM</h1>
            </div>
            <nav class="nav-menu">
                <a href="../../main.html" class="nav-item">홈</a>
                <a href="#" class="nav-item">커뮤니티</a>
                <a href="<c:url value='/member/myInfo'/>" class="nav-item nav-user">유저</a>
            </nav>
        </div>
    </header>

    <!-- Mypage Layout -->
    <div class="mypage-layout">
        <!-- Sidebar Navigation -->
        <aside class="mypage-sidebar">
            <nav class="sidebar-menu">
                <a href="profile" class="sidebar-item">나의 정보</a>
                <a href="pay" class="sidebar-item">부름 페이</a>
                <a href="activity" class="sidebar-item active">나의 거래</a>
                <a href="settings" class="sidebar-item">설정</a>
                <a href="#" class="sidebar-item">고객지원</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="mypage-content">
            <h2 class="page-title">나의 거래</h2>

            <div class="activity-layout">
                <!-- Left Column: Calendar and Transaction List -->
                <div>
                    <!-- Calendar Section (FullCalendar) -->
                    <div class="calendar-section">
                        <div id="calendar"></div>

                        <button class="view-all-btn" onclick="viewAllTransactions()">
                            전체 거래 내역 조회
                        </button>
                    </div>

                    <!-- Transaction List -->
                    <div class="transaction-list-section" style="margin-top: 2rem;">
                        <h3 class="transaction-list-title">심부름 제목, 날짜, 금액</h3>
                        
                        <div id="transactionListContainer">
                            <!-- Transaction items will be dynamically inserted here -->
                        </div>
                    </div>
                </div>

                <!-- Right Column: Detail Info Sidebar -->
                <div class="detail-info-sidebar">
                    <h3 class="detail-info-title">거래 상세 정보 조회</h3>
                    <ul class="detail-info-list">
                        <li class="detail-info-item">
                            <div class="detail-info-number">1</div>
                            <span>작성자(사용자) 정보 조회</span>
                        </li>
                        <li class="detail-info-item">
                            <div class="detail-info-number">2</div>
                            <span>심부름 날짜·시간 조회</span>
                        </li>
                        <li class="detail-info-item">
                            <div class="detail-info-number">3</div>
                            <span>심부름 장소 정보 조회</span>
                        </li>
                        <li class="detail-info-item">
                            <div class="detail-info-number">4</div>
                            <span>페이 거래 내역 조회</span>
                        </li>
                        <li class="detail-info-item">
                            <div class="detail-info-number">5</div>
                            <span>리뷰 정보 조회</span>
                        </li>
                    </ul>
                </div>
            </div>
        </main>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-info">
                    <h3>VROOM</h3>
                    <p>이웃과 함께하는 따뜻한 심부름 커뮤니티</p>
                </div>
                <div class="footer-copyright">
                    <p>&copy; 2024 VROOM. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
    <script>
        let calendar;
        let earningsData = []; // 서버에서 가져온 일별 수익 데이터

        function formatCurrency(amount) {
            return '₩' + amount.toLocaleString('ko-KR');
        }

        // 서버에서 일별 수익 데이터 가져오기
        async function fetchDailyEarnings(year, month) {
            try {
                const response = await fetch('/errander/mypage/api/daily-earnings?year=' + year + '&month=' + month);
                if (!response.ok) {
                    throw new Error('API 호출 실패');
                }
                return await response.json();
            } catch (error) {
                console.error('일별 수익 조회 오류:', error);
                return [];
            }
        }

        // 수익 데이터를 FullCalendar 이벤트로 변환
        function convertToCalendarEvents(earnings) {
            return earnings.map(item => ({
                title: formatCurrency(item.dailyEarning),
                start: item.earnDate,
                extendedProps: {
                    amount: item.dailyEarning
                }
            }));
        }

        // 달력 이벤트 갱신
        async function loadCalendarEvents(year, month) {
            earningsData = await fetchDailyEarnings(year, month);
            const events = convertToCalendarEvents(earningsData);

            // 기존 이벤트 제거 후 새 이벤트 추가
            calendar.removeAllEvents();
            events.forEach(event => calendar.addEvent(event));

            // 거래 목록도 갱신
            renderTransactionList(earningsData);
        }

        document.addEventListener('DOMContentLoaded', function() {
            const calendarEl = document.getElementById('calendar');
            const now = new Date();

            calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ko',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: ''
                },
                buttonText: {
                    today: '오늘'
                },

                // 날짜 클릭 시
                dateClick: function(info) {
                    const dateStr = info.dateStr;
                    const filtered = earningsData.filter(a => a.earnDate === dateStr);
                    renderTransactionList(filtered);
                },

                // 월 변경 시 데이터 다시 로드
                datesSet: function(info) {
                    const viewStart = info.view.currentStart;
                    const year = viewStart.getFullYear();
                    const month = viewStart.getMonth() + 1;
                    loadCalendarEvents(year, month);
                }
            });

            calendar.render();
        });

        function renderTransactionList(earnings) {
            const container = document.getElementById('transactionListContainer');
            container.innerHTML = '';

            if (earnings.length === 0) {
                container.innerHTML = '<p style="text-align: center; color: var(--color-gray); padding: 2rem;">거래 내역이 없습니다.</p>';
                return;
            }

            earnings.forEach(item => {
                const itemEl = document.createElement('div');
                itemEl.className = 'transaction-item';

                itemEl.innerHTML = `
                    <div class="transaction-info">
                        <div class="transaction-icon">🐝</div>
                        <div class="transaction-details">
                            <div class="transaction-name">\${item.earnDate}</div>
                            <div class="transaction-date">일별 수익</div>
                        </div>
                    </div>
                    <div class="transaction-amount">\${formatCurrency(item.dailyEarning)}</div>
                `;
                container.appendChild(itemEl);
            });
        }

        function viewAllTransactions() {
            renderTransactionList(earningsData);
        }
    </script>
</body>
</html>

