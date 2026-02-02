// pay.js - 부름이 부름 페이 페이지 스크립트

let currentBalance = 0;
let availBalance = 0;
const itemsPerPage = 10;

document.addEventListener('DOMContentLoaded', function() {
    loadPaySummary();
    checkAccountStatus();
    initModals();
});

// 정산 요약 정보 로드 (부름이 전용 - 상단 3개 카드)
function loadPaySummary() {
    fetch(contextPath + '/errander/api/pay/summary')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // 정산 대기 금액 (CONFIRMED1 상태)
                document.getElementById('settlementWaiting').textContent = formatAmount(data.settlementWaiting);
                // 수령 예정 금액 (CONFIRMED2 상태)
                document.getElementById('expectedAmount').textContent = formatAmount(data.expectedAmount);
                // 이번달 정산 완료 수익
                document.getElementById('thisMonthSettled').textContent = formatAmount(data.thisMonthSettled);
            } else {
                document.getElementById('settlementWaiting').textContent = '-';
                document.getElementById('expectedAmount').textContent = '-';
                document.getElementById('thisMonthSettled').textContent = '-';
            }
        })
        .catch(error => {
            console.error('정산 요약 로드 실패:', error);
            document.getElementById('settlementWaiting').textContent = '-';
            document.getElementById('expectedAmount').textContent = '-';
            document.getElementById('thisMonthSettled').textContent = '-';
        });
}

// 금액 포맷 (0이면 - 표시)
function formatAmount(amount) {
    if (amount === null || amount === undefined || amount === 0) {
        return '-';
    }
    return '₩' + Number(amount).toLocaleString();
}

// 계좌 상태 확인 및 UI 초기화 (사용자 vroomPay.js와 동일)
function checkAccountStatus() {
    const statusContainer = document.getElementById('account-status-container');
    const depositBtn = document.getElementById('depositBtn');
    const withdrawBtn = document.getElementById('withdrawBtn');
    const balanceDisplay = document.getElementById('balanceDisplay');

    fetch(contextPath + '/api/vroompay/status')
        .then(res => res.json())
        .then(data => {
            console.log("Account Status Response:", data);

            if (data.success && data.linked) {
                const account = data.account;

                const accountNum = account.realAccount ? account.realAccount : '연결됨';
                statusContainer.innerHTML = `<span>연결된 계좌: 신한 <strong>${accountNum}</strong></span>`;
                statusContainer.className = 'account-status-container linked';

                depositBtn.disabled = false;
                withdrawBtn.disabled = false;

                const balance = account.balance ? account.balance : 0;
                balanceDisplay.textContent = Number(balance).toLocaleString() + ' 원';

                currentBalance = balance;
                availBalance = account.availBalance ? account.availBalance : 0;

                loadTransactions(1);

            } else {
                // 계좌 연결 안됨
                statusContainer.innerHTML = `<span>부름페이 계좌가 연결되지 않았습니다.</span><button id="linkAccountBtn">계좌 연결</button>`;
                statusContainer.className = 'account-status-container not-linked';

                document.getElementById('linkAccountBtn').addEventListener('click', linkAccount);

                depositBtn.disabled = true;
                withdrawBtn.disabled = true;
                balanceDisplay.textContent = '-- 원';

                const list = document.getElementById('transactionList');
                list.innerHTML = '<div class="history-item"><div class="item-title" style="grid-column:1/-1;text-align:center;">부름페이 계좌를 연결하여 거래를 시작하세요.</div></div>';
                document.querySelector('.history-count').textContent = '(0)';
                document.getElementById('pagination').innerHTML = '';
            }
        })
        .catch(err => {
            console.error('Error fetching account status:', err);
            statusContainer.innerHTML = '계좌 정보 조회 중 오류가 발생했습니다. 새로고침 해주세요.';
            statusContainer.className = 'account-status-container not-linked';
        });
}

// 계좌 연결 함수
function linkAccount() {
    const btn = document.getElementById('linkAccountBtn');
    btn.disabled = true;
    btn.textContent = '연결 중...';

    fetch(contextPath + '/api/vroompay/create', {
        method: 'POST'
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert('계좌가 성공적으로 연결되었습니다. 페이지를 새로고침합니다.');
                location.reload();
            } else {
                alert('계좌 연결에 실패했습니다: ' + (data.message || '알 수 없는 오류'));
                btn.disabled = false;
                btn.textContent = '계좌 연결';
            }
        })
        .catch(err => {
            alert('오류가 발생했습니다.');
            console.error('Error linking account:', err);
            btn.disabled = false;
            btn.textContent = '계좌 연결';
        });
}

