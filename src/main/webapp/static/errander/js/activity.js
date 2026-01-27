/**
 * Errander Activity Page JavaScript
 * 나의 거래 페이지 - FullCalendar & Transaction List
 */

// 거래 내역 샘플 데이터 (나중에 서버에서 가져오기)
const activityCards = [
    { id: '1', title: '스벅 자허블 픽업', date: '2026-01-15', time: '14:30', amount: 15000 },
    { id: '2', title: '가구 날라주세요', date: '2026-01-20', time: '10:00', amount: 30000 },
    { id: '3', title: '청소 심부름', date: '2026-01-25', time: '16:00', amount: 50000 }
];

// FullCalendar 이벤트 형식으로 변환
const calendarEvents = activityCards.map(activity => ({
    id: activity.id,
    title: formatCurrency(activity.amount), // 제목 대신 금액 표시
    start: activity.date,
    extendedProps: {
        originalTitle: activity.title, // 원래 제목 저장
        time: activity.time,
        amount: activity.amount
    }
}));

function formatCurrency(amount) {
    return '₩' + amount.toLocaleString('ko-KR');
}

document.addEventListener('DOMContentLoaded', function() {
    const calendarEl = document.getElementById('calendar');

    const calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: ''
        },
        buttonText: {
            today: '오늘'
        },
        events: calendarEvents,

        // 날짜 클릭 시
        dateClick: function(info) {
            const dateStr = info.dateStr;
            const filtered = activityCards.filter(a => a.date === dateStr);
            renderTransactionList(filtered);
        },

        // 이벤트(거래) 클릭 시
        eventClick: function(info) {
            const vroomId = info.event.id;
            location.href = 'activity_detail?id=' + vroomId;
        }
    });

    calendar.render();

    // 초기 로드: 전체 거래 목록 표시
    renderTransactionList(activityCards);
});

function renderTransactionList(activities) {
    const container = document.getElementById('transactionListContainer');
    container.innerHTML = '';

    if (activities.length === 0) {
        container.innerHTML = '<p style="text-align: center; color: var(--color-gray); padding: 2rem;">거래 내역이 없습니다.</p>';
        return;
    }

    activities.forEach(activity => {
        const item = document.createElement('div');
        item.className = 'transaction-item';
        item.onclick = () => viewTransactionDetail(activity.id);

        item.innerHTML = `
            <div class="transaction-info">
                <div class="transaction-icon">🐝</div>
                <div class="transaction-details">
                    <div class="transaction-name">${activity.title}</div>
                    <div class="transaction-date">${activity.date} ${activity.time}</div>
                </div>
            </div>
            <div class="transaction-amount">${formatCurrency(activity.amount)}</div>
        `;
        container.appendChild(item);
    });
}

function viewTransactionDetail(vroomId) {
    location.href = 'activity_detail?id=' + vroomId;
}

function viewAllTransactions() {
    renderTransactionList(activityCards);
}
