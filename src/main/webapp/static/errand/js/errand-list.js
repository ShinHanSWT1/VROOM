// errand-list.js - 심부름 목록 페이지 전용 스크립트

document.addEventListener('DOMContentLoaded', function () {
    // 1) 필터/검색: 서버 GET 방식 (form submit)
    const filterForm = document.getElementById('filterForm');
    const categoryFilter = document.getElementById('categoryFilter');
    const sortFilter = document.getElementById('sortFilter');
    const neighborhoodFilter = document.getElementById('neighborhoodFilter');
    const searchInput = document.getElementById('searchInput');

    // select 변경 시 자동 submit
    if (filterForm) {
        if (categoryFilter) categoryFilter.addEventListener('change', () => filterForm.submit());
        if (sortFilter) sortFilter.addEventListener('change', () => filterForm.submit());
        if (neighborhoodFilter) neighborhoodFilter.addEventListener('change', () => filterForm.submit());

        // 검색 input에서 Enter 누르면 submit
        if (searchInput) {
            searchInput.addEventListener('keyup', (e) => {
                if (e.key === 'Enter') filterForm.submit();
            });
        }
    }

    // 2) 유저 드롭다운
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
