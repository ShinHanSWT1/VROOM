/**
 * 커뮤니티 글쓰기 페이지 JS
 */
document.addEventListener('DOMContentLoaded', function() {
    const config = window.communityWriteConfig || { contextPath: '' };

    // DOM 요소
    const writeForm = document.getElementById('writeForm');
    const titleInput = document.querySelector('input[name="title"]');
    const contentTextarea = document.querySelector('textarea[name="content"]');
    const formGuSelect = document.getElementById('formGuSelect');
    const formDongSelect = document.getElementById('formDongSelect');

    // 카운터 요소
    const titleCounter = titleInput.closest('.form-section').querySelector('.current-length');
    const contentCounter = contentTextarea.closest('.form-section').querySelector('.current-length');

    // 글자 수 카운터
    titleInput.addEventListener('input', function() {
        titleCounter.textContent = this.value.length;
    });

    contentTextarea.addEventListener('input', function() {
        contentCounter.textContent = this.value.length;
    });

    // 폼 제출 검증
    writeForm.addEventListener('submit', function(e) {
        const categorySelected = document.querySelector('input[name="categoryId"]:checked');
        const dongCode = formDongSelect.value;
        const titleValue = titleInput.value.trim();
        const contentValue = contentTextarea.value.trim();

        // 카테고리 검증
        if (!categorySelected) {
            e.preventDefault();
            alert('카테고리를 선택해주세요.');
            return false;
        }

        // 지역 검증
        if (!dongCode) {
            e.preventDefault();
            alert('지역을 선택해주세요.');
            formGuSelect.focus();
            return false;
        }

        // 제목 검증
        if (titleValue.length === 0) {
            e.preventDefault();
            alert('제목을 입력해주세요.');
            titleInput.focus();
            return false;
        }

        // 내용 검증
        if (contentValue.length === 0) {
            e.preventDefault();
            alert('내용을 입력해주세요.');
            contentTextarea.focus();
            return false;
        }

        return true;
    });

    // 지역 선택 연동
    formGuSelect.addEventListener('change', async function() {
        const selectedGu = this.value;

        // 동 선택 초기화
        formDongSelect.innerHTML = '<option value="">동 선택</option>';

        if (!selectedGu) {
            formDongSelect.disabled = true;
            return;
        }

        try {
            // communityFilter.js와 동일한 API 경로 및 파라미터 사용
            // url: contextPath + '/location/getDongs', data: { gunguName: selectedGu }
            const response = await fetch(
                config.contextPath + '/location/getDongs?gunguName=' + encodeURIComponent(selectedGu)
            );

            if (response.ok) {
                const dongs = await response.json();
                dongs.forEach(dong => {
                    const option = document.createElement('option');
                    option.value = dong.dongCode;
                    option.textContent = dong.dongName;
                    formDongSelect.appendChild(option);
                });
                formDongSelect.disabled = false;
            }
        } catch (error) {
            console.error('동 목록 조회 실패:', error);
        }
    });

    // 초기 상태: 동 선택 비활성화
    formDongSelect.disabled = true;
});