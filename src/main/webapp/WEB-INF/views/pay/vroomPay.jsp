<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>부름 페이 - VROOM</title>
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

    /* Header reused from main */
    .header {
      background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
      position: sticky;
      top: 0;
      z-index: 1000;
    }

    .header-container {
      max-width: 1200px;
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
      border: 2px solid var(--color-white);
      cursor: pointer;
    }

    /* Dropdown Styles */
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

    /* Dashboard Layout */
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 1.5rem;
    }

    .dashboard-container {
      display: flex;
      gap: 2rem;
      padding: 3rem 0;
      min-height: 80vh;
    }

    /* Sidebar */
    .sidebar {
      width: 250px;
      flex-shrink: 0;
    }

    .sidebar-menu {
      list-style: none;
      background-color: var(--color-white);
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
    }

    .sidebar-item {
      border-bottom: 1px solid var(--color-light-gray);
    }

    .sidebar-item:last-child {
      border-bottom: none;
    }

    .sidebar-link {
      display: block;
      padding: 1.25rem 1.5rem;
      text-decoration: none;
      color: var(--color-dark);
      font-weight: 500;
      transition: all 0.2s ease;
    }

    .sidebar-link:hover {
      background-color: #f8f9fa;
      color: var(--color-primary);
      padding-left: 1.75rem;
    }

    .sidebar-link.active {
      background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
      color: var(--color-white);
      font-weight: 700;
    }

    /* Main Content */
    .main-content {
      flex-grow: 1;
    }

    /* VROOM Pay Specific Styles - Refined to match my-info */
    .page-title {
      font-size: 1.5rem;
      font-weight: 700;
      margin-bottom: 2rem;
      color: var(--color-dark);
    }

    .pay-info-card {
      background-color: var(--color-white);
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
      border: 1px solid var(--color-light-gray);
      padding: 2.5rem;
      margin-bottom: 3rem;
      display: grid;
      grid-template-columns: auto 1fr auto;
      grid-template-rows: auto auto;
      gap: 2rem;
      align-items: center;
    }

    .profile-section {
      display: flex;
      align-items: center;
      gap: 1.5rem;
      grid-column: 1 / 3;
    }

    .profile-image-container {
      width: 100px;
      height: 100px;
      background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2.5rem;
      color: white;
      font-weight: 700;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    }

    .profile-details {
      display: flex;
      flex-direction: column;
    }

    .profile-nickname {
      font-size: 1.8rem;
      font-weight: 800;
      color: var(--color-dark);
      margin-bottom: 0.5rem;
    }

    .option-btn {
      background-color: var(--color-white);
      color: var(--color-dark);
      padding: 0.5rem 1rem;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
      font-size: 0.9rem;
      border: 1px solid var(--color-light-gray);
      transition: all 0.3s ease;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
      align-self: flex-start;
    }

    .option-btn:hover {
      border-color: var(--color-secondary);
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .temp-container {
      grid-column: 1 / 2;
      background-color: #FAFAFA;
      padding: 1rem 1.5rem;
      border-radius: 12px;
      border: 1px solid var(--color-light-gray);
      display: flex;
      align-items: center;
      gap: 1rem;
    }

    .temp-label {
      font-weight: 700;
      color: var(--color-dark);
      min-width: 40px;
    }

    .temp-bar {
      flex-grow: 1;
      height: 10px;
      background-color: #E0E0E0;
      border-radius: 6px;
      overflow: hidden;
      width: 200px;
    }

    .temp-fill {
      height: 100%;
      background: linear-gradient(90deg, #FF6B6B 0%, var(--color-warm) 100%);
      width: 36.5%;
    }

    .temp-value {
      font-weight: 800;
      color: var(--color-warm);
    }

    .balance-container {
      grid-column: 2 / 4;
      display: flex;
      justify-content: flex-end;
      gap: 1rem;
    }

    .balance-box {
      display: flex;
      gap: 0;
      background-color: var(--color-white);
      border-radius: 12px;
      border: 1px solid var(--color-light-gray);
      overflow: hidden;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }

    .balance-action-btn {
      padding: 1rem 2rem;
      border: none;
      background-color: var(--color-white);
      font-weight: 600;
      font-size: 1rem;
      cursor: pointer;
      transition: background-color 0.2s;
      border-right: 1px solid var(--color-light-gray);
      color: var(--color-dark);
    }

    .balance-action-btn:hover {
      background-color: #f8f9fa;
      color: var(--color-primary);
    }

    .balance-display {
      padding: 0.8rem 2rem;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      background-color: #f8f9fa;
      min-width: 120px;
    }

    .balance-label {
      font-size: 0.8rem;
      color: var(--color-gray);
      margin-bottom: 0.2rem;
    }

    .balance-amount {
      font-weight: 700;
      color: var(--color-primary);
      font-size: 1.1rem;
    }

    /* Transaction History */
    .history-section {
      background-color: var(--color-white);
      border-radius: 16px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
      border: 1px solid var(--color-light-gray);
      overflow: hidden;
    }

    .history-header {
      padding: 1.5rem 2rem;
      border-bottom: 1px solid var(--color-light-gray);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .history-title {
      font-size: 1.25rem;
      font-weight: 700;
      color: var(--color-dark);
    }

    .history-count {
      color: var(--color-primary);
    }

    .history-table-header {
      display: grid;
      grid-template-columns: 2fr 1fr 1fr;
      padding: 1rem 2rem;
      background-color: #FAFAFA;
      border-bottom: 1px solid var(--color-light-gray);
      font-weight: 600;
      color: var(--color-gray);
      font-size: 0.95rem;
      text-align: center;
    }

    .history-list {
      display: flex;
      flex-direction: column;
    }

    .history-item {
      display: grid;
      grid-template-columns: 2fr 1fr 1fr;
      padding: 1.25rem 2rem;
      border-bottom: 1px solid var(--color-light-gray);
      align-items: center;
      transition: background-color 0.2s;
      text-align: center;
    }

    .history-item:last-child {
      border-bottom: none;
    }

    .history-item:hover {
      background-color: #F8F9FA;
    }

    .item-title {
      font-weight: 500;
      color: var(--color-dark);
      text-align: left;
    }

    .item-author {
      color: var(--color-gray);
      font-size: 0.95rem;
    }

    .item-amount {
      font-weight: 700;
      color: var(--color-dark);
    }

    .pagination {
      display: flex;
      justify-content: center;
      gap: 0.5rem;
      margin-top: 2rem;
    }

    .page-btn {
      width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 8px;
      border: 1px solid var(--color-light-gray);
      background-color: var(--color-white);
      color: var(--color-dark);
      cursor: pointer;
      transition: all 0.2s;
      font-weight: 600;
    }

    .page-btn:hover {
      border-color: var(--color-secondary);
      color: var(--color-secondary);
    }

    .page-btn.active {
      background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
      color: var(--color-white);
      border: none;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    /* Modal Styles (Added) */
    .modal-overlay {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      z-index: 2000;
      justify-content: center;
      align-items: center;
      animation: fadeIn 0.2s ease-out;
    }

    .modal-overlay.active {
      display: flex;
    }

    .modal-content {
      background-color: var(--color-white);
      border-radius: 16px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
      max-width: 500px;
      width: 90%;
      padding: 2rem;
      animation: slideUp 0.3s ease-out;
    }

    @keyframes slideUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 1.5rem;
      padding-bottom: 1rem;
      border-bottom: 2px solid var(--color-light-gray);
    }

    .modal-title {
      font-size: 1.5rem;
      font-weight: 700;
      color: var(--color-dark);
    }

    .modal-close {
      background: none;
      border: none;
      font-size: 1.8rem;
      color: var(--color-gray);
      cursor: pointer;
      width: 32px;
      height: 32px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      transition: all 0.2s;
    }

    .modal-close:hover {
      background-color: var(--color-light-gray);
      color: var(--color-dark);
    }

    .modal-body {
      margin-bottom: 1.5rem;
    }

    .current-balance {
      background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
      color: var(--color-white);
      padding: 1.25rem;
      border-radius: 12px;
      margin-bottom: 1.5rem;
      text-align: center;
    }

    .current-balance-label {
      font-size: 0.9rem;
      margin-bottom: 0.5rem;
      opacity: 0.9;
    }

    .current-balance-amount {
      font-size: 1.8rem;
      font-weight: 700;
    }

    .form-group {
      margin-bottom: 1rem;
    }

    .form-label {
      display: block;
      font-weight: 600;
      color: var(--color-dark);
      margin-bottom: 0.5rem;
      font-size: 0.95rem;
    }

    .form-input {
      width: 100%;
      padding: 0.875rem 1rem;
      border: 2px solid var(--color-light-gray);
      border-radius: 8px;
      font-size: 1rem;
      transition: border-color 0.2s;
      font-weight: 500;
    }

    .form-input:focus {
      outline: none;
      border-color: var(--color-primary);
    }

    .form-input.error {
      border-color: #e74c3c;
    }

    .form-helper {
      margin-top: 0.5rem;
      font-size: 0.85rem;
      color: var(--color-gray);
    }

    .form-error {
      margin-top: 0.5rem;
      font-size: 0.85rem;
      color: #e74c3c;
      font-weight: 500;
      display: none;
    }

    .form-error.active {
      display: block;
    }

    .form-warning {
      background-color: #fff3cd;
      border: 1px solid #ffc107;
      color: #856404;
      padding: 0.75rem 1rem;
      border-radius: 8px;
      font-size: 0.9rem;
      margin-bottom: 1rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .form-warning::before {
      content: "⚠️";
      font-size: 1.2rem;
    }

    .modal-footer {
      display: flex;
      gap: 1rem;
      justify-content: flex-end;
    }

    .modal-btn {
      padding: 0.875rem 1.5rem;
      border-radius: 8px;
      font-weight: 600;
      font-size: 1rem;
      cursor: pointer;
      transition: all 0.2s;
      border: none;
    }

    .modal-btn-cancel {
      background-color: var(--color-light-gray);
      color: var(--color-dark);
    }

    .modal-btn-cancel:hover {
      background-color: #d5d9dc;
    }

    .modal-btn-submit {
      background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
      color: var(--color-white);
    }

    .modal-btn-submit:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(107, 142, 35, 0.3);
    }

    .modal-btn-submit:disabled {
      opacity: 0.5;
      cursor: not-allowed;
      transform: none;
    }

    /* Footer reused */
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

    .footer-links {
      display: flex;
      gap: 1.5rem;
      flex-wrap: wrap;
    }

    .footer-links a {
      color: var(--color-light-gray);
      font-size: 0.9rem;
      text-decoration: none;
    }

    .footer-copyright {
      text-align: center;
      padding-top: 1rem;
      border-top: 1px solid rgba(255, 255, 255, 0.1);
      color: var(--color-gray);
      font-size: 0.85rem;
    }

    /* Responsive */
    @media (max-width: 900px) {
      .pay-info-card {
        grid-template-columns: 1fr;
        grid-template-rows: auto;
        text-align: center;
        gap: 1.5rem;
      }

      .profile-section {
        grid-column: auto;
        flex-direction: column;
      }

      .temp-container {
        grid-column: auto;
        width: 100%;
        justify-content: center;
      }

      .balance-container {
        grid-column: auto;
        justify-content: center;
      }

      .history-table-header,
      .history-item {
        padding: 1rem;
        font-size: 0.9rem;
      }
    }

    @media (max-width: 768px) {
      .dashboard-container {
        flex-direction: column;
      }

      .sidebar {
        width: 100%;
      }
    }
  </style>

  <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
  <link rel="stylesheet" as="style"
        href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
</head>

<body>
<header class="header">
  <div class="header-container">
    <div class="logo">
      <h1 onclick="location.href='${pageContext.request.contextPath}/'">VROOM</h1>
    </div>
    <nav class="nav-menu">
      <a href="main_updated_2.html" class="nav-item">홈</a>
      <a href="#" class="nav-item">커뮤니티</a>
      <a href="#" class="nav-item">심부름꾼 전환</a>
      <div class="nav-dropdown">
        <button class="nav-item nav-user" id="userDropdownBtn">사용자</button>
        <div class="dropdown-menu" id="userDropdownMenu">
          <a href="${pageContext.request.contextPath}/member/myInfo" class="dropdown-item">나의정보</a>
          <a href="vroomPay" class="dropdown-item">부름페이</a>
          <a href="${pageContext.request.contextPath}/member/myActivity" class="dropdown-item">나의활동</a>
          <a href="#" class="dropdown-item">설정</a>
          <a href="#" class="dropdown-item">고객지원</a>
          <div class="dropdown-divider"></div>
          <a href="${pageContext.request.contextPath}/auth/logout" class="dropdown-item logout">로그아웃</a>
        </div>
      </div>
    </nav>
  </div>
</header>

<div class="container">
  <div class="dashboard-container">
    <aside class="sidebar">
      <ul class="sidebar-menu">
        <a href="${pageContext.request.contextPath}/member/myInfo" class="dropdown-item">나의 정보</a>
        <li class="sidebar-item"><a href="vroomPay" class="sidebar-link active">부름 페이<br>(계좌 관리)</a>
        </li>
        <a href="${pageContext.request.contextPath}/member/myActivity" class="dropdown-item">나의 활동</a>
        <li class="sidebar-item"><a href="#" class="sidebar-link">설정</a></li>
        <li class="sidebar-item"><a href="#" class="sidebar-link">고객지원</a></li>
      </ul>
    </aside>

    <main class="main-content">

      <h2 class="page-title">부름 페이</h2>

      <div class="pay-info-card">
        <div class="profile-section">
          <div class="profile-image-container">
            <c:choose>
              <c:when test="${not empty profile.profileImage}">
                <img src="${pageContext.request.contextPath}${profile.profileImage}" alt="프로필" style="width:100%; height:100%; object-fit:cover; border-radius:50%;">
              </c:when>
              <c:otherwise>
                <img src="${pageContext.request.contextPath}/resources/images/default_profile.png" alt="기본 프로필" style="width:100%; height:100%; object-fit:cover; border-radius:50%;">
              </c:otherwise>
            </c:choose>
          </div>
          <div class="profile-details">
            <span class="profile-nickname">${profile.nickname}</span>
            <button class="option-btn">현질 옵션 [ 내글을 상위 노출 해보세요 ]</button>
          </div>
        </div>

        <div class="balance-container">
          <div class="balance-box">
            <button class="balance-action-btn" id="depositBtn">충 전</button>
            <button class="balance-action-btn" id="withdrawBtn">출 금</button>
            <div class="balance-display">
              <span class="balance-label">잔 액</span>
              <span class="balance-amount" id="balanceDisplay">
                <fmt:formatNumber value="${account.balance}" type="number"/> 원
              </span>
            </div>
          </div>
        </div>

        <div class="temp-container">
          <span class="temp-label">매너온도</span>
          <div class="temp-bar">
            <div class="temp-fill" style="width: ${profile.mannerTemp}%;"></div>
          </div>
          <span class="temp-value">${profile.mannerTemp}℃</span>
        </div>
      </div>

      <div class="history-section">
        <div class="history-header">
          <h3 class="history-title">거래 내역 <span class="history-count">(12)</span></h3>
        </div>

        <div class="history-table-header">
          <div>제목</div>
          <div>작성자</div>
          <div>금액</div>
        </div>

        <div class="history-list" id="transactionList">
        </div>
      </div>

      <div class="pagination" id="pagination">
      </div>

    </main>
  </div>
</div>

<footer class="footer">
  <div class="container">
    <div class="footer-content">
      <div class="footer-info">
        <h3>우리동네 심부름</h3>
        <p>이웃과 함께하는 따뜻한 심부름 커뮤니티</p>
      </div>
      <div class="footer-links">
        <a href="#">이용약관</a>
        <a href="#">개인정보처리방침</a>
        <a href="#">운영정책</a>
        <a href="#">위치기반서비스 이용약관</a>
        <a href="#">이용자보호 비전과 계획</a>
        <a href="#">청소년보호정책</a>
      </div>
      <div class="footer-copyright">
        <p>&copy; 2024 VROOM. All rights reserved.</p>
      </div>
    </div>
  </div>
</footer>

<div class="modal-overlay" id="depositModal">
  <div class="modal-content">
    <div class="modal-header">
      <h3 class="modal-title">충전하기</h3>
      <button class="modal-close" id="closeDepositModal">&times;</button>
    </div>
    <div class="modal-body">
      <div class="current-balance">
        <div class="current-balance-label">현재 잔액</div>
        <div class="current-balance-amount" id="depositModalBalance">12 원</div>
      </div>
      <div class="form-warning">
        <span>금액은 숫자만 입력해주세요. 쉼표(,)는 사용할 수 없습니다.</span>
      </div>
      <div class="form-group">
        <label class="form-label">계좌 선택</label>
        <select class="form-input" id="depositBank">
          <option value="">은행을 선택하세요</option>
          <option value="신한">신한은행</option>
          <option value="국민">국민은행</option>
          <option value="하나">하나은행</option>
          <option value="우리">우리은행</option>
          <option value="농협">농협은행</option>
          <option value="기업">기업은행</option>
          <option value="SC">SC제일은행</option>
          <option value="카카오">카카오뱅크</option>
          <option value="토스">토스뱅크</option>
        </select>
        <div class="form-error" id="depositBankError">은행을 선택해주세요.</div>
      </div>
      <div class="form-group">
        <label class="form-label">충전 금액</label>
        <input type="text" class="form-input" id="depositAmount" placeholder="예: 10000">
        <div class="form-helper">숫자만 입력하세요 (예: 10000)</div>
        <div class="form-error" id="depositError">쉼표(,)는 사용할 수 없습니다. 숫자만 입력해주세요.</div>
      </div>
    </div>
    <div class="modal-footer">
      <button class="modal-btn modal-btn-cancel" id="cancelDepositBtn">취소</button>
      <button class="modal-btn modal-btn-submit" id="submitDepositBtn">충전하기</button>
    </div>
  </div>
</div>

<div class="modal-overlay" id="withdrawModal">
  <div class="modal-content">
    <div class="modal-header">
      <h3 class="modal-title">출금하기</h3>
      <button class="modal-close" id="closeWithdrawModal">&times;</button>
    </div>
    <div class="modal-body">
      <div class="current-balance">
        <div class="current-balance-label">현재 잔액</div>
        <div class="current-balance-amount" id="withdrawModalBalance">12 원</div>
      </div>
      <div class="form-warning">
        <span>금액은 숫자만 입력해주세요. 쉼표(,)는 사용할 수 없습니다.</span>
      </div>
      <div class="form-group">
        <label class="form-label">출금 금액</label>
        <input type="text" class="form-input" id="withdrawAmount" placeholder="예: 10000">
        <div class="form-helper">숫자만 입력하세요 (예: 10000). 잔액 범위 내에서만 출금 가능합니다.</div>
        <div class="form-error" id="withdrawError">쉼표(,)는 사용할 수 없습니다. 숫자만 입력해주세요.</div>
      </div>
    </div>
    <div class="modal-footer">
      <button class="modal-btn modal-btn-cancel" id="cancelWithdrawBtn">취소</button>
      <button class="modal-btn modal-btn-submit" id="submitWithdrawBtn">출금하기</button>
    </div>
  </div>
</div>

<script>
  // 서버에서 초기값을 안전하게 가져오기 (null이면 0)
  let currentBalance = ${account.balance != null ? account.balance : 0};
  let availBalance = ${account.availBalance != null ? account.availBalance : 0};
  const itemsPerPage = 10;

  document.addEventListener('DOMContentLoaded', function() {
    updateBalanceDisplay();
    loadTransactions(1);
    initDropdown();
  });

  // 거래 내역 조회 (수정됨: Context Path 추가)
  function loadTransactions(page) {
    fetch('${pageContext.request.contextPath}/api/wallet/transactions?page=' + page + '&size=' + itemsPerPage)
            .then(function(res) { return res.json(); })
            .then(function(data) {
              if (data.success) {
                // 내역 조회하면서 최신 잔액 동기화
                currentBalance = data.balance;
                availBalance = data.availBalance;
                updateBalanceDisplay();
                renderTransactions(data.transactions);
                renderPagination(data.totalPages, data.currentPage);
                document.querySelector('.history-count').textContent = '(' + data.totalCount + ')';
              }
            });
  }

  function renderTransactions(transactions) {
    var list = document.getElementById('transactionList');
    list.innerHTML = '';

    if (!transactions || transactions.length === 0) {
      list.innerHTML = '<div class="history-item"><div class="item-title" style="grid-column:1/-1;text-align:center;">거래 내역이 없습니다.</div></div>';
      return;
    }

    var typeLabels = {
      'CHARGE': '충전', 'WITHDRAW': '출금', 'HOLD': '보류',
      'RELEASE': '해제', 'PAYOUT': '지급', 'REFUND': '환불'
    };

    transactions.forEach(function(item) {
      var el = document.createElement('div');
      el.className = 'history-item';

      var isPlus = ['CHARGE', 'RELEASE', 'REFUND'].indexOf(item.txnType) !== -1;
      var color = isPlus ? 'color:#27ae60;' : 'color:#e74c3c;';
      var prefix = isPlus ? '+' : '-';
      var label = item.memo || typeLabels[item.txnType] || item.txnType;

      el.innerHTML =
              '<div class="item-title">' + label + '</div>' +
              '<div class="item-author">' + formatDate(item.createdAt) + '</div>' +
              '<div class="item-amount" style="' + color + '">' + prefix + Number(item.amount).toLocaleString() +
              '원</div>';
      list.appendChild(el);
    });
  }

  function formatDate(dateStr) {
    if (!dateStr) return '';
    var d = new Date(dateStr);
    return (d.getMonth()+1) + '/' + d.getDate() + ' ' + d.getHours() + ':' +
            String(d.getMinutes()).padStart(2,'0');
  }

  function renderPagination(totalPages, currentPage) {
    var container = document.getElementById('pagination');
    container.innerHTML = '';
    for (var i = 1; i <= totalPages; i++) {
      var btn = document.createElement('div');
      btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
      btn.textContent = i;
      (function(pageNum) {
        btn.onclick = function() { loadTransactions(pageNum); };
      })(i);
      container.appendChild(btn);
    }
  }

  function updateBalanceDisplay() {
    var ids = ['balanceDisplay', 'depositModalBalance', 'withdrawModalBalance'];
    ids.forEach(function(id) {
      var el = document.getElementById(id);
      if (el) el.textContent = Number(currentBalance).toLocaleString() + ' 원';
    });
  }

  // 충전 (잘 되어 있음)
  document.getElementById('submitDepositBtn').addEventListener('click', function() {
    var bankSelect = document.getElementById('depositBank');
    var input = document.getElementById('depositAmount');
    var bankError = document.getElementById('depositBankError');
    var amountError = document.getElementById('depositError');
    var valid = true;

    if (!bankSelect.value) {
      bankSelect.classList.add('error');
      bankError.classList.add('active');
      valid = false;
    } else {
      bankSelect.classList.remove('error');
      bankError.classList.remove('active');
    }

    if (!input.value || !/^\d+$/.test(input.value)) {
      input.classList.add('error');
      amountError.textContent = '숫자만 입력해주세요.';
      amountError.classList.add('active');
      valid = false;
    } else {
      input.classList.remove('error');
      amountError.classList.remove('active');
    }

    if (valid) {
      fetch('${pageContext.request.contextPath}/api/wallet/charge', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
          amount: parseInt(input.value),
          bankName: bankSelect.value
        })
      })
              .then(function(res) { return res.json(); })
              .then(function(data) {
                alert(data.message);
                if (data.success) {
                  currentBalance = data.balance;
                  availBalance = data.availBalance;
                  updateBalanceDisplay();
                  closeModal('depositModal');
                  loadTransactions(1);
                }
              });
    }
  });

  // 출금 (수정됨: Context Path 추가)
  document.getElementById('submitWithdrawBtn').addEventListener('click', function() {
    var input = document.getElementById('withdrawAmount');
    var error = document.getElementById('withdrawError');

    if (!input.value || !/^\d+$/.test(input.value)) {
      input.classList.add('error');
      error.textContent = '숫자만 입력해주세요.';
      error.classList.add('active');
      return;
    }


    fetch('${pageContext.request.contextPath}/api/wallet/withdraw', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({ amount: parseInt(input.value) })
    })
            .then(function(res) { return res.json(); })
            .then(function(data) {
              if (data.success) {
                currentBalance = data.balance;
                availBalance = data.availBalance;
                updateBalanceDisplay();
                alert(data.message);
                closeModal('withdrawModal');
                loadTransactions(1);
              } else {
                input.classList.add('error');
                error.textContent = data.message;
                error.classList.add('active');
              }
            });
  });

  // 모달
  function openModal(id) {
    document.getElementById(id).classList.add('active');
    updateBalanceDisplay();
  }

  function closeModal(id) {
    var m = document.getElementById(id);
    m.classList.remove('active');
    var inputs = m.querySelectorAll('.form-input');
    for (var i = 0; i < inputs.length; i++) {
      inputs[i].value = '';
      inputs[i].classList.remove('error');
    }
    var errors = m.querySelectorAll('.form-error');
    for (var j = 0; j < errors.length; j++) {
      errors[j].classList.remove('active');
    }
  }

  document.getElementById('depositBtn').addEventListener('click', function() { openModal('depositModal'); });
  document.getElementById('closeDepositModal').addEventListener('click', function() { closeModal('depositModal'); });
  document.getElementById('cancelDepositBtn').addEventListener('click', function() { closeModal('depositModal'); });
  document.getElementById('withdrawBtn').addEventListener('click', function() { openModal('withdrawModal'); });
  document.getElementById('closeWithdrawModal').addEventListener('click', function() { closeModal('withdrawModal'); });
  document.getElementById('cancelWithdrawBtn').addEventListener('click', function() { closeModal('withdrawModal'); });

  document.getElementById('depositModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal('depositModal');
  });
  document.getElementById('withdrawModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal('withdrawModal');
  });

  function initDropdown() {
    var btn = document.getElementById('userDropdownBtn');
    var menu = document.getElementById('userDropdownMenu');
    if (btn && menu) {
      btn.addEventListener('click', function(e) {
        e.stopPropagation();
        menu.classList.toggle('active');
      });
      document.addEventListener('click', function(e) {
        if (!menu.contains(e.target) && !btn.contains(e.target)) {
          menu.classList.remove('active');
        }
      });
    }
  }
</script>
</body>

</html>