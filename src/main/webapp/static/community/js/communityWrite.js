/**
 * 커뮤니티 글쓰기 페이지 JS
 */

// 기존 이미지 삭제 (전역 함수)
function removeExistingImage(imageId, btn) {
    const previewItem = btn.closest('.image-preview-item');
    previewItem.remove();

    // 업로드 버튼 다시 표시
    const imageUploadBtn = document.getElementById('imageUploadBtn');
    if (imageUploadBtn) {
        imageUploadBtn.style.display = 'flex';
    }
}

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

    // 폼 제출 처리 (FormData 사용)
    writeForm.addEventListener('submit', function(e) {
        e.preventDefault();

        const categorySelected = document.querySelector('input[name="categoryId"]:checked');
        const dongCode = formDongSelect.value;
        const titleValue = titleInput.value.trim();
        const contentValue = contentTextarea.value.trim();

        // 카테고리 검증
        if (!categorySelected) {
            alert('카테고리를 선택해주세요.');
            return false;
        }

        // 지역 검증
        if (!dongCode) {
            alert('지역을 선택해주세요.');
            formGuSelect.focus();
            return false;
        }

        // 제목 검증
        if (titleValue.length === 0) {
            alert('제목을 입력해주세요.');
            titleInput.focus();
            return false;
        }

        // 내용 검증
        if (contentValue.length === 0) {
            alert('내용을 입력해주세요.');
            contentTextarea.focus();
            return false;
        }

        // FormData 생성
        const formData = new FormData(writeForm);

        // 기존 imageFiles 제거 후 selectedFiles 추가
        formData.delete('imageFiles');
        selectedFiles.forEach(file => {
            formData.append('imageFiles', file);
        });

        // AJAX 제출
        fetch(writeForm.action, {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (response.redirected) {
                window.location.href = response.url;
            } else if (response.ok) {
                window.location.href = config.contextPath + '/community';
            } else {
                alert('게시글 저장에 실패했습니다.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('게시글 저장 중 오류가 발생했습니다.');
        });

        return false;
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

    // ========================================
    // 이미지 업로드 처리
    // ========================================
    const imageInput = document.getElementById('imageInput');
    const imagePreviewContainer = document.getElementById('imagePreviewContainer');
    const imageUploadBtn = document.getElementById('imageUploadBtn');
    const existingImages = document.getElementById('existingImages');
    const MAX_IMAGES = 3;

    // 새로 선택된 파일 목록
    let selectedFiles = [];

    // 현재 총 이미지 수 계산
    function getTotalImageCount() {
        const existingCount = existingImages ? existingImages.querySelectorAll('.image-preview-item').length : 0;
        return existingCount + selectedFiles.length;
    }

    // 업로드 버튼 표시/숨김
    function updateUploadBtnVisibility() {
        if (imageUploadBtn) {
            imageUploadBtn.style.display = getTotalImageCount() >= MAX_IMAGES ? 'none' : 'flex';
        }
    }

    // 이미지 선택 시
    if (imageInput) {
        imageInput.addEventListener('change', function(e) {
            const files = Array.from(e.target.files);
            const remainingSlots = MAX_IMAGES - getTotalImageCount();

            if (files.length > remainingSlots) {
                alert(`이미지는 최대 ${MAX_IMAGES}장까지 업로드할 수 있습니다.`);
                files.splice(remainingSlots);
            }

            files.forEach(file => {
                if (!file.type.startsWith('image/')) {
                    alert('이미지 파일만 업로드할 수 있습니다.');
                    return;
                }

                selectedFiles.push(file);
                addImagePreview(file);
            });

            updateUploadBtnVisibility();
            updateFileInput();

            // input 초기화 (같은 파일 다시 선택 가능하도록)
            e.target.value = '';
        });
    }

    // 미리보기 추가
    function addImagePreview(file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            const previewItem = document.createElement('div');
            previewItem.className = 'image-preview-item';
            previewItem.innerHTML = `
                <img src="${e.target.result}" alt="미리보기">
                <button type="button" class="image-remove-btn">X</button>
            `;

            // 삭제 버튼 이벤트
            previewItem.querySelector('.image-remove-btn').addEventListener('click', function() {
                const index = Array.from(imagePreviewContainer.children).indexOf(previewItem);
                selectedFiles.splice(index, 1);
                previewItem.remove();
                updateUploadBtnVisibility();
                updateFileInput();
            });

            imagePreviewContainer.appendChild(previewItem);
        };
        reader.readAsDataURL(file);
    }

    // file input 업데이트 (DataTransfer 사용)
    function updateFileInput() {
        const dt = new DataTransfer();
        selectedFiles.forEach(file => dt.items.add(file));
        imageInput.files = dt.files;
    }

    // 초기 업로드 버튼 상태
    updateUploadBtnVisibility();

    // 수정 모드일 때 기존 값 설정
    if (config.isEditMode && config.postDetail) {
        // 제목/내용 글자수 카운터 초기화
        titleCounter.textContent = titleInput.value.length;
        contentCounter.textContent = contentTextarea.value.length;

        // 구/동 선택 초기화
        const { gunguName, dongCode } = config.postDetail;
        if (gunguName) {
            formGuSelect.value = gunguName;

            // 동 목록 불러온 후 기존 동 선택
            fetch(config.contextPath + '/location/getDongs?gunguName=' + encodeURIComponent(gunguName))
                .then(response => response.json())
                .then(dongs => {
                    formDongSelect.innerHTML = '<option value="">동 선택</option>';
                    dongs.forEach(dong => {
                        const option = document.createElement('option');
                        option.value = dong.dongCode;
                        option.textContent = dong.dongName;
                        formDongSelect.appendChild(option);
                    });
                    formDongSelect.disabled = false;

                    // 기존 동 선택
                    if (dongCode) {
                        formDongSelect.value = dongCode;
                    }
                })
                .catch(error => console.error('동 목록 조회 실패:', error));
        }
    }
});