// 거래 내역 조회 (사용자 vroomPay.js와 동일한 API 사용)
function loadTransactions(page) {
    fetch(contextPath + '/api/vroompay/transactions?page=' + page + '&size=' + itemsPerPage)
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                renderTransactions(data.transactions);
                renderPagination(data.totalPages, data.currentPage);
                document.querySelector('.history-count').textContent = '(' + data.totalCount + ')';
            } else {
                const list = document.getElementById('transactionList');
                list.innerHTML = '<div class="history-item"><div class="item-title" style="grid-column:1/-1;text-align:center;">거래 내역을 불러올 수 없습니다.</div></div>';
            }
        })
        .catch(err => {
            console.error('Error loading transactions:', err);
            const list = document.getElementById('transactionList');
            list.innerHTML = '<div class="history-item"><div class="item-title" style="grid-column:1/-1;text-align:center;">거래 내역 조회 중 오류가 발생했습니다.</div></div>';
        });
}

function renderTransactions(transactions) {
    const list = document.getElementById('transactionList');

    if (!transactions || transactions.length === 0) {
        list.innerHTML = '<div class="history-item"><div class="item-type" style="grid-column:1/-1;text-align:center;">거래 내역이 없습니다.</div></div>';
        return;
    }

    let html = '';
    transactions.forEach(function(txn) {
        const typeLabel = getTypeLabel(txn.txnType);
        const amountClass = isPositiveType(txn.txnType) ? 'positive' : 'negative';
        const amountPrefix = isPositiveType(txn.txnType) ? '+' : '-';
        const memo = txn.memo ? truncateText(txn.memo, 20) : '-';

        html += '<div class="history-item">';
        html += '  <div class="item-type">' + typeLabel + '</div>';
        html += '  <div class="item-content">' + memo + '</div>';
        html += '  <div class="item-date">' + formatDate(txn.createdAt) + '</div>';
        html += '  <div class="item-amount ' + amountClass + '">' + amountPrefix + Number(txn.amount).toLocaleString() + '원</div>';
        html += '</div>';
    });

    list.innerHTML = html;
}

function getTypeLabel(txnType) {
    const labels = {
        'CHARGE': '충전',
        'WITHDRAW': '출금',
        'HOLD': '홀드',
        'RELEASE': '홀드 해제',
        'PAYOUT': '정산',
        'REFUND': '환불'
    };
    return labels[txnType] || txnType;
}

function isPositiveType(txnType) {
    return txnType === 'CHARGE' || txnType === 'PAYOUT' || txnType === 'REFUND' || txnType === 'RELEASE';
}

function formatDate(dateStr) {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return year + '.' + month + '.' + day + ' ' + hours + ':' + minutes;
}

function truncateText(text, maxLength) {
    if (!text) return '';
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
}

function renderPagination(totalPages, currentPage) {
    const pagination = document.getElementById('pagination');

    if (totalPages <= 1) {
        pagination.innerHTML = '';
        return;
    }

    let html = '';

    // 이전 버튼
    if (currentPage > 1) {
        html += '<button class="page-btn" onclick="loadTransactions(' + (currentPage - 1) + ')">이전</button>';
    }

    // 페이지 번호
    const startPage = Math.max(1, currentPage - 2);
    const endPage = Math.min(totalPages, currentPage + 2);

    for (let i = startPage; i <= endPage; i++) {
        if (i === currentPage) {
            html += '<button class="page-btn active">' + i + '</button>';
        } else {
            html += '<button class="page-btn" onclick="loadTransactions(' + i + ')">' + i + '</button>';
        }
    }

    // 다음 버튼
    if (currentPage < totalPages) {
        html += '<button class="page-btn" onclick="loadTransactions(' + (currentPage + 1) + ')">다음</button>';
    }

    pagination.innerHTML = html;
}

function updateBalanceDisplay() {
    var ids = ['balanceDisplay', 'depositModalBalance', 'withdrawModalBalance'];
    ids.forEach(function(id) {
        var el = document.getElementById(id);
        if (el) el.textContent = Number(currentBalance).toLocaleString() + ' 원';
    });
}

