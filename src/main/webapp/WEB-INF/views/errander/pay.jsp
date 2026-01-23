<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>부름Pay - 부름이 마이 페이지</title>
    <link rel="stylesheet" href="<c:url value='/static/errander/css/styles.css'/>">
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
        
        .pay-summary-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .pay-summary-card {
            background-color: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .pay-summary-label {
            font-size: 0.875rem;
            color: var(--color-gray);
            margin-bottom: 0.75rem;
        }
        
        .pay-summary-value {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--color-dark);
        }
        
        .settlement-section {
            background-color: var(--color-white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }
        
        .settlement-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .settlement-info {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .settlement-info-item {
            flex: 1;
            padding: 1rem;
            background-color: var(--color-light-gray);
            border-radius: 8px;
            text-align: center;
        }
        
        .withdraw-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-dark);
            border: none;
            border-radius: 8px;
            font-size: 1.125rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .withdraw-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        
        .settlement-list {
            background-color: var(--color-white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .settlement-list-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
        }
        
        .settlement-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.25rem;
            border-bottom: 1px solid var(--color-light-gray);
            transition: all 0.3s ease;
        }
        
        .settlement-item:last-child {
            border-bottom: none;
        }
        
        .settlement-item:hover {
            background-color: var(--color-light-gray);
        }
        
        .settlement-item-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .settlement-icon {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            border-radius: 8px;
            font-size: 1.5rem;
        }
        
        .settlement-details {
            display: flex;
            flex-direction: column;
        }
        
        .settlement-name {
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.25rem;
        }
        
        .settlement-date {
            font-size: 0.875rem;
            color: var(--color-gray);
        }
        
        .settlement-amount {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--color-accent);
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
        }
        
        .page-btn {
            padding: 0.5rem 1rem;
            background-color: var(--color-white);
            border: 1px solid var(--color-light-gray);
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .page-btn:hover {
            background-color: var(--color-light-gray);
        }
        
        .page-btn.active {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-dark);
            font-weight: 600;
            border-color: transparent;
        }
        
        .page-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
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
            
            .pay-summary-grid {
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
                <a href="pay" class="sidebar-item active">부름 페이</a>
                <a href="activity" class="sidebar-item">나의 거래</a>
                <a href="settings" class="sidebar-item">설정</a>
                <a href="#" class="sidebar-item">고객지원</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="mypage-content">
            <h2 class="page-title">부름Pay</h2>

            <!-- Pay Summary Cards -->
            <div class="pay-summary-grid">
                <div class="pay-summary-card">
                    <div class="pay-summary-label">정산 대기 금액</div>
                    <div class="pay-summary-value" id="settlementWaiting">₩0</div>
                </div>
                <div class="pay-summary-card">
                    <div class="pay-summary-label">사용 가능 잔액</div>
                    <div class="pay-summary-value" id="availableBalance">₩0</div>
                </div>
                <div class="pay-summary-card">
                    <div class="pay-summary-label">이번 달 정산 완료 수익</div>
                    <div class="pay-summary-value" id="thisMonthSettled">₩0</div>
                </div>
            </div>

            <!-- Current Settlement Section -->
            <div class="settlement-section">
                <h3 class="settlement-title">현재 정산 처리 중인 심부름</h3>
                
                <div class="settlement-info">
                    <div class="settlement-info-item">
                        <div>수령 예정 금액 <span id="expectedAmount">₩0</span></div>
                    </div>
                    <div class="settlement-info-item">
                        <div>상태: <span id="settlementStatus">대기중</span></div>
                    </div>
                </div>
                
                <button class="withdraw-btn" onclick="requestWithdrawal()">출금 요청</button>
            </div>

            <!-- Settlement History List -->
            <div class="settlement-list">
                <h3 class="settlement-list-title">정산 내역 보기</h3>
                
                <div id="settlementListContainer">
                    <!-- Settlement items will be dynamically inserted here -->
                </div>
                
                <!-- Pagination -->
                <div class="pagination">
                    <button class="page-btn" id="prevBtn" onclick="goToPage(currentPage - 1)">이전</button>
                    
                    <div id="pageNumbers"></div>
                    
                    <button class="page-btn" id="nextBtn" onclick="goToPage(currentPage + 1)">다음</button>
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

    <script>
        // VroomPay page JavaScript
        // Sample data - replace with API calls in production
        const paySummary = {
            settlementWaiting: 50000,
            availableBalance: 150000,
            thisMonthSettled: 300000
        };
        
        const settlementInProgress = {
            expectedAmount: 25000,
            status: '처리중'
        };
        
        const settlementList = [
            { name: '배달 심부름', date: '2024-01-15', amount: 15000 },
            { name: '청소 심부름', date: '2024-01-14', amount: 30000 },
            { name: '설치 서비스', date: '2024-01-13', amount: 50000 }
        ];
        
        let currentPage = 1;
        const totalPages = 5;
        
        // Format number as currency
        function formatCurrency(amount) {
            return '₩' + amount.toLocaleString('ko-KR');
        }
        
        // Initialize page data
        function initPage() {
            // Update summary cards
            document.getElementById('settlementWaiting').textContent = formatCurrency(paySummary.settlementWaiting);
            document.getElementById('availableBalance').textContent = formatCurrency(paySummary.availableBalance);
            document.getElementById('thisMonthSettled').textContent = formatCurrency(paySummary.thisMonthSettled);
            
            // Update settlement in progress
            document.getElementById('expectedAmount').textContent = formatCurrency(settlementInProgress.expectedAmount);
            document.getElementById('settlementStatus').textContent = settlementInProgress.status;
            
            // Render settlement list
            renderSettlementList();
            
            // Render pagination
            renderPagination();
        }

        function renderSettlementList() {
            const container = document.getElementById('settlementListContainer');
            container.innerHTML = '';

            settlementList.forEach(settlement => {
                const item = document.createElement('div');
                item.className = 'settlement-item';
                item.innerHTML = `
                    <div class="settlement-item-info">
                        <div class="settlement-icon">🍯</div>
                        <div class="settlement-details">
                            <div class="settlement-name">\${settlement.name}</div>
                            <div class="settlement-date">\${settlement.date}</div>
                        </div>
                    </div>
                    <div class="settlement-amount">\${formatCurrency(settlement.amount)}</div>
                `;
                container.appendChild(item);
            });
        }
        
        function renderPagination() {
            const pageNumbers = document.getElementById('pageNumbers');
            pageNumbers.innerHTML = '';
            
            for (let page = 1; page <= totalPages; page++) {
                const btn = document.createElement('button');
                btn.className = 'page-btn' + (page === currentPage ? ' active' : '');
                btn.textContent = page;
                btn.onclick = () => goToPage(page);
                pageNumbers.appendChild(btn);
            }
            
            document.getElementById('prevBtn').disabled = currentPage === 1;
            document.getElementById('nextBtn').disabled = currentPage === totalPages;
        }
        
        function requestWithdrawal() {
            if (confirm('출금을 요청하시겠습니까?')) {
                // In production, make API call here
                fetch('/api/rider/mypage/pay/withdraw', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        amount: settlementInProgress.expectedAmount
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('출금 요청이 완료되었습니다.');
                        location.reload();
                    } else {
                        alert('출금 요청 중 오류가 발생했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('출금 요청 중 오류가 발생했습니다.');
                });
            }
        }
        
        function goToPage(page) {
            if (page < 1 || page > totalPages) return;
            currentPage = page;
            // In production, load data for the page
            renderPagination();
            // renderSettlementList(); // Reload settlement list for new page
        }
        
        // Initialize on page load
        initPage();
    </script>
</body>
</html>

