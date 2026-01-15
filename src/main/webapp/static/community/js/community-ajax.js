/**
 * community-ajax.js
 * 커뮤니티 상세 페이지 AJAX 기능
 * (jQuery 사용)
 */

/**
 * 게시글 좋아요 토글 (AJAX)
 */
function toggleLike(button) {
    // 게시글 번호 가져오기
    const postNo = getPostNoFromURL();
    
    $.ajax({
        url: '/community/like',
        type: 'POST',
        data: {
            postNo: postNo
        },
        success: function(response) {
            // 버튼 활성화 토글
            $(button).toggleClass('active');
            
            // 좋아요 수 업데이트
            const likeCount = $(button).find('.like-count');
            likeCount.text(response.likeCount);
        },
        error: function(xhr, status, error) {
            if (xhr.status === 401) {
                alert('로그인이 필요한 기능입니다.');
                location.href = '/login';
            } else {
                alert('좋아요 처리 중 오류가 발생했습니다.');
            }
        }
    });
}

/**
 * 댓글 좋아요 토글 (AJAX)
 */
function toggleCommentLike(button) {
    // 댓글 번호 가져오기 (data 속성 사용 권장)
    const commentNo = $(button).closest('.comment-item').data('comment-no');
    
    $.ajax({
        url: '/community/comment/like',
        type: 'POST',
        data: {
            commentNo: commentNo
        },
        success: function(response) {
            // 좋아요 수 업데이트
            const likeCount = $(button).find('.like-count');
            const currentCount = parseInt(likeCount.text());
            likeCount.text(currentCount + 1);
        },
        error: function(xhr, status, error) {
            if (xhr.status === 401) {
                alert('로그인이 필요한 기능입니다.');
                location.href = '/login';
            } else {
                alert('좋아요 처리 중 오류가 발생했습니다.');
            }
        }
    });
}

/**
 * 댓글 작성 폼 표시
 */
function showCommentForm() {
    const form = document.getElementById('mainCommentForm');
    if (form) {
        form.style.display = 'flex';
        form.querySelector('textarea').focus();
    }
}

/**
 * 답글 작성 폼 표시
 */
function showReplyForm(button) {
    const commentItem = button.closest('.comment-item') || button.closest('.reply-item');
    
    // 이미 폼이 있으면 무시
    if (commentItem.querySelector('.comment-form')) {
        return;
    }
    
    // 답글 폼 HTML 생성
    const replyFormHTML = `
        <div class="comment-form" style="margin-left: 3.5rem; margin-top: 1rem;">
            <textarea class="comment-input" placeholder="답글을 입력하세요..." style="min-height: 60px;"></textarea>
            <button class="comment-submit-btn" onclick="submitReply(this)">등록</button>
        </div>
    `;
    
    commentItem.insertAdjacentHTML('beforeend', replyFormHTML);
    commentItem.querySelector('.comment-form textarea').focus();
}

/**
 * 댓글 등록 (AJAX)
 */
function submitComment() {
    const form = document.getElementById('mainCommentForm');
    const textarea = form.querySelector('textarea');
    const content = textarea.value.trim();
    
    if (!content) {
        alert('댓글 내용을 입력해주세요.');
        return;
    }
    
    const postNo = getPostNoFromURL();
    
    $.ajax({
        url: '/community/comment/write',
        type: 'POST',
        data: {
            postNo: postNo,
            content: content
        },
        success: function(response) {
            alert('댓글이 등록되었습니다.');
            // 페이지 새로고침 (댓글 목록 갱신)
            location.reload();
        },
        error: function(xhr, status, error) {
            if (xhr.status === 401) {
                alert('로그인이 필요한 기능입니다.');
                location.href = '/login';
            } else {
                alert('댓글 등록 중 오류가 발생했습니다.');
            }
        }
    });
}

/**
 * 답글 등록 (AJAX)
 */
function submitReply(button) {
    const form = button.closest('.comment-form');
    const textarea = form.querySelector('textarea');
    const content = textarea.value.trim();
    
    if (!content) {
        alert('답글 내용을 입력해주세요.');
        return;
    }
    
    // 부모 댓글 번호 가져오기
    const commentItem = button.closest('.comment-item');
    const parentCommentNo = $(commentItem).data('comment-no');
    
    const postNo = getPostNoFromURL();
    
    $.ajax({
        url: '/community/comment/reply',
        type: 'POST',
        data: {
            postNo: postNo,
            parentCommentNo: parentCommentNo,
            content: content
        },
        success: function(response) {
            alert('답글이 등록되었습니다.');
            // 페이지 새로고침
            location.reload();
        },
        error: function(xhr, status, error) {
            if (xhr.status === 401) {
                alert('로그인이 필요한 기능입니다.');
                location.href = '/login';
            } else {
                alert('답글 등록 중 오류가 발생했습니다.');
            }
        }
    });
}

/**
 * URL에서 게시글 번호 추출
 */
function getPostNoFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get('postNo');
}

/**
 * 관련 게시글로 이동
 */
function goToPost(postNo) {
    goToPage('/community/detail?postNo=' + postNo);
}

/**
 * 카테고리 페이지로 이동
 */
function goToCategory(category) {
    goToPage('/community/list?category=' + encodeURIComponent(category));
}

/**
 * 페이지 로드 시 초기화
 */
$(document).ready(function() {
    console.log('커뮤니티 상세 페이지 로드 완료');
    
    // 지역 선택 초기화
    if (typeof updateDongOptions === 'function') {
        updateDongOptions();
    }
});
