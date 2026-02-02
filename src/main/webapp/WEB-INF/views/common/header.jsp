<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'VROOM'}</title>

    <!-- 공통 CSS -->
    <link rel="stylesheet" href="<c:url value='/static/common/css/common.css'/>?v=2">

    <!-- 페이지별 CSS (본문 영역만) -->
    <c:choose>
        <c:when test="${pageCss == 'main'}">
            <link rel="stylesheet" href="<c:url value='/static/main/css/main.css'/>?v=2">
        </c:when>
        <c:when test="${pageCss == 'community'}">
            <link rel="stylesheet" href="<c:url value='/static/community/css/community.css'/>">
        </c:when>
        <c:when test="${pageCss == 'community-detail'}">
            <link rel="stylesheet" href="<c:url value='/static/community/css/communityDetail.css'/>">
        </c:when>
        <c:when test="${pageCss == 'community-write'}">
            <link rel="stylesheet" href="<c:url value='/static/community/css/communityWrite.css'/>">
        </c:when>
        <c:when test="${not empty pageCss && not empty pageCssDir}">
            <c:if test="${pageCssDir == 'user'}">
                <link rel="stylesheet" href="<c:url value='/static/user/css/user-layout.css'/>">
            </c:if>
            <c:if test="${pageCssDir == 'errander'}">
                <link rel="stylesheet" href="<c:url value='/static/errander/css/styles.css'/>">
                <link rel="stylesheet" href="<c:url value='/static/errander/css/errander-layout.css'/>">
            </c:if>
            <link rel="stylesheet" href="<c:url value='/static/${pageCssDir}/css/${pageCss}.css'/>">
        </c:when>
    </c:choose>

    <!-- errander 공통 스타일 (pageCss 없이 pageCssDir만 설정된 경우) -->
    <c:if test="${empty pageCss && pageCssDir == 'errander'}">
        <link rel="stylesheet" href="<c:url value='/static/errander/css/styles.css'/>">
    </c:if>

    <!-- 글꼴 -->
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet" as="style"
          href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">

    <!-- jQuery (AJAX 사용 시) -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- 공통 JS -->

</head>

<body>
<!-- Header -->
<header class="header">
    <div class="header-container">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/">
                <h1
                        style="color: ${sessionScope.loginSess.role == 'ERRANDER' ? 'var(--color-primary)' : 'var(--color-accent)'}">
                    VROOM</h1>
            </a>
        </div>
        <nav class="nav-menu">
            <a href="${pageContext.request.contextPath}/errand/list" class="nav-item">심부름</a>
            <a href="${pageContext.request.contextPath}/community/" class="nav-item">커뮤니티</a>

            <c:choose>
                <c:when test="${sessionScope.loginSess != null}">
                    <!-- 로그인 상태 -->
                    <c:choose>
                        <c:when test="${sessionScope.loginSess.role == 'ERRANDER'}">
                            <a href="${pageContext.request.contextPath}/user/switch"
                               class="nav-item">사용자 전환</a>
                        </c:when>
                        <c:otherwise>
                            <a href="#" onclick="checkAndSwitchToErrander(event)" class="nav-item">심부름꾼
                                전환</a>
                        </c:otherwise>
                    </c:choose>
                    <div class="nav-dropdown">
                        <button class="nav-item"
                                id="userDropdownBtn">${sessionScope.loginSess.nickname}님
                        </button>
                        <div class="dropdown-menu" id="userDropdownMenu">
                            <c:choose>
                                <c:when test="${sessionScope.loginSess.role == 'ERRANDER'}">
                                    <!-- 심부름꾼 메뉴 -->
                                    <a href="<c:url value='/errander/mypage/profile'/>"
                                       class="dropdown-item">나의 정보</a>
                                    <a href="<c:url value='/errander/mypage/pay'/>"
                                       class="dropdown-item">부름 페이</a>
                                    <a href="<c:url value='/errander/mypage/activity'/>"
                                       class="dropdown-item">나의 거래</a>
                                    <a href="<c:url value='/errander/mypage/settings'/>"
                                       class="dropdown-item">설정</a>
                                </c:when>
                                <c:otherwise>
                                    <!-- 사용자 메뉴 -->
                                    <a href="<c:url value='/member/myInfo'/>" class="dropdown-item">나의
                                        정보</a>
                                    <a href="<c:url value='/member/vroomPay'/>" class="dropdown-item">부름
                                        페이</a>
                                    <a href="<c:url value='/member/myActivity'/>"
                                       class="dropdown-item">나의 활동</a>
                                    <a href="#" class="dropdown-item">설정</a>
                                </c:otherwise>
                            </c:choose>
                            <a href="#" class="dropdown-item">고객지원</a>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/auth/logout" class="nav-item">로그아웃</a>
                    <div class="notification-container" onclick="toggleNotification()">
                        <span class="bell-icon">🔔</span>
                        <span class="badge-dot" id="notiBadge"></span>

                        <div class="notification-dropdown" id="notiDropdown">
                            <div class="noti-header">
                                <span>알림</span>
                                <span style="font-size:0.8rem; color:#666; cursor:pointer;"
                                      onclick="readAllNotifications(event)">모두 읽음</span>
                            </div>
                            <div class="noti-list" id="notiList">
                                <div style="padding:15px; text-align:center; color:#999;">로딩중...</div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- 비로그인 상태 -->
                    <a href="${pageContext.request.contextPath}/auth/login" class="nav-item">로그인</a>
                    <a href="${pageContext.request.contextPath}/auth/signup" class="nav-item">회원가입</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>

