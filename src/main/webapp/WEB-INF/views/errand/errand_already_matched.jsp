<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>이미 매칭된 심부름 - VROOM</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Malgun Gothic', sans-serif;
            background: linear-gradient(135deg, #6B8E23 0%, #F2CB05 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .message-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            padding: 60px 40px;
            text-align: center;
            max-width: 500px;
            width: 100%;
            animation: fadeInUp 0.5s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 30px;
            background: linear-gradient(135deg, #F2CB05 0%, #F2A007 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
        }

        h2 {
            color: #2C3E50;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .message-text {
            color: #7F8C8D;
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 40px;
        }

        .button-group {
            display: flex;
            gap: 12px;
            justify-content: center;
        }

        .btn {
            padding: 14px 32px;
            border: none;
            border-radius: 12px;
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Malgun Gothic', sans-serif;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #6B8E23 0%, #5a7a1e 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(107, 142, 35, 0.3);
        }

        .btn-secondary {
            background: #ECF0F1;
            color: #2C3E50;
        }

        .btn-secondary:hover {
            background: #D5DBDB;
            transform: translateY(-2px);
        }

        @media (max-width: 480px) {
            .message-container {
                padding: 40px 24px;
            }

            h2 {
                font-size: 24px;
            }

            .message-text {
                font-size: 14px;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
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
