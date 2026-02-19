/**
 * errand_chat.js - 심부름 채팅 페이지 전용 스크립트
 * JSP에서 전역 변수로 전달받는 값: roomId, errandsId, currentUserId, userRole, contextPath, errandStatus, reviewExists, completionProofUrl
 */

document.addEventListener('DOMContentLoaded', function() {
    // DOM 요소
    const messageInput = document.getElementById('messageInput');
    const sendBtn = document.getElementById('sendBtn');
    const messagesArea = document.getElementById('messagesArea');
    const attachBtn = document.getElementById('attachBtn');
    const proofBtnInput = document.getElementById('proofBtnInput');
    const actionArea = document.getElementById('actionArea');

    let stompClient = null;

    // ========================================
    // WebSocket (STOMP) 연결
    // ========================================
    function connectStomp() {
        const socket = new SockJS(contextPath + '/ws');
        stompClient = Stomp.over(socket);
        stompClient.debug = null;

        stompClient.connect({}, function() {
            // 방 구독
            stompClient.subscribe('/topic/room.' + roomId, function(message) {
                const payload = JSON.parse(message.body);

                // 1) 시스템 메시지
                if (payload.messageType === 'SYSTEM') {
                    addSystemMessageToUI(payload.content);
                    return;
                }

                // 2) 상태 변경 메시지(수락/거절/완료 등)
                if (payload.messageType === 'STATUS') {
                    handleStatusChange(payload);
                    return;
                }

                // 3) 일반 채팅 메시지(TEXT 등)
                const isMine = (payload.senderUserId === currentUserId);
                
                if (payload.messageType === 'IMAGE') {
                    addImageMessageToUI(payload.content, isMine);
                } else {
                    addMessageToUI(payload.content, isMine);
                }
            });
        });
    }

    // ========================================
    // 메시지 전송
    // ========================================
    function sendMessage(messageType = 'TEXT', content = null) {
        const messageText = content || messageInput.value.trim();
        if (!messageText) return;

        stompClient.send('/app/chat.send', {}, JSON.stringify({
            roomId: roomId,
            senderUserId: currentUserId,
            messageType: messageType,
            content: messageText
        }));

        if (messageType === 'TEXT') {
            messageInput.value = '';
        }
    }

    // ========================================
    // UI 업데이트 함수들
    // ========================================
    function addSystemMessageToUI(text) {
        const div = document.createElement('div');
        div.className = 'system-message';
        div.textContent = text;

        messagesArea.appendChild(div);
        messagesArea.scrollTop = messagesArea.scrollHeight;
    }

    function addMessageToUI(text, isMine) {
        const messageDiv = document.createElement('div');
        messageDiv.className = 'message ' + (isMine ? 'mine' : 'other');

        const bubble = document.createElement('div');
        bubble.className = 'message-bubble';
        bubble.textContent = text;

        const time = document.createElement('div');
        time.className = 'message-time';
        time.textContent = new Date().toLocaleTimeString('ko-KR', { hour: 'numeric', minute: '2-digit' });

        if (isMine) {
            messageDiv.appendChild(time);
            messageDiv.appendChild(bubble);
        } else {
            messageDiv.appendChild(bubble);
            messageDiv.appendChild(time);
        }

        messagesArea.appendChild(messageDiv);
        messagesArea.scrollTop = messagesArea.scrollHeight;
    }

    function addImageMessageToUI(imageUrl, isMine) {
        const messageDiv = document.createElement('div');
        messageDiv.className = 'message ' + (isMine ? 'mine' : 'other');

        const bubble = document.createElement('div');
        bubble.className = 'message-bubble image-bubble'; // image-bubble 클래스 추가

        // 이미지 태그 생성
        const img = document.createElement('img');
        
        let src = imageUrl;
        if (!src.startsWith('http') && !src.startsWith(contextPath)) {
             src = contextPath + src;
        }
        
        img.src = src;
        img.alt = "첨부 이미지";
        
        // 이미지 클릭 시 원본 보기 (선택 사항)
        img.onclick = function() {
            window.open(src, '_blank');
        };

        bubble.appendChild(img);

        const time = document.createElement('div');
        time.className = 'message-time';
        time.textContent = new Date().toLocaleTimeString('ko-KR', { hour: 'numeric', minute: '2-digit' });

        if (isMine) {
            messageDiv.appendChild(time);
            messageDiv.appendChild(bubble);
        } else {
            messageDiv.appendChild(bubble);
            messageDiv.appendChild(time);
        }

        messagesArea.appendChild(messageDiv);
        
        // 이미지가 로드된 후 스크롤 조정
        img.onload = function() {
            messagesArea.scrollTop = messagesArea.scrollHeight;
        };
        // 로드 전에도 일단 스크롤
        messagesArea.scrollTop = messagesArea.scrollHeight;
    }

    // ========================================
    // 상태 관리
    // ========================================
    function statusRank(s) {
        const order = {
            WAITING: 0,
            MATCHED: 1,
            CONFIRMED1: 2,
            CONFIRMED2: 3,
            COMPLETED: 4
        };
        return (order[s] ?? -1);
    }

    function handleStatusChange(payload) {
        const status = payload.status;
        if (!actionArea) return;

        const current = actionArea.getAttribute('data-status');

        // 이미 더 진행된 상태면, 더 낮은 이벤트는 무시
        if (current && statusRank(status) < statusRank(current)) {
            return;
        }

        actionArea.setAttribute('data-status', status);

        const isUser = (userRole === 'USER' || userRole === 'OWNER');
        const isErrander = (userRole === 'ERRANDER' || userRole === 'RUNNER');

        if (status === 'CONFIRMED1') {
            if (isUser) {
                actionArea.innerHTML = `<div class="status-wait">⏳ 심부름 중</div>`;
            }
            if (isErrander) {
                actionArea.innerHTML = `<button class="complete-btn" id="proofBtn" type="button">📷 인증하기</button>`;
            }
            return;
        }

        if (status === 'CONFIRMED2') {
            // 인증 완료 상태 -> 인증사진 보기 버튼 추가
            let html = `<button type="button" id="viewProofBtn" class="v-btn v-btn--ghost" style="margin-right:4px;">📷 인증사진 보기</button>`;
            
            if (isUser) {
                html += `<button class="review-btn" id="openReviewBtn" type="button" data-reviewed="0">리뷰작성</button>`;
                actionArea.innerHTML = html;
                bindReviewBtn(); // 리뷰 버튼은 별도 로직이 많아 기존 방식 유지
            } else {
                html += `<div class="status-done" style="margin-left:8px;">거래 완료</div>`;
                actionArea.innerHTML = html;
            }
            return;
        }

        if (status === 'MATCHED') {
            if (isUser) {
                actionArea.innerHTML =
                    `<button class="accept-btn" id="acceptBtn" type="button">✓ 수락</button>
                     <button class="reject-btn" id="rejectBtn" type="button">✗ 거절</button>`;
            }
            if (isErrander) {
                actionArea.innerHTML = `<div class="status-wait">사용자 수락 대기중</div>`;
            }
            return;
        }

        if (status === 'WAITING') {
            actionArea.innerHTML = `<div class="status-wait">상태: WAITING</div>`;
            return;
        }

        actionArea.innerHTML = `<div class="status-wait">상태: ${status}</div>`;
    }

    // ========================================
    // 액션 버튼 이벤트 위임 (통합)
    // ========================================
    function bindActionButtons() {
        if (!actionArea) return;
        
        // 중복 바인딩 방지
        if (actionArea.dataset.eventsBound === 'true') return;
        actionArea.dataset.eventsBound = 'true';

        actionArea.addEventListener('click', function(e) {
            const target = e.target;

            // 1. 인증하기 (업로드)
            if (target.closest('#proofBtn')) {
                openProofModal();
                return;
            }

            // 2. 인증사진 보기
            if (target.closest('#viewProofBtn')) {
                openViewProofModal();
                return;
            }

            // 3. 수락
            if (target.closest('#acceptBtn')) {
                handleAccept();
                return;
            }

            // 4. 거절
            if (target.closest('#rejectBtn')) {
                handleReject();
                return;
            }
        });
    }

    // ========================================
    // 핸들러 함수들
    // ========================================

    function handleAccept() {
        if (!confirm('이 부름이와 심부름을 진행하시겠습니까?')) return;

        fetch(contextPath + '/errand/chat/accept', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'same-origin',
            body: JSON.stringify({
                errandsId: Number(errandsId),
                roomId: Number(roomId)
            })
        })
        .then(res => res.json())
        .then(data => {
            if (!data.success) {
                alert(data.error || '수락 처리 실패');
                return;
            }
            alert('심부름이 수락되었습니다!');
        })
        .catch(err => {
            console.error(err);
            alert('수락 처리 중 오류');
        });
    }

    function handleReject() {
        if (!confirm('정말로 이 심부름을 거절하시겠습니까?')) return;

        const rawErranderUserId = actionArea.dataset.erranderUserId;
        const erranderUserId = Number(rawErranderUserId);

        if (!rawErranderUserId || !Number.isFinite(erranderUserId) || erranderUserId <= 0) {
            alert('거절 대상 사용자 정보가 없습니다.');
            return;
        }

        fetch(contextPath + '/errand/chat/reject', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'same-origin',
            body: JSON.stringify({
                errandsId: Number(errandsId),
                roomId: Number(roomId),
                erranderUserId: erranderUserId
            })
        })
        .then(res => res.json().catch(() => ({})).then(data => ({res, data})))
        .then(({res, data}) => {
            if (!res.ok || !data.success) {
                alert(data.error || '거절 처리 실패');
                return;
            }
            alert('심부름이 거절되었습니다.');
        })
        .catch(err => {
            console.error(err);
            alert('거절 처리 중 오류');
        });
    }

    function openViewProofModal() {
        if (!completionProofUrl) {
            alert('인증 사진 정보를 불러올 수 없습니다.');
            return;
        }
        
        const modal = document.getElementById('viewProofModal');
        const overlay = document.getElementById('viewProofOverlay');
        const closeBtn = document.getElementById('viewProofCloseBtn');
        const img = document.getElementById('viewProofImg');
        
        if (!modal) return;

        let src = completionProofUrl;
        if (!src.startsWith('http') && !src.startsWith(contextPath)) {
             src = contextPath + src;
        }
        img.src = src;
        
        modal.classList.add('is-open');
        
        const close = () => modal.classList.remove('is-open');
        
        if (overlay) overlay.onclick = close;
        if (closeBtn) closeBtn.onclick = close;
    }

    // ========================================
    // 인증사진 모달 (업로드용)
    // ========================================
    function openProofModal(selectedFile) {
        const modal = document.getElementById('proofModal');
        const overlay = document.getElementById('proofOverlay');
        const fileInput = document.getElementById('proofFile');
        const previewWrap = document.getElementById('proofPreview');
        const previewImg = document.getElementById('proofPreviewImg');
        const fileName = document.getElementById('proofFileName');

        if (!modal) {
            alert('모달이 없습니다.');
            return;
        }

        // 초기화
        fileInput.value = '';

        if (selectedFile) {
            // 파일이 전달된 경우 (proofBtnInput을 통해 선택됨)
            const dt = new DataTransfer();
            dt.items.add(selectedFile);
            fileInput.files = dt.files;

            fileName.textContent = selectedFile.name;
            const url = URL.createObjectURL(selectedFile);
            previewImg.src = url;
            previewWrap.style.display = 'block';
        } else {
            previewWrap.style.display = 'none';
            previewImg.src = '';
            fileName.textContent = '';
        }

        modal.classList.add('is-open');
        modal.setAttribute('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';

        // 파일 선택 시 미리보기
        fileInput.onchange = () => {
            const f = fileInput.files?.[0];
            if (!f) return;
            fileName.textContent = f.name;

            const url = URL.createObjectURL(f);
            previewImg.src = url;
            previewWrap.style.display = 'block';
        };

        // 닫기 함수
        const close = () => {
            modal.classList.remove('is-open');
            modal.setAttribute('aria-hidden', 'true');
            document.body.style.overflow = '';

            if (previewImg?.src?.startsWith('blob:')) {
                try { URL.revokeObjectURL(previewImg.src); } catch (e) {}
            }
        };

        // 닫기/취소 버튼
        const closeBtn = document.getElementById('proofCloseBtn');
        const cancelBtn = document.getElementById('proofCancelBtn');

        if (closeBtn) closeBtn.onclick = close;
        if (cancelBtn) cancelBtn.onclick = close;
        if (overlay) overlay.onclick = close;

        // ESC 닫기
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') close();
        }, { once: true });

        // 업로드 버튼
        const submitBtn = document.getElementById('proofSubmitBtn');
        submitBtn.onclick = async () => {
            const f = fileInput.files?.[0];
            if (!f) {
                alert('사진을 선택해주세요.');
                return;
            }

            const fd = new FormData();
            fd.append('errandsId', errandsId);
            fd.append('roomId', roomId);
            fd.append('file', f);

            try {
                const res = await fetch(contextPath + '/errand/chat/assign/complete-proof', {
                    method: 'POST',
                    body: fd,
                    credentials: 'same-origin'
                });

                const data = await res.json();
                if (!res.ok || data.success !== true) {
                    alert(data.message || data.error || '업로드 실패');
                    return;
                }

                close();
                
                // 업로드 성공 시 URL 저장
                if (data.imageUrl) {
                    completionProofUrl = data.imageUrl;
                }

                // UI 갱신: 인증사진 보기 버튼 추가
                if (actionArea) {
                    let html = `<button type="button" id="viewProofBtn" class="v-btn v-btn--ghost" style="margin-right:4px;">📷 인증사진 보기</button>`;
                    html += `<div class="status-done" style="margin-left:8px;">거래 완료</div>`;
                    actionArea.innerHTML = html;
                }

                addSystemMessageToUI('부름이가 완료 인증사진을 제출했습니다.');
                
                // 이미지 메시지로도 전송 (채팅방에 보이게)
                if (data.imageUrl) {
                    sendMessage('IMAGE', data.imageUrl);
                }

            } catch (e) {
                console.error(e);
                alert('업로드 중 오류가 발생했습니다.');
            }
        };
    }

    // ========================================
    // 리뷰 버튼 바인딩 (별도 처리)
    // ========================================
    function bindReviewBtn() {
        const openBtn = document.getElementById('openReviewBtn');
        const modal = document.getElementById('reviewModal');
        if (!openBtn || !modal) return;

        if (openBtn.dataset.bound === '1') return;
        openBtn.dataset.bound = '1';

        const reviewed = openBtn.dataset.reviewed === '1';
        if (reviewed) {
            openBtn.textContent = '리뷰 완료';
            openBtn.disabled = true;
            return;
        }

        const ratingRow = document.getElementById('ratingRow');
        const ratingText = document.getElementById('ratingText');
        const commentEl = document.getElementById('reviewComment');
        const cancelBtn = document.getElementById('reviewCancelBtn');
        const submitBtn = document.getElementById('reviewSubmitBtn');

        function setRating(v) {
            ratingRow.dataset.rating = String(v);
            document.querySelectorAll('#ratingRow .star').forEach(s => {
                const sv = Number(s.dataset.v);
                s.style.opacity = (sv <= v) ? '1' : '0.35';
            });
            ratingText.textContent = v ? (v + '점') : '별점을 선택하세요';
        }

        openBtn.addEventListener('click', () => {
            modal.style.display = 'flex';
            setRating(0);
            commentEl.value = '';
        });

        cancelBtn.addEventListener('click', () => {
            modal.style.display = 'none';
        });

        ratingRow.addEventListener('click', (e) => {
            const star = e.target.closest('.star');
            if (!star) return;
            setRating(Number(star.dataset.v));
        });

        submitBtn.addEventListener('click', async () => {
            const rating = Number(ratingRow.dataset.rating || 0);
            const comment = (commentEl.value || '').trim();

            if (!rating) {
                alert('별점을 선택해주세요.');
                return;
            }

            const body = new URLSearchParams();
            body.append('errandsId', String(errandsId));
            body.append('rating', String(rating));
            body.append('comment', comment);

            const res = await fetch(contextPath + '/errand/chat/review', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                credentials: 'same-origin',
                body: body.toString()
            });

            const raw = await res.text();

            if (!res.ok) {
                alert(`리뷰 등록 실패 (HTTP ${res.status})`);
                return;
            }

            let data;
            try { data = JSON.parse(raw); }
            catch (e) {
                alert('서버 응답이 JSON이 아닙니다.');
                return;
            }

            if (!data.success) {
                alert(data.error || '리뷰 등록 실패');
                return;
            }

            alert('리뷰가 등록되었습니다.');
            modal.style.display = 'none';

            openBtn.dataset.reviewed = '1';
            openBtn.textContent = '리뷰 완료';
            openBtn.disabled = true;
        });
    }

    // ========================================
    // 이벤트 리스너 등록
    // ========================================

    // 전송 버튼
    sendBtn.addEventListener('click', function() {
        sendMessage('TEXT');
    });

    // 엔터키 전송
    messageInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            sendMessage('TEXT');
        }
    });

    // 첨부 버튼
    attachBtn.addEventListener('click', function() {
        alert('파일 첨부 기능은 추후 구현 예정입니다.');
    });

    // 인증 사진 버튼 (입력 영역 - proofBtnInput)
    if (proofBtnInput) {
        proofBtnInput.addEventListener('click', function() {
            const input = document.createElement('input');
            input.type = 'file';
            input.accept = 'image/*';
            input.onchange = function(e) {
                const file = e.target.files[0];
                if (file) {
                    openProofModal(file);
                }
            };
            input.click();
        });
    }

    // ========================================
    // 초기화
    // ========================================

    // 스크롤 최하단
    messagesArea.scrollTop = messagesArea.scrollHeight;

    // WebSocket 연결
    connectStomp();

    // 액션 버튼 이벤트 위임 (한 번만 실행)
    bindActionButtons();

    // 리뷰 버튼 바인딩 (CONFIRMED2/COMPLETED 상태에서)
    const isUser = (userRole === 'USER' || userRole === 'OWNER');
    if (isUser && (errandStatus === 'CONFIRMED2' || errandStatus === 'COMPLETED')) {
        if (actionArea && !document.getElementById('openReviewBtn')) {
            actionArea.insertAdjacentHTML('beforeend', `
                <button class="review-btn" id="openReviewBtn" type="button" data-reviewed="${reviewExists ? '1' : '0'}">${reviewExists ? '리뷰 완료' : '리뷰작성'}</button>
            `);
        }
    }
    bindReviewBtn();
});
