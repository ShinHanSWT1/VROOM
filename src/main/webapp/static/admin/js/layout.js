document.addEventListener('DOMContentLoaded', function () {
    const sidebar = document.getElementById('sidebar');
    const sidebarToggle = document.getElementById('sidebarToggle');
    const adminDropdownTrigger = document.getElementById('adminDropdownTrigger');
    const adminDropdown = document.getElementById('adminDropdown');

    // 1. 사이드바 토글
    if (sidebarToggle && sidebar) {
        sidebarToggle.addEventListener('click', function (e) {
            e.stopPropagation();
            sidebar.classList.toggle('collapsed');
        });
    }

    // 2. 관리자 드롭다운 토글
    if (adminDropdownTrigger && adminDropdown) {
        adminDropdownTrigger.addEventListener('click', function (e) {
            e.stopPropagation();
            adminDropdown.classList.toggle('show');
        });
    }

    // 3. 외부 클릭 시 드롭다운 닫기
    window.addEventListener('click', function () {
        if (adminDropdown && adminDropdown.classList.contains('show')) {
            adminDropdown.classList.remove('show');
        }
    });

    // 4. 메뉴 활성화 상태 유지
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.sidebar-nav .nav-item');
    navLinks.forEach(function (link) {
        if (link.getAttribute('href') === currentPath) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });
});
