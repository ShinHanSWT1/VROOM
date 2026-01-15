// 지역 선택 로직

// 페이지 로드 시 초기화
$(document).ready(function() {
    // 처음에 금천구가 선택되어 있다면 해당 동 목록을 바로 불러옴
    updateDongOptions();
});

// 구 선택시 동을 가져옴
function updateDongOptions() {
    // 선택된 구 이름 (예: 금천구)
    const selectedGu = $('#guSelect').val();
    const $dongSelect = $('#dongSelect');

    // 주소 설정 (
    const url = "/vroom/location/getDongs";

    // AJAX 통신
    $.ajax({
        url: url,
        type: 'GET',
        data: { gunguName: selectedGu }, // 서버 @RequestParam("gunguName")으로 전달
        dataType: 'json',
        success: function(data) {
            // 기존 옵션 제거
            $dongSelect.empty();

            if (data && data.length > 0) {
                // 서버에서 받은 LegalDongVO 리스트를 순회
                data.forEach(function(item) {
                    // value에는 PK인 dong_code를, 화면에는 dong_name을 출력
                    const option = `<option value="${item.dong_code}">${item.dong_name}</option>`;
                    $dongSelect.append(option);
                });
            } else {
                $dongSelect.append('<option value="">동 정보 없음</option>');
            }

            // 동 목록이 바뀌었으므로 제목 등 관련 UI 업데이트
            updatePageTitle();
        },
        error: function(xhr, status, error) {
            console.error("동 목록 조회 실패:", error);
            alert("동네 목록을 불러오는 중 오류가 발생했습니다.");
        }
    });
}

// 선택된 지역에 따라 제목 text 업데이트
function updatePageTitle() {
    const guName = $('#guSelect option:selected').text();
    const dongName = $('#dongSelect option:selected').text();
    const $pageTitle = $('#pageTitle');

    if ($pageTitle.length) {
        // 제목 텍스트 업데이트 (예: 서울특별시 금천구 가산동 관련 소식)
        $pageTitle.html(`서울특별시 ${guName} ${dongName} <span class="category-badge-active">맛집</span> 관련 소식`);
    }
}