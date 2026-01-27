let targetUserId = null;       // 정지 대상 ID
let targetElement = null;      // UI 업데이트할 배지 요소

// Status Dropdown Toggle
function toggleStatusDropdown(button) {
    const dropdown = button.nextElementSibling;
    const allDropdowns = document.querySelectorAll('.status-dropdown-menu');

    // Close all other dropdowns
    allDropdowns.forEach(d => {
        if (d !== dropdown) {
            d.classList.remove('show');
        }
    });

    dropdown.classList.toggle('show');
    event.stopPropagation();
}

// 외부 창 클릭 시 드롭다운 접기
document.addEventListener('click', function () {
    const allDropdowns = document.querySelectorAll('.status-dropdown-menu');
    allDropdowns.forEach(d => d.classList.remove('show'));
});

// 상태 변경 함수
function changeStatus(element, newStatus, extraData, userId) {
    // 1. 상태 배지 UI 업데이트
    const dropdown = element.closest('.status-dropdown');
    const statusBadge = dropdown.querySelector('.status-badge');

    statusBadge.className = 'status-badge ' + newStatus;

    // 텍스트 변경 로직
    if (newStatus === 'ACTIVE') statusBadge.textContent = '정상';
    else if (newStatus === 'BANNED') statusBadge.textContent = '정지';
    else if (newStatus === 'SUSPENDED') statusBadge.textContent = '일시정지';

    // 드롭다운 메뉴 닫기
    const menu = dropdown.querySelector('.status-dropdown-menu');
    if (menu) {
        menu.classList.remove('show');
    }

    // API 호출 데이터 구성
    const payload = {
        userId: userId,
        status: newStatus,
        extraData: extraData
    };

    // API 전송
    fetch('${pageContext.request.contextPath}/api/admin/users/status', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
        .then(response => response.json())
        .then(data => {
            if (data.result === 'success') {
                alert('상태가 변경되었습니다.');
                window.location.reload(); // 새로고침
            } else {
                alert('상태 변경 실패');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('서버 통신 중 오류가 발생했습니다.');
        });
}


// 일시정지 모달 열기
function showSuspensionModal(element, status, userId) {
    targetElement = element.closest('.status-dropdown').querySelector('.status-dropdown-toggle');
    targetUserId = userId;

    const modal = document.getElementById('suspensionModal');
    modal.classList.add('show');

    element.closest('.status-dropdown-menu').classList.remove('show');

    document.getElementById('suspensionDays').value = 7;
    document.getElementById('suspensionReason').value = '';
}

// 일시정지 적용
function applySuspension() {
    const days = document.getElementById('suspensionDays').value;
    const reason = document.getElementById('suspensionReason').value;

    if (!days || days < 1) {
        alert('정지 기간을 입력해주세요.');
        return;
    }

    console.log(targetElement, { days: days, reason: reason }, targetUserId);
    changeStatus(targetElement, 'SUSPENDED', { days: days, reason: reason }, targetUserId);

    closeSuspensionModal();
}

// 일시정지 모달 close
function closeSuspensionModal() {
    const modal = document.getElementById('suspensionModal');
    modal.classList.remove('show');
    targetElement = null;
}

// 상세 페이지 이동
function goToDetail(userId) {
    const contextPath = '${pageContext.request.contextPath}';
    const url = contextPath + '/admin/users/detail?id=' + userId;
    window.location.href = url;
}

// 페이지 로드 시 초기 목록 조회
document.addEventListener('DOMContentLoaded', function () {
    loadUserList(1);
});

// 검색 버튼 클릭
function searchUsers() {
    loadUserList(1);
}

// 엔터키 입력 시 검색
document.getElementById('searchInput').addEventListener('keyup', function (e) {
    if (e.key === 'Enter') searchUsers();
});

// 필터 변경 시 자동 검색
document.getElementById('filterStatus').addEventListener('change', () => loadUserList(1));
document.getElementById('filterRole').addEventListener('change', () => loadUserList(1));
document.getElementById('filterReports').addEventListener('change', () => loadUserList(1));

// 실제 데이터를 가져와 렌더링하는 함수
function loadUserList(page) {
    const contextPath = '${pageContext.request.contextPath}';
    const keyword = document.getElementById('searchInput').value;
    const status = document.getElementById('filterStatus').value;
    const role = document.getElementById('filterRole').value;
    const reportFilter = document.getElementById('filterReports').value;

    // 쿼리 스트링 생성
    const params = new URLSearchParams({
        page: page,
        keyword: keyword,
        status: status,
        role: role,
        reportCount: reportFilter
    });

    fetch(contextPath + `/api/admin/users?` + params)
        .then(response => response.json())
        .then(data => {
            console.log(data);
            renderTable(data.userList);
            renderPagination(data.pageInfo);

            // 총 인원 수 업데이트
            document.querySelector('.table-count strong').innerText = data.totalCount;
        })
        .catch(error => {
            console.error('데이터 로드 실패:', error);
            alert('데이터를 불러오는 중 오류가 발생했습니다.');
        });
}

// 사용자 테이블 렌더링
function renderTable(users) {
    const tbody = document.getElementById('userTableBody');
    tbody.innerHTML = '';

    if (!users || users.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" style="text-align:center; padding: 2rem;">검색 결과가 없습니다.</td></tr>';
        return;
    }

    users.forEach(user => {
        const roleBadgeClass = user.role === 'ERRANDER' ? 'role-badge errander' : 'role-badge';

        let statusClass = 'ACTIVE';
        let statusText = '정상';
        if (user.status === 'BANNED') {
            statusClass = 'BANNED';
            statusText = '정지';
        } else if (user.status === 'SUSPENDED') {
            statusClass = 'SUSPENDED';
            statusText = '일시정지';
        }

        const lastLogin = user.last_login_at ? new Date(user.last_login_at).toLocaleString('ko-KR', {
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        }) : '-';

        const suspensionEnd = user.suspension_end_at ? new Date(user.suspension_end_at).toLocaleString('ko-KR', {
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        }) : '-';

        const row = `
            <tr>
                <td>${user.user_id}</td>
                <td>${user.email}</td>
                <td>${user.nickname}</td>
                <td><span class="${roleBadgeClass}">${user.role}</span></td>
                <td>
                    <div class="status-dropdown">
                        <button class="status-dropdown-toggle" onclick="toggleStatusDropdown(this)">
                            <span class="status-badge ${statusClass}">${statusText}</span>
                            <span>▼</span>
                        </button>
                        <div class="status-dropdown-menu">
                            <div class="status-dropdown-item" onclick="changeStatus(this, 'ACTIVE', null, ${user.user_id})">정상</div>
                            <div class="status-dropdown-item" onclick="showSuspensionModal(this, 'SUSPENDED', ${user.user_id})">일시정지</div>
                            <div class="status-dropdown-item" onclick="changeStatus(this, 'BANNED', null, ${user.user_id})">정지</div>
                        </div>
                    </div>
                </td>
                <td>${user.report_count || 0}</td>
                <td>${suspensionEnd}</td>
                <td>${lastLogin}</td>
                <td><button class="action-button" onclick="goToDetail(${user.user_id})">상세</button></td>
            </tr>
        `;
        tbody.innerHTML += row;
    });
}

// 페이지네이션 렌더링
function renderPagination(pageInfo) {
    const pagination = document.querySelector('.pagination');
    pagination.innerHTML = '';

    const {currentPage, startPage, endPage, totalPage} = pageInfo;

    const prevBtn = document.createElement('button');
    prevBtn.className = 'pagination-button';
    prevBtn.innerText = '이전';

    if (currentPage > 1) {
        prevBtn.onclick = () => loadUserList(currentPage - 1);
    } else {
        prevBtn.disabled = true;
        prevBtn.classList.add('disabled');
    }
    pagination.appendChild(prevBtn);

    for (let i = startPage; i <= endPage; i++) {
        const btn = document.createElement('button');
        btn.className = 'pagination-button';
        btn.innerText = i;

        if (i === currentPage) {
            btn.classList.add('active');
        } else {
            btn.onclick = () => loadUserList(i);
        }

        pagination.appendChild(btn);
    }

    const nextBtn = document.createElement('button');
    nextBtn.className = 'pagination-button';
    nextBtn.innerText = '다음';

    if (currentPage < totalPage) {
        nextBtn.onclick = () => loadUserList(currentPage + 1);
    } else {
        nextBtn.disabled = true;
        nextBtn.classList.add('disabled');
    }

    pagination.appendChild(nextBtn);
}
