/* Main page filter behavior (Location selection) */
(function () {
    'use strict';

    if (typeof window === 'undefined' || !window.jQuery) {
        return;
    }

    var config = window.mainFilterConfig || {};
    var contextPath = config.contextPath || '';
    var selectedDongCode = config.selectedDongCode || '';

    $(document).ready(function () {
        // Bind events
        $('.district-tab').on('click', function() {
            var guName = $(this).text().trim(); // 버튼 텍스트(예: "송파구") 가져오기
            
            // 탭 활성화 스타일 변경
            $('.district-tab').removeClass('active');
            $(this).addClass('active');

            loadDongList(guName);
        });

        // 초기 로딩 시 첫 번째 탭(송파구) 또는 선택된 구의 동 목록 로드
        // (현재는 하드코딩된 탭 중 첫 번째가 송파구이므로 송파구 로드)
        // 만약 selectedDongCode가 있다면 해당 구를 찾아서 활성화하는 로직 추가 가능
        loadDongList('송파구');
    });

    function loadDongList(guName) {
        var $dongGrid = $('#dongGrid');
        $dongGrid.empty(); // 기존 목록 초기화

        $.ajax({
            url: contextPath + '/location/getDongs',
            type: 'GET',
            data: { gunguName: guName },
            dataType: 'json',
            success: function (data) {
                if (data && data.length > 0) {
                    data.forEach(function (item) {
                        var isSelected = (item.dongCode === selectedDongCode) ? 'selected' : '';
                        var $dongItem = $('<div class="dong-item ' + isSelected + '">' + item.dongName + '</div>');
                        
                        // 동 클릭 시 필터링 (페이지 리로드)
                        $dongItem.on('click', function() {
                            window.location.href = contextPath + '/?dongCode=' + item.dongCode;
                        });

                        $dongGrid.append($dongItem);
                    });
                } else {
                    $dongGrid.append('<div class="no-data">동 정보가 없습니다.</div>');
                }
            },
            error: function (xhr, status, error) {
                console.error('동 목록 조회 실패:', error);
                $dongGrid.append('<div class="error-message">동 목록을 불러오는데 실패했습니다.</div>');
            }
        });
    }
})();
