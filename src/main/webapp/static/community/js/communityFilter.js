/* Community filter shared behavior for main/detail pages. */
(function () {
    'use strict';

    if (typeof window === 'undefined' || !window.jQuery) {
        return;
    }

    var config = window.communityFilterConfig || {};
    var contextPath = config.contextPath || '';
    var currentDongCode = config.currentDongCode || '';
    var selectedGuName = config.selectedGuName || '';
    // categoryId가 '0'인 경우도 유효한 값이므로 별도 처리
    var currentCategoryId = (config.currentCategoryId !== undefined && config.currentCategoryId !== '')
        ? config.currentCategoryId : null;

    $(document).ready(function () {
        // Reload detection: redirect to base community page
        var navigationEntry = performance.getEntriesByType('navigation')[0];
        if (navigationEntry && navigationEntry.type === 'reload') {
            window.location.href = contextPath + '/community';
            return;
        }

        // Bind events
        $('#guSelect').on('change', loadDongOptions);
        $('#dongSelect').on('change', filterPosts);
        $('#searchBtn').on('click', filterPosts);
        $('#searchInput').on('keypress', function (e) {
            if (e.which === 13) {
                filterPosts();
            }
        });

        // On load: if Gu is selected, load dong list
        if (selectedGuName) {
            loadDongOptions();
        }
    });

    function loadDongOptions() {
        var selectedGu = $('#guSelect').val();
        var $dongSelect = $('#dongSelect');

        $dongSelect.empty().append('<option value="">동 선택</option>');

        if (!selectedGu) {
            updatePageTitle();
            return;
        }

        $.ajax({
            url: contextPath + '/location/getDongs',
            type: 'GET',
            data: { gunguName: selectedGu },
            dataType: 'json',
            success: function (data) {
                if (data && data.length > 0) {
                    data.forEach(function (item) {
                        var selected = (item.dongCode === currentDongCode) ? ' selected' : '';
                        var option = '<option value="' + item.dongCode + '"' + selected + '>' + item.dongName + '</option>';
                        $dongSelect.append(option);
                    });
                }
                updatePageTitle();
            },
            error: function (xhr, status, error) {
                console.error('동 목록 조회 실패:', error);
            }
        });
    }


    function filterPosts() {
        var guName = $('#guSelect').val();
        var dongCode = $('#dongSelect').val();
        var searchKeyword = $('#searchInput').val().trim();

        var url = contextPath + '/community';
        var params = [];

        if (guName) {
            params.push('guName=' + encodeURIComponent(guName));
        }
        if (dongCode) {
            params.push('dongCode=' + encodeURIComponent(dongCode));
        }
        if (currentCategoryId !== null) {
            params.push('categoryId=' + currentCategoryId);
        }
        if (searchKeyword) {
            params.push('searchKeyword=' + encodeURIComponent(searchKeyword));
        }

        if (params.length > 0) {
            url += '?' + params.join('&');
        }
        window.location.href = url;
    }

    function updatePageTitle() {
        var guName = $('#guSelect option:selected').text();
        var dongName = $('#dongSelect option:selected').text();
        var $pageTitle = $('#pageTitle');

        if (dongName && dongName !== '동 선택') {
            $pageTitle.text('서울특별시 ' + guName + ' ' + dongName + ' 동네생활');
        } else if (guName && guName !== '구 선택') {
            $pageTitle.text('서울특별시 ' + guName + ' 동네생활');
        } else {
            $pageTitle.text('서울특별시 동네생활');
        }
    }
})();
