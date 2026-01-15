/**
 * common.js
 * 전체 페이지 공통 기능
 */

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    console.log('VROOM 페이지 로드 완료');
});

/**
 * 페이지 이동 함수 (공통)
 */
function goToPage(url) {
    window.location.href = url;
}

/**
 * 로고 클릭 시 메인 페이지로 이동
 */
function goToMain() {
    goToPage('/main');
}
