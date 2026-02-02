<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"></head>
<body>
<script>
  alert("<%= request.getAttribute("message") %>");
  location.href = "<%= request.getAttribute("redirectUrl") %>";
</script>
</body>
</html>
