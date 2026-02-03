// contextPath 가져오기 (meta 태그에서)
const contextPath = document.querySelector('meta[name="context-path"]').content;

// HTML data attribute에서 심부름 데이터 읽기
const myActivities = [];
document.querySelectorAll('#errandDataContainer .errand-data').forEach(function (el) {
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

// timrAgo 함수를 추가
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

// Function to render activities with pagination
function renderActivities(filterType, page = 1) {
    currentFilter = filterType;
    currentPage = page;
    const gridContainer = document.getElementById('activityGrid');
    gridContainer.innerHTML = ''; // Clear existing

    let filteredData;
    if (filterType === 'all') {
        filteredData = myActivities;
    } else if (filterType === 'waiting') {
        filteredData = myActivities.filter(task => task.status === 'WAITING');
    } else if (filterType === 'reserved') {
        filteredData = myActivities.filter(task =>
            task.status === 'MATCHED' || task.status === 'CONFIRMED1' || task.status === 'CONFIRMED2');
    } else if (filterType === 'completed') {
        // 완료 탭: COMPLETED와 HOLD 모두 포함
        filteredData = myActivities.filter(task => task.status === 'COMPLETED' || task.status === 'HOLD');
    } else {
        filteredData = myActivities.filter(task => task.status === filterType);
    }

    if (filteredData.length === 0) {
        gridContainer.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 3rem; color: var(--color-gray);">해당하는 내역이 없습니다.</div>';
        renderPagination(0, page);
        return;
    }

// --- 여기부터 붙여넣으세요 ---

    // 1. 페이지네이션 계산
    const totalPages = Math.ceil(filteredData.length / itemsPerPage);
    const startIndex = (page - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const paginatedData = filteredData.slice(startIndex, endIndex);

    // 2. 리스트 그리기
    paginatedData.forEach((task, index) => {
        const taskCard = document.createElement('div');
        taskCard.className = 'task-card';

        taskCard.addEventListener('click', function () {
            window.location.href = '' + contextPath + '/errand/detail?errandsId=' + task.errandsId;
        });

        // 상태 배지 로직
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

        // 신고하기 버튼 (보류 상태일 때만)
        const reportButton = task.status === 'HOLD'
            ? '<button class="report-btn" data-task-index="' + (startIndex + index) + '" style="margin-left:8px; padding:2px 8px; font-size:0.7rem; vertical-align:middle;">신고하기</button>'
            : '';

        // 주소 처리 (없으면 공백)
        const locationText = task.location || '';

        // 시간 변환
        const displayTime = timeAgo(task.createdAt);

        // [수정됨] ★ 설명 글자수 20자로 자르기 로직 추가 ★
        let shortDescription = task.description || ''; // 내용이 없으면 빈 문자열
        if (shortDescription.length > 20) {
            shortDescription = shortDescription.substring(0, 20) + '...';
        }

        taskCard.innerHTML = '<div class="task-image">' + task.icon + statusLabel + '</div>' +
            '<div class="task-card-content">' +
            '<div class="task-card-header">' +
            '<span class="task-badge">' + task.badge + '</span>' +
            '<span class="task-time" style="display:flex; align-items:center;">' + displayTime + reportButton + '</span>' +
            '</div>' +
            '<h3 class="task-card-title">' + task.title + '</h3>' +
            '<div class="task-author-info">' +
            '<div class="author-avatar" style="font-size:0.7rem; width:20px; height:20px; margin-right:5px;">👤</div>' +
            // [수정됨] 자른 설명(shortDescription)을 넣었습니다.
            '<span class="author-name">' + shortDescription + '</span>' +
            '</div>' +
            '<div class="task-meta">' +
            '<span class="task-location">' + locationText + '</span>' +
            '<span class="task-price">' + task.price + '</span>' +
            '</div>' +
            '</div>';
        gridContainer.appendChild(taskCard);
    });

    // 신고하기 버튼 이벤트 연결
    document.querySelectorAll('.report-btn').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.stopPropagation();
            const taskIndex = parseInt(btn.dataset.taskIndex);
            currentReportTask = myActivities[taskIndex];
            openReportModal();
        });
    });

    // 페이지네이션 그리기
    renderPagination(totalPages, page);
}

