<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="부름 페이" />
<c:set var="pageCss" value="vroomPay" />
<c:set var="pageCssDir" value="user" />

<%@ include file="../common/header.jsp" %>

<div class="container">
  <div class="dashboard-container">
    <aside class="sidebar">
      <ul class="sidebar-menu">
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/member/myInfo" class="sidebar-link">나의 정보</a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/member/vroomPay" class="sidebar-link active">부름 페이</a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/member/myActivity" class="sidebar-link">나의 활동</a>
        </li>
        <li class="sidebar-item"><a href="#" class="sidebar-link">설정</a></li>
        <li class="sidebar-item"><a href="#" class="sidebar-link">고객지원</a></li>
      </ul>
    </aside>

    <main class="main-content">

      <h2 class="page-title">부름 페이</h2>

      <div class="pay-info-card">
        <div class="profile-section">
          <div class="profile-image-container">
            <c:choose>
              <c:when test="${not empty profile.profileImage}">
                <img src="${pageContext.request.contextPath}${profile.profileImage}" alt="프로필" style="width:100%; height:100%; object-fit:cover; border-radius:50%;">
              </c:when>
              <c:otherwise>
                <img src="${pageContext.request.contextPath}/resources/images/default_profile.png" alt="기본 프로필" style="width:100%; height:100%; object-fit:cover; border-radius:50%;">
              </c:otherwise>
            </c:choose>
          </div>
          <div class="profile-details">
            <span class="profile-nickname">${profile.nickname}</span>
            <button class="option-btn">현질 옵션 [ 내글을 상위 노출 해보세요 ]</button>
          </div>
        </div>

        <div id="account-status-container" class="account-status-container">
            <%-- JS를 통해 내용이 채워질 영역 --%>
        </div>

        <div class="temp-container">
          <span class="temp-label">매너온도</span>
          <div class="temp-bar">
            <div class="temp-fill" style="width: ${profile.mannerTemp}%;"></div>
          </div>
          <span class="temp-value">${profile.mannerTemp}℃</span>
        </div>

        <div class="balance-container" id="balanceActionContainer">
          <div class="balance-box" id="balanceBox">
            <button class="balance-action-btn" id="depositBtn" disabled>충 전</button>
            <button class="balance-action-btn" id="withdrawBtn" disabled>출 금</button>
            <div class="balance-display">
              <span class="balance-label">잔 액</span>
              <span class="balance-amount" id="balanceDisplay">-- 원</span>
            </div>
          </div>
        </div>
      </div>

      <div class="history-section">
        <div class="history-header">
          <h3 class="history-title">거래 내역 <span class="history-count">(0)</span></h3>
        </div>

        <div class="history-table-header">
          <div>내용</div>
          <div>일시</div>
          <div>금액</div>
        </div>

        <div class="history-list" id="transactionList">
          <div class="history-item">
            <div class="item-title" style="grid-column:1/-1;text-align:center;">계좌 정보를 불러오는 중입니다...</div>
          </div>
        </div>
      </div>

      <div class="pagination" id="pagination">
      </div>

    </main>
  </div>
</div>

<%-- Modal Windows --%>
<div class="modal-overlay" id="depositModal">
  <div class="modal-content">
    <div class="modal-header">
      <h3 class="modal-title">충전하기</h3>
      <button class="modal-close" id="closeDepositModal">&times;</button>
    </div>
    <div class="modal-body">
      <div class="current-balance">
        <div class="current-balance-label">현재 잔액</div>
        <div class="current-balance-amount" id="depositModalBalance">0 원</div>
      </div>
      <div class="form-warning">
        <span>금액은 숫자만 입력해주세요. 쉼표(,)는 사용할 수 없습니다.</span>
      </div>
      <div class="form-group">
        <label class="form-label">충전 금액</label>
        <input type="text" class="form-input" id="depositAmount" placeholder="예: 10000">
        <div class="form-helper">숫자만 입력하세요 (예: 10000)</div>
        <div class="form-error" id="depositError">쉼표(,)는 사용할 수 없습니다. 숫자만 입력해주세요.</div>
      </div>
      <div class="form-group">
        <label class="form-label">메모 (선택)</label>
        <input type="text" class="form-input" id="depositMemo" placeholder="내용을 입력하세요 (선택사항)">
      </div>
    </div>
    <div class="modal-footer">
      <button class="modal-btn modal-btn-cancel" id="cancelDepositBtn">취소</button>
      <button class="modal-btn modal-btn-submit" id="submitDepositBtn">충전하기</button>
    </div>
  </div>
</div>

<div class="modal-overlay" id="withdrawModal">
  <div class="modal-content">
    <div class="modal-header">
      <h3 class="modal-title">출금하기</h3>
      <button class="modal-close" id="closeWithdrawModal">&times;</button>
    </div>
    <div class="modal-body">
      <div class="current-balance">
        <div class="current-balance-label">현재 잔액</div>
        <div class="current-balance-amount" id="withdrawModalBalance">0 원</div>
      </div>
      <div class="form-warning">
        <span>금액은 숫자만 입력해주세요. 쉼표(,)는 사용할 수 없습니다.</span>
      </div>
      <div class="form-group">
        <label class="form-label">출금 금액</label>
        <input type="text" class="form-input" id="withdrawAmount" placeholder="예: 10000">
        <div class="form-helper">숫자만 입력하세요 (예: 10000). 잔액 범위 내에서만 출금 가능합니다.</div>
        <div class="form-error" id="withdrawError">쉼표(,)는 사용할 수 없습니다. 숫자만 입력해주세요.</div>
      </div>
      <div class="form-group">
        <label class="form-label">메모 (선택)</label>
        <input type="text" class="form-input" id="withdrawMemo" placeholder="내용을 입력하세요 (선택사항)">
      </div>
    </div>
    <div class="modal-footer">
      <button class="modal-btn modal-btn-cancel" id="cancelWithdrawBtn">취소</button>
      <button class="modal-btn modal-btn-submit" id="submitWithdrawBtn">출금하기</button>
    </div>
  </div>
</div>

<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="<c:url value='/static/user/js/vroomPay.js'/>"></script>

<%@ include file="../common/footer.jsp" %>
