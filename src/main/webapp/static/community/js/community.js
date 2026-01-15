/**
 * community.js
 * 커뮤니티 목록 페이지 전용 스크립트
 */

// 현재 상태
let currentCategory = '맛집';
let currentLocation = '서울특별시 금천구 가산동';

/**
 * 페이지 제목 업데이트
 */
function updatePageTitle() {
    const guSelect = document.getElementById('guSelect');
    const dongSelect = document.getElementById('dongSelect');
    
    if (!guSelect || !dongSelect) return;
    
    const gu = guSelect.value;
    const dong = dongSelect.value;
    
    currentLocation = '서울특별시 ' + gu + ' ' + dong;
    
    const pageTitle = document.getElementById('pageTitle');
    if (pageTitle) {
        pageTitle.innerHTML = currentLocation + 
            ' <span class="category-badge-active">' + currentCategory + '</span> 관련 소식';
    }
}

/**
 * 카테고리 선택
 */
function selectCategory(element, category) {
    // 모든 카테고리 비활성화
    const items = document.querySelectorAll('.category-item');
    items.forEach(function(item) {
        item.classList.remove('active');
    });
    
    // 선택한 카테고리 활성화
    element.classList.add('active');
    
    currentCategory = category;
    updatePageTitle();
    
    // TODO: 서버에 카테고리 필터 요청
    // filterPostsByCategory(category);
}

/**
 * 검색 실행
 */
function performSearch() {
    const searchInput = document.getElementById('searchInput');
    if (!searchInput) return;
    
    const searchTerm = searchInput.value.trim();
    
    if (searchTerm) {
        // 폼 서브밋 방식으로 서버에 요청
        const form = document.createElement('form');
        form.method = 'GET';
        form.action = '/community/list';
        
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'search';
        input.value = searchTerm;
        
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
}

/**
 * 게시글 상세 페이지로 이동
 */
function goToPostDetail(postNo) {
    goToPage('/community/detail?postNo=' + postNo);
}

/**
 * 엔터키로 검색
 */
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                performSearch();
            }
        });
    }
    
    // 페이지 로드 시 동 옵션 초기화
    updateDongOptions();
});
