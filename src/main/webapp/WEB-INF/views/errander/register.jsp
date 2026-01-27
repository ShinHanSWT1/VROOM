<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>부름이 등록 - 우리동네 심부름</title>
    <style>
        /* 전역 변수 및 리셋 */
        :root {
            /* 컬러 팔레트 */
            --color-primary: #6B8E23;
            --color-secondary: #F2CB05;
            --color-tertiary: #F2B807;
            --color-accent: #F2A007;
            --color-warm: #D97218;

            /* 중성 컬러 */
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
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Malgun Gothic', sans-serif;
            color: var(--color-dark);
            line-height: 1.6;
            background-color: #FAFAFA;
        }

        /* 헤더 */
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

        /* 컨테이너 */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1.5rem;
        }

        /* 푸터 */
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

        /* 인증 페이지 공통 스타일 */
        .auth-page {
            min-height: calc(100vh - 200px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 1.5rem;
        }

        .auth-card {
            background-color: var(--color-white);
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            padding: 3rem;
            width: 100%;
            max-width: 500px;
        }

        .auth-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--color-dark);
            text-align: center;
            margin-bottom: 2rem;
        }

        /* 입력 필드 */
        .auth-form-group {
            margin-bottom: 1.5rem;
        }

        .auth-label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.5rem;
        }

        .auth-input {
            width: 100%;
            height: 44px;
            padding: 0 1rem;
            border: 1px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 1rem;
            background-color: var(--color-light-gray);
            color: var(--color-gray);
            transition: all 0.2s ease;
        }

        .auth-input:focus {
            outline: none;
            background-color: var(--color-white);
        }

        .auth-input[type="file"] {
            cursor: pointer;
            padding: 0.5rem;
            height: auto;
            line-height: 1.5;
        }

        .auth-input[type="file"]:focus {
            border-color: var(--color-primary);
            background-color: var(--color-white);
        }

        /* 주소 선택 */
        .address-group {
            margin-bottom: 1.5rem;
        }

        .address-label {
            display: block;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.5rem;
        }

        .address-selects {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .address-sido {
            font-size: 1rem;
            color: var(--color-dark);
            font-weight: 500;
            white-space: nowrap;
            padding: 0 0.5rem;
        }

        .address-select {
            flex: 1;
            min-width: 0;
            height: 44px;
            padding: 0 0.75rem;
            border: 1px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 1rem;
            background-color: var(--color-light-gray);
            color: var(--color-gray);
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .address-select:focus {
            outline: none;
            background-color: var(--color-white);
            border-color: var(--color-primary);
            color: var(--color-primary);
        }

        .address-select.has-value {
            background-color: var(--color-white);
            border-color: var(--color-primary);
            color: var(--color-primary);
        }

        .address-select option {
            background-color: var(--color-white);
            color: var(--color-dark);
        }

        /* 메인 버튼 */
        .auth-btn {
            width: 100%;
            height: 44px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-bottom: 1.5rem;
        }

        .auth-btn:disabled {
            background-color: var(--color-light-gray);
            color: var(--color-gray);
            cursor: not-allowed;
        }

        .auth-btn:not(:disabled) {
            background-color: var(--color-primary);
            color: var(--color-white);
        }

        .auth-btn:not(:disabled):hover {
            background-color: #5a7a1d;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                gap: 1rem;
            }

            .nav-menu {
                flex-wrap: wrap;
                justify-content: center;
            }

            .auth-card {
                padding: 2rem 1.5rem;
            }

            .auth-title {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
<!-- 헤더 -->
<header class="header">
    <div class="header-container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/" style="text-decoration: none;"><h1>VROOM</h1></a>
        </div>
        <nav class="nav-menu">
            <a href="${pageContext.request.contextPath}/community/" class="nav-item">커뮤니티</a>
            <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item">로그아웃</a>
        </nav>
    </div>
</header>

<!-- 부름이 등록 섹션 -->
<section class="auth-page">
    <div class="auth-card">
        <h2 class="auth-title">부름이 등록</h2>
        <p style="text-align: center; color: var(--color-gray); margin-bottom: 2rem; font-size: 0.9rem;">
            부름이로 활동하기 위해 추가 정보를 입력해주세요.<br>
            제출하신 서류는 관리자 승인 후 활동이 가능합니다.
        </p>

        <form action="${pageContext.request.contextPath}/errander/register" method="post" enctype="multipart/form-data" id="registerForm">

            <!-- 주 활동 지역 -->
            <div class="address-group">
                <label class="address-label">주 활동 지역 (필수)</label>
                <div class="address-selects">
                    <span class="address-sido">서울특별시</span>
                    <select name="gu1" id="gu1" class="address-select" required>
                        <option value="">구 선택</option>
                    </select>
                    <select name="dong1" id="dong1" class="address-select" disabled required>
                        <option value="">동 선택</option>
                    </select>
                    <input type="hidden" name="dongCode1" id="dongCode1">
                </div>
            </div>

            <!-- 부 활동 지역 -->
            <div class="address-group">
                <label class="address-label">부 활동 지역 (선택)</label>
                <div class="address-selects">
                    <span class="address-sido">서울특별시</span>
                    <select name="gu2" id="gu2" class="address-select">
                        <option value="">구 선택</option>
                    </select>
                    <select name="dong2" id="dong2" class="address-select" disabled>
                        <option value="">동 선택</option>
                    </select>
                    <input type="hidden" name="dongCode2" id="dongCode2">
                </div>
            </div>

            <!-- 서류 제출 1 -->
            <div class="auth-form-group">
                <label for="document1" class="auth-label">신분증 사본 (필수)</label>
                <input
                        type="file"
                        id="document1"
                        name="documentFiles"
                        class="auth-input"
                        accept="image/*"
                        required
                >
            </div>

            <!-- 서류 제출 2 -->
            <div class="auth-form-group">
                <label for="document2" class="auth-label">통장 사본 (필수)</label>
                <input
                        type="file"
                        id="document2"
                        name="documentFiles"
                        class="auth-input"
                        accept="image/*"
                        required
                >
            </div>

            <!-- 등록 버튼 -->
            <button type="submit" class="auth-btn" id="registerBtn">부름이 등록 신청</button>
        </form>
    </div>
</section>

<!-- 푸터 -->
<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-info">
                <h3>우리동네 심부름</h3>
                <p>이웃과 함께하는 따뜻한 심부름 커뮤니티</p>
            </div>
            <div class="footer-links">
                <a href="#">회사소개</a>
                <a href="#">이용약관</a>
                <a href="#">개인정보처리방침</a>
                <a href="#">문의하기</a>
            </div>
            <div class="footer-copyright">
                <p>&copy; 2024 우리동네 심부름. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>

<script>
    // 주소 선택 관련 변수
    const gu1Select = document.getElementById('gu1');
    const dong1Select = document.getElementById('dong1');
    const dongCode1Input = document.getElementById('dongCode1');
    const gu2Select = document.getElementById('gu2');
    const dong2Select = document.getElementById('dong2');
    const dongCode2Input = document.getElementById('dongCode2');

    // 목업 데이터 (실제로는 API 호출)
    const mockGus = ['강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구', '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'];

    // 페이지 로드 시 구 목록 로드
    function loadGus() {
        mockGus.forEach(gu => {
            // gu1용 option
            const option1 = document.createElement('option');
            option1.value = gu;
            option1.textContent = gu;
            gu1Select.appendChild(option1);

            // gu2용 option
            const option2 = document.createElement('option');
            option2.value = gu;
            option2.textContent = gu;
            gu2Select.appendChild(option2);
        });
    }

    // 구 선택 시 동 목록 로드
    function loadDongs(guSelect, dongSelect, dongCodeInput) {
        const selectedGu = guSelect.value;

        if (!selectedGu) {
            dongSelect.disabled = true;
            dongSelect.innerHTML = '<option value="">동 선택</option>';
            dongCodeInput.value = '';
            dongSelect.classList.remove('has-value');
            return;
        }

        const contextPath = '${pageContext.request.contextPath}';

        fetch(contextPath + '/auth/selectdong?gu=' + encodeURIComponent(selectedGu))
            .then(res => res.json())
            .then(dongs => {
                dongSelect.disabled = false;
                dongSelect.innerHTML = '<option value="">동 선택</option>';

                dongs.forEach(dong => {
                    const option = document.createElement('option');
                    option.value = dong.dongName;
                    option.textContent = dong.dongName;
                    option.dataset.code = dong.dongCode;
                    dongSelect.appendChild(option);
                });

                dongCodeInput.value = '';
                dongSelect.classList.remove('has-value');
            })
            .catch(err => {
                console.error('동 조회 실패', err);
                alert('동 정보를 불러오지 못했습니다.');
            });
    }

    // 동 선택 시 dong_code 저장
    function handleDongSelect(dongSelect, dongCodeInput) {
        const selectedOption = dongSelect.options[dongSelect.selectedIndex];

        if (selectedOption.value && selectedOption.dataset.code) {
            dongCodeInput.value = selectedOption.dataset.code;
            dongSelect.classList.add('has-value');
        } else {
            dongCodeInput.value = '';
            dongSelect.classList.remove('has-value');
        }
    }

    // 구 선택 이벤트 리스너
    gu1Select.addEventListener('change', function() {
        this.classList.add('has-value');
        loadDongs(gu1Select, dong1Select, dongCode1Input);
    });

    gu2Select.addEventListener('change', function() {
        this.classList.add('has-value');
        loadDongs(gu2Select, dong2Select, dongCode2Input);
    });

    // 동 선택 이벤트 리스너
    dong1Select.addEventListener('change', function() {
        handleDongSelect(dong1Select, dongCode1Input);
    });

    dong2Select.addEventListener('change', function() {
        handleDongSelect(dong2Select, dongCode2Input);
    });

    // 포커스 처리
    [gu1Select, dong1Select, gu2Select, dong2Select].forEach(select => {
        select.addEventListener('focus', function() {
            this.style.backgroundColor = 'var(--color-white)';
        });

        select.addEventListener('blur', function() {
            if (!this.value) {
                this.style.backgroundColor = 'var(--color-light-gray)';
            }
        });
    });

    // 페이지 로드 시 구 목록 로드
    loadGus();
</script>
</body>
</html>