// Function to render pagination
function renderPagination(totalPages, currentPage) {
    const paginationContainer = document.getElementById('paginationContainer');
    paginationContainer.innerHTML = '';

    if (totalPages <= 1) {
        return; // Don't show pagination if only one page
    }

    // Previous button
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

    // Page numbers
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

    // Next button
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

// Initialize with all data
renderActivities('all', 1);

// Tab Click Listeners
const tabs = document.querySelectorAll('.tab-btn');
tabs.forEach(tab => {
    tab.addEventListener('click', function () {
        // Remove active class from all
        tabs.forEach(t => t.classList.remove('active'));
        // Add active class to clicked
        this.classList.add('active');

        // Determine filter type based on text content
        const tabText = this.textContent.trim();
        let filterType = 'all';
        if (tabText === '부름') filterType = 'waiting';
        else if (tabText === '예약') filterType = 'reserved';
        else if (tabText === '완료') filterType = 'completed';

        renderActivities(filterType, 1);
    });
});

// Report Modal Logic
const reportModal = document.getElementById('reportModal');
const reportModalClose = document.getElementById('reportModalClose');
const reportCancel = document.getElementById('reportCancel');
const reportSubmit = document.getElementById('reportSubmit');
const reportReason = document.getElementById('reportReason');
const reportCharCount = document.getElementById('reportCharCount');

function openReportModal() {
    reportModal.classList.add('active');
    reportReason.value = '';
    reportCharCount.textContent = '0';
}

function closeReportModal() {
    reportModal.classList.remove('active');
    reportReason.value = '';
    currentReportTask = null;
}

reportModalClose.addEventListener('click', closeReportModal);
reportCancel.addEventListener('click', closeReportModal);

reportModal.addEventListener('click', (e) => {
    if (e.target === reportModal) {
        closeReportModal();
    }
});

// Character count for report
reportReason.addEventListener('input', () => {
    const length = reportReason.value.length;
    reportCharCount.textContent = length;

    if (length > 500) {
        reportReason.value = reportReason.value.substring(0, 500);
        reportCharCount.textContent = '500';
    }
});

// Submit report
reportSubmit.addEventListener('click', () => {
    const reason = reportReason.value.trim();

    if (!reason) {
        alert('신고 사유를 입력해주세요.');
        reportReason.focus();
        return;
    }

    if (reason.length < 10) {
        alert('신고 사유를 10자 이상 입력해주세요.');
        reportReason.focus();
        return;
    }

    // 백엔드 API 호출
    fetch('' + contextPath + '/api/profile/report', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            errandId: currentReportTask.errandsId,
            title: '심부름꾼 신고 - ' + currentReportTask.title,
            content: reason,
            type: 'ERRANDER_REPORT'
        })
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('신고가 접수되었습니다.\n관리자가 검토 후 조치하겠습니다.');
                closeReportModal();
            } else {
                alert('신고 접수에 실패했습니다: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('서버 오류가 발생했습니다.');
        });
});

// Withdrawal Modal Logic
const withdrawalModal = document.getElementById('withdrawalModal');
const withdrawalBtn = document.getElementById('withdrawalBtn');
const withdrawalModalClose = document.getElementById('withdrawalModalClose');
const withdrawalCancel = document.getElementById('withdrawalCancel');
const withdrawalConfirm = document.getElementById('withdrawalConfirm');
const withdrawalPassword = document.getElementById('withdrawalPassword');

// Open withdrawal modal
withdrawalBtn.addEventListener('click', () => {
    withdrawalModal.classList.add('active');
    withdrawalPassword.value = ''; // Clear password field
});

// Close withdrawal modal
function closeWithdrawalModal() {
    withdrawalModal.classList.remove('active');
    withdrawalPassword.value = '';
}

withdrawalModalClose.addEventListener('click', closeWithdrawalModal);
withdrawalCancel.addEventListener('click', closeWithdrawalModal);

// Close when clicking outside
withdrawalModal.addEventListener('click', (e) => {
    if (e.target === withdrawalModal) {
        closeWithdrawalModal();
    }
});

// Confirm withdrawal
withdrawalConfirm.addEventListener('click', () => {
    const password = withdrawalPassword.value;

    if (!password) {
        alert('비밀번호를 입력해주세요.');
        withdrawalPassword.focus();
        return;
    }

    if (!confirm('정말로 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
        return;
    }

    // 백엔드 API 호출
    fetch('' + contextPath + '/api/profile/withdraw', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            password: password
        })
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('회원 탈퇴가 완료되었습니다. 그동안 VROOM을 이용해주셔서 감사합니다.');
                closeWithdrawalModal();
                window.location.href = '' + contextPath + '/';
            } else {
                alert('탈퇴 실패: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('서버 오류가 발생했습니다.');
        });
});

