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
              
              // 거래 내역 조회 (나중에 구현)
              // loadTransactions(1);

            } else {
              // 계좌 연결 안됨
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


// 거래 내역 조회 (나중에 구현)
function loadTransactions(page) {
}

function renderTransactions(transactions) {
}

function formatDate(dateStr) {
}

function renderPagination(totalPages, currentPage) {
}

function updateBalanceDisplay() {
  var ids = ['balanceDisplay', 'depositModalBalance', 'withdrawModalBalance'];
  ids.forEach(function(id) {
    var el = document.getElementById(id);
    if (el) el.textContent = Number(currentBalance).toLocaleString() + ' 원';
  });
}

// 충전 버튼 (나중에 구현)
document.getElementById('submitDepositBtn').addEventListener('click', function() {
  alert("충전 기능은 준비 중입니다.");
});

// 출금 버튼 (나중에 구현)
document.getElementById('submitWithdrawBtn').addEventListener('click', function() {
  alert("출금 기능은 준비 중입니다.");
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
