// 전역 변수
let currentErranderId = null; // 승인/반려 모달용 ID 저장

document.addEventListener('DOMContentLoaded', function () {
    // 초기 데이터 로드
    loadErranderList(1);

    // 이벤트 리스너
    // 검색 (엔터키 & 버튼)
    document.querySelector('.search-button').addEventListener('click', () => loadErranderList(1));
    document.getElementById('searchInput').addEventListener('keyup', function (e) {
        if (e.key === 'Enter') loadErranderList(1);
    });

    // 필터 변경 시 자동 검색
    document.getElementById('filterApprovalStatus').addEventListener('change', () => loadErranderList(1));
    document.getElementById('filterActivityStatus').addEventListener('change', () => loadErranderList(1));
    document.getElementById('filterRating').addEventListener('change', () => loadErranderList(1));
});

//  부름이 목록 조회
function loadErranderList(page) {
    const contextPath = '${pageContext.request.contextPath}';
    const keyword = document.getElementById('searchInput').value;
    const approveStatus = document.getElementById('filterApprovalStatus').value;
    const activeStatus = document.getElementById('filterActivityStatus').value;
    const reviewScope = document.getElementById('filterRating').value;

    // Query String 생성
    const params = new URLSearchParams({
        page: page,
        keyword: keyword,
        approveStatus: approveStatus,
        activeStatus: activeStatus,
        reviewScope: reviewScope
    });

    fetch(contextPath + `/api/admin/erranders?` + params)
        .then(response => response.json())
        .then(data => {
            // data = { userList: [...], totalCount: 123, pageInfo: {...} }
            renderTable(data.userList);       // 테이블 그리기
            renderPagination(data.pageInfo);  // 페이지네이션 그리기

            // 총 개수 업데이트
            document.getElementById('totalCount').innerText = data.totalCount;
        })
        .catch(error => {
            console.error('데이터 로드 실패:', error);
            // alert('데이터를 불러오는 중 오류가 발생했습니다.');
        });
}

// 테이블 HTML 렌더링
function renderTable(list) {
    const tbody = document.getElementById('helperTableBody');
    tbody.innerHTML = ''; // 초기화

    if (!list || list.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; padding: 2rem;">검색 결과가 없습니다.</td></tr>';
        return;
    }

    list.forEach(item => {
        const erranderId = item.errander_id;
        const nickname = item.nickname;
        const approvalStatus = item.approval_status;
        const activeStatus = item.active_status;
        const completeRate = item.complete_rate || 0;
        const ratingAvg = item.rating_avg || 0;

        // 날짜 포맷팅 (Timestamp -> YYYY-MM-DD)
        let lastActive = '-';
        if (item.last_active_at) {
            const date = new Date(item.last_active_at);
            lastActive = date.toISOString().split('T')[0];
        }

        let approvedAt = '-';
        if (item.approved_at) {
            const date = new Date(item.approved_at);
            approvedAt = date.toISOString().split('T')[0];
        }

        // 배지 텍스트 및 클래스 설정
        let approvalText = approvalStatus === 'APPROVED' ? '승인' : (approvalStatus === 'PENDING' ? '승인대기' : '반려');
        let activityText = '-';
        if (activeStatus === 'ACTIVE') activityText = '활성';
        else if (activeStatus === 'INACTIVE') activityText = '비활성';
        else if (activeStatus === 'SUSPENDED') activityText = '일시정지';
        else if (activeStatus === 'BANNED') activityText = '정지';

        // 별점 표시
        const stars = '⭐'.repeat(Math.floor(ratingAvg));
        const ratingDisplay = ratingAvg > 0 ?
            `<div class="rating-display"><span class="rating-stars">${stars}</span> <span class="rating-value">${ratingAvg}</span></div>` : '-';

        // 활동 상태 드롭다운 HTML 생성
        const activityStatusHtml = `
            <div class="status-dropdown">
                <button class="status-dropdown-toggle" onclick="toggleActivityStatusDropdown(this, event)">
                    <span class="status-badge ${activeStatus}">${activityText}</span>
                    <span>▼</span>
                </button>
                <div class="status-dropdown-menu">
                    <div class="status-dropdown-item" onclick="changeActivityStatus(this, 'ACTIVE', ${erranderId}, event)">활성</div>
                    <div class="status-dropdown-item" onclick="changeActivityStatus(this, 'INACTIVE', ${erranderId}, event)">비활성</div>
                    <div class="status-dropdown-item" onclick="changeActivityStatus(this, 'SUSPENDED', ${erranderId}, event)">일시정지</div>
                    <div class="status-dropdown-item" onclick="changeActivityStatus(this, 'BANNED', ${erranderId}, event)">정지</div>
                </div>
            </div>
        `;

        // 액션 버튼 (승인 대기중이면 승인버튼, 아니면 관리버튼)
        let actionBtnHtml = '';
        if (approvalStatus === 'APPROVED') {
            actionBtnHtml = `<button class="action-button" onclick="goToDetail(${erranderId})">관리</button>`;
        } else {
            actionBtnHtml = `<button class="action-button approve" onclick="openApprovalModal(${erranderId})">승인</button>`;
        }

        const row = `
            <tr>
                <td>${erranderId} / ${nickname}</td>
                <td><span class="status-badge ${approvalStatus}">${approvalText}</span></td>
                <td>${activityStatusHtml}</td>
                <td>${completeRate}%</td>
                <td>${ratingDisplay}</td>
                <td>${approvedAt}</td>
                <td>${lastActive}</td>
                <td>${actionBtnHtml}</td>
            </tr>
        `;
        tbody.innerHTML += row;
    });
}

