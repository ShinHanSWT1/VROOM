const currentErranderId = '${summary.detail.errander_id}';

document.addEventListener('DOMContentLoaded', function () {
    // Load helper detail
    loadErranderDetail();
});

// User Dropdown Toggle
function toggleUserDropdown() {
    const dropdown = document.getElementById('userDropdown');
    dropdown.classList.toggle('show');
}

document.addEventListener('click', function (e) {
    const userDropdown = document.getElementById('userDropdown');
    const headerUser = document.querySelector('.header-user');
    if (userDropdown && headerUser && !headerUser.contains(e.target)) {
        userDropdown.classList.remove('show');
    }
});

// Load helper detail data
function loadErranderDetail() {
    if (!currentErranderId) {
        alert('부름이 ID가 없습니다.');
        return;
    }
    const contextPath = '${pageContext.request.contextPath}';

    // API 호출
    fetch(contextPath + '/api/admin/erranders/detail',{
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            erranderId: currentErranderId,
            limit: 5
        })
    })
        .then(response => response.json())
        .then(data => {

            console.log(data);

            // 정산 내역
            document.getElementById('totalSettlement').textContent = (data.settlementSummary.total_amount || 0).toLocaleString() + '원';
            document.getElementById('completedSettlement').textContent = (data.settlementSummary.this_month_amount|| 0).toLocaleString() + '원';
            document.getElementById('pendingSettlement').textContent = (data.settlementSummary.settlement_pending_amount || 0).toLocaleString() + '원';
            document.getElementById('recentSettlement').textContent = data.recentSettlement || '-';

            // 리뷰 평점
            document.getElementById('reviewAvgRating').textContent = (data.ratingAvg || 0) + ' / 5.0';

            // 최근 리뷰 날짜 가공 및 데이터 삽입
            data.recentReviewList.forEach(r => {
                r.created_at = formatReviewTime(r.created_at);
            });
            if (data.recentReviewList && data.recentReviewList.length > 0) {
                const reviewsHtml = data.recentReviewList.map(review => `
                    <div style="
                        padding: 0.6rem;
                        background: #F8F9FA;
                        border-radius: 6px;
                        margin-bottom: 0.5rem;
                        display: grid;
                        grid-template-columns: 1fr auto;
                        row-gap: 0.3rem;
                    ">
                        <!-- 1행: 심부름ID / 날짜 -->
                        <div style="font-size: 0.75rem; color: var(--color-gray);">
                            심부름ID: ${review.errand_id}
                        </div>
                        <div style="font-size: 0.75rem; color: var(--color-gray); text-align: right;">
                            ${review.created_at}
                        </div>

                        <!-- 2행 왼쪽: 평점 -->
                        <div style="
                            font-size: 0.85rem;
                            color: var(--color-dark);
                            font-weight: 600;
                            white-space: nowrap;
                        ">
                            ⭐ ${review.rating}
                        </div>

                        <!-- 2행 오른쪽: 코멘트 -->
                        <div style="
                            font-size: 0.8rem;
                            color: var(--color-gray);
                            line-height: 1.4;
                        ">
                            ${review.comment}
                        </div>
                    </div>
                `).join('');
                document.getElementById('recentReviews').innerHTML = reviewsHtml;
            }

            // 수행 심부름 목록
            data.recentErrandsList.forEach(r => {
                r.event_at = formatDate(r.event_at);
            });
            if (data.recentErrandsList && data.recentErrandsList.length > 0) {
                const errandTbody = document.getElementById('errandListBody');
                errandTbody.innerHTML = data.recentErrandsList.map((errand, idx) => `
                    <tr>
                        <td>${idx + 1}</td>
                        <td>${errand.errands_id}</td>
                        <td>${errand.title}</td>
                        <td>${errand.event_at}</td>
                        <td><span class="status-badge ${errand.status}">${errand.status}</span></td>
                    </tr>
                `).join('');
            }

            // 활동 제한 이력
            if (data.restrictionHistory && data.restrictionHistory.length > 0) {
                const restrictionTbody = document.getElementById('restrictionHistoryBody');
                restrictionTbody.innerHTML = data.restrictionHistory.map(item => `
                    <tr>
                        <td>${item.date}</td>
                        <td>${item.reason}</td>
                        <td>${item.admin}</td>
                    </tr>
                `).join('');
            }

            // 제출 서류
            if (data.authDocuments && data.authDocuments.length > 0) {
                const documentsHtml = data.authDocuments.map(doc => {
                    const icon = doc.doc_type === 'IDCARD' ? '🪪' : '📄';

                    return `
                        <div style="display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem; background: #F8F9FA; border-radius: 8px;">
                            <div style="font-size: 1.5rem;">${icon}</div>
                            <div style="flex: 1;">
                                <div style="font-size: 0.9rem; font-weight: 600;">${doc.name}</div>
                                <div style="font-size: 0.75rem; color: var(--color-gray);">${doc.doc_type}</div>
                            </div>
                            <button onclick="viewDocument('${doc.file_url}')" style="padding: 0.375rem 0.75rem; background: var(--color-dark); color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 0.8rem;">보기</button>
                        </div>
                    `;
                }).join('');
                document.getElementById('documentList').innerHTML = documentsHtml;
            }

            // 관리자 메모
            if (data.adminMemo) {
                document.getElementById('adminMemo').value = data.adminMemo;
            }
        })
        .catch(error => {
            console.error('데이터 로드 실패:', error);
        });
}

function formatDate(ms) {
    const d = new Date(ms);
    const yyyy = d.getFullYear();
    const mm = String(d.getMonth() + 1).padStart(2, '0');
    const dd = String(d.getDate()).padStart(2, '0');

    const days = ['일', '월', '화', '수', '목', '금', '토'];
    const day = days[d.getDay()];

    return yyyy + '-' + mm + '-' + dd + ' ' + day;
}

function formatReviewTime(ms) {
    ms = Number(ms);
    const now = Date.now();
    const diff = now - ms;

    const min = 60 * 1000;
    const hour = 60 * min;
    const day = 24 * hour;

    if (diff < 0) return '방금 전';

    if (diff < min) return '방금 전';
    if (diff < hour) return Math.floor(diff / min) + '분 전';
    if (diff < day) return Math.floor(diff / hour) + '시간 전';

    const d = new Date(ms);
    const yyyy = d.getFullYear();
    const mm = String(d.getMonth() + 1).padStart(2, '0');
    const dd = String(d.getDate()).padStart(2, '0');

    return yyyy + '-' + mm + '-' + dd;
}


function viewDocument(url) {
    if (!url) {
        alert('파일 경로가 존재하지 않습니다.');
        return;
    }
    const contextPath = '${pageContext.request.contextPath}';
    window.open(contextPath + '/' + url, '_blank');
}

function saveMemo() {
    const memo = document.getElementById('adminMemo').value;
    const contextPath = '${pageContext.request.contextPath}';

    fetch(contextPath + '/api/admin/erranders/savememo', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({
            erranderId: currentErranderId,
            memo: memo
        })
    })
        .then(res => res.json())
        .then(data => {
            if(data.result === 'success'){
                alert('저장되었습니다');
                window.location.reload();
            }
            else {
                alert('처리 실패했습니다: ' + data.message);
            }

        });

    console.log('저장할 메모:', memo);
}
