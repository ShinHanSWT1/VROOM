<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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
                        <div class="detail-item">
                            <span class="detail-label">상태</span>
                            <span class="status-badge" id="errandStatus">${chatRoomInfo.status}</span>
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
                                <c:when test="${userRole eq 'OWNER'}">심부름 작성자</c:when>
                                <c:when test="${userRole eq 'ERRANDER'}">부름이</c:when>
                                <c:otherwise>${userRole}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- 역할별 액션 버튼 카드 -->
                <c:if test="${userRole eq 'OWNER'}">
                    <div class="errand-card">
                        <div class="section-label">💼 심부름 관리</div>
                        <div class="action-buttons">
                            <button class="accept-btn" id="acceptBtn">✓ 수락</button>
                            <button class="reject-btn" id="rejectBtn">✗ 거절</button>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- 우측 패널: 채팅 -->
            <div class="right-panel">
                <!-- 채팅 헤더 (고정) -->
                <div class="chat-header">
                    <div class="chat-user-info">
                        <h3 id="chatPartnerName">${chatRoomInfo.partnerNickname}</h3>
                        <div class="chat-user-status">
                            <c:choose>
                                <c:when test="${userRole eq 'OWNER'}">부름이</c:when>
                                <c:when test="${userRole eq 'ERRANDER'}">심부름 작성자</c:when>
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
                                <div class="system-message">${msg.content}</div>
                            </c:when>
                            <c:otherwise>
                                <div class="message ${msg.isMine ? 'mine' : 'other'}">
                                    <c:if test="${!msg.isMine}">
                                        <div class="message-bubble">${msg.content}</div>
                                    </c:if>
                                    <div class="message-time">
                                        <fmt:formatDate value="${msg.createdAt}" pattern="a h:mm"/>
                                    </div>
                                    <c:if test="${msg.isMine}">
                                        <div class="message-bubble">${msg.content}</div>
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

    <script>
        // 채팅 관련 JavaScript
        const roomId = ${roomId};
        const errandsId = ${errandsId};
        const currentUserId = ${currentUserId};
        const userRole = '${userRole}';
        const contextPath = '${pageContext.request.contextPath}';

        document.addEventListener('DOMContentLoaded', function() {
            const messageInput = document.getElementById('messageInput');
            const sendBtn = document.getElementById('sendBtn');
            const messagesArea = document.getElementById('messagesArea');
            const attachBtn = document.getElementById('attachBtn');
            const proofBtn = document.getElementById('proofBtn');
            const acceptBtn = document.getElementById('acceptBtn');
            const rejectBtn = document.getElementById('rejectBtn');

            // 메시지 전송 함수
            function sendMessage(messageType = 'TEXT') {
                const messageText = messageInput.value.trim();
                if (!messageText && messageType === 'TEXT') return;

                // 서버로 메시지 전송
                fetch(contextPath + '/errand/chat/send', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        roomId: roomId,
                        content: messageText,
                        messageType: messageType
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // UI에 메시지 추가
                        addMessageToUI(messageText, true);
                        messageInput.value = '';
                        messagesArea.scrollTop = messagesArea.scrollHeight;
                    } else {
                        alert('메시지 전송 실패');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('메시지 전송 중 오류가 발생했습니다.');
                });
            }

            // UI에 메시지 추가
            function addMessageToUI(text, isMine) {
                const now = new Date();
                const hours = now.getHours();
                const minutes = now.getMinutes();
                const ampm = hours >= 12 ? '오후' : '오전';
                const displayHours = hours > 12 ? hours - 12 : (hours === 0 ? 12 : hours);
                const timeString = ampm + ' ' + displayHours + ':' + (minutes < 10 ? '0' + minutes : minutes);

                const messageDiv = document.createElement('div');
                messageDiv.className = 'message ' + (isMine ? 'mine' : 'other');
                
                if (isMine) {
                    messageDiv.innerHTML = `
                        <div class="message-time">${timeString}</div>
                        <div class="message-bubble"><c:out value="${msg.content}"/></div>
                    `;
                } else {
                    messageDiv.innerHTML = `
                        <div class="message-bubble"><c:out value="${msg.content}"/></div>
                        <div class="message-time">${timeString}</div>
                    `;
                }

                messagesArea.appendChild(messageDiv);
                messagesArea.scrollTop = messagesArea.scrollHeight;
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

            // 인증 사진 버튼 클릭 (부름이만)
            if (proofBtn) {
                proofBtn.addEventListener('click', function() {
                    alert('인증 사진 업로드 기능은 추후 구현 예정입니다.');
                    // 실제 구현시에는 파일 선택 후 PROOF_IMAGE 타입으로 전송
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
                            roomId: roomId,
                            erranderUserId: currentUserId
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

            // 페이지 로드시 스크롤을 최하단으로
            messagesArea.scrollTop = messagesArea.scrollHeight;

            // 주기적으로 새 메시지 확인 (폴링 - 실제로는 WebSocket 사용 권장)
            setInterval(function() {
                // loadNewMessages();
            }, 5000);
        });
    </script>
</body>

</html>