<script>
    // Dropdown 기능
    document.addEventListener('DOMContentLoaded', function () {
        const dropdownBtn = document.getElementById('userDropdownBtn');
        const dropdownMenu = document.getElementById('userDropdownMenu');

        if (dropdownBtn && dropdownMenu) {
            dropdownBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                dropdownMenu.classList.toggle('active');
            });

            document.addEventListener('click', function (e) {
                if (!dropdownMenu.contains(e.target) && !dropdownBtn.contains(e.target)) {
                    dropdownMenu.classList.remove('active');
                }
            });
        }

        // 알림 체크
        checkUnread();
    });

    // 심부름꾼 전환 체크
    function checkAndSwitchToErrander(e) {
        e.preventDefault();

        $.ajax({
            url: '${pageContext.request.contextPath}/errander/check',
            type: 'GET',
            success: function (response) {
                if (response.isRegistered) {
                    // 등록된 경우 승인 상태 확인
                    if (response.approvalStatus === 'APPROVED') {
                        location.href = '${pageContext.request.contextPath}/errander/switch';
                    } else if (response.approvalStatus === 'PENDING') {
                        alert('현재 관리자 승인 대기 중입니다.');
                    } else if (response.approvalStatus === 'REJECTED') {
                        alert('승인이 거절되었습니다. 관리자에게 문의하세요.');
                    } else {
                        alert('알 수 없는 상태입니다.');
                    }
                } else {
                    // 등록되지 않은 경우 확인창 표시
                    if (confirm('부름이 등록 하시겠습니까?')) {
                        // 부름이 등록 페이지로 이동
                        location.href = '${pageContext.request.contextPath}/errander/register';
                    }
                }
            },
            error: function () {
                alert('오류가 발생했습니다. 다시 시도해주세요.');
            }
        });
    }

    // 안 읽은 알림 개수 체크 (빨간점 제어)
    function checkUnread() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/notification/unread',
            type: 'GET',
            success: function (count) {
                if (count > 0) {
                    $('#notiBadge').show();
                } else {
                    $('#notiBadge').hide();
                }
            }
        });
    }

    // 종 아이콘 클릭 시 목록 불러오기
    function toggleNotification() {
        const dropdown = $('#notiDropdown');

        if (dropdown.hasClass('active')) {
            dropdown.removeClass('active');
            return;
        }

        // 열릴 때 목록 로드
        $.ajax({
            url: '${pageContext.request.contextPath}/api/notification/list',
            type: 'GET',
            success: function (data) {
                renderNotifications(data.list);
                dropdown.addClass('active');
            }
        });
    }

    // 목록 렌더링
    function renderNotifications(list) {
        const container = $('#notiList');
        container.empty();

        if (list.length === 0) {
            container.html('<div style="padding:20px; text-align:center; color:#999;">새로운 알림이 없습니다.</div>');
            return;
        }

        list.forEach(noti => {
            const bgClass = (!noti.isRead) ? 'unread' : '';
            let notiType = '-';

            //enum('CHAT', 'ERRAND', 'PAY', 'SYSTEM', 'ETC')
            switch (noti.type) {
                case 'CHAT':
                    notiType = '채팅';
                    break;
                case 'ERRAND':
                    notiType = '심부름';
                    break;
                case 'PAY':
                    notiType = '부름 페이';
                    break;
                case 'SYSTEM':
                    notiType = '시스템/공지';
                    break;
                default:
                    notiType = '기타/공지'
            }
            const html = `
                <div class="noti-item \${bgClass}" onclick="clickNotification(\${noti.notificationId}, '\${noti.url}')">
                    <div class="noti-message">[\${notiType}] \${noti.message}</div>
                    <div class="noti-date">\${new Date(noti.createdAt).toLocaleString()}</div>
                </div>
            `;
            container.append(html);
        });
    }

    // 알림 클릭 시 읽음 처리 후 이동
    function clickNotification(id, url) {
        // 읽음 처리 API 호출
        $.post('${pageContext.request.contextPath}/api/notification/read/' + id, function () {
            if (url && url !== 'null' && url !== '') {
                window.location.href = '${pageContext.request.contextPath}' + url;
            } else {
                checkUnread();
                toggleNotification();
            }
        });
    }
</script>