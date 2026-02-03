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
    let uploadedImages = [];

    if (imageUploadArea && imageInput && uploadCounter) {
        imageUploadArea.addEventListener('click', function () {
            if (uploadedImages.length >= 10) {
                alert('이미지는 최대 10개까지 업로드할 수 있습니다.');
                return;
            }
            imageInput.click();
        });

        imageInput.addEventListener('change', function (e) {
            const files = Array.from(e.target.files);
            const remainingSlots = 10 - uploadedImages.length;
            const MAX_FILE_SIZE = 30 * 1024 * 1024; // 30MB

            // 파일 크기 체크
            const oversizedFiles = files.filter(file => file.size > MAX_FILE_SIZE);
            const validFiles = files.filter(file => file.size <= MAX_FILE_SIZE);

            if (oversizedFiles.length > 0) {
                const fileNames = oversizedFiles.map(f => f.name).join(', ');
                alert(`30MB를 초과하는 이미지는 업로드할 수 없습니다.\n제외된 파일: ${fileNames}`);
            }

            if (validFiles.length > remainingSlots) {
                alert(`이미지는 최대 10개까지 등록 가능합니다. ${remainingSlots}개만 추가됩니다.`);
            }

            const filesToAdd = validFiles.slice(0, remainingSlots);

            uploadedImages = uploadedImages.concat(filesToAdd);
            uploadCounter.textContent = `${uploadedImages.length}/10`;

            if (uploadedImages.length >= 10) {
                imageUploadArea.style.opacity = '0.5';
                imageUploadArea.style.cursor = 'not-allowed';
            }
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

    // Form Submit Validation
    const errandForm = document.getElementById('errandForm');
    if (errandForm) {
        errandForm.addEventListener('submit', function (e) {
            if (!catInput.value) {
                e.preventDefault();
                alert('카테고리를 선택해주세요.');
                // 카테고리 섹션으로 스크롤
                document.getElementById('categoryToggle').scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
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
