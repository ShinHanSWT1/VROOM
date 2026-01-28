let currentBalance = 0;
let availBalance = 0;
const itemsPerPage = 10;

document.addEventListener('DOMContentLoaded', function() {
  checkAccountStatus();
  initModals();
});

// 계좌 상태 확인 및 UI 초기화 로직
function checkAccountStatus() {
  const statusContainer = document.getElementById('account-status-container');
  const depositBtn = document.getElementById('depositBtn');
  const withdrawBtn = document.getElementById('withdrawBtn');
  const balanceDisplay = document.getElementById('balanceDisplay');

  fetch(contextPath + '/api/vroompay/status')
          .then(res => res.json())
          .then(data => {
            if (data.success && data.linked) {
              // 계좌 연결됨
              const account = data.account;
              statusContainer.innerHTML = `<span>연결된 계좌: <strong>${account.realAccount}</strong></span>`;
              statusContainer.className = 'account-status-container linked';

              // 버튼 활성화 및 잔액 표시
              depositBtn.disabled = false;
              withdrawBtn.disabled = false;
              balanceDisplay.textContent = Number(account.balance).toLocaleString() + ' 원';
              
              currentBalance = account.balance;
              availBalance = account.availBalance;
              
              loadTransactions(1);

            } else {
              // 계좌 연결 안됨 또는 오류
              statusContainer.innerHTML = `<span>부름페이 계좌가 연결되지 않았습니다.</span><button id="linkAccountBtn">계좌 연결</button>`;
              statusContainer.className = 'account-status-container not-linked';
              
              // 계좌 연결 버튼에 이벤트 리스너 추가
              document.getElementById('linkAccountBtn').addEventListener('click', linkAccount);

              // 버튼 비활성화 및 잔액 초기화
              depositBtn.disabled = true;
              withdrawBtn.disabled = true;
              balanceDisplay.textContent = '-- 원';

              const list = document.getElementById('transactionList');
              list.innerHTML = '<div class="history-item"><div class="item-title" style="grid-column:1/-1;text-align:center;">부름페이 계좌를 연결하여 거래를 시작하세요.</div></div>';
              document.querySelector('.history-count').textContent = '(0)';
              document.getElementById('pagination').innerHTML = '';

              // [수정] 알림 제거
              // if (!data.success) {
              //     alert(data.message || '계좌 정보를 불러오는 데 실패했습니다.');
              // }
            }
          })
          .catch(err => {
              console.error('Error fetching account status:', err);
              statusContainer.innerHTML = '계좌 정보 조회 중 오류가 발생했습니다. 새로고침 해주세요.';
              statusContainer.className = 'account-status-container not-linked';
          });
}

// [수정] 계좌 연결 함수
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


// 거래 내역 조회 (API 경로 수정)
function loadTransactions(page) {
  // TODO: VroomPayService에 getTransactionHistory 구현 후, 아래 API 호출 필요
  // fetch(contextPath + '/api/vroompay/transactions?page=' + page + '&size=' + itemsPerPage)
  //         .then(res => res.json())
  //         .then(data => {
  //           if (data.success) {
  //             currentBalance = data.balance;
  //             availBalance = data.availBalance;
  //             updateBalanceDisplay();
  //             renderTransactions(data.transactions);
  //             renderPagination(data.totalPages, data.currentPage);
  //             document.querySelector('.history-count').textContent = '(' + data.totalCount + ')';
  //           }
  //         });
  // 임시로 거래내역 없음을 표시
  renderTransactions([]);
  renderPagination(0, 1);
  document.querySelector('.history-count').textContent = '(0)';
}

