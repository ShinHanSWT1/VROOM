// DOM이 완전히 로드된 후 스크립트 실행
document.addEventListener('DOMContentLoaded', () => {
    // JSP에서 설정한 전역 설정 값 사용
    const { contextPath, postId, isUserLoggedIn } = window.communityConfig;

    const commentListContainer = document.getElementById('commentList');
    const mainCommentTextarea = document.querySelector('#mainCommentForm .comment-input');
    const totalCommentsHeader = document.querySelector('.comments-header h3');

    // 페이지 로딩 시 댓글 목록 최초 호출
    fetchComments();

   // 댓글 화면에 렌더링 
    async function fetchComments() {
        try {
            const response = await fetch(`${contextPath}/community/api/posts/${postId}/comments`);
            if (!response.ok) {
                throw new Error('댓글을 불러오는 데 실패했습니다.');
            }
            const comments = await response.json();
            renderComments(comments);
            updateTotalCommentsCount(comments.length);
        } catch (error) {
            console.error(error);
            commentListContainer.innerHTML = '<div class="error-message">댓글을 불러올 수 없습니다.</div>';
        }
    }
    
    function renderComments(comments) {
        commentListContainer.innerHTML = ''; // 기존 댓글 목록 초기화
        if (comments && comments.length > 0) {
            comments.forEach(comment => {
                const commentElement = createCommentElement(comment);
                commentListContainer.appendChild(commentElement);
            });
        } else {
            commentListContainer.innerHTML = '<div class="no-data">아직 댓글이 없습니다. 첫 댓글을 남겨보세요!</div>';
        }
    }

   // 댓글 객체 생성 
    function createCommentElement(comment) {
        const wrapper = document.createElement('div');
        wrapper.className = `comment-item-wrapper ${comment.depth > 0 ? 'reply' : ''}`;
        wrapper.dataset.commentId = comment.commentId;
        wrapper.dataset.groupId = comment.groupId;

        // 간단한 날짜 포맷팅
        const timeAgo = new Date(comment.createdAt).toLocaleDateString('ko-KR', {
            month: 'long',
            day: 'numeric'
        });

        const avatarContent = comment.profileUrl
            ? `<img src="${comment.profileUrl}" alt="profile">`
            : (comment.nickname ? comment.nickname.substring(0, 1) : 'V');

        wrapper.innerHTML = `
            <div class="comment-item">
                <div class="comment-avatar">${avatarContent}</div>
                <div class="comment-body">
                    <div class="comment-author">
                        <span>${comment.nickname}</span>
                        <span class="time-ago"> • ${timeAgo}</span>
                    </div>
                    <div class="comment-content">${comment.content.replace(/\\n/g, '<br>')}</div>
                    <div class="comment-actions">
                        <button class="action-btn">👍 <span>${comment.likeCount || 0}</span></button>
                        <button class="action-btn" onclick="showReplyForm(this, ${comment.commentId}, ${comment.groupId})">답글</button>
                    </div>
                </div>
            </div>
            <div class="reply-form-container" style="display: none;"></div>
        `;
        return wrapper;
    }

    // 전체 댓글 수 업데이트 
    function updateTotalCommentsCount(count) {
        if (totalCommentsHeader) {
            totalCommentsHeader.textContent = `댓글 ${count}개`;
        }
    }

  

    // 댓글, 대댓글 서버 전송 
    window.submitComment = async (button, parentCommentId = null, groupId = null) => {
        if (!isUserLoggedIn) {
            alert('로그인이 필요합니다.');
            // 로그인 페이지로 리디렉션
            // window.location.href = `${contextPath}/login`;
            return;
        }

        const formContainer = button.closest('.comment-form-container');
        const textarea = formContainer.querySelector('.comment-input');
        const content = textarea.value.trim();

        if (!content) {
            alert('댓글 내용을 입력하세요.');
            textarea.focus();
            return;
        }

        const commentData = {
            content: content,
            parentCommentId: parentCommentId,
            groupId: groupId
        };

        try {
            const response = await fetch(`${contextPath}/community/api/posts/${postId}/comments`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(commentData),
            });

            if (response.status === 201) { 
                textarea.value = '';
                // 답글 폼이었다면 폼을 닫고 초기화
                if (parentCommentId) {
                    formContainer.style.display = 'none';
                    formContainer.innerHTML = '';
                }
                // 댓글 목록 전체를 새로고침하여 변경사항 즉시 반영
                await fetchComments();
            } else {
                const errorText = await response.text();
                throw new Error(errorText || '댓글 등록에 실패했습니다.');
            }
        } catch (error) {
            console.error(error);
            alert(error.message);
        }
    };

    // 대댓글 입력 폼 토글 
    window.showReplyForm = (button, parentCommentId, groupId) => {
        const commentWrapper = button.closest('.comment-item-wrapper');
        const replyContainer = commentWrapper.querySelector('.reply-form-container');

        // 폼이 이미 열려있으면 닫기
        if (replyContainer.style.display === 'block') {
            replyContainer.style.display = 'none';
            replyContainer.innerHTML = '';
            return;
        }

        // 다른 모든 답글 폼 닫기
        document.querySelectorAll('.reply-form-container').forEach(container => {
            container.style.display = 'none';
            container.innerHTML = '';
        });

        // 새로운 답글 폼 생성 및 표시
        replyContainer.style.display = 'block';
        replyContainer.innerHTML = `
            <div class="comment-form-container reply-form">
                 <div class="comment-avatar">
                    <span>↳</span>
                </div>
                <div class="comment-input-wrapper">
                    <textarea class="comment-input" placeholder="답글을 입력하세요..."></textarea>
                    <button class="comment-submit-btn" onclick="submitComment(this, ${parentCommentId}, ${groupId})">등록</button>
                </div>
            </div>
        `;
        replyContainer.querySelector('.comment-input').focus();
    };

    // 게시글 댓글 버튼 클릭시, 메인 댓글 입력 표시
    window.focusCommentForm = () => {
        if (mainCommentTextarea) {
            mainCommentTextarea.focus();
            mainCommentTextarea.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    };
});
