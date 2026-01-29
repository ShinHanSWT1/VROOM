<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="심부름 상세 - VROOM" scope="request"/>
<c:set var="pageCss" value="errand-detail" scope="request"/>
<c:set var="pageCssDir" value="errand" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<section class="main-section">
    <div class="container">
        <div class="detail-grid">
            <!-- Left: Image Section + Money -->
            <div class="left-col">
                <div class="image-section">
                    <div class="errand-image">
                        <c:choose>
                            <c:when test="${not empty errand.mainImageUrl}">
                                <img src="${pageContext.request.contextPath}${errand.mainImageUrl}" alt="심부름 이미지">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/static/img/errand/noimage.png" alt="기본 이미지">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 심부름값 + 재료비: 이미지 아래로 이동 -->
                <div class="money-row-under-image">
                    <div class="money-box">
                        <h2 class="panel-title">심부름값</h2>
                        <p class="panel-content">
                            <fmt:formatNumber value="${errand.rewardAmount}" type="number" />원
                        </p>
                    </div>

                    <div class="money-box">
                        <h2 class="panel-title">재료비</h2>
                        <p class="panel-content">
                            <fmt:formatNumber value="${errand.expenseAmount}" type="number" />원
                        </p>
                    </div>
                </div>
            </div>

            <!-- Right: Info Panels -->
            <div class="info-panels">
                <div class="info-panel">
                    <h2 class="panel-title">제목</h2>
                    <p class="panel-content">
                        <c:out value="${errand.title}" />
                    </p>
                </div>

                <div class="info-panel">
                    <h2 class="panel-title">위치</h2>
                    <p class="panel-content">
                        <c:out value="${errand.dongFullName}" />
                    </p>
                </div>

                <div class="info-panel is-description" id="descPanel">
                    <h2 class="panel-title">심부름 설명</h2>
                    <p class="panel-content desc-content" id="descContent">
                        <c:out value="${errand.description}" />
                    </p>
                </div>
            </div>
        </div>

        <!-- Description Section -->
		<div class="description-section">
		
		  <!-- 작성자 카드(좌) + 채팅 버튼(우) -->
		  <div class="author-chat-row">
			  <div class="author-card-wrap">
			    <div class="author-card">
			      <div class="author-avatar-large">
			        <i class="icon-user"></i>
			      </div>
			
			      <div class="author-details">
			        <div class="author-name-large">작성자: <c:out value="${errand.userId}" /></div>
			        <div class="author-meta"><c:out value="${errand.timeAgo}" /></div>
			      </div>
			
			      <div class="author-score-inline">
			        <span class="score-label">매너점수 :</span>
			        <span class="score-value">
			          <c:choose>
			            <c:when test="${not empty errand.mannerScore}">
			              <fmt:formatNumber value="${errand.mannerScore}" maxFractionDigits="1"/>
			            </c:when>
			            <c:otherwise>-</c:otherwise>
			          </c:choose>
			        </span>
			      </div>
			    </div>
			  </div>
			
			
			
			  <div class="chat-cta">
				  <c:set var="loginUserId" value="${sessionScope.loginSess.userId}" />
				  <c:set var="isOwner" value="${loginUserId eq errand.userId}" />
				
				  <c:choose>
				
				    <c:when test="${isOwner}">
				      <form method="get" action="${pageContext.request.contextPath}/errand/chat">
				        <input type="hidden" name="errandsId" value="${errand.errandsId}" />
				        <button type="submit" class="btn btn-primary">
				          채팅하기
				        </button>
				      </form>
				    </c:when>
				
				    <c:otherwise>
				      <form method="post" action="${pageContext.request.contextPath}/errand/assign/request">
				        <input type="hidden" name="errandsId" value="${errand.errandsId}" />
				
				        <c:choose>
				          <c:when test="${errand.status eq 'WAITING'}">
				            <button type="submit" class="btn btn-primary">
				              채팅하기
				            </button>
				          </c:when>
				          <c:otherwise>
				            <button type="button" class="btn btn-secondary" disabled>
				              매칭 완료
				            </button>
				          </c:otherwise>
				        </c:choose>
				      </form>
				    </c:otherwise>
				
				  </c:choose>
				</div>
			</div>
		</div>
		
		

        <!-- Related Errands Section -->
        <div class="related-section">
            <div class="section-header">
                <h2 class="section-title">동네 일거리</h2>
            </div>

            <div class="tasks-grid">
                <c:choose>
                    <c:when test="${empty relatedErrands}">
                        <div style="grid-column: 1 / -1; color: var(--color-gray); padding: 1rem 0;">
                            근처에 등록된 심부름이 아직 없어요.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:forEach var="e" items="${relatedErrands}">
                            <div class="task-card"
                                 onclick="location.href='${pageContext.request.contextPath}/errand/detail?errandsId=${e.errandsId}'">

                                <div class="task-image">
                                    <c:choose>
                                        <c:when test="${not empty e.categoryDefaultImageUrl}">
                                            <img src="${pageContext.request.contextPath}${e.categoryDefaultImageUrl}" alt="심부름 이미지">
                                        </c:when>
                                        <c:otherwise>
                                            📦
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="task-card-content">
                                    <div class="task-card-header">
                                        <span class="task-badge">대기중</span>
                                        <span class="task-time">
                                            <c:out value="${e.createdAt}" />
                                        </span>
                                    </div>

                                    <div class="task-card-title">
                                        <c:out value="${e.title}" />
                                    </div>

                                    <div class="task-meta">
                                        <span class="task-location">
                                            <c:out value="${e.dongFullName}" />
                                        </span>
                                        <span class="task-price">
                                            <fmt:formatNumber value="${e.rewardAmount}" pattern="#,###" />원
                                        </span>
                                    </div>
                                </div>

                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</section>

<jsp:include page="../common/footer.jsp"/>

<script src="<c:url value='/static/errand/js/errand-detail.js'/>"></script>
</body>
</html>