//  페이지네이션 렌더링
function renderPagination(pageInfo) {
    const pagination = document.getElementById('pagination');
    pagination.innerHTML = '';

    if (!pageInfo) return;

    const { currentPage, startPage, endPage, totalPage } = pageInfo;

    // 이전 버튼
    const prevBtn = document.createElement('button');
    prevBtn.className = 'pagination-button';
    prevBtn.innerText = '이전';
    if (currentPage > 1) {
        prevBtn.onclick = () => loadErranderList(currentPage - 1);
    } else {
        prevBtn.disabled = true;
        prevBtn.classList.add('disabled');
    }
    pagination.appendChild(prevBtn);

    // 번호 버튼
    for (let i = startPage; i <= endPage; i++) {
        const btn = document.createElement('button');
        btn.className = 'pagination-button';
        btn.innerText = i;
        if (i === currentPage) {
            btn.classList.add('active');
        } else {
            btn.onclick = () => loadErranderList(i);
        }
        pagination.appendChild(btn);
    }

    // 다음 버튼
    const nextBtn = document.createElement('button');
    nextBtn.className = 'pagination-button';
    nextBtn.innerText = '다음';
    if (currentPage < totalPage) {
        nextBtn.onclick = () => loadErranderList(currentPage + 1);
    } else {
        nextBtn.disabled = true;
        nextBtn.classList.add('disabled');
    }
    pagination.appendChild(nextBtn);
}

//  기타 기능 (모달, 이동 등)

// 상세 페이지 이동
function goToDetail(erranderId) {
    const contextPath = '${pageContext.request.contextPath}';
    window.location.href = contextPath + '/admin/erranders/detail/' + erranderId;
}

// 승인 모달 열기
function openApprovalModal(erranderId) {
    currentErranderId = erranderId;
    const contextPath = '${pageContext.request.contextPath}';

    fetch(contextPath + '/api/admin/erranders/resume?id=' + erranderId)
        .then(res => {
            if (!res.ok) {
                throw new Error('서버 응답 에러: ' + res.status);
            }
            return res.json();
        })
        .then(data => {
            document.getElementById('modalUserId').textContent = data.user_id + ' / ' + erranderId;
            document.getElementById('modalNickname').textContent = data.nickname;
            document.getElementById('modalContactPhone').textContent = data.phone || '-';
            document.getElementById('modalContactEmail').textContent = data.email || '-';
            document.getElementById('modalActivityStatus').textContent = data.status || '-';
            document.getElementById('modalLastActivity').textContent = data.last_login_at || '-';
            document.getElementById('modalRegions1').textContent = data.address1 || '-';
            document.getElementById('modalRegions2').textContent = data.address2 || '-';

            const documentList = document.getElementById('documentList');
            documentList.innerHTML = '';
            data.documents.forEach(doc => {
                const docIcon = doc.doc_type.includes('IDCARD') ? '💳' : '📄';
                const docItem = `
                    <div class="document-item">
                        <div class="document-icon">${docIcon}</div>
                        <div class="document-info">
                            <div class="document-type">${doc.doc_type === 'IDCARD' ? '신분증' : '여권'}</div>
                        </div>
                        <button class="document-view-btn" onclick="viewDocument('${doc.file_url}')">보기</button>
                    </div>
                `;
                documentList.innerHTML += docItem;
            });
        })
        .catch(error => {
            console.error('데이터 로드 실패:', error);
        });

    document.getElementById('approvalModal').dataset.helperId = erranderId;
    document.getElementById('approvalModal').classList.add('show');
}

