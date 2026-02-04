<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
						  <c:set var="summaryImgUrl" value="" />

						  <c:choose>
						    <c:when test="${not empty chatRoomInfo.errandImageUrl}">
						      <c:set var="summaryImgUrl" value="${chatRoomInfo.errandImageUrl}" />
						    </c:when>

						    <c:when test="${not empty chatRoomInfo.categoryDefaultImageUrl}">
						      <c:set var="summaryImgUrl" value="${chatRoomInfo.categoryDefaultImageUrl}" />
						    </c:when>

						    <c:otherwise>
						      <c:set var="summaryImgUrl" value="/static/img/errand/noimage.png" />
						    </c:otherwise>
						  </c:choose>

						  <c:choose>
						    <c:when test="${fn:startsWith(summaryImgUrl, 'http')}">
						      <img src="${summaryImgUrl}" alt="심부름 이미지" id="errandThumbnail"
						           onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/static/img/errand/noimage.png';" />
						    </c:when>
						    <c:otherwise>
						      <img src="${pageContext.request.contextPath}${summaryImgUrl}" alt="심부름 이미지" id="errandThumbnail"
						           onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/static/img/errand/noimage.png';" />
						    </c:otherwise>
						  </c:choose>
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
				<c:set var="reviewed" value="${(not empty reviewExists and reviewExists) or (param.reviewExists eq '1')}" />
				<div class="errand-card">
				  <div class="errand-card-header">
				    <div class="section-label">💼 심부름 관리</div>

				    <div class="action-buttons" id="actionArea" data-status="${errandStatus}" data-errander-user-id="${erranderUserId}">
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

				            <c:when test="${errandStatus eq 'CONFIRMED2' or errandStatus eq 'COMPLETED'}">
							  <c:choose>
							    <c:when test="${reviewed}">
							      <button type="button" id="openReviewBtn" class="review-btn" data-reviewed="1" disabled>리뷰 완료</button>
							    </c:when>
							    <c:otherwise>
							      <button type="button" id="openReviewBtn" class="review-btn" data-reviewed="0">리뷰작성</button>
							    </c:otherwise>
							  </c:choose>
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

						    <c:when test="${errandStatus eq 'CONFIRMED2' or errandStatus eq 'COMPLETED'}">
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
					          <c:when test="${userRole eq 'OWNER' or userRole eq 'USER'}">부름이</c:when>
					          <c:when test="${userRole eq 'ERRANDER' or userRole eq 'RUNNER'}">사용자</c:when>
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
                        <button class="proof-btn" id="proofBtnInput" type="button" title="인증 사진 전송">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect>
                                <circle cx="8.5" cy="8.5" r="1.5"></circle>
                                <polyline points="21 15 16 10 5 21"></polyline>
                            </svg>
                        </button>
                    </c:if>
                    <button class="attach-btn" id="attachBtn" type="button" title="파일 첨부">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                    </button>
                    <input type="text" class="message-input" id="messageInput" placeholder="메시지를 입력하세요...">
                    <button class="send-btn" id="sendBtn" type="button">전송</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 외부 라이브러리 -->
	<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

	<!-- 전역 설정값 (JS에서 사용) -->
	<script>
		const roomId = ${roomId};
		const errandsId = ${errandsId};
		const currentUserId = ${currentUserId};
		const userRole = '${userRole}';
		const contextPath = '${pageContext.request.contextPath}';
		const errandStatus = '${errandStatus}';
		const reviewExists = ('${reviewExists}' === 'true') || ('${param.reviewExists}' === '1');
	</script>

	<!-- 채팅 로직 (외부 JS 파일) -->
	<script src="${pageContext.request.contextPath}/static/errand/js/errand_chat.js"></script>

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

	<!-- ===== 리뷰 작성 모달 ===== -->
	<div id="reviewModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.45); z-index:9999; align-items:center; justify-content:center;">
	  <div style="width:420px; background:#fff; border-radius:16px; padding:18px;">
	    <div style="font-weight:800; font-size:18px;">리뷰 작성</div>

	    <div id="ratingRow" data-rating="0" style="margin-top:12px; display:flex; align-items:center; gap:6px;">
	      <span class="star" data-v="1" style="font-size:22px; cursor:pointer; opacity:0.35;">★</span>
	      <span class="star" data-v="2" style="font-size:22px; cursor:pointer; opacity:0.35;">★</span>
	      <span class="star" data-v="3" style="font-size:22px; cursor:pointer; opacity:0.35;">★</span>
	      <span class="star" data-v="4" style="font-size:22px; cursor:pointer; opacity:0.35;">★</span>
	      <span class="star" data-v="5" style="font-size:22px; cursor:pointer; opacity:0.35;">★</span>
	      <span id="ratingText" style="margin-left:10px; font-size:14px; opacity:0.75;">별점을 선택하세요</span>
	    </div>

	    <textarea id="reviewComment" maxlength="1000"
	              placeholder="리뷰 내용을 입력하세요 (선택)"
	              style="margin-top:12px; width:100%; min-height:110px; border-radius:12px; border:1px solid #eee; padding:12px; resize:none;"></textarea>

	    <div style="margin-top:14px; display:flex; justify-content:flex-end; gap:10px;">
	      <button type="button" id="reviewCancelBtn">취소</button>
	      <button type="button" id="reviewSubmitBtn">등록</button>
	    </div>
	  </div>
	</div>
</body>

</html>