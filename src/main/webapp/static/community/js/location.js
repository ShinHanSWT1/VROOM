// 지역 선택 로직

// 페이지 로드 시 초기화
$(document).ready(function() {
    updateDongOptions();
});

// 구 선택시 동을 가져옴
function updateDongOptions() {
    const selectedGu = $('#guSelect').val();
    const $dongSelect = $('#dongSelect');
    const url = "/vroom/location/getDongs";

    $.ajax({
        url: url,           // 요청 URL
        type: 'GET',        // HTTP 메서드
        data: {             // 서버로 보낼 파라미터
            gunguName: selectedGu
        },
        dataType: 'json',   // 응답 데이터 타입

        // 성공 시 실행되는 함수
        success: function(data) {
            console.log("받은 데이터:", data);

            // 기존 옵션 제거
            $dongSelect.empty();

            if (data && data.length > 0) {
                data.forEach(function(item) {
                    const option = `<option value="${item.dongCode}">${item.dongName}</option>`;
                    $dongSelect.append(option);
                });
            }

            // 옵션이 없으면 안내 메시지
            if ($dongSelect.children().length === 0) {
                $dongSelect.append('<option value="">동 선택</option>');
            }

            // 제목 업데이트
            updatePageTitle();
        },

        // 실패 시 실행되는 함수
        error: function(xhr, status, error) {
            console.error("동 목록 조회 실패:", error);
            console.error("상태 코드:", xhr.status);
            console.error("응답:", xhr.responseText);
            alert("동네 목록을 불러오는 중 오류가 발생했습니다.");
        }
    });
}

function updatePageTitle() {
    const guName = $('#guSelect option:selected').text();
    const dongName = $('#dongSelect option:selected').text();
    const $pageTitle = $('#pageTitle');

    if ($pageTitle.length) {
        $pageTitle.html(
            `서울특별시 ${guName} <span class="location-name">${dongName}</span> 관련 소식`
        );
    }
}