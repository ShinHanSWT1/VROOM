// myInfo.js - 사용자 마이페이지 전용 스크립트

// timeAgo 함수
function timeAgo(dateString) {
    if (!dateString) return "";
    const now = new Date();
    const past = new Date(dateString);

    const diff = now - past;

    const seconds = Math.floor(diff / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);

    if (seconds < 60) return "방금 전";
    if (minutes < 60) return minutes + "분 전";
    if (hours < 24) return hours + "시간 전";
    if (days < 7) return days + "일 전";

    return dateString.substring(0, 10);
}

// 변수 선언
let currentPage = 1;
const itemsPerPage = 9;
let currentFilter = 'all';
let currentReportTask = null;

// HTML data attribute에서 심부름 데이터 읽기
const myActivities = [];
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('#errandDataContainer .errand-data').forEach(function(el) {
        myActivities.push({
            errandsId: parseInt(el.dataset.id),
            icon: '📦',
            badge: '심부름',
            title: (el.dataset.title || '').replace(/[\r\n]+/g, ' '),
            description: (el.dataset.description || '').replace(/[\r\n]+/g, ' '),
            price: el.dataset.price + '원',
            status: el.dataset.status,
            location: el.dataset.location,
            createdAt: el.dataset.created
        });
    });

    // Initialize
    renderActivities('all', 1);

    // Tab Click Listeners
    const tabs = document.querySelectorAll('.tab-btn');
    tabs.forEach(tab => {
        tab.addEventListener('click', function () {
            tabs.forEach(t => t.classList.remove('active'));
            this.classList.add('active');

            const tabText = this.textContent.trim();
            let filterType = 'all';
            if (tabText === '부름') filterType = 'waiting';
            else if (tabText === '예약') filterType = 'reserved';
            else if (tabText === '완료') filterType = 'completed';

            renderActivities(filterType, 1);
        });
    });

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
});

