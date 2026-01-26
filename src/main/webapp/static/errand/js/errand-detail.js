// errand-detail.js - 심부름 상세 페이지 전용 스크립트

document.addEventListener('DOMContentLoaded', function () {
    // Dropdown Logic
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

    // Initialize
    renderRelatedTasks();
});

// Mock related tasks data
const relatedTasks = [
    { icon: '🧹', badge: '청소', time: '10분 전', title: '집 청소 도와주실 분', location: '서초구 서초동', price: '15,000원' },
    { icon: '🔧', badge: '설치/조립', time: '15분 전', title: '책장 조립 부탁드립니다', location: '송파구 잠실동', price: '8,000원' },
    { icon: '🐕', badge: '반려동물', time: '20분 전', title: '강아지 산책 시켜주세요', location: '강동구 천호동', price: '6,000원' },
    { icon: '📝', badge: '줄서기', time: '25분 전', title: '토요쿠 대기줄 서주세요', location: '마포구 합정동', price: '20,000원' },
    { icon: '🛍️', badge: '배달', time: '30분 전', title: '편의점 야식 배달 부탁해요', location: '영등포구 여의도동', price: '3,500원' },
    { icon: '🏠', badge: '기타', time: '35분 전', title: '바퀴벌레 잡아주세요', location: '송파구 문정동', price: '10,000원' }
];

function renderRelatedTasks() {
    const grid = document.getElementById('relatedTasksGrid');
    if (!grid) return;
    grid.innerHTML = '';

    relatedTasks.forEach(task => {
        const taskCard = document.createElement('div');
        taskCard.className = 'task-card';
        taskCard.innerHTML = `
            <div class="task-image">
                <img src="${task.imageUrl}" alt="심부름 이미지">	
            </div>
            <div class="task-card-content">
                <div class="task-card-header">
                    <span class="task-badge">${task.badge}</span>
                    <span class="task-time">${task.time}</span>
                </div>
                <h3 class="task-card-title">${task.title}</h3>
                <div class="task-meta">
                    <span class="task-location">${task.location}</span>
                    <span class="task-price">${task.price}</span>
                </div>
            </div>
        `;
        grid.appendChild(taskCard);
    });
}