function closeApprovalModal() {
    document.getElementById('approvalModal').classList.remove('show');
}

// 모달 외부 클릭 닫기
document.getElementById('approvalModal').addEventListener('click', function (e) {
    if (e.target === this) closeApprovalModal();
});

// 승인 처리
function approveErrander() {
    if (!confirm(' 부름이 ID: ' + currentErranderId + '을 승인하시겠습니까?')) return;
    const contextPath = '${pageContext.request.contextPath}';

    fetch(contextPath + '/api/admin/erranders/approve', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            erranderId: currentErranderId,
            status: "APPROVED",
            reason: ""
        })
    })
        .then(res => res.json())
        .then(data => {
            if (data.result === 'success') {
                alert('승인되었습니다.');
                window.location.reload();
            } else {
                alert('승인 처리 실패했습니다: ' + data.message);
            }
        });

    closeApprovalModal();
}

// 반려 처리
function rejectHelper() {
    const helperId = document.getElementById('approvalModal').dataset.helperId;
    const reason = prompt('반려 사유를 입력하세요:');
    if (!reason) return;
    const contextPath = '${pageContext.request.contextPath}';

    fetch(contextPath + '/api/admin/erranders/approve', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            erranderId: currentErranderId,
            status: "REJECTED",
            reason: reason
        })
    })
        .then(res => res.json())
        .then(data => {
            if (data.result === 'success') {
                alert('반려되었습니다.');
                window.location.reload();
            } else {
                alert('처리 실패했습니다: ' + data.message);
            }
        });

    closeApprovalModal();
}

function viewDocument(url) {
    if (!url) {
        alert('파일 경로가 존재하지 않습니다.');
        return;
    }
    const contextPath = '${pageContext.request.contextPath}';
    url = contextPath + '/' + url;
    window.open(url, '_blank');
}

// 활동 상태 드롭다운 토글
function toggleActivityStatusDropdown(button, event) {
    event.stopPropagation();
    const dropdown = button.nextElementSibling;

    document.querySelectorAll('.status-dropdown-menu.show').forEach(menu => {
        if (menu !== dropdown) {
            menu.classList.remove('show');
        }
    });

    dropdown.classList.toggle('show');
}

// 활동 상태 변경
function changeActivityStatus(item, newStatus, erranderId, event) {
    event.stopPropagation();
    const contextPath = '${pageContext.request.contextPath}';

    let statusText = '';
    switch(newStatus) {
        case 'ACTIVE': statusText = '활성'; break;
        case 'INACTIVE': statusText = '비활성'; break;
        case 'SUSPENDED': statusText = '일시정지'; break;
        case 'BANNED': statusText = '정지'; break;
        default: statusText = newStatus;
    }

    fetch(contextPath + '/api/admin/erranders/status', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            erranderId: erranderId,
            activeStatus: newStatus
        })
    })
        .then(res => res.json())
        .then(data => {
            if (data.result === 'success') {
                alert('활동 상태가 변경되었습니다.');
                window.location.reload();
            } else {
                alert('상태 변경에 실패했습니다.');
            }
        })
        .catch(error => {
            console.error('상태 변경 실패:', error);
            alert(error);
            loadErranderList(1);
        });

    item.closest('.status-dropdown-menu').classList.remove('show');
}

// 전역 클릭 이벤트로 드롭다운 닫기
document.addEventListener('click', function() {
    document.querySelectorAll('.status-dropdown-menu.show').forEach(menu => {
        menu.classList.remove('show');
    });
});
