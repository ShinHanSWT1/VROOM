<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>심부름 등록 - VROOM</title>
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

        .form-container {
            background-color: var(--color-white);
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .form-header {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            padding: 2rem;
            text-align: center;
        }

        .form-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--color-white);
        }

        .form-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            padding: 2.5rem;
        }

        .form-left,
        .form-right {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .form-label {
            font-size: 0.95rem;
            font-weight: 600;
            color: var(--color-dark);
        }

        .form-label-required::after {
            content: ' *';
            color: #e74c3c;
        }

        .form-input,
        .form-select,
        .form-textarea {
            padding: 0.75rem 1rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: inherit;
            transition: all 0.3s ease;
            background-color: var(--color-white);
            color: var(--color-dark);
        }

        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: var(--color-secondary);
            background-color: #FFFEF8;
        }

        .form-textarea {
            resize: vertical;
            min-height: 120px;
        }

        .category-toggle {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 0.75rem;
        }

        .category-option {
            padding: 0.75rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
            background-color: var(--color-white);
            color: var(--color-gray);
        }

        .category-option:hover {
            border-color: var(--color-secondary);
            background-color: #FFFEF8;
        }

        .category-option.active {
            border-color: var(--color-accent);
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-white);
        }

        .image-upload-area {
            border: 2px dashed var(--color-light-gray);
            border-radius: 8px;
            padding: 2rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background-color: #FAFAFA;
        }

        .image-upload-area:hover {
            border-color: var(--color-secondary);
            background-color: #FFFEF8;
        }

        .upload-icon {
            font-size: 3rem;
            color: var(--color-gray);
            margin-bottom: 1rem;
        }

        .upload-text {
            font-size: 0.9rem;
            color: var(--color-gray);
        }

        .upload-counter {
            font-size: 0.85rem;
            color: var(--color-gray);
            margin-top: 0.5rem;
        }

        .datetime-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .form-actions {
            grid-column: 1 / -1;
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 1rem;
        }

        .btn {
            padding: 0.875rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-dark);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, var(--color-accent) 0%, var(--color-warm) 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .btn-secondary {
            background-color: var(--color-light-gray);
            color: var(--color-dark);
        }

        .btn-secondary:hover {
            background-color: var(--color-gray);
            color: var(--color-white);
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

        @media (max-width: 900px) {
            .form-content {
                grid-template-columns: 1fr;
            }

            .category-toggle {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {
            .datetime-group {
                grid-template-columns: 1fr;
            }

            .category-toggle {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
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
            <div class="form-container">
                <div class="form-header">
                    <h1 class="form-title">HEADER</h1>
                </div>

                <form class="form-content" id="errandForm" method="post" action="${pageContext.request.contextPath}/errand/create">
                    <!-- 카테고리/이미지 등 화면 선택값을 서버로 보내는 hidden들 -->
    				<input type="hidden" id="categoryId" name="categoryId" value="">
    				<input type="hidden" name="dongFullName" id="dongFullName">
                    
                    <!-- Left Column -->
                    <div class="form-left">
                        <div class="form-group">
                            <label class="form-label form-label-required">심부름 제목</label>
                            <input type="text" class="form-input" name="title" placeholder="제목을 입력하세요" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label form-label-required">카테고리</label>
                            <div class="category-toggle" id="categoryToggle">
                                <div class="category-option" data-category="1">배달/장보기</div>
                                <div class="category-option" data-category="2">청소/집안일</div>
                                <div class="category-option" data-category="3">벌레퇴치</div>
                                <div class="category-option" data-category="4">설치/조립</div>
                                <div class="category-option" data-category="5">동행/돌봄</div>
                                <div class="category-option" data-category="6">줄서기/예약</div>
                                <div class="category-option" data-category="7">서류/비즈니스</div>
                                <div class="category-option" data-category="8">기타</div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label form-label-required">심부름값</label>
                            <input type="number" class="form-input" name="rewardAmount" placeholder="가격을 입력하세요 (원)" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label form-label-required">수행비용</label>
                            <input type="number" class="form-input" name="expenseAmount" placeholder="가격을 입력하세요 (원)" required>
                        </div>
                       
                        <div class="form-group">
                            <label class="form-label">심부름 이미지</label>
                            <div class="image-upload-area" id="imageUploadArea">
                                <div class="upload-icon">
                                    <i class="icon-camera"></i>
                                </div>
                                <div class="upload-text">클릭하여 이미지를 업로드하세요</div>
                                <div class="upload-counter">0/10</div>
                            </div>
            				<input type="file" id="imageInput" name="images" multiple accept="image/*" style="display: none;">
                        </div>
                    </div>

                    <!-- Right Column -->
                    <div class="form-right">
                        <div class="form-group">
                            <label class="form-label form-label-required">심부름 설명</label>
                            <textarea class="form-textarea" name="description" placeholder="심부름에 대한 자세한 설명을 입력하세요" rows="11" required></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label form-label-required">심부름 위치</label>
                            <select class="form-input" name="dongCode" id="dongCodeSelect" required>
							  <option value="">동네를 선택하세요</option>
							  <c:forEach var="d" items="${dongs}">
							    <option value="${d.dongCode}" data-fullname="${d.dongFullName}">
							      ${d.dongFullName}
							    </option>
							  </c:forEach>
							</select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">희망날짜</label>
                            <div class="datetime-group">
                                <input type="date" class="form-input" name="desiredDate">
                				<input type="time" class="form-input" name="desiredTime">
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" 
                            onclick="window.location.href='${pageContext.request.contextPath}/errand/list'">취소</button>
                            <button type="submit" class="btn btn-primary">등록하기</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-info">
                    <h3>(주) 답스미포유</h3>
                    <p>대표 김동수, 황준호 ㅣ 사업자번호 375-87-00088<br>
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
        });

     	// Category Toggle (hidden 즉시 반영)
        document.addEventListener('DOMContentLoaded', function () {
          const categoryOptions = document.querySelectorAll('#categoryToggle .category-option');
          const catInput = document.getElementById('categoryId');

          categoryOptions.forEach(option => {
            option.addEventListener('click', function () {
              categoryOptions.forEach(opt => opt.classList.remove('active'));
              this.classList.add('active');

              const v = this.dataset.category;
              catInput.value = v;   // ⭐ 여기서 바로 박는다

              console.log('categoryId set immediately =>', v);
            });
          });
        });

        // Image Upload
        const imageUploadArea = document.getElementById('imageUploadArea');
        const imageInput = document.getElementById('imageInput');
        const uploadCounter = document.querySelector('.upload-counter');
        let uploadedImages = [];

        imageUploadArea.addEventListener('click', function () {
        	if (uploadedImages.length >= 10) return;
            imageInput.click();
        });

        imageInput.addEventListener('change', function (e) {
            const files = Array.from(e.target.files);
            const remainingSlots = 10 - uploadedImages.length;
            const filesToAdd = files.slice(0, remainingSlots);

            uploadedImages = uploadedImages.concat(filesToAdd);
            uploadCounter.textContent = `${uploadedImages.length}/10`;

            if (uploadedImages.length >= 10) {
                imageUploadArea.style.opacity = '0.5';
                imageUploadArea.style.cursor = 'not-allowed';
            }
        });
        
     	// Dong Select (코드 + 이름 분리)
        const dongSelect = document.getElementById('dongCodeSelect');
        const dongNameHidden = document.getElementById('dongFullName');

        if (dongSelect && dongNameHidden) {
        	  dongSelect.addEventListener('change', () => {
        	    const opt = dongSelect.options[dongSelect.selectedIndex];
        	    dongNameHidden.value = opt?.dataset?.fullname || '';
        	  });
        	  const opt = dongSelect.options[dongSelect.selectedIndex];
        	  dongNameHidden.value = opt?.dataset?.fullname || '';
        	}

        // Form Submit
        const errandForm = document.getElementById('errandForm');
        errandForm.addEventListener('submit', function (e) {
        	const catInput = document.getElementById('categoryId');
        	
            if (!selectedCategory) {
            	e.preventDefault();
                alert('카테고리를 선택해주세요.');
                return;
            }
        });
    </script>
</body>

</html>