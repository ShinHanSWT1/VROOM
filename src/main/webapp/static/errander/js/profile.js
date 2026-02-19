// profile.js - 부름이 프로필 페이지 스크립트

document.addEventListener('DOMContentLoaded', function() {
    initReviewModal();
});

function initReviewModal() {
    const reviewCountBtn = document.getElementById('reviewCountBtn');
    const modal = document.getElementById('reviewModal');
    const closeBtn = document.getElementById('closeReviewModal');
    const reviewListContainer = document.getElementById('reviewListContainer');
    const loadingSpinner = document.getElementById('reviewLoading');

    let currentPage = 1;
    let isLoading = false;
    let hasMore = true;
    const pageSize = 10;

    // 모달 열기
    reviewCountBtn.addEventListener('click', function() {
        modal.classList.add('active');
        // 초기화 및 첫 페이지 로드
        resetReviewList();
        loadReviews();
    });

    // 모달 닫기
    closeBtn.addEventListener('click', function() {
        modal.classList.remove('active');
    });

    // 배경 클릭 시 닫기
    modal.addEventListener('click', function(e) {
        if (e.target === modal) {
            modal.classList.remove('active');
        }
    });

    // 무한 스크롤 이벤트
    reviewListContainer.addEventListener('scroll', function() {
        if (isLoading || !hasMore) return;

        // 스크롤이 바닥에 가까워지면 다음 페이지 로드
        if (reviewListContainer.scrollTop + reviewListContainer.clientHeight >= reviewListContainer.scrollHeight - 50) {
            loadReviews();
        }
    });

    function resetReviewList() {
        reviewListContainer.innerHTML = ''; // 모든 내용을 깨끗하게 비움
        reviewListContainer.appendChild(loadingSpinner); // 로딩 스피너를 다시 추가
        
        currentPage = 1;
        hasMore = true;
        isLoading = false;
    }

    function loadReviews() {
        if (isLoading || !hasMore) return;

        isLoading = true;
        loadingSpinner.style.display = 'flex';

        fetch(contextPath + `/errander/api/reviews?page=${currentPage}&size=${pageSize}`)
            .then(response => response.json())
            .then(data => {
                loadingSpinner.style.display = 'none';
                
                if (data.success) {
                    const reviews = data.reviews;
                    
                    if (reviews.length === 0 && currentPage === 1) {
                        showEmptyMessage();
                    } else {
                        renderReviews(reviews);
                        currentPage++;
                        hasMore = data.hasMore;
                    }
                } else {
                    console.error('리뷰 로드 실패:', data.message);
                }
            })
            .catch(error => {
                console.error('API 호출 오류:', error);
                loadingSpinner.style.display = 'none';
            })
            .finally(() => {
                isLoading = false;
            });
    }

    function renderReviews(reviews) {
        reviews.forEach(review => {
            const item = document.createElement('div');
            item.className = 'review-item';
            
            // 별점 생성
            let stars = '';
            for (let i = 1; i <= 5; i++) {
                stars += i <= review.rating ? '★' : '☆';
            }

            // 날짜 포맷
            const date = new Date(review.createdAt);
            const dateStr = `${date.getFullYear()}.${String(date.getMonth() + 1).padStart(2, '0')}.${String(date.getDate()).padStart(2, '0')}`;

            // 프로필 이미지 처리
            const profileImgSrc = review.reviewerImage ? contextPath + review.reviewerImage : contextPath + '/resources/images/default_profile.png';

            item.innerHTML = `
                <div class="review-header">
                    <div class="reviewer-info">
                        <img src="${profileImgSrc}" alt="프로필" class="reviewer-img">
                        <span class="reviewer-name">${review.reviewerNickname}</span>
                    </div>
                    <span class="review-date">${dateStr}</span>
                </div>
                <div class="review-errand-title">${review.errandTitle}</div>
                <div class="review-rating">${stars}</div>
                <div class="review-comment">${review.comment || ''}</div>
            `;
            
            // 로딩 스피너 앞에 추가
            reviewListContainer.insertBefore(item, loadingSpinner);
        });
    }

    function showEmptyMessage() {
        const msg = document.createElement('div');
        msg.className = 'empty-reviews';
        msg.textContent = '아직 받은 리뷰가 없습니다.';
        reviewListContainer.insertBefore(msg, loadingSpinner);
    }
}
