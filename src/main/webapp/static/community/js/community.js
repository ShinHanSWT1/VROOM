/**
 * community.js
 * 커뮤니티 목록 페이지 - 지역 선택만
 */

/**
 * 페이지 제목 업데이트
 */
function updatePageTitle() {
    const guName = $('#guSelect option:selected').text();
    const dongName = $('#dongSelect option:selected').text();
    const $pageTitle = $('#pageTitle');

    if ($pageTitle.length && guName && dongName) {
        $pageTitle.html(`서울특별시 ${guName} ${dongName} 동네생활`);
    }
}