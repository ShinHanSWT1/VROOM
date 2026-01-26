<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="나의 정보 - 부름이 마이 페이지" scope="request"/>
<c:set var="pageCss" value="profile" scope="request"/>
<c:set var="pageCssDir" value="errander" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<!-- Mypage Layout -->
<div class="mypage-layout">
    <!-- Sidebar Navigation -->
    <aside class="mypage-sidebar">
        <nav class="sidebar-menu">
            <a href="profile" class="sidebar-item active">나의 정보</a>
            <a href="pay" class="sidebar-item">부름 페이</a>
            <a href="activity" class="sidebar-item">나의 거래</a>
            <a href="settings" class="sidebar-item">설정</a>
            <a href="#" class="sidebar-item">고객지원</a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="mypage-content">
        <!-- Profile Header with Greeting -->
        <div class="profile-header">
            <div style="display: flex; align-items: center; gap: 1.5rem; margin-bottom: 1rem;">
                <c:choose>
                    <c:when test="${not empty profile.profileImage}">
                        <img src="<c:url value='${profile.profileImage}'/>"
                             alt="프로필 이미지"
                             style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid white;">
                    </c:when>
                    <c:otherwise>
                        <div style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%); display: flex; align-items: center; justify-content: center; font-size: 2rem; color: white; border: 3px solid white;">
                            🐝
                        </div>
                    </c:otherwise>
                </c:choose>
                <h2 class="profile-greeting"> ${profile.nickname}</h2>
            </div>
            
            <!-- Progress Bars -->
            <div class="progress-bar-container">
                <div class="progress-label">
                    <span>심부름 완료율 <span id="completionRate">${profile.completeRate != null ? profile.completeRate : 0}</span>%</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" id="completionRateBar" style="width: ${profile.completeRate != null ? profile.completeRate : 0}%">
                        ${profile.completeRate != null ? profile.completeRate : 0}%
                    </div>
                </div>
            </div>
            
            <!-- Stats Row -->
            <div class="profile-stats">
                <div class="stat-item">
                    <div class="stat-label">[ 수행 중 ]</div>
                    <div class="stat-value" id="inProgressCount">${profile.inProgressCount != null ? profile.inProgressCount : 0}건</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">[ 완료 ]</div>
                    <div class="stat-value" id="completedCount">${profile.completedCount != null ? profile.completedCount : 0}건</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">[ 이번 달 수익 ]</div>
                    <div class="stat-value" id="thisMonthEarningTotal">₩<fmt:formatNumber value="${profile.thisMonthEarning != null ? profile.thisMonthEarning : 0}" pattern="#,###"/></div>
                </div>
            </div>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Activity Summary Card -->
            <div class="info-card">
                <h3 class="info-card-title">활동 요약</h3>
                <ul class="info-list">
                    <li class="info-list-item">
                        <span>최근 30일 수행</span>
                        <strong id="last30DaysCount">15건</strong>
                    </li>
                    <li class="info-list-item">
                        <span>취소율</span>
                        <strong id="activityCancellationRate">5%</strong>
                    </li>
                    <li class="info-list-item">
                        <span>평균 응답 시간</span>
                        <strong id="avgResponseTime">12분</strong>
                    </li>
                </ul>
            </div>

            <!-- 평점 -->
            <div class="info-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                    <h3 class="info-card-title" style="margin-bottom: 0;">고객 만족도</h3>
                    <span style="font-size: 0.9rem; color: #7f8c8d;">
                        누적 리뷰 <fmt:formatNumber value="${profile.reviewCount}" pattern="#,###"/>건
                    </span>
                </div>

                <div style="text-align: center; padding: 1.5rem 0;">
                    <div style="font-size: 3.5rem; font-weight: 800; color: #2c3e50; line-height: 1;">
                        <fmt:formatNumber value="${profile.ratingAvg}" pattern="0.0"/>
                    </div>

                    <div style="margin: 0.5rem 0 1rem 0; font-size: 1.5rem; letter-spacing: 5px;">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= profile.ratingAvg}">
                                    <span style="color: #f1c40f;">★</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #bdc3c7;">★</span>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>

                    <p style="color: #7f8c8d; font-size: 0.95rem; margin: 0;">
                        사용자들에게 받은 평균 평점입니다.
                    </p>
                </div>
            </div>

            <!-- Income Ratio Card -->
            <div class="info-card">
                <h3 class="info-card-title">수행 비율</h3>
                <ul class="info-list">
                    <li class="info-list-item">
                        <span>성공률 100%</span>
                    </li>
                    <li class="info-list-item">
                        <span>재의뢰율</span>
                    </li>
                </ul>
            </div>

            <!-- Account Status Card -->
            <div class="info-card">
                <h3 class="info-card-title">계정 상태</h3>
                <ul class="info-list">
                    <li class="info-list-item">
                        <span>
                            [
                            <c:choose>
                                <c:when test="${profile.activeStatus eq 'ACTIVE'}">활성 계정</c:when>
                                <c:when test="${profile.activeStatus eq 'SUSPENDED'}">정지된 계정</c:when>
                                <c:otherwise>비활성 계정</c:otherwise>
                            </c:choose>
                            ]
                        </span>
                    </li>

                    <li class="info-list-item">
                        <span>
                            [
                            <c:choose>
                                <c:when test="${profile.approvalStatus eq 'APPROVED'}">인증 완료</c:when>
                                <c:when test="${profile.approvalStatus eq 'PENDING'}">인증 대기</c:when>
                                <c:when test="${profile.approvalStatus eq 'REJECTED'}">승인 거절</c:when>
                                <c:otherwise>미인증</c:otherwise>
                            </c:choose>
                            ]
                        </span>
                    </li>

                    <li class="info-list-item">
                        <span style="font-weight: bold;
                                color: ${profile.grade == 'VIP' ? '#9b59b6' : (profile.grade == 'PREMIUM' ? '#f39c12' : '#2c3e50')};">
                            [ ${profile.memberTypeLabel} ]
                        </span>
                    </li>
                </ul>
            </div>
        </div>

        <div class="info-card">
            <h3 class="info-card-title">[ ACHIEVEMENTS ]</h3>
            <div class="achievement-list">
                <div class="achievement-item ${profile.completedCount >= 1 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">🏆</div>
                    <span>첫 심부름 완료</span>
                    <c:if test="${profile.completedCount >= 1}">
                        <span style="margin-left: auto; color: green;">✔</span>
                    </c:if>
                </div>

                <div class="achievement-item ${profile.completedCount >= 10 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">⭐</div>
                    <span>10건 달성</span>
                    <c:if test="${profile.completedCount >= 10}">
                        <span style="margin-left: auto; color: green;">✔</span>
                    </c:if>
                </div>

                <div class="achievement-item ${profile.completedCount >= 50 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">💎</div>
                    <span style="${profile.completedCount >= 50 ? 'font-weight:bold;' : ''}">50건 달성</span>
                    <c:if test="${profile.completedCount >= 50}">
                        <span style="margin-left: auto; color: green;">✔</span>
                    </c:if>
                </div>

                <div class="achievement-item ${profile.completedCount >= 100 ? 'unlocked' : 'locked'}">
                    <div class="achievement-icon">👑</div>
                    <span>100건 달성</span>
                    <c:if test="${profile.completedCount >= 100}">
                        <span style="margin-left: auto; color: green;">✔</span>
                    </c:if>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="../common/footer.jsp"/>

