// errand-list.js - 심부름 목록 페이지 전용 스크립트

document.addEventListener('DOMContentLoaded', function () {
    // 1) 필터/검색: 서버 GET 방식 (form submit)
    const filterForm = document.getElementById('filterForm');
    if (filterForm) {
        const categoryFilter = document.getElementById('categoryFilter');
        const sortFilter = document.getElementById('sortFilter');
        const neighborhoodFilter = document.getElementById('neighborhoodFilter');
        const searchInput = document.getElementById('searchInput');

        if (categoryFilter) categoryFilter.addEventListener('change', () => filterForm.submit());
        if (sortFilter) sortFilter.addEventListener('change', () => filterForm.submit());
        if (neighborhoodFilter) neighborhoodFilter.addEventListener('change', () => filterForm.submit());

        if (searchInput) {
            searchInput.addEventListener('keyup', (e) => {
                if (e.key === 'Enter') filterForm.submit();
            });
        }
    }

    // 2) 글쓰기 버튼 권한 확인
    const writeBtn = document.getElementById('writeBtn');
    if (writeBtn) {
        writeBtn.addEventListener('click', function (event) {
            event.preventDefault(); // 기본 링크 이동 방지

            const isLoggedIn = this.dataset.isLoggedIn === 'true';
            const userRole = this.dataset.userRole;
            const loginUrl = this.dataset.loginUrl;
            const createUrl = this.dataset.createUrl;

            if (!isLoggedIn) {
                if (confirm("로그인하시겠습니까?")) {
                    window.location.href = loginUrl;
                }
            } else if (userRole === 'ERRANDER') {
                alert("사용자만 글작성이 가능합니다.");
            } else {
                // 계좌 연결 여부 체크
                fetch(contextPath + '/api/vroompay/status')
                    .then(res => res.json())
                    .then(data => {
                        if (data.success && data.linked) {
                            window.location.href = createUrl;
                        } else {
                            if (confirm("부름페이 계좌 연결이 필요합니다. 연결 페이지로 이동하시겠습니까?")) {
                                window.location.href = contextPath + '/member/vroomPay';
                            }
                        }
                    })
                    .catch(err => {
                        console.error('계좌 상태 확인 오류:', err);
                        alert("계좌 정보를 확인할 수 없습니다. 다시 시도해주세요.");
                    });
            }
        });
    }
});
