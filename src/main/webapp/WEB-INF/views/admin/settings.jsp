<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <title>VROOM - 시스템 설정</title>
    <style>
        :root {
            --color-primary: #6B8E23;
            --color-secondary: #F2CB05;
            --color-tertiary: #F2B807;
            --color-accent: #F2A007;
            --color-warm: #D97218;
            --color-dark: #2C3E50;
            --color-gray: #7F8C8D;
            --color-light-gray: #ECF0F1;
            --color-white: #FFFFFF;
            --sidebar-width: 240px;
            --sidebar-collapsed-width: 70px;
            --header-height: 70px;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Malgun Gothic', sans-serif;
            color: var(--color-dark);
            line-height: 1.6;
            background-color: #F8F9FA;
        }

        .admin-layout { display: flex; min-height: 100vh; }

        /* Sidebar & Header (기존 스타일 유지) */
        .sidebar {
            width: var(--sidebar-width);
            background: linear-gradient(180deg, var(--color-primary) 0%, #4A6B1A 100%);
            color: var(--color-white);
            position: fixed;
            left: 0; top: 0; height: 100vh;
            transition: width 0.3s ease;
            z-index: 1000;
            overflow: hidden;
        }
        .sidebar.collapsed { width: var(--sidebar-collapsed-width); }
        .sidebar-header { padding: 1rem; border-bottom: 1px solid rgba(255, 255, 255, 0.1); display: flex; align-items: center; justify-content: space-between; height: var(--header-height); }
        .sidebar-logo { font-size: 1.5rem; font-weight: 700; white-space: nowrap; transition: opacity 0.3s ease; }
        .sidebar-logo > img { width: 150px; height: 37.5px; }
        .sidebar.collapsed .sidebar-logo { display: none; }
        .sidebar.collapsed .sidebar-header, .sidebar.collapsed .nav-item { justify-content: center; padding: 1rem 0; }
        .sidebar.collapsed .nav-item-icon { margin-right: 0; }
        .sidebar-toggle { z-index: 1001; background: rgba(255, 255, 255, 0.2); border-radius: 4px; border: none; color: var(--color-white); width: 36px; height: 36px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; }
        .sidebar-nav { padding: 1rem 0; }
        .nav-item { display: flex; align-items: center; padding: 1rem 1.5rem; color: var(--color-white); text-decoration: none; transition: all 0.3s ease; border-left: 4px solid transparent; }
        .nav-item:hover { background: rgba(255, 255, 255, 0.1); border-left-color: var(--color-secondary); }
        .nav-item.active { background: rgba(255, 255, 255, 0.15); border-left-color: var(--color-secondary); font-weight: 600; }
        .nav-item-icon { font-size: 1.5rem; min-width: 40px; display: flex; align-items: center; justify-content: center; }
        .nav-item-text { white-space: nowrap; transition: opacity 0.3s ease; }
        .sidebar.collapsed .nav-item-text { opacity: 0; width: 0; }

        .main-content { flex: 1; margin-left: var(--sidebar-width); transition: margin-left 0.3s ease; }
        .sidebar.collapsed ~ .main-content { margin-left: var(--sidebar-collapsed-width); }

        .admin-header { background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%); box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12); position: sticky; top: 0; z-index: 999; height: var(--header-height); }
        .header-container { padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; height: 100%; }
        .header-title { color: var(--color-white); font-size: 1.5rem; font-weight: 700; }
        .header-user { position: relative; cursor: pointer; display: flex; align-items: center; gap: 0.5rem; background: rgba(255, 255, 255, 0.15); padding: 0.5rem 1rem; border-radius: 8px; color: var(--color-white); font-weight: 600; }
        .user-dropdown { display: none; position: absolute; top: calc(100% + 10px); right: 0; background-color: var(--color-white); min-width: 150px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15); border-radius: 8px; overflow: hidden; z-index: 1001; }
        .user-dropdown.show { display: block; }
        .dropdown-item { padding: 0.75rem 1rem; color: var(--color-dark); text-decoration: none; display: flex; align-items: center; gap: 0.5rem; transition: background 0.2s; }
        .dropdown-item:hover { background-color: var(--color-light-gray); color: var(--color-warm); }

        /* Settings Page Styles */
        .page-content { padding: 2rem; }
        .page-title { font-size: 2rem; font-weight: 700; margin-bottom: 2rem; color: var(--color-dark); }

        .settings-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 2rem;
            max-width: 1000px;
        }

        .settings-card {
            background: var(--color-white);
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border: 1px solid #eee;
        }

        .card-header {
            margin-bottom: 1.5rem;
            border-bottom: 2px solid var(--color-light-gray);
            padding-bottom: 1rem;
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--color-dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-title::before {
            content: '';
            display: block;
            width: 4px;
            height: 20px;
            background-color: var(--color-secondary);
            border-radius: 2px;
        }

        .setting-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.2rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .setting-item:last-child { border-bottom: none; }

        .setting-info {
            flex: 1;
            padding-right: 2rem;
        }

        .setting-label {
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.3rem;
            display: block;
        }

        .setting-desc {
            font-size: 0.85rem;
            color: var(--color-gray);
        }

        .setting-control {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Number Input Style */
        .input-number {
            padding: 0.5rem;
            border: 1px solid var(--color-gray);
            border-radius: 6px;
            width: 100px;
            text-align: right;
            font-size: 1rem;
        }
        .input-unit {
            font-weight: 600;
            color: var(--color-gray);
        }

        /* Toggle Switch Style */
        .switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 26px;
        }

        .switch input { opacity: 0; width: 0; height: 0; }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0; left: 0; right: 0; bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 20px; width: 20px;
            left: 3px; bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .slider { background-color: var(--color-primary); }
        input:checked + .slider:before { transform: translateX(24px); }

        /* Save Button Area */
        .action-bar {
            margin-top: 2rem;
            display: flex;
            justify-content: flex-end;
            padding-top: 1rem;
            border-top: 1px solid var(--color-light-gray);
        }

        .btn-save {
            padding: 0.8rem 2.5rem;
            background: linear-gradient(135deg, var(--color-primary) 0%, #4A6B1A 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(107, 142, 35, 0.3); }

    </style>

    <link rel="stylesheet" as="style" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
</head>

<body>
<div class="admin-layout">
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">
                <img src="${pageContext.request.contextPath}/static/img/logo2.png" alt="VROOM" srcset="">
            </div>
            <button class="sidebar-toggle" id="sidebarToggle">☰</button>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
                <span class="nav-item-icon">📊</span>
                <span class="nav-item-text">대시보드</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-item">
                <span class="nav-item-icon">👥</span>
                <span class="nav-item-text">사용자 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/erranders" class="nav-item">
                <span class="nav-item-icon">🏃</span>
                <span class="nav-item-text">부름이 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/errands" class="nav-item">
                <span class="nav-item-icon">📦</span>
                <span class="nav-item-text">심부름/배정 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/issue" class="nav-item">
                <span class="nav-item-icon">⚠️</span>
                <span class="nav-item-text">신고/이슈 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/settlements" class="nav-item">
                <span class="nav-item-icon">💰</span>
                <span class="nav-item-text">정산 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/notice" class="nav-item">
                <span class="nav-item-icon">📢</span>
                <span class="nav-item-text">공지/컨텐츠 관리</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/settings" class="nav-item active">
                <span class="nav-item-icon">⚙️</span>
                <span class="nav-item-text">시스템 설정</span>
            </a>
        </nav>
    </aside>

    <div class="main-content">
        <header class="admin-header">
            <div class="header-container">
                <h1 class="header-title">관리자 페이지</h1>
                <div class="header-actions">
                    <div class="header-user" id="adminDropdownTrigger">
                        <span>👤</span>
                        <span>${sessionScope.loginAdmin.name}</span>
                        <span style="font-size: 0.8rem; margin-left: 5px;">▼</span>
                        <div class="user-dropdown" id="adminDropdown">
                            <a href="${pageContext.request.contextPath}/admin/logout" class="dropdown-item">
                                <span>🚪</span> 로그아웃
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <main class="page-content">
            <h2 class="page-title">시스템 설정</h2>

            <form id="settingsForm" onsubmit="saveSettings(event)">
                <div class="settings-grid">

                    <div class="settings-card">
                        <div class="card-header">
                            <h3 class="card-title">심부름 관련 설정</h3>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <label class="setting-label">미배정 기준 시간 설정</label>
                                <p class="setting-desc">심부름 등록 후 매칭되지 않았을 때 '미배정' 경고를 띄울 기준 시간입니다.</p>
                            </div>
                            <div class="setting-control">
                                <input type="number" id="unmatchedTime" class="input-number" min="10" value="60">
                                <span class="input-unit">분</span>
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <label class="setting-label">관리자 개입 기준 시간</label>
                                <p class="setting-desc">매칭 실패 시 관리자에게 알림이 전송되는 기준 시간입니다.</p>
                            </div>
                            <div class="setting-control">
                                <input type="number" id="adminAlertTime" class="input-number" min="30" value="120">
                                <span class="input-unit">분</span>
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <label class="setting-label">정직원 배정 허용 여부</label>
                                <p class="setting-desc">미배정 심부름에 대해 관리자가 정직원을 수동 배정할 수 있는지 설정합니다.</p>
                            </div>
                            <div class="setting-control">
                                <label class="switch">
                                    <input type="checkbox" id="allowEmployeeAssign" checked>
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="settings-card">
                        <div class="card-header">
                            <h3 class="card-title">부름이 관련 설정</h3>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <label class="setting-label">부름이 가입 승인 필요 여부</label>
                                <p class="setting-desc">활성화 시, 관리자가 승인해야만 부름이 활동이 가능합니다.</p>
                            </div>
                            <div class="setting-control">
                                <label class="switch">
                                    <input type="checkbox" id="requireApproval" checked>
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <label class="setting-label">자동 활동 제한 기준 (완료율)</label>
                                <p class="setting-desc">심부름 완료율이 설정값 미만일 경우 자동으로 활동이 일시 정지됩니다.</p>
                            </div>
                            <div class="setting-control">
                                <input type="number" id="minCompletionRate" class="input-number" min="0" max="100" value="70">
                                <span class="input-unit">% 미만</span>
                            </div>
                        </div>
                    </div>

                    <div class="settings-card">
                        <div class="card-header">
                            <h3 class="card-title">신고 관련 설정</h3>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <label class="setting-label">신고 누적 시 자동 경고 기준</label>
                                <p class="setting-desc">누적 신고 횟수가 도달하면 사용자에게 경고 메시지를 발송합니다.</p>
                            </div>
                            <div class="setting-control">
                                <input type="number" id="warnReportCount" class="input-number" min="1" value="3">
                                <span class="input-unit">회</span>
                            </div>
                        </div>

                        <div class="setting-item">
                            <div class="setting-info">
                                <label class="setting-label">신고 누적 시 자동 정지 기준</label>
                                <p class="setting-desc">누적 신고 횟수가 도달하면 계정을 자동으로 정지 처리합니다.</p>
                            </div>
                            <div class="setting-control">
                                <input type="number" id="banReportCount" class="input-number" min="1" value="10">
                                <span class="input-unit">회</span>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="action-bar">
                    <button type="submit" class="btn-save">변경 사항 저장</button>
                </div>
            </form>
        </main>
    </div>
</div>

<script>
    $(document).ready(function () {
        // 사이드바 & 헤더 드롭다운 로직 (공통)
        const sidebar = document.getElementById('sidebar');
        const sidebarToggle = document.getElementById('sidebarToggle');
        const adminDropdownTrigger = document.getElementById('adminDropdownTrigger');
        const adminDropdown = document.getElementById('adminDropdown');
        const savedState = localStorage.getItem('sidebarState');

        if (savedState === 'collapsed') sidebar.classList.add('collapsed');

        sidebarToggle.addEventListener('click', function (e) {
            e.stopPropagation();
            sidebar.classList.toggle('collapsed');
            localStorage.setItem('sidebarState', sidebar.classList.contains('collapsed') ? 'collapsed' : 'expanded');
        });

        adminDropdownTrigger.addEventListener('click', function (e) {
            e.stopPropagation();
            adminDropdown.classList.toggle('show');
        });

        window.addEventListener('click', function () {
            if (adminDropdown.classList.contains('show')) adminDropdown.classList.remove('show');
        });

        // 초기 설정 로드
        loadSettings();
    });

    // 설정값 불러오기 (Mock Data)
    function loadSettings() {
        // 실제로는 fetch('${pageContext.request.contextPath}/api/admin/settings') 호출

        // [테스트용 더미 데이터]
        const dummyConfig = {
            unmatchedTime: 60,
            adminAlertTime: 120,
            allowEmployeeAssign: true,
            requireApproval: true,
            minCompletionRate: 80,
            warnReportCount: 3,
            banReportCount: 10
        };

        // 데이터 바인딩
        document.getElementById('unmatchedTime').value = dummyConfig.unmatchedTime;
        document.getElementById('adminAlertTime').value = dummyConfig.adminAlertTime;
        document.getElementById('allowEmployeeAssign').checked = dummyConfig.allowEmployeeAssign;

        document.getElementById('requireApproval').checked = dummyConfig.requireApproval;
        document.getElementById('minCompletionRate').value = dummyConfig.minCompletionRate;

        document.getElementById('warnReportCount').value = dummyConfig.warnReportCount;
        document.getElementById('banReportCount').value = dummyConfig.banReportCount;
    }

    // 설정 저장
    function saveSettings(event) {
        event.preventDefault();

        if(!confirm('시스템 설정을 변경하시겠습니까?')) return;

        const settings = {
            unmatchedTime: document.getElementById('unmatchedTime').value,
            adminAlertTime: document.getElementById('adminAlertTime').value,
            allowEmployeeAssign: document.getElementById('allowEmployeeAssign').checked,
            requireApproval: document.getElementById('requireApproval').checked,
            minCompletionRate: document.getElementById('minCompletionRate').value,
            warnReportCount: document.getElementById('warnReportCount').value,
            banReportCount: document.getElementById('banReportCount').value
        };

        console.log("Saving settings:", settings);

        // API 호출 로직
        /*
        fetch('${pageContext.request.contextPath}/api/admin/settings', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(settings)
        }).then(...)
        */

        alert('설정이 성공적으로 저장되었습니다.');
    }
</script>
</body>
</html>