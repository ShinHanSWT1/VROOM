/* Main page filter behavior (Location selection) */
(function () {
    'use strict';

    if (typeof window === 'undefined' || !window.jQuery) {
        return;
    }

    var config = window.mainFilterConfig || {};
    var contextPath = config.contextPath || '';
    var selectedDongCode = config.selectedDongCode || '';
    var selectedGuName = config.selectedGuName || '';

    $(document).ready(function () {
        // Bind events
        $('#guSelect').on('change', loadDongOptions);
        $('#dongSelect').on('change', filterPosts);

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
            // 구 선택 해제 시 전체 조회로 이동 (선택 사항)
            // window.location.href = contextPath + '/';
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
                        var selected = (item.dongCode === selectedDongCode) ? ' selected' : '';
                        var option = '<option value="' + item.dongCode + '"' + selected + '>' + item.dongName + '</option>';
                        $dongSelect.append(option);
                    });
                }
            },
            error: function (xhr, status, error) {
                console.error('동 목록 조회 실패:', error);
            }
        });
    }

    function filterPosts() {
        var guName = $('#guSelect').val();
        var dongCode = $('#dongSelect').val();

        var url = contextPath + '/';
        var params = [];

        if (guName) {
            params.push('guName=' + encodeURIComponent(guName));
        }
        if (dongCode) {
            params.push('dongCode=' + encodeURIComponent(dongCode));
        }

        if (params.length > 0) {
            url += '?' + params.join('&');
        }
        window.location.href = url;
    }
})();
