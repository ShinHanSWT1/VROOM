/**
 * main.js
 * 메인 페이지 전용 스크립트
 */

/**
 * 게시글 상세 페이지로 이동
 */
function goToPostDetail(postId) {
    goToPage('/community/detail?postNo=' + postId);
}

/**
 * 페이지 로드 시 초기화
 */
window.addEventListener('DOMContentLoaded', function() {
    // 기본 지역(송파구) 표시
    const firstTab = document.querySelector('.district-tab');
    if (firstTab) {
        showDong('songpa');
    }
});
