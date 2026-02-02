<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>채팅하기 - VROOM</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/errand/css/errand_chat.css">
</head>

<body>
    <!-- 헤더 -->
    <header class="header">
        <div class="header-container">
            <div class="logo">
                <h1 onclick="location.href='${pageContext.request.contextPath}/'">VROOM</h1>
            </div>
            <nav class="nav-menu">
                <a href="${pageContext.request.contextPath}/errand/list" class="nav-item">심부름 목록</a>
                <a href="${pageContext.request.contextPath}/community" class="nav-item">커뮤니티</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.loginSess}">
                        <span class="nav-item nav-user">${sessionScope.loginSess.nickname}님</span>
                        <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item">로그아웃</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/auth/login" class="nav-item nav-login">로그인</a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>

    <!-- 채팅 컨테이너 -->
    <div class="chat-container">
        <div class="chat-layout">
            <!-- 좌측 패널: 심부름 요약 -->
            <div class="left-panel">
                <!-- 썸네일 + 기본정보 카드 -->
                <div class="errand-card">
                    <div class="errand-thumbnail-section">
                        <div class="errand-thumbnail">
                            <img src="${pageContext.request.contextPath}${chatRoomInfo.errandImageUrl}"
                                 alt="심부름 이미지" id="errandThumbnail">
                        </div>
                        <div class="errand-basic-info">
                            <div class="errand-title" id="errandTitle">${chatRoomInfo.errandTitle}</div>
                            <div class="errand-location" id="errandLocation">📍 ${chatRoomInfo.errandLocation}</div>
                            <div class="errand-price">
                                <div class="price-item">
                                    <span class="price-value" id="errandReward">
									    <c:choose>
									      <c:when test="${not empty chatRoomInfo && not empty chatRoomInfo.rewardAmount}">
									        <fmt:formatNumber value="${chatRoomInfo.rewardAmount}" pattern="#,##0"/>
									      </c:when>
									      <c:otherwise>0</c:otherwise>
									    </c:choose>원
									  </span>
                                </div>
                                <c:if test="${not empty chatRoomInfo.expenseAmount}">
                                    <div class="price-item">
                                        <span class="price-label">재료비</span>
                                        <span class="price-value" id="errandMaterialCost">
                                            <fmt:formatNumber value="${chatRoomInfo.expenseAmount}" pattern="#,##0"/>원
                                        </span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 제목 카드 -->
                <div class="errand-card">
                    <div class="section-label">📋 제목</div>
                    <div class="description-text" style="font-weight: 600; margin-bottom: 12px;" id="errandFullTitle">
                        ${chatRoomInfo.errandTitle}
                    </div>
                </div>

                <!-- 심부름 설명 카드 -->
                <div class="errand-card">
                    <div class="section-label">📝 심부름 설명</div>
                    <div class="description-text" id="errandDescription">
                        ${chatRoomInfo.errandDescription}
                    </div>
                </div>

                <!-- 위치 카드 -->
                <div class="errand-card">
                    <div class="section-label">📍 위치</div>
                    <div class="description-text" style="margin-bottom: 16px;" id="errandLocationDetail">
                        ${chatRoomInfo.errandLocation}
                    </div>

                    <div class="errand-details">
                        <div class="detail-item">
                            <span class="detail-label">심부름값 / 재료비</span>
                            <span class="detail-value" id="errandPriceDetail">
                                <fmt:formatNumber value="${chatRoomInfo.rewardAmount}" pattern="#,##0"/>원 / 
                                <c:choose>
                                    <c:when test="${not empty chatRoomInfo.expenseAmount}">
                                        <fmt:formatNumber value="${chatRoomInfo.expenseAmount}" pattern="#,##0"/>원
                                    </c:when>
                                    <c:otherwise>0원</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- 추가 정보 카드 -->
                <div class="errand-card">
                    <div class="section-label">⏰ 채팅 상태</div>
                    <div class="detail-item">
                        <span class="detail-label">나의 역할</span>
                        <span class="status-badge" id="userRoleDisplay">
                            <c:choose>
                                <c:when test="${userRole eq 'USER' or userRole eq 'OWNER'}">사용자</c:when>
                                <c:when test="${userRole eq 'ERRANDER'}">부름이</c:when>
                                <c:otherwise>${userRole}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                
                
                <!-- 역할별 액션 버튼 카드 -->
				<div class="errand-card">
				  <div class="errand-card-header">
				    <div class="section-label">💼 심부름 관리</div>				    
				
				    <div class="action-buttons" id="actionArea" data-status="${errandStatus}">
				      <c:choose>
				
				        <c:when test="${userRole eq 'USER' or userRole eq 'OWNER'}">
				          <c:choose>
				            <c:when test="${errandStatus eq 'MATCHED'}">
				              <button class="accept-btn" id="acceptBtn" type="button">✓ 수락</button>
				              <button class="reject-btn" id="rejectBtn" type="button">✗ 거절</button>
				            </c:when>
				
				            <c:when test="${errandStatus eq 'CONFIRMED1'}">
						      <div class="status-wait">⏳ 심부름 중</div>
						    </c:when>
				
				            <c:when test="${errandStatus eq 'CONFIRMED2'}">
				              <div class="status-done">거래 완료</div>
				            </c:when>
				          </c:choose>
				        </c:when>
				
				        <c:when test="${userRole eq 'ERRANDER' or userRole eq 'RUNNER'}">
						  <c:choose>
						    <c:when test="${errandStatus eq 'MATCHED'}">
						      <div class="status-wait">사용자 수락 대기중</div>
						    </c:when>
						
						    <c:when test="${errandStatus eq 'CONFIRMED1'}">
						      <button class="complete-btn" id="proofBtn" type="button">✔ 거래완료</button>
						    </c:when>
						
						    <c:when test="${errandStatus eq 'CONFIRMED2'}">
						      <div class="status-done">거래 완료</div>
						    </c:when>
						  </c:choose>
						</c:when>
				
				        <c:otherwise>
				          <div class="status-wait">심부름 진행중</div>
				        </c:otherwise>
				
				      </c:choose>
				    </div>
				  </div>
				</div>


            </div>

            <!-- 우측 패널: 채팅 -->
            <div class="right-panel">
                <!-- 채팅 헤더 (고정) -->
				<div class="chat-header">
				  <div class="chat-header-row">
				
				    <!-- 왼쪽: 닉네임/온도/역할 -->
					  <div class="chat-user-info">
					    <div class="chat-user-text">
					      <div class="chat-user-name-row">
					        <h3 id="chatPartnerName">${chatRoomInfo.partnerNickname}</h3>
					
					        <c:if test="${not empty chatRoomInfo.partnerMannerScore}">
					          <span class="manner-inline">
					            / <fmt:formatNumber value="${chatRoomInfo.partnerMannerScore}" maxFractionDigits="1" />℃
					          </span>
					        </c:if>
					      </div>
					
					      <div class="chat-user-status">
					        <c:choose>
					          <c:when test="${userRole eq 'OWNER'}">사용자</c:when>
					          <c:when test="${userRole eq 'ERRANDER'}">부름이</c:when>
					        </c:choose>
					      </div>
					    </div>
					  </div>
				
				    <!-- 오른쪽: 프로필 이미지 -->
				    <div class="chat-user-avatar-right">
					  <c:choose>
					    <c:when test="${not empty chatRoomInfo.partnerProfileImage}">
					      <img src="${pageContext.request.contextPath}${chatRoomInfo.partnerProfileImage}" alt="상대 프로필" />
					    </c:when>
					    <c:otherwise>
					      <img src="${pageContext.request.contextPath}/static/img/logo.png" alt="기본 프로필" />
					    </c:otherwise>
					  </c:choose>
					</div>
				
				  </div>
				</div>



                <!-- 메시지 영역 (스크롤) -->
                <div class="messages-area" id="messagesArea">
                    <div class="date-divider">
                        <jsp:useBean id="now" class="java.util.Date" />
                        <fmt:formatDate value="${now}" pattern="yyyy년 MM월 dd일 EEEE" var="todayDate"/>
                        <span id="chatDate">${todayDate}</span>
                    </div>

                    <!-- 기존 메시지들 표시 -->
                    <c:forEach var="msg" items="${messages}">
                        <c:choose>
                            <c:when test="${msg.messageType eq 'SYSTEM'}">
                                <div class="system-message"><c:out value="${msg.content}"/></div>
                            </c:when>
                            <c:otherwise>
                                <div class="message ${msg.isMine ? 'mine' : 'other'}">
                                    <c:if test="${!msg.isMine}">
                                        <div class="message-bubble"><c:out value="${msg.content}"/></div>
                                    </c:if>
                                    <div class="message-time">
                                        <fmt:formatDate value="${msg.createdAt}" pattern="a h:mm"/>
                                    </div>
                                    <c:if test="${msg.isMine}">
                                        <div class="message-bubble"><c:out value="${msg.content}"/></div>
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>

                <!-- 입력 영역 (하단 고정) -->
                <div class="input-area">
                    <c:if test="${userRole eq 'ERRANDER'}">
                        <button class="proof-btn" id="proofBtn" title="인증 사진 전송">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                <polyline points="21 15 16 10 5 21"></polyline>
                            </svg>
                        </button>
                    </c:if>
                    <button class="attach-btn" id="attachBtn" title="파일 첨부">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                    </button>
                    <input type="text" class="message-input" id="messageInput" placeholder="메시지를 입력하세요...">
                    <button class="send-btn" id="sendBtn">전송</button>
                </div>
            </div>
        </div>
    </div>
	
	<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
    <script>
        // 채팅 관련 JavaScript
        const roomId = ${roomId};
        const errandsId = ${errandsId};
        const currentUserId = ${currentUserId};
        const userRole = '${userRole}';
        const contextPath = '${pageContext.request.contextPath}';
        const assignmentStatus = '${assignmentStatus}'; 


        document.addEventListener('DOMContentLoaded', function() {
            const messageInput = document.getElementById('messageInput');
            const sendBtn = document.getElementById('sendBtn');
            const messagesArea = document.getElementById('messagesArea');
            const attachBtn = document.getElementById('attachBtn');
            const proofBtn = document.getElementById('proofBtn');
            const acceptBtn = document.getElementById('acceptBtn');
            const rejectBtn = document.getElementById('rejectBtn');
            
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
           	  const acceptBtn2 = document.getElementById('acceptBtn');
           	  const rejectBtn2 = document.getElementById('rejectBtn');

           	  if (acceptBtn2) {
           	    acceptBtn2.addEventListener('click', function() {
           	      if (!confirm('이 부름이와 심부름을 진행하시겠습니까?')) return;

           	      fetch(contextPath + '/errand/chat/accept', {
           	        method: 'POST',
           	        headers: { 'Content-Type': 'application/json' },
           	        credentials: 'same-origin',
           	        body: JSON.stringify({ errandsId: errandsId, roomId: roomId })
           	      })
           	      .then(res => res.json())
           	      .then(data => {
           	        if (data.success) {
           	          alert('심부름이 수락되었습니다!');
           	          // 서버가 STATUS를 뿌려주면 부름이 화면이 즉시 proofBtn으로 바뀜.
           	        } else {
           	          alert(data.error || '수락 처리 실패');
           	        }
           	      })
           	      .catch(err => {
           	        console.error(err);
           	        alert('수락 처리 중 오류가 발생했습니다.');
           	      });
           	    });
           	  }

           	  if (rejectBtn2) {
           	    rejectBtn2.addEventListener('click', function() {
           	      if (!confirm('정말로 이 심부름을 거절하시겠습니까?')) return;

           	      fetch(contextPath + '/errand/chat/reject', {
           	        method: 'POST',
           	        headers: { 'Content-Type': 'application/json' },
           	        credentials: 'same-origin',
           	        body: JSON.stringify({ errandsId: errandsId, roomId: roomId })
           	      })
           	      .then(res => res.json())
           	      .then(data => {
           	        if (data.success) {
           	          alert('심부름이 거절되었습니다.');
           	          // 거절도 STATUS WAITING을 서버에서 뿌려주면 화면 자동 동기화 가능
           	        } else {
           	          alert(data.error || '거절 처리 실패');
           	        }
           	      })
           	      .catch(err => {
           	        console.error(err);
           	        alert('거절 처리 중 오류가 발생했습니다.');
           	      });
           	    });
           	  }
           	}

            function bindProofBtn() {
           	  const btn = document.getElementById('proofBtn');
           	  if (!btn) return;

           	  btn.addEventListener('click', () => {
           	    openProofModal();
           	  });
           	}
            
            function openProofModal() {
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
           	  previewWrap.style.display = 'none';
           	  previewImg.src = '';
           	  fileName.textContent = '';

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
                alert('파일 첨부 기능은 추후 구현 예정입니다.');
            });

            // 인증 사진 버튼 클릭 (부름이만) - 거래완료(인증사진 업로드)
			if (proofBtn) {
			  proofBtn.addEventListener('click', async function () {
			    // 파일 선택창
			    const input = document.createElement('input');
			    input.type = 'file';
			    input.accept = 'image/*';
			
			    input.onchange = async () => {
			      if (!input.files || input.files.length === 0) return;
			
			      const file = input.files[0];
			
			      const form = new FormData();
			      form.append('errandsId', errandsId);
			      form.append('roomId', roomId);
			      form.append('proofImage', file);
			
			      try {
			        const res = await fetch(contextPath + '/errand/assign/complete-proof', {
			          method: 'POST',
			          credentials: 'same-origin',
			          body: form
			        });
			
			        const text = await res.text();
			        if (!res.ok) {
			          console.error('HTTP ERROR', res.status, text);
			          alert(`서버 오류 (${res.status})`);
			          return;
			        }
			
			        let data;
			        try { data = JSON.parse(text); }
			        catch (e) {
			          console.error('JSON 파싱 실패:', text);
			          alert('서버 응답이 JSON이 아닙니다.');
			          return;
			        }
			
			        if (data.success !== true) {
			          alert(data.error || data.message || '인증 업로드 실패');
			          return;
			        }
			
			        alert('인증사진 업로드 완료!');
			        location.reload();
			
			      } catch (e) {
			        console.error(e);
			        alert('인증 업로드 중 오류가 발생했습니다.');
			      }
			    };
			
			    input.click();
			  });
			}

            // 수락 버튼 클릭 (OWNER만)
            if (acceptBtn) {
                acceptBtn.addEventListener('click', function() {
                    if (!confirm('이 부름이와 심부름을 진행하시겠습니까?')) {
                        return;
                    }

                    fetch(contextPath + '/errand/chat/accept', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            errandsId: errandsId,
                            roomId: roomId
                        })
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('심부름이 수락되었습니다!');
                            location.reload();
                        } else {
                            alert(data.error || '수락 처리 실패');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('수락 처리 중 오류가 발생했습니다.');
                    });
                });
            }

            // 거절 버튼 클릭 (OWNER만)
            if (rejectBtn) {
                rejectBtn.addEventListener('click', function() {
                    if (!confirm('정말로 이 심부름을 거절하시겠습니까?')) {
                        return;
                    }

                    fetch(contextPath + '/errand/chat/reject', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            errandsId: errandsId,
                            roomId: roomId
                        })
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('심부름이 거절되었습니다.');
                            location.href = contextPath + '/errand/detail?errandsId=' + errandsId;
                        } else {
                            alert(data.error || '거절 처리 실패');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('거절 처리 중 오류가 발생했습니다.');
                    });
                });
            }
            
         	// 수락 AJAX 성공했을 때
            function showCompleteButton() {
              const area = document.getElementById('actionArea'); // 버튼 영역 div id
              area.innerHTML = `<button id="completeConfirmBtn" class="complete-btn" type="button">✔ 거래 완료</button>`;
              bindCompleteConfirm();
            }
         	
            function bindProofUpload() {
           	  const proofBtn = document.getElementById('proofBtn');
           	  if (!proofBtn) return;

           	  proofBtn.addEventListener('click', async () => {
           	    // 파일 선택창 띄우기
           	    const input = document.createElement('input');
           	    input.type = 'file';
           	    input.accept = 'image/*';

           	    input.onchange = async () => {
           	      if (!input.files || input.files.length === 0) return;

           	      const file = input.files[0];

           	      const form = new FormData();
           	      form.append('errandsId', errandsId);
           	      form.append('roomId', roomId);
           	      form.append('proofImage', file);

           	      try {
           	        const res = await fetch(contextPath + '/errand/chat/assign/complete-proof', {
           	          method: 'POST',
           	          credentials: 'same-origin',
           	          body: form
           	        });

           	        const text = await res.text();
           	        if (!res.ok) {
           	          console.error('HTTP ERROR', res.status, text);
           	          alert(`서버 오류 (${res.status})`);
           	          return;
           	        }

           	        let data;
           	        try { data = JSON.parse(text); }
           	        catch (e) {
           	          console.error('JSON 파싱 실패:', text);
           	          alert('서버 응답이 JSON이 아닙니다.');
           	          return;
           	        }

           	        if (data.success !== true) {
           	          alert(data.message || data.error || '인증 업로드 실패');
           	          return;
           	        }

           	        alert('인증사진 업로드 완료!');
           	        location.reload();

           	      } catch (e) {
           	        console.error(e);
           	        alert('인증 업로드 중 오류가 발생했습니다.');
           	      }
           	    };

           	    input.click();
           	  }, { once: true });
           	}

         	
            function bindCompleteConfirm() {
            	  const btn = document.getElementById('completeConfirmBtn');
            	  if (!btn) return;

            	  btn.addEventListener('click', async () => {
            	    try {
           	    	  const url = contextPath + '/errand/chat/assign/complete-confirm';
            	      console.log('POST URL=', url);

            	      const res = await fetch(url, {
            	        method: 'POST',
            	        headers: { 'Content-Type': 'application/json' },
            	        credentials: 'same-origin', // 이거 없으면 loginSess null 뜰 수 있음
            	        body: JSON.stringify({ errandsId, roomId })
            	      });

            	      const text = await res.text();

            	      // 404/500이면 여기서 바로 잡힘
            	      if (!res.ok) {
            	        console.error('HTTP ERROR', res.status, text);
            	        alert(`서버 오류 (${res.status})`);
            	        return;
            	      }

            	      // JSON 파싱 방어
            	      let data;
            	      try { data = JSON.parse(text); }
            	      catch (e) {
            	        console.error('JSON 파싱 실패:', text);
            	        alert('서버 응답이 JSON이 아닙니다.');
            	        return;
            	      }

            	      // 서버 응답 표준화: success 기준으로만 판단(네 컨트롤러는 success를 씀)
            	      if (data.success !== true) {
            	        alert(data.message || data.error || '거래 완료 처리 실패');
            	        return;
            	      }

            	      document.getElementById('actionArea').innerHTML =
            	        `<div class="status-done">거래 완료</div>`;

            	    } catch (e) {
            	      console.error(e);
            	      alert('거래 완료 처리 중 오류가 발생했습니다.');
            	    }
            	  }, { once: true });
            	}


           	
            // 페이지 로드시 스크롤을 최하단으로
            messagesArea.scrollTop = messagesArea.scrollHeight;
            
            connectStomp();
            bindCompleteConfirm();
            bindProofUpload();
        });
    </script>
    <!-- ===== 인증사진 업로드 모달 (ERRANDER 전용) ===== -->
	<div id="proofModal" class="v-modal" aria-hidden="true">
	  <!-- 화면 전체 오버레이 (클릭 시 닫기) -->
	  <div class="v-modal__overlay" id="proofOverlay"></div>
	
	  <!-- 중앙 패널 -->
	  <div class="v-modal__panel" role="dialog" aria-modal="true" aria-labelledby="proofModalTitle">
	    <div class="v-modal__header">
	      <h3 id="proofModalTitle" class="v-modal__title">완료 인증 사진 업로드</h3>
	      <button type="button" id="proofCloseBtn" class="v-modal__close">✕</button>
	    </div>
	
	    <div class="v-modal__body">
	      <div class="proof-upload">
	        <input type="file" id="proofFile" accept="image/*" />
	
	        <div class="proof-filemeta">
	          <span id="proofFileName" class="proof-filename"></span>
	        </div>
	
	        <div id="proofPreview" class="proof-preview" style="display:none;">
	          <img id="proofPreviewImg" alt="미리보기" />
	        </div>
	      </div>
	    </div>
	
	    <div class="v-modal__footer">
	      <button type="button" id="proofCancelBtn" class="v-btn v-btn--ghost">취소</button>
	      <button type="button" id="proofSubmitBtn" class="v-btn v-btn--primary">업로드</button>
	    </div>
	  </div>
	</div>
	<div id="proofModal" class="v-modal" aria-hidden="true">
	  <div class="v-modal__overlay" onclick="closeProofModal()"></div>
	
	  <div class="v-modal__panel" role="dialog" aria-modal="true" aria-labelledby="proofModalTitle">
	    <div class="v-modal__header">
	      <h3 id="proofModalTitle" class="v-modal__title">완료 인증 사진 업로드</h3>
	      <button type="button" class="v-modal__close" onclick="closeProofModal()">✕</button>
	    </div>
	
	    <div class="v-modal__body">
	      <!-- 너가 기존에 쓰던 proofUploadInner / preview 영역 그대로 넣으면 됨 -->
	      <div id="proofUploadInner">
	        <input type="file" id="proofFile" accept="image/*">
	        <div id="proofPreview" style="display:none; margin-top:12px;">
	          <img id="proofPreviewImg" alt="preview" style="max-width:100%; border-radius:12px;">
	        </div>
	      </div>
	    </div>
	
	    <div class="v-modal__footer">
	      <button type="button" class="v-btn v-btn--ghost" onclick="closeProofModal()">취소</button>
	      <button type="button" id="proofSubmitBtn" class="v-btn v-btn--primary">업로드</button>
	    </div>
	  </div>
	</div>
    
</body>

</html>
