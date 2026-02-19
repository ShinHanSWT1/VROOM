document.addEventListener('DOMContentLoaded', function() {
    // 탭 버튼 요소들 선택
    const tabs = document.querySelectorAll('.activity-tab-btn');
    // 탭 내용 컨테이너들 선택
    const contents = document.querySelectorAll('.activity-list-container');

    tabs.forEach(function(tab) {
        tab.addEventListener('click', function() {
            // 1. 모든 탭 버튼에서 active 클래스 제거
            tabs.forEach(function(t) {
                t.classList.remove('active');
            });

            // 2. 클릭된 탭 버튼에 active 클래스 추가
            this.classList.add('active');

            // 3. 모든 탭 내용 숨기기 (active 클래스 제거)
            contents.forEach(function(content) {
                content.classList.remove('active');
            });

            // 4. 클릭된 탭의 data-target에 해당하는 내용만 보이기
            const targetId = this.getAttribute('data-target');
            const targetContent = document.getElementById(targetId);
            if (targetContent) {
                targetContent.classList.add('active');
            }
        });
    });
});
