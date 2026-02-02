<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-info">
                    <h3>우리동네 심부름</h3>
                    <p>이웃과 함께하는 따뜻한 심부름 커뮤니티</p>
                </div>
                <div class="footer-links">
                    <a href="<c:url value='/about'/>">회사소개</a>
                    <a href="<c:url value='/terms'/>">이용약관</a>
                    <a href="<c:url value='/privacy'/>">개인정보처리방침</a>
                    <a href="<c:url value='/contact'/>">문의하기</a>
                </div>
                <div class="footer-copyright">
                    <p>&copy; 2024 우리동네 심부름. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>
    
    <!-- 페이지별 추가 JS -->
    <c:if test="${pageJs != null}">
<%--        <script src="<c:url value='/static/main/js/${pageJs}.js'/>"></script>--%>
    </c:if>
</body>
</html>
