<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script
            src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js">

    </script>
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
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Malgun Gothic', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 50%, var(--color-accent) 100%);
            overflow: hidden;
            position: relative;
        }

        /* Honeycomb Background */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: linear-gradient(30deg, transparent 48%, rgba(255, 255, 255, 0.03) 48%, rgba(255, 255, 255, 0.03) 52%, transparent 52%),
            linear-gradient(150deg, transparent 48%, rgba(255, 255, 255, 0.03) 48%, rgba(255, 255, 255, 0.03) 52%, transparent 52%),
            linear-gradient(90deg, transparent 48%, rgba(255, 255, 255, 0.03) 48%, rgba(255, 255, 255, 0.03) 52%, transparent 52%);
            background-size: 80px 138px;
            animation: honeycombMove 20s linear infinite;
        }

        @keyframes honeycombMove {
            0% {
                background-position: 0 0;
            }

            100% {
                background-position: 80px 138px;
            }
        }

        /* Loading Container */
        .loading-container {
            text-align: center;
            z-index: 10;
            position: relative;
        }

        /* Bee Animation */
        .bee-container {
            position: relative;
            width: 200px;
            height: 200px;
            margin: 0 auto 2rem;
        }

        .bee-icon {
            font-size: 5rem;
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

            0%,
            100% {
                transform: translate(-50%, -50%) translateY(0px) rotate(0deg);
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
            clip-path: polygon(30% 0%, 70% 0%, 100% 50%, 70% 100%, 30% 100%, 0% 50%);
            opacity: 0.8;
        }

        .hexagon:nth-child(1) {
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            animation: hexagonPulse 1.5s ease-in-out infinite;
            animation-delay: 0s;
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

            0%,
            100% {
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

        /* Dots Animation */
        .loading-dots {
            display: inline-block;
        }

        .loading-dots span {
            animation: dotBounce 1.4s ease-in-out infinite;
        }

        .loading-dots span:nth-child(1) {
            animation-delay: 0s;
        }

        .loading-dots span:nth-child(2) {
            animation-delay: 0.2s;
        }

        .loading-dots span:nth-child(3) {
            animation-delay: 0.4s;
        }

        @keyframes dotBounce {

            0%,
            60%,
            100% {
                transform: translateY(0);
            }

            30% {
                transform: translateY(-10px);
            }
        }

        /* Progress Bar */
        .progress-container {
            width: 300px;
            height: 8px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            margin: 0 auto;
            overflow: hidden;
            position: relative;
        }

        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, var(--color-white) 0%, rgba(255, 255, 255, 0.7) 100%);
            border-radius: 10px;
            animation: progressAnimation 2s ease-in-out infinite;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
        }

        @keyframes progressAnimation {
            0% {
                width: 0%;
            }

            50% {
                width: 70%;
            }

            100% {
                width: 100%;
            }
        }

        /* Flying Bees */
        .flying-bee {
            position: absolute;
            font-size: 2rem;
            animation: flyAcross 7s linear infinite;
            opacity: 0.6;
        }

        .flying-bee > img {
            width: 50px;
            height: 50px;

        }

        .flying-bee-1 {
            top: 20%;
            animation-delay: 0s;
        }

        .flying-bee-2 {
            top: 60%;
            animation-delay: 0s;
            animation-direction: reverse;
        }

        .flying-bee-3 {
            top: 80%;
            animation-delay: 0.3s;
            animation-direction: alternate;
        }

        @keyframes flyAcross {
            0% {
                left: -60px;
                transform: rotate(0deg);
            }

            50% {
                transform: rotate(10deg);
            }

            100% {
                left: calc(100% + 60px);
                transform: rotate(0deg);
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .loading-text {
                font-size: 1.5rem;
            }

            .loading-subtitle {
                font-size: 1rem;
            }

            .bee-container {
                width: 150px;
                height: 150px;
            }

            .bee-icon {
                font-size: 4rem;
            }

            .bee-icon-img {
                width: 80px;
                height: 60px;
            }

            .hexagon-spinner {
                width: 130px;
                height: 130px;
            }

            .hexagon {
                width: 30px;
                height: 30px;
            }

            .progress-container {
                width: 240px;
            }
        }
    </style>

    <!-- 글꼴 -->
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet" as="style"
          href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
</head>

<body>
<!-- Flying Bees -->
<div class="flying-bee flying-bee-1"><img src="${pageContext.request.contextPath}/static/img/common/bee1.png" alt=""
                                          srcset=""></div>
<div class="flying-bee flying-bee-2"><img src="${pageContext.request.contextPath}/static/img/common/bee1.png" alt=""
                                          srcset=""></div>
<div class="flying-bee flying-bee-3"><img src="${pageContext.request.contextPath}/static/img/common/bee1.png" alt=""
                                          srcset=""></div>

<!-- Loading Container -->
<div class="loading-container">
    <!-- Bee Animation with Hexagon Spinner -->
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
            <img src="${pageContext.request.contextPath}/static/img/logo4.png" alt="" class="bee-icon-img"/>
        </div>
    </div>
    <!-- Loading Text -->
    <h1 class="loading-text">
        ${message}
        <span class="loading-dots">
                <span>.</span><span>.</span><span>.</span>
        </span>
    </h1>
    <p class="loading-subtitle">${subMessage}</p>

    <!-- Progress Bar -->
    <div class="progress-container">
        <div class="progress-bar"></div>
    </div>
</div>

<script>
    <c:if test="${result == 'success'}">
        setTimeout(function () {
            location.href = '${pageContext.request.contextPath}' + '${url}'
        }, 3000);
    </c:if>
    <c:if test="${result == 'fail'}">
        console.log('${errorMsg}');
        setTimeout(function () {
            location.href = '${pageContext.request.contextPath}' + '${url}'
        }, 2000);
    </c:if>

</script>
</body>

</html>