<script src="<c:url value='/static/errander/js/profile.js'/>"></script>
</body>
</html>
		  position: relative;
		  display: inline-block;
		  border: none;
		}
		
		/* 실제 테두리 원인 */
		.nav-dropdown button,
		.nav-user {
		  border: none;
		  outline: none;
		  box-shadow: none;
		}

        .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            background-color: var(--color-white);
            min-width: 160px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1001;
            border-radius: 8px;
            overflow: hidden;
            margin-top: 0.5rem;
            animation: fadeIn 0.2s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dropdown-menu.active {
            display: block;
        }

        .dropdown-item {
            color: var(--color-dark);
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            font-size: 0.9rem;
            transition: background-color 0.2s;
        }

        .dropdown-item:hover {
            background-color: #f1f1f1;
            color: var(--color-primary);
        }

        .dropdown-divider {
            height: 1px;
            background-color: var(--color-light-gray);
            margin: 4px 0;
        }

        .dropdown-item.logout {
            color: #e74c3c;
        }

        .dropdown-item.logout:hover {
            background-color: #fdeaea;
        }
        
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
        
        .profile-header {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        .profile-greeting {
            font-size: 2rem;
            font-weight: 700;
            color: var(--color-dark);
            margin-bottom: 1rem;
        }
        
        .profile-stats {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .stat-item {
            flex: 1;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            padding: 1rem;
            text-align: center;
        }
        
        .stat-label {
            font-size: 0.875rem;
            color: var(--color-gray);
            margin-bottom: 0.5rem;
        }
        
        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--color-dark);
        }
        
        .progress-bar-container {
            margin-bottom: 1rem;
        }
        
        .progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }
        
        .progress-bar {
            height: 24px;
            background-color: var(--color-light-gray);
            border-radius: 12px;
            overflow: hidden;
            position: relative;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            transition: width 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--color-white);
            font-weight: 600;
            font-size: 0.75rem;
        }
        
        .content-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .info-card {
            background-color: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .info-card-title {
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--color-dark);
        }
        
        .info-list {
            list-style: none;
        }
        
        .info-list-item {
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--color-light-gray);
            display: flex;
            justify-content: space-between;
        }
        
        .info-list-item:last-child {
            border-bottom: none;
        }
        
        .attendance-report {
            background: #2C3E50;
            color: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
        }
        
        .attendance-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .attendance-title {
            font-size: 1rem;
            font-weight: 600;
            color: var(--color-white);
        }
        
        .attendance-expand-btn {
            width: 24px;
            height: 24px;
            background-color: rgba(255, 255, 255, 0.2);
            border: none;
            border-radius: 4px;
            color: var(--color-white);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }
        
        .attendance-expand-btn:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }
        
        .attendance-metrics {
            display: flex;
            gap: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .attendance-metric {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .attendance-metric-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--color-white);
        }
        
        .attendance-metric-arrow {
            font-size: 0.875rem;
        }
        
        .attendance-metric-arrow.up {
            color: #F2CB05;
        }
        
        .attendance-metric-arrow.down {
            color: #7F8C8D;
        }
        
        .attendance-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            grid-template-rows: repeat(5, 1fr);
            gap: 4px;
            margin-top: 1rem;
        }
        
        .attendance-day {
            aspect-ratio: 1;
            border-radius: 50%;
            background-color: #34495E;
            transition: all 0.2s ease;
        }
        
        .attendance-day.attended {
            background-color: #F2CB05;
        }
        
        .attendance-footer {
            margin-top: 1rem;
            font-size: 0.875rem;
            color: rgba(255, 255, 255, 0.7);
            text-align: center;
        }
        
        .achievement-list {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        /* 업적 스타일 보강 */
        .achievement-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        /* 달성했을 때 (활성) - 황금빛 배경 */
        .achievement-item.unlocked {
            background-color: #fff9c4; /* 연한 노랑 */
            color: #d35400; /* 진한 주황 텍스트 */
            border: 1px solid #f1c40f;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        /* 미달성 (비활성) - 회색조 */
        .achievement-item.locked {
            background-color: #ecf0f1;
            color: #bdc3c7;
            border: 1px dashed #bdc3c7;
            opacity: 0.6; /* 흐릿하게 */
        }
        
        .achievement-icon {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
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
            
            .content-grid {
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
                <a href="../../" class="nav-item">홈</a>
                <a href="../../errand/list" class="nav-item">심부름 목록</a>
                <a href="../../community" class="nav-item">커뮤니티</a>
                <a href="<c:url value='/member/myInfo'/>" class="nav-item">사용자 전환</a>
                <div class="nav-dropdown">
	                <button class="nav-item nav-user" id="userDropdownBtn">부름이</button>
	                <div class="dropdown-menu" id="userDropdownMenu">
	                    <a href="myInfo" class="dropdown-item">나의정보</a>
	                    <a href="vroomPay" class="dropdown-item">부름페이</a>
	                    <a href="myActivity" class="dropdown-item">나의거래</a>
	                    <a href="#" class="dropdown-item">설정</a>
	                    <a href="#" class="dropdown-item">고객지원</a>
	                    <div class="dropdown-divider"></div>
	                    <a href="#" class="dropdown-item logout">로그아웃</a>
	                </div>
            	</div>
            </nav>
        </div>
    </header>

    <!-- Mypage Layout -->
    <div class="mypage-layout">
        <!-- Sidebar Navigation -->
        <aside class="mypage-sidebar">
            <nav class="sidebar-menu">
                <a href="profile" class="sidebar-item active">나의 정보</a>
                <a href="pay" class="sidebar-item">부름 페이</a>
                <a href="activity" class="sidebar-item">나의 거래</a>
                <a href="settings" class="sidebar-item">설정</a>
                <a href="#" class="sidebar-item">고객지원</a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="mypage-content">
            <!-- Profile Header with Greeting -->
            <div class="profile-header">
                <div style="display: flex; align-items: center; gap: 1.5rem; margin-bottom: 1rem;">
                    <c:choose>
                        <%-- 이미지가 있을 때: 경로를 /static/img/ + 파일명으로 조합 --%>
                        <c:when test="${not empty profile.profileImage}">
                            <img src="<c:url value='${profile.profileImage}'/>"
                                 alt="프로필 이미지"
                                 style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid white;">
                        </c:when>
                        <%-- 이미지가 없을 때: 기본 꿀벌 아이콘 표시 --%>
                        <c:otherwise>
                            <div style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%); display: flex; align-items: center; justify-content: center; font-size: 2rem; color: white; border: 3px solid white;">
                                🐝
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <h2 class="profile-greeting"> ${profile.nickname}</h2>
                </div>
                
                <!-- Progress Bars -->
                <div class="progress-bar-container">
                    <div class="progress-label">
                        <span>심부름 완료율 <span id="completionRate">${profile.completeRate != null ? profile.completeRate : 0}</span>%</span>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill" id="completionRateBar" style="width: ${profile.completeRate != null ? profile.completeRate : 0}%">
                            ${profile.completeRate != null ? profile.completeRate : 0}%
                        </div>
                    </div>
                </div>
                
                <!-- Stats Row -->
                <div class="profile-stats">
                    <div class="stat-item">
                        <div class="stat-label">[ 수행 중 ]</div>
                        <div class="stat-value" id="inProgressCount">${profile.inProgressCount != null ? profile.inProgressCount : 0}건</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-label">[ 완료 ]</div>
                        <div class="stat-value" id="completedCount">${profile.completedCount != null ? profile.completedCount : 0}건</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-label">[ 이번 달 수익 ]</div>
                        <div class="stat-value" id="thisMonthEarningTotal">₩<fmt:formatNumber value="${profile.thisMonthEarning != null ? profile.thisMonthEarning : 0}" pattern="#,###"/></div>
                    </div>
                </div>
            </div>

            <!-- Content Grid -->
            <div class="content-grid">
                <!-- Activity Summary Card -->
                <div class="info-card">
                    <h3 class="info-card-title">활동 요약</h3>
                    <ul class="info-list">
                        <li class="info-list-item">
                            <span>최근 30일 수행</span>
                            <strong id="last30DaysCount">15건</strong>
                        </li>
                        <li class="info-list-item">
                            <span>취소율</span>
                            <strong id="activityCancellationRate">5%</strong>
                        </li>
                        <li class="info-list-item">
                            <span>평균 응답 시간</span>
                            <strong id="avgResponseTime">12분</strong>
                        </li>
                    </ul>
                </div>


                <%--평점--%>
                <div class="info-card">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                        <h3 class="info-card-title" style="margin-bottom: 0;">고객 만족도</h3>
                        <span style="font-size: 0.9rem; color: #7f8c8d;">
                            누적 리뷰 <fmt:formatNumber value="${profile.reviewCount}" pattern="#,###"/>건
                        </span>
                    </div>

                    <div style="text-align: center; padding: 1.5rem 0;">
                        <div style="font-size: 3.5rem; font-weight: 800; color: #2c3e50; line-height: 1;">
                            <fmt:formatNumber value="${profile.ratingAvg}" pattern="0.0"/>
                        </div>

                        <div style="margin: 0.5rem 0 1rem 0; font-size: 1.5rem; letter-spacing: 5px;">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <%-- 현재 별 번호(i)가 평점보다 작거나 같으면 노란색 --%>
                                    <c:when test="${i <= profile.ratingAvg}">
                                        <span style="color: #f1c40f;">★</span>
                                    </c:when>
                                    <%-- 아니면 회색 --%>
                                    <c:otherwise>
                                        <span style="color: #bdc3c7;">★</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>

                        <p style="color: #7f8c8d; font-size: 0.95rem; margin: 0;">
                            사용자들에게 받은 평균 평점입니다.
                        </p>
                    </div>
                </div>

                <!-- Income Ratio Card -->
                <div class="info-card">
                    <h3 class="info-card-title">수행 비율</h3>
                    <ul class="info-list">
                        <li class="info-list-item">
                            <span>성공률 100%</span>
                        </li>
                        <li class="info-list-item">
                            <span>재의뢰율</span>
                        </li>
                    </ul>
                </div>

                <!-- Account Status Card -->
                <div class="info-card">
                    <h3 class="info-card-title">계정 상태</h3>
                    <ul class="info-list">

                        <li class="info-list-item">
                        <span>
                            [
                            <c:choose>
                                <c:when test="${profile.activeStatus eq 'ACTIVE'}">활성 계정</c:when>
                                <c:when test="${profile.activeStatus eq 'SUSPENDED'}">정지된 계정</c:when>
                                <c:otherwise>비활성 계정</c:otherwise>
                            </c:choose>
                            ]
                        </span>
                        </li>

                        <li class="info-list-item">
                        <span>
                            [
                            <c:choose>
                                <c:when test="${profile.approvalStatus eq 'APPROVED'}">인증 완료</c:when>
                                <c:when test="${profile.approvalStatus eq 'PENDING'}">인증 대기</c:when>
                                <c:when test="${profile.approvalStatus eq 'REJECTED'}">승인 거절</c:when>
                                <c:otherwise>미인증</c:otherwise>
                            </c:choose>
                            ]
                        </span>
                        </li>

                        <li class="info-list-item">
                        <span style="font-weight: bold;
                                color: ${profile.grade == 'VIP' ? '#9b59b6' : (profile.grade == 'PREMIUM' ? '#f39c12' : '#2c3e50')};">
                            [ ${profile.memberTypeLabel} ]
                        </span>
                        </li>

                    </ul>
                </div>
            </div>

            <div class="info-card">
                <h3 class="info-card-title">[ ACHIEVEMENTS ]</h3>
                <div class="achievement-list">

                    <div class="achievement-item ${profile.completedCount >= 1 ? 'unlocked' : 'locked'}">
                        <div class="achievement-icon">🏆</div>
                        <span>첫 심부름 완료</span>
                        <c:if test="${profile.completedCount >= 1}">
                            <span style="margin-left: auto; color: green;">✔</span>
                        </c:if>
                    </div>

                    <div class="achievement-item ${profile.completedCount >= 10 ? 'unlocked' : 'locked'}">
                        <div class="achievement-icon">⭐</div>
                        <span>10건 달성</span>
                        <c:if test="${profile.completedCount >= 10}">
                            <span style="margin-left: auto; color: green;">✔</span>
                        </c:if>
                    </div>

                    <div class="achievement-item ${profile.completedCount >= 50 ? 'unlocked' : 'locked'}">
                        <div class="achievement-icon">💎</div>
                        <span style="${profile.completedCount >= 50 ? 'font-weight:bold;' : ''}">50건 달성</span>
                        <c:if test="${profile.completedCount >= 50}">
                            <span style="margin-left: auto; color: green;">✔</span>
                        </c:if>
                    </div>

                    <div class="achievement-item ${profile.completedCount >= 100 ? 'unlocked' : 'locked'}">
                        <div class="achievement-icon">👑</div>
                        <span>100건 달성</span>
                        <c:if test="${profile.completedCount >= 100}">
                            <span style="margin-left: auto; color: green;">✔</span>
                        </c:if>
                    </div>

                </div>
            </div>
        </main>
    </div>

<jsp:include page="../common/footer.jsp"/>

<script src="<c:url value='/static/errander/js/profile.js'/>"></script>
</body>
</html>