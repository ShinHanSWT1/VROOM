document.addEventListener('DOMContentLoaded', function() {
    const messageInput = document.getElementById('messageInput');
    const sendBtn = document.getElementById('sendBtn');
    const messagesArea = document.getElementById('messagesArea');
    const attachBtn = document.getElementById('attachBtn');
    const proofBtnInput = document.getElementById('proofBtnInput');
    
    let stompClient = null;

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
                handleStatusChange(payload); // 아래 함수 추가
                return;
              }

              // 3) 일반 채팅 메시지(TEXT 등)
              const isMine = (payload.senderUserId === currentUserId);
              addMessageToUI(payload.content, isMine);
            });
        });
      }
    
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
      // payload.status 예: 'CONFIRMED1', 'CONFIRMED2', 'WAITING', 'MATCHED'
      const status = payload.status;
      const actionArea = document.getElementById('actionArea');
      if (!actionArea) return;
      
      const current = actionArea.getAttribute('data-status'); // 예: CONFIRMED2

      // 이미 더 진행된 상태면, 더 낮은 이벤트는 무시 (되돌림 방지)
      if (current && statusRank(status) < statusRank(current)) {
        return;
      }
      
      actionArea.setAttribute('data-status', status);

      // role 값이 지금 OWNER/ERRANDER 섞여 있을 수 있어서 방어적으로 처리
      const isUser = (userRole === 'USER' || userRole === 'OWNER');
      const isErrander = (userRole === 'ERRANDER' || userRole === 'RUNNER');

      if (status === 'CONFIRMED1') {
        // 사용자(작성자): "대기중"
        if (isUser) {
            actionArea.innerHTML = `<div class="status-wait">⏳ 심부름 중</div>`;
        }
        // 부름이: 거래완료 버튼 즉시 노출
        if (isErrander) {
          actionArea.innerHTML = `<button class="complete-btn" id="proofBtn" type="button">✔ 거래완료</button>`;
          bindProofBtn(); // 버튼 이벤트 바인딩 (아래 함수 추가)
        }
        return;
      }

      if (status === 'CONFIRMED2') {
        actionArea.innerHTML = `<div class="status-done">거래 완료</div>`;
        return;
      }

      if (status === 'MATCHED') {
        // MATCHED는 "채팅 시작됨" 상태라, 사용자 화면에 수락/거절 버튼이 떠야 함
        if (isUser) {
          actionArea.innerHTML =
            `<button class="accept-btn" id="acceptBtn" type="button">✓ 수락</button>
             <button class="reject-btn" id="rejectBtn" type="button">✗ 거절</button>`;
          bindAcceptReject(); // 아래 함수로 이벤트 다시 연결
        }
        if (isErrander) {
          actionArea.innerHTML = `<div class="status-wait">사용자 수락 대기중</div>`;
        }
        return;
      }

      if (status === 'WAITING') {
        // 거절 후 다시 WAITING 복귀 같은 케이스
        if (isUser) actionArea.innerHTML = `<div class="status-wait">상태: WAITING</div>`;
        if (isErrander) actionArea.innerHTML = `<div class="status-wait">상태: WAITING</div>`;
        return;
      }

      // 기타 상태
      actionArea.innerHTML = `<div class="status-wait">상태: ${status}</div>`;
    }
    
    function bindAcceptReject() {
      const actionArea = document.getElementById('actionArea');
      if (!actionArea) return;

      // 중복 바인딩 방지
      if (actionArea.dataset.bound === '1') return;
      actionArea.dataset.bound = '1';

      actionArea.addEventListener('click', function(e) {
        const btn = e.target.closest('#acceptBtn, #rejectBtn');
        if (!btn) return;

        // 수락
        if (btn.id === 'acceptBtn') {
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

        // 거절
        if (btn.id === 'rejectBtn') {
          if (!confirm('정말로 이 심부름을 거절하시겠습니까?')) return;

            const rawErranderUserId = actionArea.dataset.erranderUserId; // data-errander-user-id 값
            const erranderUserId = Number(rawErranderUserId);

            if (!rawErranderUserId || !Number.isFinite(erranderUserId) || erranderUserId <= 0) {
              alert('거절 대상 사용자 정보(erranderUserId)가 없습니다. 서버에서 erranderUserId를 내려주고 있는지 확인하세요.');
              console.error('[ERR] invalid erranderUserId', { rawErranderUserId, erranderUserId });
              return;
            }

        console.log('[DEBUG reject SEND]', { errandsId, roomId, erranderUserId });

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
            console.log('[DEBUG reject RES]', res.status, data);
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
      });
    }


    function bindProofBtn() {
      const btn = document.getElementById('proofBtn');
      if (!btn) return;

      btn.addEventListener('click', () => {
        openProofModal();
      });
    }
    
    function openProofModal(selectedFile) {
      const modal = document.getElementById('proofModal');
      const overlay = document.getElementById('proofOverlay');
      const fileInput = document.getElementById('proofFile');
      const previewWrap = document.getElementById('proofPreview');
      const previewImg = document.getElementById('proofPreviewImg');
      const fileName = document.getElementById('proofFileName');

      if (!modal) {
        alert('모달이 없습니다. proofModal HTML을 확인하세요.');
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
          // 직접 모달을 연 경우 (proofBtn을 통해)
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

   // 닫기 공통 함수
      const close = () => {
        modal.classList.remove('is-open');
        modal.setAttribute('aria-hidden', 'true');
        document.body.style.overflow = '';

        // objectURL 메모리 누수 방지(선택)
        if (previewImg?.src?.startsWith('blob:')) {
          try { URL.revokeObjectURL(previewImg.src); } catch (e) {}
        }
      };

      // 닫기/취소
      const closeBtn = document.getElementById('proofCloseBtn');
      const cancelBtn = document.getElementById('proofCancelBtn');

      closeBtn.onclick = close;
      cancelBtn.onclick = close;

      // 오버레이 클릭 닫기
      if (overlay) overlay.onclick = close;

      // ESC 닫기 (열릴 때만 1회 등록/해제)
      const onKeyDown = (e) => {
        if (e.key === 'Escape') close();
      };
      document.addEventListener('keydown', onKeyDown, { once: true });

      // 업로드
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

          // 업로드 성공 -> 모달 닫기
          close();

          const actionArea = document.getElementById('actionArea');
          if (actionArea) {
            actionArea.innerHTML = `<div class="status-wait">✅ 인증 완료</div>`;
          }

          addSystemMessageToUI('부름이가 완료 인증사진을 제출했습니다.');

        } catch (e) {
          console.error(e);
          alert('업로드 중 오류가 발생했습니다.');
        }
      };
    }


    
    function sendMessage(messageType = 'TEXT') {
        const messageText = messageInput.value.trim();
        if (!messageText) return;
        
        stompClient.send('/app/chat.send', {}, JSON.stringify({
            roomId: roomId,
            senderUserId: currentUserId,
            messageType: messageType,
            content: messageText
        }));

          messageInput.value = '';
    }  
    
    function addSystemMessageToUI(text) {
      const div = document.createElement('div');
      div.className = 'system-message';
      div.textContent = text;

      const area = document.getElementById('messagesArea');
      area.appendChild(div);
      area.scrollTop = area.scrollHeight;
    }

    function addMessageToUI(text, isMine) {
      console.log('[UI] addMessageToUI running', { text, isMine });

      const messageDiv = document.createElement('div');
      messageDiv.className = 'message ' + (isMine ? 'mine' : 'other');

      const bubble = document.createElement('div');
      bubble.className = 'message-bubble';
      bubble.textContent = text;

      const time = document.createElement('div');
      time.className = 'message-time';
      time.textContent = new Date().toLocaleTimeString('ko-KR', { hour: 'numeric', minute: '2-digit' });

      // mine이면 (시간, 말풍선), other이면 (말풍선, 시간) 유지
      if (isMine) {
        messageDiv.appendChild(time);
        messageDiv.appendChild(bubble);
      } else {
        messageDiv.appendChild(bubble);
        messageDiv.appendChild(time);
      }

      const area = document.getElementById('messagesArea');
      console.log('[UI] messagesArea found?', !!area);

      area.appendChild(messageDiv);
      area.scrollTop = area.scrollHeight;

      console.log('[UI] appended. children=', area.children.length);
    }


    // HTML 이스케이프 함수
    function escapeHtml(text) {
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return text.replace(/[&<>"']/g, function(m) { return map[m]; });
    }

    // 전송 버튼 클릭
    sendBtn.addEventListener('click', function() {
        sendMessage('TEXT');
    });

    // 엔터키로 전송
    messageInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            sendMessage('TEXT');
        }
    });

    // 첨부 버튼 클릭
    attachBtn.addEventListener('click', function() {
        // 파일 첨부 기능 구현
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = 'image/*';
        input.onchange = async () => {
            if (!input.files || input.files.length === 0) return;
            const file = input.files[0];
            
            // S3 연동 로직 추가
            const fd = new FormData();
            fd.append('roomId', roomId);
            fd.append('file', file);
            
            try {
                // TODO: 서버에 파일 업로드 엔드포인트가 필요함.
                // 현재는 /errand/chat/upload-image 같은 엔드포인트가 없으므로
                // 기존 proof 업로드 엔드포인트를 사용할 수는 없음 (용도가 다름)
                // 따라서 일단 alert로 안내
                alert('채팅방 이미지 전송 기능은 서버 엔드포인트 구현이 필요합니다.\n(현재는 인증 사진 업로드만 구현됨)');
                
                /* 
                // 추후 구현 시 예시 코드:
                const res = await fetch(contextPath + '/errand/chat/upload-image', {
                    method: 'POST',
                    body: fd,
                    credentials: 'same-origin'
                });
                
                const data = await res.json();
                if (data.success) {
                    // 이미지 URL을 받아서 채팅 메시지로 전송 (IMAGE 타입)
                    stompClient.send('/app/chat.send', {}, JSON.stringify({
                        roomId: roomId,
                        senderUserId: currentUserId,
                        messageType: 'IMAGE',
                        content: data.imageUrl // 서버에서 리턴한 S3 URL
                    }));
                }
                */
            } catch (e) {
                console.error(e);
                alert('이미지 전송 중 오류가 발생했습니다.');
            }
        };
        input.click();
    });

    // 인증 사진 버튼 클릭 (부름이만) - 거래완료(인증사진 업로드)
    if (proofBtnInput) {
      proofBtnInput.addEventListener('click', function () {
        // openProofModal();
        // 직접 파일 선택창 열기
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
    
    // 페이지 로드시 스크롤을 최하단으로
    messagesArea.scrollTop = messagesArea.scrollHeight;
    
    connectStomp();
    bindAcceptReject();
    
    // If status is CONFIRMED1, we need to bind the dynamic proofBtn if it exists
    if (document.getElementById('proofBtn')) {
        bindProofBtn();
    }
});