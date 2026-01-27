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
                            <img src="${pageContext.request.contextPath}/static/img/errand/noimage.png" 
                                 alt="심부름 이미지" id="errandThumbnail">
                        </div>
                        <div class="errand-basic-info">
                            <div class="errand-title" id="errandTitle">강남역 서류 전달</div>
                            <div class="errand-location" id="errandLocation">📍 서울 강남구 역삼동</div>
                            <div class="errand-price">
                                <div class="price-item">
                                    <span class="price-label">심부름값</span>
                                    <span class="price-value" id="errandReward">5,000원</span>
                                </div>
                                <div class="price-item">
                                    <span class="price-label">재료비</span>
                                    <span class="price-value" id="errandMaterialCost">10,000원</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 제목 카드 -->
                <div class="errand-card">
                    <div class="section-label">📋 제목</div>
                    <div class="description-text" style="font-weight: 600; margin-bottom: 12px;" id="errandFullTitle">
                        강남역 서류 전달 부탁드려요
                    </div>
                </div>

                <!-- 심부름 설명 카드 -->
                <div class="errand-card">
                    <div class="section-label">📝 심부름 설명</div>
                    <div class="description-text" id="errandDescription">
                        안녕하세요! 강남역 근처 사무실로 중요한 서류를 전달해주실 분을 찾습니다. 
                        시간 약속을 잘 지켜주시는 분이면 좋겠습니다.
                    </div>
                </div>

                <!-- 위치 카드 -->
                <div class="errand-card">
                    <div class="section-label">📍 위치</div>
                    <div class="description-text" style="margin-bottom: 16px;" id="errandLocationDetail">
                        서울 관악구 신림동 → 서울 강남구 역삼동
                    </div>

                    <div class="errand-details">
                        <div class="detail-item">
                            <span class="detail-label">심부름값 / 재료비</span>
                            <span class="detail-value" id="errandPriceDetail">5,000원 / 10,000원</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">카테고리</span>
                            <span class="detail-value" id="errandCategory">서류 전달</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">상태</span>
                            <span class="status-badge" id="errandStatus">진행중</span>
                        </div>
                    </div>
                </div>

                <!-- 추가 정보 카드 -->
                <div class="errand-card">
                    <div class="section-label">⏰ 상태 표시</div>
                    <div class="detail-item">
                        <span class="detail-label">매칭 상태</span>
                        <span class="status-badge" id="matchStatus">✓ 매칭됨</span>
                    </div>
                </div>
            </div>

            <!-- 우측 패널: 채팅 -->
            <div class="right-panel">
                <!-- 채팅 헤더 (고정) -->
                <div class="chat-header">
                    <div class="chat-user-info">
                        <h3 id="chatPartnerName">김심부름</h3>
                        <div class="chat-user-status">채팅 상대 / 현재 상태</div>
                    </div>
                </div>

                <!-- 메시지 영역 (스크롤) -->
                <div class="messages-area" id="messagesArea">
                    <div class="date-divider">
                        <span id="chatDate">2026년 1월 26일 일요일</span>
                    </div>

                    <div class="system-message">
                        시스템 메시지: 심부름이 매칭되었습니다
                    </div>

                    <!-- 메시지들은 여기에 동적으로 추가됩니다 -->
                    <div class="message other">
                        <div class="message-bubble">
                            안녕하세요! 심부름 매칭되었네요. 
                            오늘 오후 3시에 강남역 10번 출구 괜찮으신가요?
                        </div>
                        <div class="message-time">오후 2:15</div>
                    </div>

                    <div class="message mine">
                        <div class="message-time">오후 2:17</div>
                        <div class="message-bubble">
                            네! 좋습니다. 3시에 뵙겠습니다 😊
                        </div>
                    </div>

                    <div class="message other">
                        <div class="message-bubble">
                            감사합니다! 그럼 조금 이따 봬요~
                        </div>
                        <div class="message-time">오후 2:18</div>
                    </div>
                </div>

                <!-- 입력 영역 (하단 고정) -->
                <div class="input-area">
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
        document.addEventListener('DOMContentLoaded', function() {
            const messageInput = document.getElementById('messageInput');
            const sendBtn = document.getElementById('sendBtn');
            const messagesArea = document.getElementById('messagesArea');
            const attachBtn = document.getElementById('attachBtn');

            // 메시지 전송 함수
            function sendMessage() {
                const messageText = messageInput.value.trim();
                if (!messageText) return;

                // 현재 시간
                const now = new Date();
                const hours = now.getHours();
                const minutes = now.getMinutes();
                const ampm = hours >= 12 ? '오후' : '오전';
                const displayHours = hours > 12 ? hours - 12 : (hours === 0 ? 12 : hours);
                const timeString = ampm + ' ' + displayHours + ':' + (minutes < 10 ? '0' + minutes : minutes);

                // 메시지 엘리먼트 생성
                const messageDiv = document.createElement('div');
                messageDiv.className = 'message mine';
                messageDiv.innerHTML = `
                    <div class="message-time">${timeString}</div>
                    <div class="message-bubble">${escapeHtml(messageText)}</div>
                `;

                // 메시지 추가
                messagesArea.appendChild(messageDiv);

                // 입력창 초기화
                messageInput.value = '';

                // 스크롤을 최하단으로
                messagesArea.scrollTop = messagesArea.scrollHeight;

                // 실제 구현시에는 여기서 서버로 메시지 전송
                // sendMessageToServer(messageText);
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
            sendBtn.addEventListener('click', sendMessage);

            // 엔터키로 전송
            messageInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });

            // 첨부 버튼 클릭
            attachBtn.addEventListener('click', function() {
                alert('파일 첨부 기능은 추후 구현 예정입니다.');
                // 실제 구현시에는 파일 선택 다이얼로그 표시
            });

            // 페이지 로드시 스크롤을 최하단으로
            messagesArea.scrollTop = messagesArea.scrollHeight;

            // 실제 구현시에는 여기서 서버로부터 심부름 정보와 채팅 내역을 가져와야 함
            // loadErrandInfo();
            // loadChatHistory();
        });
    </script>
</body>

</html>
