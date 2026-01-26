/**
 * 커뮤니티 좋아요 기능 공통 JS
 * Main(List) 및 Detail 페이지에서 공통으로 사용
 */
const CommunityLike = {
    /**
     * 좋아요 토글 함수
     * @param {Event} event - 클릭 이벤트 객체
     * @param {number} postId - 게시글 ID
     * @param {HTMLElement} button - 클릭된 버튼 요소
     */
    toggle: async function(event, postId, button) {
        if (event) {
            event.preventDefault();
            event.stopPropagation();
        }

        // Context Path 찾기 (각 페이지별 Config 객체 확인)
        const contextPath = (window.communityFilterConfig && window.communityFilterConfig.contextPath) ||
                            (window.communityConfig && window.communityConfig.contextPath) ||
                            '';

        if (!contextPath) {
            console.error('Context Path를 찾을 수 없습니다.');
            return;
        }

        // 로그인 여부 사전 체크 (Detail 페이지 등 Config에 정보가 있는 경우)
        if (window.communityConfig && window.communityConfig.hasOwnProperty('isUserLoggedIn')) {
            if (!window.communityConfig.isUserLoggedIn) {
                if (confirm('로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?')) {
                    window.location.href = contextPath + '/member/login';
                }
                return;
            }
        }

        try {
            const response = await fetch(contextPath + '/community/api/posts/' + postId + '/like', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (response.status === 401) {
                if (confirm('로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?')) {
                    window.location.href = contextPath + '/member/login';
                }
                return;
            }

            if (response.ok) {
                const data = await response.json();

                // 아이콘과 카운트 요소 찾기 (Class 우선, 없으면 ID - Detail 페이지 호환)
                const likeIcon = button.querySelector('.like-icon') || button.querySelector('#likeIcon');
                const likeCount = button.querySelector('.like-count') || button.querySelector('#likeCount');

                if (data.liked) {
                    button.classList.add('active'); // 스타일링용 클래스 추가
                    if (likeIcon) likeIcon.textContent = '❤️';
                } else {
                    button.classList.remove('active');
                    if (likeIcon) likeIcon.textContent = '👍';
                }

                if (likeCount) likeCount.textContent = data.likeCount;
            } else {
                console.error('좋아요 처리 실패');
            }
        } catch (error) {
            console.error('네트워크 오류:', error);
        }
    }
};