// 충전 기능 구현
document.getElementById('submitDepositBtn').addEventListener('click', function() {
    var input = document.getElementById('depositAmount');
    var memoInput = document.getElementById('depositMemo');
    var amountError = document.getElementById('depositError');
    var valid = true;

    if (!input.value || !/^\d+$/.test(input.value)) {
        input.classList.add('error');
        amountError.textContent = '숫자만 입력해주세요.';
        amountError.classList.add('active');
        valid = false;
    } else {
        input.classList.remove('error');
        amountError.classList.remove('active');
    }

    if (valid) {
        fetch(contextPath + '/api/vroompay/charge', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                amount: parseInt(input.value),
                memo: memoInput.value
            })
        })
            .then(res => res.json())
            .then(data => {
                alert(data.message);
                if (data.success) {
                    if(data.balance !== undefined) currentBalance = data.balance;
                    if(data.availBalance !== undefined) availBalance = data.availBalance;
                    updateBalanceDisplay();

                    var m = document.getElementById('depositModal');
                    m.classList.remove('active');

                    input.value = '';
                    memoInput.value = '';

                    loadTransactions(1);
                }
            })
            .catch(err => {
                console.error(err);
                alert("충전 중 오류가 발생했습니다.");
            });
    }
});

//  출금 기능 구현
document.getElementById('submitWithdrawBtn').addEventListener('click', function() {
    var input = document.getElementById('withdrawAmount');
    var memoInput = document.getElementById('withdrawMemo');
    var error = document.getElementById('withdrawError');

    // 초기화
    input.classList.remove('error');
    error.classList.remove('active');

    if (!input.value || !/^\d+$/.test(input.value)) {
        input.classList.add('error');
        error.textContent = '숫자만 입력해주세요.';
        error.classList.add('active');
        return;
    }

    var withdrawAmount = parseInt(input.value);

    // 잔액 검증
    if (withdrawAmount > currentBalance) {
        input.classList.add('error');
        error.textContent = '출금 금액이 잔액보다 큽니다. (현재 잔액: ' + Number(currentBalance).toLocaleString() + '원)';
        error.classList.add('active');
        return;
    }

    // 0원 이하 검증
    if (withdrawAmount <= 0) {
        input.classList.add('error');
        error.textContent = '출금 금액은 0원보다 커야 합니다.';
        error.classList.add('active');
        return;
    }

    fetch(contextPath + '/api/vroompay/withdraw', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            amount: parseInt(input.value),
            memo: memoInput.value // 메모 값 전송
        })
    })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert(data.message);
                if(data.balance !== undefined) currentBalance = data.balance;
                if(data.availBalance !== undefined) availBalance = data.availBalance;
                updateBalanceDisplay();

                var m = document.getElementById('withdrawModal');
                m.classList.remove('active');

                input.value = '';
                memoInput.value = '';

                loadTransactions(1);
            } else {
                input.classList.add('error');
                error.textContent = data.message;
                error.classList.add('active');
            }
        })
        .catch(err => {
            console.error(err);
            alert("출금 중 오류가 발생했습니다.");
        });
});

// 모달 초기화
function initModals() {
    function openModal(id) {
        document.getElementById(id).classList.add('active');
        updateBalanceDisplay();
    }

    function closeModal(id) {
        var m = document.getElementById(id);
        m.classList.remove('active');
        var inputs = m.querySelectorAll('.form-input');
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].value = '';
            inputs[i].classList.remove('error');
        }
        var errors = m.querySelectorAll('.form-error');
        for (var j = 0; j < errors.length; j++) {
            errors[j].classList.remove('active');
        }
    }

    document.getElementById('depositBtn').addEventListener('click', function() { openModal('depositModal'); });
    document.getElementById('closeDepositModal').addEventListener('click', function() { closeModal('depositModal'); });
    document.getElementById('cancelDepositBtn').addEventListener('click', function() { closeModal('depositModal'); });
    document.getElementById('withdrawBtn').addEventListener('click', function() { openModal('withdrawModal'); });
    document.getElementById('closeWithdrawModal').addEventListener('click', function() { closeModal('withdrawModal'); });
    document.getElementById('cancelWithdrawBtn').addEventListener('click', function() { closeModal('withdrawModal'); });

    document.getElementById('depositModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal('depositModal');
    });
    document.getElementById('withdrawModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal('withdrawModal');
    });
}