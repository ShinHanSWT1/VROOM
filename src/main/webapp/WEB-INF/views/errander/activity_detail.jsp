<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>거래 상세 정보 - 부름이 마이 페이지</title>
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
        
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background-color: var(--color-white);
            border: 1px solid var(--color-light-gray);
            border-radius: 8px;
            color: var(--color-dark);
            text-decoration: none;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }
        
        .back-btn:hover {
            background-color: var(--color-light-gray);
        }
        
        .detail-section {
            background-color: var(--color-white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
        }
        
        .detail-section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--color-light-gray);
        }
        
        .requester-info {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }
        
        .requester-avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
        }
        
        .requester-details {
            flex: 1;
        }
        
        .requester-name {
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .requester-meta {
            display: flex;
            gap: 1rem;
            font-size: 0.875rem;
            color: var(--color-gray);
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
        }
        
        .info-item {
            padding: 1rem;
            background-color: var(--color-light-gray);
            border-radius: 8px;
        }
        
        .info-label {
            font-size: 0.875rem;
            color: var(--color-gray);
            margin-bottom: 0.5rem;
        }
        
        .info-value {
            font-size: 1rem;
            font-weight: 600;
            color: var(--color-dark);
        }
        
        .location-info {
            padding: 1rem;
            background-color: var(--color-light-gray);
            border-radius: 8px;
        }
        
        .payment-info-grid {
            display: grid;
            gap: 1rem;
        }
        
        .payment-row {
            display: flex;
            justify-content: space-between;
            padding: 1rem;
            background-color: var(--color-light-gray);
            border-radius: 8px;
        }
        
        .payment-label {
            font-weight: 500;
        }
        
        .payment-value {
            font-weight: 600;
        }
        
        .payment-total {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-dark);
            font-size: 1.125rem;
        }
        
        .review-content {
            padding: 1.5rem;
            background-color: var(--color-light-gray);
            border-radius: 8px;
            line-height: 1.6;
        }
        
        .review-rating {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        
        .rating-stars {
            color: var(--color-secondary);
            font-size: 1.25rem;
        }
        
        .rating-score {
            font-weight: 600;
            font-size: 1.125rem;
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
            
            .info-grid {
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
                <a href="member/myInfo" class="nav-item nav-user" id="userNickname">유저</a>
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
            <a href="activity" class="back-btn">
                ← 목록으로 돌아가기
            </a>
            
            <h2 class="page-title">거래 상세 정보</h2>

            <!-- Requester Information Section -->
            <div class="detail-section">
                <h3 class="detail-section-title">작성자(사용자) 정보</h3>
                <div class="requester-info">
                    <div class="requester-avatar">👤</div>
                    <div class="requester-details">
                        <div class="requester-name" id="requesterName">홍길동</div>
                        <div class="requester-meta">
                            <span>닉네임: <span id="requesterNickname">길동이</span></span>
                            <span>신뢰도: <span id="requesterTrustScore">95</span>%</span>
                            <span>완료 건수: <span id="requesterCompletedCount">42</span>건</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Schedule Information Section -->
            <div class="detail-section">
                <h3 class="detail-section-title">심부름 날짜·시간 정보</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">작성일</div>
                        <div class="info-value" id="createdDate">2024-01-10</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">수행 날짜</div>
                        <div class="info-value" id="scheduledDate">2024-01-15</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">수행 시간</div>
                        <div class="info-value" id="scheduledTime">14:30</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">완료 시간</div>
                        <div class="info-value" id="completedTime">15:45</div>
                    </div>
                </div>
            </div>

            <!-- Location Information Section -->
            <div class="detail-section">
                <h3 class="detail-section-title">심부름 장소 정보</h3>
                <div class="location-info">
                    <div class="info-label">출발지</div>
                    <div class="info-value" style="margin-bottom: 1rem;" id="startAddress">서울시 강남구 역삼동 123-45</div>
                    
                    <div class="info-label">도착지</div>
                    <div class="info-value" id="endAddress">서울시 강남구 역삼동 678-90</div>
                </div>
            </div>

            <!-- Payment Information Section -->
            <div class="detail-section">
                <h3 class="detail-section-title">페이 거래 내역</h3>
                <div class="payment-info-grid">
                    <div class="payment-row">
                        <span class="payment-label">기본 금액</span>
                        <span class="payment-value" id="baseAmount">₩10,000</span>
                    </div>
                    <div class="payment-row">
                        <span class="payment-label">추가 금액</span>
                        <span class="payment-value" id="additionalAmount">₩5,000</span>
                    </div>
                    <div class="payment-row">
                        <span class="payment-label">수수료</span>
                        <span class="payment-value">- <span id="fee">₩1,000</span></span>
                    </div>
                    <div class="payment-row payment-total">
                        <span class="payment-label">최종 수익</span>
                        <span class="payment-value" id="finalAmount">₩14,000</span>
                    </div>
                </div>
            </div>

            <!-- Review Information Section -->
            <div class="detail-section">
                <h3 class="detail-section-title">리뷰 정보</h3>
                <div id="reviewContainer">
                    <div class="review-rating">
                        <span class="rating-stars">★★★★★</span>
                        <span class="rating-score" id="reviewRating">4.5 / 5.0</span>
                    </div>
                    <div class="review-content" id="reviewContent">
                        매우 친절하고 빠르게 심부름을 완료해주셨어요! 다음에도 부탁드리고 싶습니다.
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-info">
                    <h3>우리동네 심부름</h3>
                    <p>이웃과 함께하는 따뜻한 심부름 커뮤니티</p>
                </div>
                <div class="footer-copyright">
                    <p>&copy; 2024 우리동네 심부름. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <script>
        // Activity detail page JavaScript
        // Sample data - replace with API calls in production
        const requesterInfo = {
            name: '홍길동',
            nickname: '길동이',
            trustScore: 95,
            completedCount: 42
        };
        
        const vroomSchedule = {
            createdDate: '2024-01-10',
            scheduledDate: '2024-01-15',
            scheduledTime: '14:30',
            completedTime: '15:45'
        };
        
        const vroomLocation = {
            startAddress: '서울시 강남구 역삼동 123-45',
            endAddress: '서울시 강남구 역삼동 678-90'
        };
        
        const paymentInfo = {
            baseAmount: 10000,
            additionalAmount: 5000,
            fee: 1000,
            finalAmount: 14000
        };
        
        const reviewInfo = {
            rating: 4.5,
            content: '매우 친절하고 빠르게 심부름을 완료해주셨어요! 다음에도 부탁드리고 싶습니다.'
        };
        
        function formatCurrency(amount) {
            return '₩' + amount.toLocaleString('ko-KR');
        }
        
        function initPage() {
            // Get vroomId from URL
            const urlParams = new URLSearchParams(window.location.search);
            const vroomId = urlParams.get('id');
            
            // In production, fetch data from API using vroomId
            // For now, use sample data
            
            // Update requester info
            document.getElementById('requesterName').textContent = requesterInfo.name;
            document.getElementById('requesterNickname').textContent = requesterInfo.nickname;
            document.getElementById('requesterTrustScore').textContent = requesterInfo.trustScore;
            document.getElementById('requesterCompletedCount').textContent = requesterInfo.completedCount;
            
            // Update schedule
            document.getElementById('createdDate').textContent = vroomSchedule.createdDate;
            document.getElementById('scheduledDate').textContent = vroomSchedule.scheduledDate;
            document.getElementById('scheduledTime').textContent = vroomSchedule.scheduledTime;
            document.getElementById('completedTime').textContent = vroomSchedule.completedTime;
            
            // Update location
            document.getElementById('startAddress').textContent = vroomLocation.startAddress;
            document.getElementById('endAddress').textContent = vroomLocation.endAddress;
            
            // Update payment
            document.getElementById('baseAmount').textContent = formatCurrency(paymentInfo.baseAmount);
            document.getElementById('additionalAmount').textContent = formatCurrency(paymentInfo.additionalAmount);
            document.getElementById('fee').textContent = formatCurrency(paymentInfo.fee);
            document.getElementById('finalAmount').textContent = formatCurrency(paymentInfo.finalAmount);
            
            // Update review
            if (reviewInfo && reviewInfo.content) {
                document.getElementById('reviewRating').textContent = reviewInfo.rating + ' / 5.0';
                document.getElementById('reviewContent').textContent = reviewInfo.content;
            } else {
                document.getElementById('reviewContainer').innerHTML = 
                    '<div class="review-content">아직 리뷰가 작성되지 않았습니다.</div>';
            }
        }
        
        // Initialize on page load
        initPage();
    </script>
</body>
</html>
