<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>심부름 상세 - VROOM</title>
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
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont,
                'Segoe UI', 'Malgun Gothic', sans-serif;
            background-color: #FAFAFA;
            color: var(--color-dark);
            line-height: 1.6;
        }

        .header {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo h1 {
            color: var(--color-white);
            font-size: 1.5rem;
            font-weight: 700;
            cursor: pointer;
        }

        .nav-menu {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .nav-item {
            color: var(--color-white);
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .nav-item:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .nav-login,
        .nav-signup {
            background-color: rgba(255, 255, 255, 0.15);
        }

        .nav-user {
            background-color: var(--color-white);
            color: var(--color-primary);
            font-weight: 600;
            cursor: pointer;
            border: 2px solid var(--color-white);
        }

        .nav-dropdown {
            position: relative;
            display: inline-block;
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

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 1.5rem;
        }

        .main-section {
            padding: 3rem 0;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 2rem;
            margin-bottom: 3rem;
            
            align-items: stretch;
        }
        
        .left-col{
		  display: flex;
		  flex-direction: column;
		  height: 100%;          /* 오른쪽 컬럼 높이에 맞춰 늘어나게 */
		}

        .image-section {
            background-color: var(--color-white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            
            flex: 1 1 auto;    /* 남는 높이를 이미지가 먹게 */
		  	display: flex;     /* 내부 .errand-image가 height:100% 먹기 편하게 */
		  	min-height: 260px; /* 너무 납작해지는거 방지(선택) */
        }

        .errand-image {
		    width: 100%;
		    height: 100%;
		    background: linear-gradient(135deg, var(--color-light-gray) 0%, var(--color-white) 100%);
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    font-size: 8rem;
		}

        .errand-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .info-panels {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            
            height: 100%;
        }

        .info-panel {
            background-color: var(--color-white);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            text-align: left;
        }
        
        .info-panel.is-description {
		    flex: 1;
		    display: flex;
		    flex-direction: column;
		}
		
		.info-panel.is-description .panel-content {
		    flex: 1;              /* 내용영역이 늘어나게 */
		    overflow: auto;       /* 설명이 길면 스크롤로 처리 (원하면 hidden/ellipsis로 변경 가능) */
		}
		
		/* money-row는 바깥 카드 스타일 제거 */
		.info-panel.money-row{
		  background: transparent;
		  box-shadow: none;
		  padding: 0;
		
		  display: grid;
		  grid-template-columns: 1fr 1fr;
		  gap: 12px;
		}
		
		/* 내부 박스가 카드 역할 */
		.money-box{
		  background: #fff;
		  border-radius: 14px;
		  padding: 18px;
		  box-shadow: 0 2px 10px rgba(0,0,0,0.06);
		}
		
		.money-row-under-image{
		  width: 100%;
		  display: flex;
		  gap: 12px;
		  
		  margin-top: 16px; 
		}
		
		.money-row-under-image .money-box{
		  flex: 1;                /* 좌우 반반 */
		  min-width: 0;           /* flex에서 줄바꿈 방지 핵심 */
		}

        .panel-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--color-dark);
            margin-bottom: 1rem;
            text-align: left;
        }

        .panel-content {
            font-size: 1rem;
            color: var(--color-gray);
            text-align: left;
            line-height: 1.8;
        }

        .description-section {
            background-color: var(--color-white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 3rem;
        }

        .description-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--color-dark);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .description-text {
            font-size: 1rem;
            color: var(--color-gray);
            line-height: 1.8;
            white-space: pre-wrap;
        }
        
        /* 작성자 카드 + 버튼 한 줄 레이아웃 */
		.author-chat-row {
		  display: flex;
		  align-items: stretch;
		  gap: 16px;
		  width: 100%;
		}
		
		/* 왼쪽 카드 폭 고정 담당 */
		.author-card-wrap {
		  flex: 0 1 720px;   /*  원하는 너비로 조절 */
		  max-width: 720px;
		  width: 100%;
		}
		
		/* 오른쪽 버튼 영역 */
		.chat-cta {
		  flex: 1;
		  display: flex;
		  align-items: stretch;
		  justify-content: flex-end;
		}
		
		/* 버튼 스타일 */
		.chat-cta form{
		  display: flex;            /* ✅ 버튼을 가운데 정렬 */
		  align-items: center;
		  justify-content: center;
		  height: 100%;             /* ✅ 왼쪽 카드 높이와 동일하게 */
		  background: transparent;
		  border: none;
		  box-shadow: none;
		  padding: 0;
		}
		
		.chat-cta button{
		  width: 220px;                /* 🔥 크게 */
		  height: 72px;                /* 🔥 세로 키우기 */
		  font-size: 1.2rem;
		  font-weight: 800;
		  border-radius: 16px;
		
		  background: linear-gradient(
		    135deg,
		    var(--color-secondary),
		    var(--color-accent)
		  );
		  color: #fff;
		
		  border: none;
		  cursor: pointer;
		  transition: all 0.25s ease;
		}
		
		/* 호버 효과 */
		.chat-cta button:hover{
		  transform: translateY(-2px);
		  box-shadow: 0 8px 20px rgba(0,0,0,0.18);
		}

        .author-card {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1.5rem;
            background: linear-gradient(135deg, #F8F9FA 0%, var(--color-white) 100%);
            border-radius: 12px;
        }

        .author-avatar-large {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            flex-shrink: 0;
        }

        .author-details {
            flex: 1;
            min-width: 0;
        }
        
        .author-score-inline{
		  display: flex;
		  align-items: center;
		  gap: 6px;
		  margin-left: auto;      /* 오른쪽으로 밀기 */
		  white-space: nowrap;
		  font-size: 1.5rem;
		  font-weight: 800;
		  color: var(--color-dark);
		}
		
		.author-score-inline .score-label{
		  font-weight: 600;
		  color: var(--color-gray);
		}
		
		.author-score-inline .score-value{
		  font-weight: 800;
		}

        .author-name-large {
            font-size: 1.125rem;
            font-weight: 700;
            color: var(--color-dark);
            margin-bottom: 0.25rem;
        }

        .author-meta {
            font-size: 0.875rem;
            color: var(--color-gray);
        }

        .related-section {
            margin-top: 3rem;
        }

        .section-header {
            background: linear-gradient(135deg, var(--color-light-gray) 0%, var(--color-white) 100%);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            text-align: center;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--color-dark);
        }

        .tasks-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }

        .task-card {
            background-color: var(--color-white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 2px solid transparent;
            cursor: pointer;
        }

        .task-card:hover {
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
            transform: translateY(-4px);
            border-color: var(--color-secondary);
        }

        .task-image {
            width: 100%;
            height: 180px;
            background: linear-gradient(135deg, var(--color-light-gray) 0%, var(--color-white) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
        }

        .task-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .task-card-content {
            padding: 1.25rem;
        }

        .task-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
        }

        .task-badge {
            display: inline-block;
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .task-time {
            color: var(--color-gray);
            font-size: 0.8rem;
        }

        .task-card-title {
            font-size: 1rem;
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.5rem;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            line-height: 1.4;
        }

        .task-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 0.75rem;
            border-top: 1px solid var(--color-light-gray);
        }

        .task-location {
            color: var(--color-gray);
            font-size: 0.85rem;
        }

        .task-price {
            color: var(--color-accent);
            font-weight: 700;
            font-size: 1.125rem;
        }

        .footer {
            background-color: var(--color-dark);
            color: var(--color-white);
            padding: 3rem 0 1rem;
            margin-top: 3rem;
        }

        .footer-content {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .footer-info h3 {
            color: var(--color-secondary);
            margin-bottom: 0.5rem;
        }

        .footer-info p {
            color: var(--color-light-gray);
            font-size: 0.9rem;
        }

        .footer-links {
            display: flex;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        .footer-links a {
            color: var(--color-light-gray);
            font-size: 0.9rem;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: var(--color-secondary);
        }

        .footer-copyright {
            text-align: center;
            padding-top: 1rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--color-gray);
            font-size: 0.85rem;
        }

        @media (max-width: 1024px) {
            .detail-grid {
                grid-template-columns: 1fr;
            }

            .tasks-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {
            .tasks-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* 기본: 4줄까지만 보여주고 … */
		.desc-content{
		  display: -webkit-box;
		  -webkit-box-orient: vertical;
		  -webkit-line-clamp: 4;   /* 보여줄 줄 수: 3~6으로 조절 */
		  overflow: hidden;
		  word-break: break-word;
		}
		
		/* 펼친 상태: 전체 표시 */
		#descPanel.expanded .desc-content{
		  -webkit-line-clamp: unset;
		  display: block;
		  overflow: visible;
		}
		
		/* 더보기 버튼 */
		.desc-toggle{
		  margin-top: 10px;
		  background: transparent;
		  border: none;
		  padding: 0;
		  cursor: pointer;
		  font-weight: 700;
		  color: var(--color-primary);
		  text-align: left;
		  display: none; /* ✅ 실제로 잘릴 때만 JS가 보여줌 */
		}
		        
        
    </style>

    <!-- 글꼴 -->
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet" as="style"
        href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">

    <!-- Lucide Icons -->
    <link href='https://cdn.jsdelivr.net/npm/lucide-static/font/lucide.css' rel='stylesheet'>
</head>

<body>
    <header class="header">
        <div class="header-container">
            <div class="logo">
                <h1 onclick="location.href='errands-list.html'">VROOM</h1>
            </div>
            <nav class="nav-menu">
                <a href="errands-list.html" class="nav-item">홈</a>
                <a href="#" class="nav-item">커뮤니티</a>
                <a href="#" class="nav-item">심부름꾼 전환</a>
                <a href="#" class="nav-item nav-login">로그인</a>
                <a href="#" class="nav-item nav-signup">회원가입</a>
                <div class="nav-dropdown">
                    <button class="nav-item nav-user" id="userDropdownBtn">유저</button>
                    <div class="dropdown-menu" id="userDropdownMenu">
                        <a href="#" class="dropdown-item">나의정보</a>
                        <a href="#" class="dropdown-item">부름페이</a>
                        <a href="#" class="dropdown-item">나의 활동</a>
                        <a href="#" class="dropdown-item">설정</a>
                        <a href="#" class="dropdown-item">고객지원</a>
                        <div class="dropdown-divider"></div>
                        <a href="#" class="dropdown-item logout">로그아웃</a>
                    </div>
                </div>
            </nav>
        </div>
    </header>

    <section class="main-section">
        <div class="container">
            <div class="detail-grid">
                <!-- Left: Image Section + Money -->
                <div class="left-col">
			      <div class="image-section">
			        <div class="errand-image">
			          <c:choose>
			            <c:when test="${not empty errand.mainImageUrl}">
			              <img src="${pageContext.request.contextPath}${errand.mainImageUrl}" alt="심부름 이미지">
			            </c:when>
			            <c:otherwise>
			              <img src="${pageContext.request.contextPath}/static/img/errand/noimage.png" alt="기본 이미지">
			            </c:otherwise>
			          </c:choose>
			        </div>
			      </div>
			      
			      <!-- ✅ 심부름값 + 재료비: 이미지 아래로 이동 -->
			      <div class="money-row-under-image">
			        <div class="money-box">
			          <h2 class="panel-title">심부름값</h2>
			          <p class="panel-content">
			            <fmt:formatNumber value="${errand.rewardAmount}" type="number" />원
			          </p>
			        </div>
			
			        <div class="money-box">
			          <h2 class="panel-title">재료비</h2>
			          <p class="panel-content">
			            <fmt:formatNumber value="${errand.expenseAmount}" type="number" />원
			          </p>
			        </div>
			      </div>
			    </div>

                <!-- Right: Info Panels -->
                <div class="info-panels">
                    <div class="info-panel">
                        <h2 class="panel-title">제목</h2>
                        <p class="panel-content">
				          <c:out value="${errand.title}" />
				        </p>
                    </div>

                    <div class="info-panel">
                        <h2 class="panel-title">위치</h2>
                        <p class="panel-content">
                        	<c:out value="${errand.dongFullName}" />
                        </p>
                    </div>

                    <div class="info-panel is-description" id="descPanel">
					  <h2 class="panel-title">심부름 설명</h2>
					
					  <p class="panel-content desc-content" id="descContent">
					    <c:out value="${errand.description}" />
					  </p>
					</div>
                </div>
            </div>

            <!-- Description Section -->
			<div class="description-section">
			
			  <!-- 작성자 카드(좌) + 채팅 버튼(우) -->
			  <div class="author-chat-row">
				  <div class="author-card-wrap">
				    <div class="author-card">
				      <div class="author-avatar-large">
				        <i class="icon-user"></i>
				      </div>
				
				      <div class="author-details">
				        <div class="author-name-large">작성자: <c:out value="${errand.userId}" /></div>
				        <div class="author-meta"><c:out value="${errand.timeAgo}" /></div>
				      </div>
				
				      <div class="author-score-inline">
				        <span class="score-label">매너점수 :</span>
				        <span class="score-value">
				          <c:choose>
				            <c:when test="${not empty errand.mannerScore}">
				              <fmt:formatNumber value="${errand.mannerScore}" maxFractionDigits="1"/>
				            </c:when>
				            <c:otherwise>-</c:otherwise>
				          </c:choose>
				        </span>
				      </div>
				    </div>
				  </div>
				
				  <div class="chat-cta">
					  <form method="post" action="${pageContext.request.contextPath}/errand/assign/request">
					    <input type="hidden" name="errandsId" value="${errand.errandsId}" />
					
					    <c:choose>
					      <c:when test="${errand.status eq 'WAITING'}">
					        <button type="submit" class="btn btn-primary">
					          채팅하기
					        </button>
					      </c:when>
					      <c:otherwise>
					        <button type="button" class="btn btn-secondary" disabled>
					          이미 매칭됨
					        </button>
					      </c:otherwise>
					    </c:choose>
					
					  </form>
					</div>
				</div>
			</div>

           

            <!-- Related Errands Section -->
            <div class="related-section">
                <div class="section-header">
                    <h2 class="section-title">동네 일거리</h2>
                </div>
	
	                <div class="tasks-grid">
					  <c:choose>
					    <c:when test="${empty relatedErrands}">
					      <div style="grid-column: 1 / -1; color: var(--color-gray); padding: 1rem 0;">
					        근처에 등록된 심부름이 아직 없어요.
					      </div>
					    </c:when>
					
					    <c:otherwise>
					      <c:forEach var="e" items="${relatedErrands}">
					        <!-- 목록 페이지 카드 마크업 그대로 여기에 붙이면 됨 -->
					        <div class="task-card"
					             onclick="location.href='${pageContext.request.contextPath}/errand/detail?errandsId=${e.errandsId}'">
					
					          <div class="task-image">
								<c:choose>
								  <c:when test="${not empty e.categoryDefaultImageUrl}">
								    <img src="${pageContext.request.contextPath}${e.categoryDefaultImageUrl}" alt="심부름 이미지">
								  </c:when>
								  <c:otherwise>
								    📦
								  </c:otherwise>
								</c:choose>
							  </div>
					
					          <div class="task-card-content">
					            <div class="task-card-header">
					              <span class="task-badge">대기중</span>
					              <span class="task-time">
					                <c:out value="${e.createdAt}" />
					              </span>
					            </div>
					
					            <div class="task-card-title">
					              <c:out value="${e.title}" />
					            </div>
					
					            <div class="task-meta">
					              <span class="task-location">
					                <c:out value="${e.dongFullName}" />
					              </span>
					              <span class="task-price">
					                <fmt:formatNumber value="${e.rewardAmount}" pattern="#,###" />원
					              </span>
					            </div>
					          </div>
					
					        </div>
					      </c:forEach>
					    </c:otherwise>
					  </c:choose>
					</div>
	            </div>
            </div>
        </div>
    </section>
    
    

    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-info">
                    <h3>(주) 답스미포유</h3>
                    <p>대표 허남훈 ㅣ 사업자번호 375-87-00088<br>
                        제2종정보통신판매업 신고번호 JT200C03030C118<br>
                        통신판매업 신고번호 2021-서울노원-2875<br>
                        호스팅 사업자 Amazon Web Service(AWS)<br>
                        주소 서울특별시 구로구 디지털로 306, 10층 (오구역사)<br>
                        전화 1877-9737 | 고객문의 cs@daangn.service.com</p>
                </div>
                <div class="footer-links">
                    <a href="#">이용약관</a>
                    <a href="#">개인정보처리방침</a>
                    <a href="#">운영정책</a>
                    <a href="#">위치기반서비스 이용약관</a>
                    <a href="#">이용자보호 비전과 계획</a>
                    <a href="#">청소년보호정책</a>
                    <a href="#">고객센터</a>
                </div>
                <div class="footer-copyright">
                    <p>&copy; Danggeun Market Inc.</p>
                </div>
            </div>
        </div>
    </footer>

    <script>
        // Dropdown Logic
        document.addEventListener('DOMContentLoaded', function () {
            const dropdownBtn = document.getElementById('userDropdownBtn');
            const dropdownMenu = document.getElementById('userDropdownMenu');

            if (dropdownBtn && dropdownMenu) {
                dropdownBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    dropdownMenu.classList.toggle('active');
                });

                document.addEventListener('click', function (e) {
                    if (!dropdownMenu.contains(e.target) && !dropdownBtn.contains(e.target)) {
                        dropdownMenu.classList.remove('active');
                    }
                });
            }

            // Initialize
            renderRelatedTasks();
        });

        // Mock related tasks data
        const relatedTasks = [
            { icon: '🧹', badge: '청소', time: '10분 전', title: '집 청소 도와주실 분', location: '서초구 서초동', price: '15,000원' },
            { icon: '🔧', badge: '설치/조립', time: '15분 전', title: '책장 조립 부탁드립니다', location: '송파구 잠실동', price: '8,000원' },
            { icon: '🐕', badge: '반려동물', time: '20분 전', title: '강아지 산책 시켜주세요', location: '강동구 천호동', price: '6,000원' },
            { icon: '📝', badge: '줄서기', time: '25분 전', title: '토요쿠 대기줄 서주세요', location: '마포구 합정동', price: '20,000원' },
            { icon: '🛍️', badge: '배달', time: '30분 전', title: '편의점 야식 배달 부탁해요', location: '영등포구 여의도동', price: '3,500원' },
            { icon: '🏠', badge: '기타', time: '35분 전', title: '바퀴벌레 잡아주세요', location: '송파구 문정동', price: '10,000원' }
        ];

        function renderRelatedTasks() {
            const grid = document.getElementById('relatedTasksGrid');
            if (!grid) return; // 없으면 종료
            grid.innerHTML = '';

            relatedTasks.forEach(task => {
                const taskCard = document.createElement('div');
                taskCard.className = 'task-card';
                taskCard.innerHTML = `
                    <div class="task-image">
                		<img src="${task.imageUrl}" alt="심부름 이미지">	
                    </div>
                    <div class="task-card-content">
                        <div class="task-card-header">
                            <span class="task-badge">${task.badge}</span>
                            <span class="task-time">${task.time}</span>
                        </div>
                        <h3 class="task-card-title">${task.title}</h3>
                        <div class="task-meta">
                            <span class="task-location">${task.location}</span>
                            <span class="task-price">${task.price}</span>
                        </div>
                    </div>
                `;
                grid.appendChild(taskCard);
            });
        }
    </script>
</body>

</html>