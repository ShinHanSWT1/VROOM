document.addEventListener('DOMContentLoaded', function() {
    // 탭 클릭 이벤트
    const tabs = document.querySelectorAll('.activity-tab-btn');
    tabs.forEach(function(tab) {
        tab.addEventListener('click', function () {
            const type = this.dataset.type;
            // 현재 URL을 가져와서 'type' 파라미터만 변경하여 페이지 이동
            const url = new URL(window.location.href);
            url.searchParams.set('type', type);
            window.location.href = url.toString();
        });
    });
});