// Function to render activities with pagination
function renderActivities(filterType, page = 1) {
    currentFilter = filterType;
    currentPage = page;
    const gridContainer = document.getElementById('activityGrid');
    if (!gridContainer) return;
    
    gridContainer.innerHTML = '';

    let filteredData;
    if (filterType === 'all') {
        filteredData = myActivities;
    } else if (filterType === 'waiting') {
        filteredData = myActivities.filter(task => task.status === 'WAITING');
    } else if (filterType === 'reserved') {
        filteredData = myActivities.filter(task =>
            task.status === 'MATCHED' || task.status === 'CONFIRMED1' || task.status === 'CONFIRMED2');
    } else if (filterType === 'completed') {
        filteredData = myActivities.filter(task => task.status === 'COMPLETED' || task.status === 'HOLD');
    } else {
        filteredData = myActivities.filter(task => task.status === filterType);
    }

    if (filteredData.length === 0) {
        gridContainer.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 3rem; color: var(--color-gray);">해당하는 내역이 없습니다.</div>';
        renderPagination(0, page);
        return;
    }

    const totalPages = Math.ceil(filteredData.length / itemsPerPage);
    const startIndex = (page - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const paginatedData = filteredData.slice(startIndex, endIndex);

    paginatedData.forEach((task, index) => {
        const taskCard = document.createElement('div');
        taskCard.className = 'task-card';

        taskCard.addEventListener('click', function() {
            const contextPath = document.querySelector('meta[name="context-path"]')?.content || '';
            window.location.href = contextPath + '/errand/detail?errandsId=' + task.errandsId;
        });

        let statusLabel = '';
        if (task.status === 'WAITING') {
            statusLabel = '<span style="position:absolute; top:10px; right:10px; background:#6B8E23; color:#fff; padding:2px 8px; border-radius:4px; font-size:0.7rem; z-index:2;">부름중</span>';
        } else if (task.status === 'MATCHED' || task.status === 'CONFIRMED1' || task.status === 'CONFIRMED2') {
            statusLabel = '<span style="position:absolute; top:10px; right:10px; background:#F2B807; color:#fff; padding:2px 8px; border-radius:4px; font-size:0.7rem; z-index:2;">예약중</span>';
        } else if (task.status === 'COMPLETED') {
            statusLabel = '<span style="position:absolute; top:10px; right:10px; background:#7F8C8D; color:#fff; padding:2px 8px; border-radius:4px; font-size:0.7rem; z-index:2;">완료</span>';
        } else if (task.status === 'CANCELED') {
            statusLabel = '<span style="position:absolute; top:10px; right:10px; background:#e74c3c; color:#fff; padding:2px 8px; border-radius:4px; font-size:0.7rem; z-index:2;">취소</span>';
        } else if (task.status === 'HOLD') {
            statusLabel = '<span style="position:absolute; top:10px; right:10px; background:#e74c3c; color:#fff; padding:2px 8px; border-radius:4px; font-size:0.7rem; z-index:2;">보류</span>';
        }

        const reportButton = task.status === 'HOLD'
            ? '<button class="report-btn" data-task-index="' + (startIndex + index) + '" style="margin-left:8px; padding:2px 8px; font-size:0.7rem; vertical-align:middle;">신고하기</button>'
            : '';

        const locationText = task.location || '';
        const displayTime = timeAgo(task.createdAt);

        taskCard.innerHTML = '<div class="task-image">' + task.icon + statusLabel + '</div>' +
            '<div class="task-card-content">' +
            '<div class="task-card-header">' +
            '<span class="task-badge">' + task.badge + '</span>' +
            '<span class="task-time" style="display:flex; align-items:center;">' + displayTime + reportButton + '</span>' +
            '</div>' +
            '<h3 class="task-card-title">' + task.title + '</h3>' +
            '<div class="task-author-info">' +
            '<div class="author-avatar" style="font-size:0.7rem; width:20px; height:20px; margin-right:5px;">👤</div>' +
            '<span class="author-name">' + (task.description || '') + '</span>' +
            '</div>' +
            '<div class="task-meta">' +
            '<span class="task-location">' + locationText + '</span>' +
            '<span class="task-price">' + task.price + '</span>' +
            '</div>' +
            '</div>';
        gridContainer.appendChild(taskCard);
    });

    // 신고하기 버튼 이벤트
    document.querySelectorAll('.report-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            const taskIndex = parseInt(btn.dataset.taskIndex);
            currentReportTask = myActivities[taskIndex];
            // openReportModal();
        });
    });

    renderPagination(totalPages, page);
}

// Function to render pagination
function renderPagination(totalPages, currentPage) {
    const paginationContainer = document.getElementById('paginationContainer');
    if (!paginationContainer) return;
    
    paginationContainer.innerHTML = '';

    if (totalPages <= 1) return;

    const prevBtn = document.createElement('button');
    prevBtn.className = 'pagination-btn';
    prevBtn.innerHTML = '&laquo;';
    prevBtn.disabled = currentPage === 1;
    prevBtn.addEventListener('click', () => {
        if (currentPage > 1) {
            renderActivities(currentFilter, currentPage - 1);
        }
    });
    paginationContainer.appendChild(prevBtn);

    const maxVisiblePages = 5;
    let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
    let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);

    if (endPage - startPage < maxVisiblePages - 1) {
        startPage = Math.max(1, endPage - maxVisiblePages + 1);
    }

    for (let i = startPage; i <= endPage; i++) {
        const pageBtn = document.createElement('button');
        pageBtn.className = 'pagination-btn';
        if (i === currentPage) {
            pageBtn.classList.add('active');
        }
        pageBtn.textContent = i;
        pageBtn.addEventListener('click', () => {
            renderActivities(currentFilter, i);
        });
        paginationContainer.appendChild(pageBtn);
    }

    const nextBtn = document.createElement('button');
    nextBtn.className = 'pagination-btn';
    nextBtn.innerHTML = '&raquo;';
    nextBtn.disabled = currentPage === totalPages;
    nextBtn.addEventListener('click', () => {
        if (currentPage < totalPages) {
            renderActivities(currentFilter, currentPage + 1);
        }
    });
    paginationContainer.appendChild(nextBtn);
}
