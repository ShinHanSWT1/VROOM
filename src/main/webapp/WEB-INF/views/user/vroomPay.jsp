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

  <!-- 글꼴 -->
  <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
  <link rel="stylesheet" as="style"
        href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
</head>

<body>
<header class="header">
  <div class="header-container">
    <div class="logo">
      <h1 onclick="location.href='main_updated_2.html'">VROOM</h1>
    </div>
    <nav class="nav-menu">
      <a href="main_updated_2.html" class="nav-item">홈</a>
      <a href="#" class="nav-item">커뮤니티</a>
      <a href="#" class="nav-item">심부름꾼 전환</a>
      <div class="nav-dropdown">
        <button class="nav-item nav-user" id="userDropdownBtn">유저</button>
        <div class="dropdown-menu" id="userDropdownMenu">
          <a href="myInfo" class="dropdown-item">나의정보</a>
          <a href="vroomPay" class="dropdown-item">부름페이</a>
          <a href="myActivity" class="dropdown-item">나의 활동</a>
          <a href="#" class="dropdown-item">설정</a>
          <a href="#" class="dropdown-item">고객지원</a>
          <div class="dropdown-divider"></div>
          <a href="#" class="dropdown-item logout">로그아웃</a>
        </div>
      </div>
    </nav>
  </div>
</header>

<div class="container">
  <div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="sidebar">
      <ul class="sidebar-menu">
        <li class="sidebar-item"><a href="myInfo" class="sidebar-link">나의 정보</a></li>
        <li class="sidebar-item"><a href="vroomPay" class="sidebar-link active">부름 페이<br>(계좌 관리)</a>
        </li>
        <li class="sidebar-item"><a href="myActivity" class="sidebar-link">나의 활동</a></li>
        <li class="sidebar-item"><a href="#" class="sidebar-link">설정</a></li>
        <li class="sidebar-item"><a href="#" class="sidebar-link">고객지원</a></li>
      </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content">

      <h2 class="page-title">부름 페이</h2>

      <!-- Refined Profile & Balance Card -->
      <div class="pay-info-card">
        <div class="profile-section">
          <div class="profile-image-container">
            온도
          </div>
          <div class="profile-details">
            <span class="profile-nickname">닉네임</span>
            <button class="option-btn">현질 옵션 [ 내글을 상위 노출 해보세요 ]</button>
          </div>
        </div>

        <div class="balance-container">
          <div class="balance-box">
            <button class="balance-action-btn">충 전</button>
            <button class="balance-action-btn">출 금</button>
            <div class="balance-display">
              <span class="balance-label">잔 액</span>
              <span class="balance-amount">12 원</span>
            </div>
          </div>
        </div>

        <div class="temp-container">
          <span class="temp-label">온도</span>
          <div class="temp-bar">
            <div class="temp-fill"></div>
          </div>
          <span class="temp-value">36.5℃</span>
        </div>
      </div>

      <!-- Refined Transaction History -->
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
          <!-- JS populated -->
        </div>
      </div>

      <div class="pagination" id="pagination">
        <!-- JS populated -->
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

<script>
  // Mock Data - 12 items
  const transactionData = Array.from({ length: 12 }, (_, i) => ({
    title: `거래 내역 테스트 제목 ${i + 1}`,
    author: `사용자${i + 1}`,
    amount: `${(i + 1) * 1000}원`
  }));

  const itemsPerPage = 10;
  let currentPage = 1;

  function renderTransactions(page) {
    const listContainer = document.getElementById('transactionList');
    listContainer.innerHTML = '';

    const start = (page - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    const pageItems = transactionData.slice(start, end);

    pageItems.forEach(item => {
      const el = document.createElement('div');
      el.className = 'history-item';
      el.innerHTML = `
                    <div class="item-title">${item.title}</div>
                    <div class="item-author">${item.author}</div>
                    <div class="item-amount">${item.amount}</div>
                `;
      listContainer.appendChild(el);
    });

    renderPagination();
  }

  function renderPagination() {
    const paginationContainer = document.getElementById('pagination');
    paginationContainer.innerHTML = '';

    const totalPages = Math.ceil(transactionData.length / itemsPerPage);

    for (let i = 1; i <= totalPages; i++) {
      const btn = document.createElement('div');
      btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
      btn.textContent = i;
      btn.onclick = () => {
        currentPage = i;
        renderTransactions(currentPage);
      }
      paginationContainer.appendChild(btn);
    }
  }

  // Init
  renderTransactions(1);

  // Dropdown Logic (Reused)
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
  });
</script>
</body>

</html>