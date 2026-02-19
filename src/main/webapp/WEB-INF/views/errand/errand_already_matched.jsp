<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"/>
  <title>매칭 완료</title>
</head>
<body>
    <div class="message-container">
        <div class="icon">⚠️</div>
        <h2>이미 매칭된 심부름입니다</h2>
        <p class="message-text">
            <c:choose>
                <c:when test="${not empty message}">
                    ${message}
                </c:when>
                <c:otherwise>
                    다른 부름이가 이미 이 심부름에 대해 채팅을 진행 중입니다.<br>
                    다른 심부름을 찾아보세요!
                </c:otherwise>
            </c:choose>
        </p>
        <div class="button-group">
            <a href="${pageContext.request.contextPath}/errand/list" class="btn btn-primary">
                심부름 목록으로
            </a>
            <a href="javascript:history.back();" class="btn btn-secondary">
                이전 페이지
            </a>
        </div>
    </div>
</body>
</html>