// Profile Edit Modal Logic
const profileModal = document.getElementById('profileModal');
const profileImage = document.getElementById('profileImage');
const profileNickname = document.getElementById('profileNickname');
const modalClose = document.getElementById('modalClose');
const modalCancel = document.getElementById('modalCancel');
const modalSave = document.getElementById('modalSave');
const imageUpload = document.getElementById('imageUpload');
const previewImage = document.getElementById('previewImage');
const removeImage = document.getElementById('removeImage');
const nicknameInput = document.getElementById('nicknameInput');
const charCount = document.getElementById('charCount');

// Tab switching
const modalTabs = document.querySelectorAll('.modal-tab');
const modalTabPanels = document.querySelectorAll('.modal-tab-panel');

let currentImage = null;
let currentNickname = 'VROOM 유저';

// Open modal on profile image or nickname click
profileImage.addEventListener('click', () => {
    profileModal.classList.add('active');
    // Switch to image tab
    switchTab('image');
});

profileNickname.addEventListener('click', () => {
    profileModal.classList.add('active');
    // Switch to nickname tab
    switchTab('nickname');
});

// Close modal
function closeModal() {
    profileModal.classList.remove('active');
}

modalClose.addEventListener('click', closeModal);
modalCancel.addEventListener('click', closeModal);

// Close modal when clicking outside
profileModal.addEventListener('click', (e) => {
    if (e.target === profileModal) {
        closeModal();
    }
});

// Tab switching logic
function switchTab(tabName) {
    modalTabs.forEach(tab => {
        tab.classList.remove('active');
        if (tab.dataset.tab === tabName) {
            tab.classList.add('active');
        }
    });

    modalTabPanels.forEach(panel => {
        panel.classList.remove('active');
        if (panel.id === tabName + 'Panel') {
            panel.classList.add('active');
        }
    });
}

modalTabs.forEach(tab => {
    tab.addEventListener('click', () => {
        switchTab(tab.dataset.tab);
    });
});

// Image upload
imageUpload.addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (file) {
        // Validate file type
        if (!file.type.match('image.*')) {
            alert('이미지 파일만 업로드 가능합니다.');
            return;
        }

        // Validate file size (5MB)
        if (file.size > 5 * 1024 * 1024) {
            alert('파일 크기는 5MB를 초과할 수 없습니다.');
            return;
        }

        const reader = new FileReader();
        reader.onload = (event) => {
            currentImage = event.target.result;
            previewImage.innerHTML = '<img src="' + currentImage + '" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">';
        };
        reader.readAsDataURL(file);
    }
});

// Remove image (reset to default)
removeImage.addEventListener('click', () => {
    currentImage = null;
    previewImage.innerHTML = '<img src="' + contextPath + '/static/img/logo3.png" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">';
    imageUpload.value = '';
});

// Nickname character count
nicknameInput.addEventListener('input', () => {
    const length = nicknameInput.value.length;
    charCount.textContent = length;
});

// Save changes
modalSave.addEventListener('click', () => {
    const activeTab = document.querySelector('.modal-tab.active').dataset.tab;

    if (activeTab === 'image') {
        // 이미지 업로드
        const file = imageUpload.files[0];
        if (file) {
            const formData = new FormData();
            formData.append('file', file);

            fetch('' + contextPath + '/api/profile/image', {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        profileImage.innerHTML = '<img src="' + contextPath + '' + data.imagePath + '" alt="Profile" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">';
                        alert('프로필 이미지가 변경되었습니다.');
                        closeModal();
                    } else {
                        alert('이미지 업로드 실패: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('서버 오류가 발생했습니다.');
                });
        } else if (currentImage === null) {
            // 기본 이미지로 변경
            profileImage.innerHTML = '<img src="' + contextPath + '/static/img/logo3.png" alt="Profile" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">';
            closeModal();
        } else {
            closeModal();
        }
    } else if (activeTab === 'nickname') {
        const newNickname = nicknameInput.value.trim();

        if (newNickname.length < 2) {
            alert('닉네임은 최소 2자 이상이어야 합니다.');
            return;
        }

        const validPattern = /^[가-힣a-zA-Z0-9\s]+$/;
        if (!validPattern.test(newNickname)) {
            alert('한글, 영문, 숫자만 사용 가능합니다.');
            return;
        }

        // Ajax 호출
        fetch('' + contextPath + '/api/profile/nickname', {
            method: 'PUT',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({nickname: newNickname})
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    profileNickname.textContent = newNickname;
                    closeModal();
                } else {
                    alert(data.message || '닉네임 변경에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 오류가 발생했습니다.');
            });
    }
});

