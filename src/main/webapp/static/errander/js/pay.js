// pay.js - 부름 페이 페이지 전용 스크립트

// Sample data - replace with API calls in production
const paySummary = {
    settlementWaiting: 50000,
    availableBalance: 150000,
    thisMonthSettled: 300000
};

const settlementInProgress = {
    expectedAmount: 25000,
    status: '처리중'
};

const settlementList = [
    { name: '배달 심부름', date: '2024-01-15', amount: 15000 },
    { name: '청소 심부름', date: '2024-01-14', amount: 30000 },
    { name: '설치 서비스', date: '2024-01-13', amount: 50000 }
];

let currentPage = 1;
const totalPages = 5;

// Format number as currency
function formatCurrency(amount) {
    return '₩' + amount.toLocaleString('ko-KR');
}

// Initialize page data
function initPage() {
    // Update summary cards
    document.getElementById('settlementWaiting').textContent = formatCurrency(paySummary.settlementWaiting);
    document.getElementById('availableBalance').textContent = formatCurrency(paySummary.availableBalance);
    document.getElementById('thisMonthSettled').textContent = formatCurrency(paySummary.thisMonthSettled);

    // Update settlement in progress
    document.getElementById('expectedAmount').textContent = formatCurrency(settlementInProgress.expectedAmount);
    document.getElementById('settlementStatus').textContent = settlementInProgress.status;

    // Render settlement list
    renderSettlementList();

    // Render pagination
    renderPagination();
}

function renderSettlementList() {
    const container = document.getElementById('settlementListContainer');
    container.innerHTML = '';

    settlementList.forEach(settlement => {
        const item = document.createElement('div');
        item.className = 'settlement-item';
        item.innerHTML = `
            <div class="settlement-item-info">
                <div class="settlement-icon">🍯</div>
                <div class="settlement-details">
                    <div class="settlement-name">${settlement.name}</div>
                    <div class="settlement-date">${settlement.date}</div>
                </div>
            </div>
            <div class="settlement-amount">${formatCurrency(settlement.amount)}</div>
        `;
        container.appendChild(item);
    });
}

function renderPagination() {
    const pageNumbers = document.getElementById('pageNumbers');
    pageNumbers.innerHTML = '';

    for (let page = 1; page <= totalPages; page++) {
        const btn = document.createElement('button');
        btn.className = 'page-btn' + (page === currentPage ? ' active' : '');
        btn.textContent = page;
        btn.onclick = () => goToPage(page);
        pageNumbers.appendChild(btn);
    }

    document.getElementById('prevBtn').disabled = currentPage === 1;
    document.getElementById('nextBtn').disabled = currentPage === totalPages;
}

function requestWithdrawal() {
    if (confirm('출금을 요청하시겠습니까?')) {
        // In production, make API call here
        fetch('/api/rider/mypage/pay/withdraw', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                amount: settlementInProgress.expectedAmount
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('출금 요청이 완료되었습니다.');
                location.reload();
            } else {
                alert('출금 요청 중 오류가 발생했습니다.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('출금 요청 중 오류가 발생했습니다.');
        });
    }
}

function goToPage(page) {
    if (page < 1 || page > totalPages) return;
    currentPage = page;
    // In production, load data for the page
    renderPagination();
    // renderSettlementList(); // Reload settlement list for new page
}

document.addEventListener('DOMContentLoaded', initPage);
