<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"/>
  <title>이미 매칭됨</title>
</head>
<body style="padding:24px; font-family: sans-serif;">
  <h2>이미 매칭된 페이지입니다.</h2>
  <p><c:out value="${message}"/></p>
  <a href="${pageContext.request.contextPath}/errand/list">목록으로 돌아가기</a>
</body>
</html>
