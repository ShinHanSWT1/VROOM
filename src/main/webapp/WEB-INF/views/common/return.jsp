<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 2026-01-19
  Time: 오전 10:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <title>VROOM - 로딩중</title>

    <style>
        :root {
            --color-primary: #6B8E23;
            --color-secondary: #F2CB05;
            --color-tertiary: #F2B807;
            --color-accent: #F2A007;
            --color-warm: #D97218;
            --color-dark: #2C3E50;
            --color-gray: #7F8C8D;
            --color-white: #FFFFFF;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont,
            'Segoe UI', 'Malgun Gothic', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(
                    135deg,
                    var(--color-primary) 0%,
                    var(--color-secondary) 50%,
                    var(--color-accent) 100%
            );
            overflow: hidden;
            position: relative;
        }

        /* Honeycomb Background */
        body::before {
            content: '';
            position: absolute;
            inset: 0;
            background-image:
                    linear-gradient(
                            30deg,
                            transparent 48%,
                            rgba(255, 255, 255, 0.03) 48%,
                            rgba(255, 255, 255, 0.03) 52%,
                            transparent 52%
                    ),
                    linear-gradient(
                            150deg,
                            transparent 48%,
                            rgba(255, 255, 255, 0.03) 48%,
                            rgba(255, 255, 255, 0.03) 52%,
                            transparent 52%
                    ),
                    linear-gradient(
                            90deg,
                            transparent 48%,
                            rgba(255, 255, 255, 0.03) 48%,
                            rgba(255, 255, 255, 0.03) 52%,
                            transparent 52%
                    );
            background-size: 80px 138px;
            animation: honeycombMove 20s linear infinite;
        }

        @keyframes honeycombMove {
            from { background-position: 0 0; }
            to   { background-position: 80px 138px; }
        }

        /* Loading Container */
        .loading-container {
            text-align: center;
            position: relative;
            z-index: 10;
        }

        /* Bee Animation */
        .bee-container {
            position: relative;
            width: 200px;
            height: 200px;
            margin: 0 auto 2rem;
        }

        .bee-icon {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation: beeFloat 2s ease-in-out infinite;
        }

        .bee-icon-img {
            width: 80px;
            height: 60px;
        }

        @keyframes beeFloat {
            0%, 100% {
                transform: translate(-50%, -50%) translateY(0) rotate(0);
            }
            50% {
                transform: translate(-50%, -50%) translateY(-20px) rotate(10deg);
            }
        }

        /* Hexagon Spinner */
        .hexagon-spinner {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 180px;
            height: 180px;
        }

        .hexagon {
            position: absolute;
            width: 40px;
            height: 40px;
            background: var(--color-white);
            clip-path: polygon(
                    30% 0%, 70% 0%, 100% 50%,
                    70% 100%, 30% 100%, 0% 50%
            );
            opacity: 0.8;
        }

        .hexagon:nth-child(1) {
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            animation: hexagonPulse 1.5s ease-in-out infinite;
        }

        .hexagon:nth-child(2) {
            top: 25%;
            right: 10%;
            animation: hexagonPulse 1.5s ease-in-out infinite;
            animation-delay: 0.25s;
        }

        .hexagon:nth-child(3) {
            bottom: 25%;
            right: 10%;
            animation: hexagonPulse 1.5s ease-in-out infinite;
            animation-delay: 0.5s;
        }

        .hexagon:nth-child(4) {
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            animation: hexagonPulse 1.5s ease-in-out infinite;
            animation-delay: 0.75s;
        }

        .hexagon:nth-child(5) {
            bottom: 25%;
            left: 10%;
            animation: hexagonPulse 1.5s ease-in-out infinite;
            animation-delay: 1s;
        }

        .hexagon:nth-child(6) {
            top: 25%;
            left: 10%;
            animation: hexagonPulse 1.5s ease-in-out infinite;
            animation-delay: 1.25s;
        }

        @keyframes hexagonPulse {
            0%, 100% {
                transform: scale(1);
                opacity: 0.8;
            }
            50% {
                transform: scale(1.3);
                opacity: 0.3;
            }
        }

        /* Loading Text */
        .loading-text {
            color: var(--color-white);
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        .loading-subtitle {
            color: var(--color-white);
            font-size: 1.125rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }

        /* Progress Bar */
        .progress-container {
            width: 300px;
            height: 8px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(
                    90deg,
                    var(--color-white) 0%,
                    rgba(255, 255, 255, 0.7) 100%
            );
            animation: progressAnimation 2s ease-in-out infinite;
        }

        @keyframes progressAnimation {
            0%   { width: 0%; }
            50%  { width: 70%; }
            100% { width: 100%; }
        }
    </style>

    <!-- Font -->
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
</head>

<body>

<!-- Flying Bees -->
<div class="flying-bee flying-bee-1">
    <img src="${pageContext.request.contextPath}/resources/img/common/bee1.png" alt="">
</div>
<div class="flying-bee flying-bee-2">
    <img src="${pageContext.request.contextPath}/resources/img/common/bee1.png" alt="">
</div>
<div class="flying-bee flying-bee-3">
    <img src="${pageContext.request.contextPath}/resources/img/common/bee1.png" alt="">
</div>

<!-- Loading Container -->
<div class="loading-container">

    <div class="bee-container">
        <div class="hexagon-spinner">
            <div class="hexagon"></div>
            <div class="hexagon"></div>
            <div class="hexagon"></div>
            <div class="hexagon"></div>
            <div class="hexagon"></div>
            <div class="hexagon"></div>
        </div>

        <div class="bee-icon">
            <img src="${pageContext.request.contextPath}/resources/img/logo4.png"
                 class="bee-icon-img" alt="">
        </div>
    </div>

    <h1 class="loading-text">
        ${message}
        <span class="loading-dots">
            <span>.</span><span>.</span><span>.</span>
        </span>
    </h1>

    <p class="loading-subtitle">${subMessage}</p>

    <div class="progress-container">
        <div class="progress-bar"></div>
    </div>

</div>

<script>
    <c:if test="${result == 'success'}">
    setTimeout(function () {
        location.href = '${url}'
    }, 3000);
    </c:if>

    <c:if test="${result == 'fail'}">
    console.log('${errorMsg}');
    setTimeout(function () {
        location.href = '${url}'
    }, 2000);
    </c:if>
</script>

</body>
</html>