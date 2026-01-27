// Mock Data
const activityData = {
    written: [
        { title: '제 목', nickname: '닉네임', time: '올린 시간', views: '조회수', comments: 0 },
        { title: '제 목', nickname: '닉네임', time: '올린 시간', views: '조회수', comments: 0 },
        { title: '제 목', nickname: '닉네임', time: '올린 시간', views: '조회수', comments: 0 },
        { title: '제 목', nickname: '닉네임', time: '올린 시간', views: '조회수', comments: 0 }
    ],
    commented: [
        { title: '댓글단 글 제목', nickname: '작성자', time: '1시간 전', views: '123', comments: 5 },
        { title: '다른 게시물', nickname: '작성자2', time: '2시간 전', views: '45', comments: 12 }
    ],
    saved: [
        { title: '저장한 꿀팁', nickname: '정보왕', time: '어제', views: '999+', comments: 30 }
    ]
};

function renderActivities(type) {
    const listContainer = document.getElementById('activityList');
    listContainer.innerHTML = '';

    const data = activityData[type];

    if (!data || data.length === 0) {
        listContainer.innerHTML = '<div style="text-align:center; padding: 3rem; color: #777;">활동 내역이 없습니다.</div>';
        return;
    }

    data.forEach(function(item) {
        const el = document.createElement('div');
        el.className = 'activity-list-item';

        let htmlContent = '';
        htmlContent += '<div class="item-left">';
        htmlContent += '    <div class="item-title">' + item.title + '</div>';
        htmlContent += '    <div class="item-meta">';
        htmlContent += '        <span>' + item.nickname + '</span>';
        htmlContent += '        <span style="margin: 0 0.5rem">|</span>';
        htmlContent += '        <span>' + item.time + '</span>';
        htmlContent += '        <span style="margin: 0 0.5rem">|</span>';
        htmlContent += '        <span>' + item.views + '</span>';
        htmlContent += '    </div>';
        htmlContent += '</div>';

        htmlContent += '<div class="item-right">';
        htmlContent += '    <div class="item-thumbnail">';
        htmlContent += '        <span class="duck-icon">🐥</span>';
        htmlContent += '    </div>';
        htmlContent += '    <div class="item-comment-box">';
        htmlContent += '        <span class="comment-count">' + item.comments + '</span>';
        htmlContent += '        <span class="comment-label">댓글</span>';
        htmlContent += '    </div>';
        htmlContent += '</div>';

        el.innerHTML = htmlContent;
        listContainer.appendChild(el);
    });
}

// 초기 실행
document.addEventListener('DOMContentLoaded', function() {
    renderActivities('written');

    // 탭 클릭 이벤트
    const tabs = document.querySelectorAll('.activity-tab-btn');
    tabs.forEach(function(tab) {
        tab.addEventListener('click', function () {
            tabs.forEach(function(t) { t.classList.remove('active'); });
            this.classList.add('active');
            renderActivities(this.dataset.type);
        });
    });
});
