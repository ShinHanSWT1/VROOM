<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>설정 - 부름이 마이 페이지</title>
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
        
        .settings-section {
            background-color: var(--color-white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
        }
        
        .settings-section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--color-light-gray);
        }
        
        .location-selector {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .location-item {
            position: relative;
        }
        
        .location-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--color-dark);
        }
        
        .location-select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 1rem;
            background-color: var(--color-white);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .location-select:focus {
            outline: none;
            border-color: var(--color-secondary);
            box-shadow: 0 0 0 3px rgba(242, 203, 5, 0.1);
        }
        
        .location-help {
            font-size: 0.875rem;
            color: var(--color-gray);
            margin-top: 0.5rem;
        }
        
        .save-btn {
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
        
        .save-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        
        .verification-status {
            padding: 1.5rem;
            background-color: var(--color-light-gray);
            border-radius: 8px;
            margin-bottom: 1rem;
        }
        
        .verification-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
        }
        
        .verification-item:last-child {
            border-bottom: none;
        }
        
        .verification-label {
            font-weight: 500;
        }
        
        .verification-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .verification-badge.verified {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
        }
        
        .verification-badge.pending {
            background-color: var(--color-gray);
            color: var(--color-white);
        }
        
        .verify-link {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background-color: var(--color-primary);
            color: var(--color-white);
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .verify-link:hover {
            background-color: var(--color-secondary);
            color: var(--color-dark);
        }
        
        .blocked-users-info {
            padding: 1rem;
            background-color: var(--color-light-gray);
            border-radius: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .blocked-count {
            font-size: 1.125rem;
            font-weight: 600;
        }
        
        .manage-btn {
            padding: 0.75rem 1.5rem;
            background-color: var(--color-dark);
            color: var(--color-white);
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .manage-btn:hover {
            background-color: var(--color-gray);
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
            
            .location-selector {
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
                <h1>우리동네 심부름</h1>
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
                <a href="activity" class="sidebar-item">나의 거래</a>
                <a href="settings" class="sidebar-item active">설정</a>
                <a href="#" class="sidebar-item">고객지원</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="mypage-content">
            <h2 class="page-title">설정</h2>

            <!-- Preferred Neighborhood Settings -->
            <div class="settings-section">
                <h3 class="settings-section-title">동네 설정</h3>
                
                <form id="locationForm" onsubmit="saveLocationSettings(event)">
                    <div class="location-selector">
                        <div class="location-item">
                            <label class="location-label">동네 설정 1</label>
                            <select name="dongCode3" class="location-select" id="location1">
                                <option value="">선택하세요</option>
                                <!-- Options will be populated dynamically -->
                            </select>
                        </div>
                        
                        <div class="location-item">
                            <label class="location-label">동네 설정 2</label>
                            <select name="dongCode4" class="location-select" id="location2">
                                <option value="">선택하세요</option>
                                <!-- Options will be populated dynamically -->
                            </select>
                        </div>
                    </div>
                    
                    <p class="location-help">
                        * 최대 2개의 동네를 설정할 수 있습니다.
                    </p>
                    
                    <button type="submit" class="save-btn">동네 설정 저장</button>
                </form>
            </div>

            <!-- Authentication/Verification Status -->
            <div class="settings-section">
                <h3 class="settings-section-title">인증</h3>
                
                <div class="verification-status">
                    <div class="verification-item">
                        <span class="verification-label">본인 인증</span>
                        <span class="verification-badge" id="phoneVerificationBadge">미인증</span>
                    </div>
                    <div class="verification-item">
                        <span class="verification-label">이메일 인증</span>
                        <span class="verification-badge" id="emailVerificationBadge">미인증</span>
                    </div>
                </div>
                
                <a href="#" class="verify-link" onclick="goToVerification()">
                    인증 페이지로 이동 →
                </a>
            </div>

            <!-- Blocked Users Management -->
            <div class="settings-section">
                <h3 class="settings-section-title">사용자 차단</h3>
                
                <div class="blocked-users-info">
                    <div>
                        <div class="blocked-count">차단된 사용자: <span id="blockedUserCount">0</span>명</div>
                        <p style="margin-top: 0.5rem; color: var(--color-gray); font-size: 0.875rem;">
                            차단한 사용자의 게시글과 심부름 요청이 보이지 않습니다.
                        </p>
                    </div>
                    <button class="manage-btn" onclick="manageBlockedUsers()">
                        관리하기
                    </button>
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
        // Settings page JavaScript
        // Sample data - replace with API calls in production
        const userProfile = {
            isPhoneVerified: true,
            isEmailVerified: false
        };
        
        const dongCode3 = '';
        const dongCode4 = '';
        
        const locationList = [
            { dongCode: '1168010100', dongName: '서울시 강남구 역삼동' },
            { dongCode: '1168010200', dongName: '서울시 강남구 논현동' },
            { dongCode: '1168010300', dongName: '서울시 강남구 압구정동' },
            { dongCode: '1168010400', dongName: '서울시 강남구 청담동' },
            { dongCode: '1168010500', dongName: '서울시 강남구 삼성동' },
            { dongCode: '1168010600', dongName: '서울시 강남구 대치동' },
            { dongCode: '1168010700', dongName: '서울시 강남구 개포동' },
            { dongCode: '1168010800', dongName: '서울시 강남구 도곡동' }
        ];
        
        const blockedUserCount = 0;
        
        function initPage() {
            // Populate location selects
            const location1Select = document.getElementById('location1');
            const location2Select = document.getElementById('location2');
            
            locationList.forEach(location => {
                const option1 = document.createElement('option');
                option1.value = location.dongCode;
                option1.textContent = location.dongName;
                if (location.dongCode === dongCode3) {
                    option1.selected = true;
                }
                location1Select.appendChild(option1);
                
                const option2 = document.createElement('option');
                option2.value = location.dongCode;
                option2.textContent = location.dongName;
                if (location.dongCode === dongCode4) {
                    option2.selected = true;
                }
                location2Select.appendChild(option2);
            });
            
            // Update verification badges
            const phoneBadge = document.getElementById('phoneVerificationBadge');
            if (userProfile.isPhoneVerified) {
                phoneBadge.textContent = '인증 완료';
                phoneBadge.classList.add('verified');
                phoneBadge.classList.remove('pending');
            } else {
                phoneBadge.textContent = '미인증';
                phoneBadge.classList.add('pending');
                phoneBadge.classList.remove('verified');
            }
            
            const emailBadge = document.getElementById('emailVerificationBadge');
            if (userProfile.isEmailVerified) {
                emailBadge.textContent = '인증 완료';
                emailBadge.classList.add('verified');
                emailBadge.classList.remove('pending');
            } else {
                emailBadge.textContent = '미인증';
                emailBadge.classList.add('pending');
                emailBadge.classList.remove('verified');
            }
            
            // Update blocked user count
            document.getElementById('blockedUserCount').textContent = blockedUserCount;
        }
        
        function saveLocationSettings(event) {
            event.preventDefault();
            
            const location1 = document.getElementById('location1').value;
            const location2 = document.getElementById('location2').value;
            
            if (!location1 && !location2) {
                alert('최소 1개의 동네를 선택해주세요.');
                return false;
            }
            
            if (location1 && location2 && location1 === location2) {
                alert('서로 다른 동네를 선택해주세요.');
                return false;
            }
            
            // In production, make API call here
            fetch('/api/rider/mypage/settings/location', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    dongCode3: location1,
                    dongCode4: location2
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('동네 설정이 저장되었습니다.');
                } else {
                    alert('동네 설정 저장 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('동네 설정 저장 중 오류가 발생했습니다.');
            });
        }
        
        function goToVerification() {
            // Navigate to verification page
            alert('인증 페이지로 이동합니다.');
            // location.href = '/rider/verify';
        }
        
        function manageBlockedUsers() {
            // Navigate to blocked users management page
            alert('차단된 사용자 관리 페이지로 이동합니다.');
            // location.href = '/rider/mypage/settings/blocked-users';
        }
        
        // Initialize on page load
        initPage();
    </script>
</body>
</html>
