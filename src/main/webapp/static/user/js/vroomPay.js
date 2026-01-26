// Mock Data - 12 items
const transactionData = Array.from({ length: 12 }, (_, i) => ({
    title: `거래 내역 테스트 제목 ${i + 1}`,
    author: `사용자${i + 1}`,
    amount: `${(i + 1) * 1000}원`
}));

const itemsPerPage = 10;
let currentPage = 1;

function renderTransactions(page) {
    const listContainer = document.getElementById('transactionList');
    listContainer.innerHTML = '';

    const start = (page - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    const pageItems = transactionData.slice(start, end);

    pageItems.forEach(item => {
        const el = document.createElement('div');
        el.className = 'history-item';
        el.innerHTML = `
            <div class="item-title">${item.title}</div>
            <div class="item-author">${item.author}</div>
            <div class="item-amount">${item.amount}</div>
        `;
        listContainer.appendChild(el);
    });

    renderPagination();
}

function renderPagination() {
    const paginationContainer = document.getElementById('pagination');
    paginationContainer.innerHTML = '';

    const totalPages = Math.ceil(transactionData.length / itemsPerPage);

    for (let i = 1; i <= totalPages; i++) {
        const btn = document.createElement('div');
        btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
        btn.textContent = i;
        btn.onclick = () => {
            currentPage = i;
            renderTransactions(currentPage);
        }
        paginationContainer.appendChild(btn);
    }
}

// Init
document.addEventListener('DOMContentLoaded', function() {
    renderTransactions(1);
});