function renderTransactions(transactions) {
  var list = document.getElementById('transactionList');
  list.innerHTML = '';

  if (!transactions || transactions.length === 0) {
    list.innerHTML = '<div class="history-item"><div class="item-title" style="grid-column:1/-1;text-align:center;">거래 내역이 없습니다.</div></div>';
    return;
  }

  var typeLabels = {
    'CHARGE': '충전', 'WITHDRAW': '출금', 'HOLD': '보류',
    'RELEASE': '해제', 'PAYOUT': '지급', 'REFUND': '환불'
  };

  transactions.forEach(function(item) {
    var el = document.createElement('div');
    el.className = 'history-item';

    var isPlus = ['CHARGE', 'RELEASE', 'REFUND'].indexOf(item.txnType) !== -1;
    var color = isPlus ? 'color:#27ae60;' : 'color:#e74c3c;';
    var prefix = isPlus ? '+' : '-';
    var label = item.memo || typeLabels[item.txnType] || item.txnType;

    el.innerHTML =
            '<div class="item-title">' + label + '</div>' +
            '<div class="item-author">' + formatDate(item.createdAt) + '</div>' +
            '<div class="item-amount" style="' + color + '">' + prefix + Number(item.amount).toLocaleString() +
            '원</div>';
    list.appendChild(el);
  });
}

function formatDate(dateStr) {
  if (!dateStr) return '';
  var d = new Date(dateStr);
  return (d.getMonth()+1) + '/' + d.getDate() + ' ' + d.getHours() + ':' +
          String(d.getMinutes()).padStart(2,'0');
}

function renderPagination(totalPages, currentPage) {
  var container = document.getElementById('pagination');
  container.innerHTML = '';
  for (var i = 1; i <= totalPages; i++) {
    var btn = document.createElement('div');
    btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
    btn.textContent = i;
    (function(pageNum) {
      btn.onclick = function() { loadTransactions(pageNum); };
    })(i);
    container.appendChild(btn);
  }
}

function updateBalanceDisplay() {
  var ids = ['balanceDisplay', 'depositModalBalance', 'withdrawModalBalance'];
  ids.forEach(function(id) {
    var el = document.getElementById(id);
    if (el) el.textContent = Number(currentBalance).toLocaleString() + ' 원';
  });
}

// [수정] 충전 기능 구현
document.getElementById('submitDepositBtn').addEventListener('click', function() {
  var bankSelect = document.getElementById('depositBank');
  var input = document.getElementById('depositAmount');
  var bankError = document.getElementById('depositBankError');
  var amountError = document.getElementById('depositError');
  var valid = true;

  if (!bankSelect.value) {
    bankSelect.classList.add('error');
    bankError.classList.add('active');
    valid = false;
  } else {
    bankSelect.classList.remove('error');
    bankError.classList.remove('active');
  }

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
        bankName: bankSelect.value
      })
    })
    .then(res => res.json())
    .then(data => {
        alert(data.message);
        if (data.success) {
          // 성공 시 잔액 갱신 및 모달 닫기
          if(data.balance) currentBalance = data.balance;
          if(data.availBalance) availBalance = data.availBalance;
          updateBalanceDisplay();
          
          // 모달 닫기 (함수 재사용)
          var m = document.getElementById('depositModal');
          m.classList.remove('active');
          
          loadTransactions(1);
        }
    })
    .catch(err => {
        console.error(err);
        alert("충전 중 오류가 발생했습니다.");
    });
  }
});

// [수정] 출금 기능 구현
document.getElementById('submitWithdrawBtn').addEventListener('click', function() {
  var input = document.getElementById('withdrawAmount');
  var error = document.getElementById('withdrawError');

  if (!input.value || !/^\d+$/.test(input.value)) {
    input.classList.add('error');
    error.textContent = '숫자만 입력해주세요.';
    error.classList.add('active');
    return;
  }

  fetch(contextPath + '/api/vroompay/withdraw', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({ amount: parseInt(input.value) })
  })
  .then(res => res.json())
  .then(data => {
      if (data.success) {
        alert(data.message);
        if(data.balance) currentBalance = data.balance;
        if(data.availBalance) availBalance = data.availBalance;
        updateBalanceDisplay();
        
        var m = document.getElementById('withdrawModal');
        m.classList.remove('active');
        
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
