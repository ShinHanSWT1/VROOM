// errand-create.js - 심부름 등록 페이지 전용 스크립트

document.addEventListener('DOMContentLoaded', function () {

    // Category Toggle (hidden 즉시 반영)
    const categoryOptions = document.querySelectorAll('#categoryToggle .category-option');
    const catInput = document.getElementById('categoryId');

    if (categoryOptions.length > 0 && catInput) {
        categoryOptions.forEach(option => {
            option.addEventListener('click', function () {
                categoryOptions.forEach(opt => opt.classList.remove('active'));
                this.classList.add('active');
                catInput.value = this.dataset.category;
            });
        });
    }

    // Image Upload
    const imageUploadArea = document.getElementById('imageUploadArea');
    const imageInput = document.getElementById('imageInput');
    const uploadCounter = document.querySelector('.upload-counter');
    const imagePreviewContainer = document.getElementById('imagePreviewContainer');
    const MAX_IMAGES = 5;
    let selectedFiles = [];

    // 업로드 버튼 표시/숨김
    function updateUploadAreaVisibility() {
        if (imageUploadArea) {
            if (selectedFiles.length >= MAX_IMAGES) {
                imageUploadArea.style.display = 'none';
            } else {
                imageUploadArea.style.display = 'flex';
                imageUploadArea.style.opacity = '1';
                imageUploadArea.style.cursor = 'pointer';
            }
        }
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
                uploadCounter.textContent = `${selectedFiles.length}/${MAX_IMAGES}`;
                updateUploadAreaVisibility();
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

    if (imageUploadArea && imageInput && uploadCounter) {
        imageUploadArea.addEventListener('click', function () {
            if (selectedFiles.length >= MAX_IMAGES) {
                alert(`이미지는 최대 ${MAX_IMAGES}장까지 업로드할 수 있습니다.`);
                return;
            }
            imageInput.click();
        });

        imageInput.addEventListener('change', function (e) {
            const files = Array.from(e.target.files);
            const remainingSlots = MAX_IMAGES - selectedFiles.length;
            const MAX_FILE_SIZE = 30 * 1024 * 1024; // 30MB

            // 파일 크기 체크
            const oversizedFiles = files.filter(file => file.size > MAX_FILE_SIZE);
            const validFiles = files.filter(file => file.size <= MAX_FILE_SIZE);

            if (oversizedFiles.length > 0) {
                const fileNames = oversizedFiles.map(f => f.name).join(', ');
                alert(`30MB를 초과하는 이미지는 업로드할 수 없습니다.\n제외된 파일: ${fileNames}`);
            }

            if (validFiles.length > remainingSlots) {
                alert(`이미지는 최대 ${MAX_IMAGES}장까지 등록 가능합니다. ${remainingSlots}장만 추가됩니다.`);
            }

            const filesToAdd = validFiles.slice(0, remainingSlots);

            filesToAdd.forEach(file => {
                if (!file.type.startsWith('image/')) {
                    alert('이미지 파일만 업로드할 수 있습니다.');
                    return;
                }
                selectedFiles.push(file);
                addImagePreview(file);
            });

            uploadCounter.textContent = `${selectedFiles.length}/${MAX_IMAGES}`;
            updateUploadAreaVisibility();
            updateFileInput();

            // input 초기화 (같은 파일 다시 선택 가능하도록)
            e.target.value = '';
        });
    }

    // Dong Select (코드 + 이름 분리)
    const dongSelect = document.getElementById('dongCodeSelect');
    const dongNameHidden = document.getElementById('dongFullName');

    if (dongSelect && dongNameHidden) {
        const updateDongFullName = () => {
            const selectedOption = dongSelect.options[dongSelect.selectedIndex];
            dongNameHidden.value = selectedOption ? selectedOption.dataset.fullname || '' : '';
        };
        
        dongSelect.addEventListener('change', updateDongFullName);
        updateDongFullName(); // 페이지 로드 시 초기값 설정
    }

    // Form Submit Validation & 이미지 파일 처리
    const errandForm = document.getElementById('errandForm');
    if (errandForm) {
        errandForm.addEventListener('submit', function (e) {
            // 카테고리 검증
            if (!catInput.value) {
                e.preventDefault();
                alert('카테고리를 선택해주세요.');
                document.getElementById('categoryToggle').scrollIntoView({ behavior: 'smooth', block: 'center' });
                return false;
            }

            // 기본 폼 제출 막고 FormData로 처리
            e.preventDefault();

            // FormData 생성
            const formData = new FormData(errandForm);

            // 기존 imageFiles 제거 후 selectedFiles 추가
            formData.delete('imageFiles');
            selectedFiles.forEach(file => {
                formData.append('imageFiles', file);
            });

            // AJAX 제출
            fetch(errandForm.action, {
                method: 'POST',
                body: formData,
                redirect: 'follow'
            })
            .then(response => {
                // 리다이렉트된 경우 최종 URL로 이동
                if (response.redirected) {
                    window.location.href = response.url;
                    return;
                }
                // 정상 응답인 경우
                if (response.ok) {
                    // 최종 URL 확인 (리다이렉트 후 URL)
                    window.location.href = response.url;
                } else {
                    alert('심부름 등록에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('심부름 등록 중 오류가 발생했습니다.');
            });

            return false;
        });
    }

    // Title Counter
    const titleInput = document.querySelector('input[name="title"]');
    const titleCounter = document.getElementById('titleCounter');
    const MAX_LENGTH = 50;

    if (titleInput && titleCounter) {
        const updateCounter = () => {
            titleCounter.textContent = `${titleInput.value.length} / ${MAX_LENGTH}`;
        };

        titleInput.addEventListener('input', updateCounter);
        titleInput.addEventListener('compositionend', updateCounter); // 한글 조합 시 이벤트 처리
        updateCounter(); // 초기 렌더링
    }
});
