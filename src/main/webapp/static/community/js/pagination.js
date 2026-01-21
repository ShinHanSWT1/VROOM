$(document).ready(function () {
    const postListContainer = $('#postList');
    const paginationContainer = $('#pagination');

    // 페이지네이션 버튼 클릭 이벤트
    $(document).on('click', '.page-btn, .prev-btn, .next-btn', function (e) {
        e.preventDefault(); // a 태그나 button의 기본동작 방지
        const page = $(this).data('page');

        if (page > 0 && page <= window.communityFilterConfig.totalPages) {
            fetchPosts(page);
        }
    });

    // 서버에서 게시글 데이터 요청
    function fetchPosts(page) {
        const {
            contextPath,
            currentDongCode,
            selectedGuName,
            currentCategoryId,
            currentSearchKeyword
        } = window.communityFilterConfig;

        // URL 파라미터 구성
        const params = new URLSearchParams({
            page: page,
            dongCode: currentDongCode,
            guName: selectedGuName,
            categoryId: currentCategoryId,
            search: currentSearchKeyword
        });

        // AJAX 요청
        $.ajax({
            url: `${contextPath}/community/api/posts?${params.toString()}`,
            type: 'GET',
            dataType: 'json',
            success: function (response) {
                updatePostList(response.content);
                updatePagination(response);
                window.communityFilterConfig.currentPage = response.page;
                window.communityFilterConfig.totalPages = response.totalPages;
            },
            error: function (xhr, status, error) {
                console.error("Failed to fetch posts:", error);
                postListContainer.html('<div class="no-data">게시글을 불러오는 데 실패했습니다.</div>');
            }
        });
    }

    // 게시글 목록 HTML을 생성하고 교체하는 함수
    function updatePostList(posts) {
        postListContainer.empty(); // 기존 목록 비우기
        if (posts && posts.length > 0) {
            posts.forEach(post => {
                const postCard = `
                    <a class="post-card" href="${window.communityFilterConfig.contextPath}/community/detail/${post.postId}" style="text-decoration: none; color: inherit;">
                        <div class="post-content-wrapper">
                            <div class="post-text-content">
                                <h1 class="post-title">${post.title}</h1>
                                <p class="post-description">${post.content}</p>
                                <div class="post-meta">
                                    <span class="post-meta-item">${post.dongName}</span>
                                    <span class="post-meta-item">•</span>
                                    <span class="post-meta-item">${post.categoryName}</span>
                                    <span class="post-meta-item">•</span>
                                    <span class="post-meta-item">${formatDate(post.createdAt)}</span>
                                </div>
                                <div class="post-stats">
                                    <span class="post-stat">👍 ${post.likeCount}</span>
                                    <span class="post-stat">👁 ${post.viewCount}</span>
                                </div>
                            </div>
                        </div>
                    </a>`;
                postListContainer.append(postCard);
            });
        } else {
            postListContainer.html('<div class="no-data">게시글이 없습니다.</div>');
        }
    }

    // pagination HTML을 생성하고 교체
    function updatePagination(pagination) {
        paginationContainer.empty();
        if (pagination.totalPages > 1) {
            const { page, totalPages } = pagination;

            let paginationHtml = `
                <button class="pagination-btn prev-btn wide-btn" ${page === 1 ? 'disabled' : ''} data-page="${page - 1}">
                    <span>이전</span>
                </button>
                <div class="page-numbers">`;

            for (let i = 1; i <= totalPages; i++) {
                paginationHtml += `<button class="page-btn ${page === i ? 'active' : ''}" data-page="${i}">${i}</button>`;
            }

            paginationHtml += `
                </div>
                <button class="pagination-btn next-btn wide-btn" ${page === totalPages ? 'disabled' : ''} data-page="${page + 1}">
                    <span>다음</span>
                </button>`;

            paginationContainer.html(paginationHtml);
        }
    }

    // 날짜 포맷
    function formatDate(dateString) {
        const date = new Date(dateString);
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${month}.${day}`;
    }
});