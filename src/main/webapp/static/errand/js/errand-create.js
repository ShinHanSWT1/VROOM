// errand-create.js - 심부름 등록 페이지 전용 스크립트

document.addEventListener('DOMContentLoaded', function () {
    // Dropdown Logic
    const dropdownBtn = document.getElementById('userDropdownBtn');
    const dropdownMenu = document.getElementById('userDropdownMenu');

    if (dropdownBtn && dropdownMenu) {
        dropdownBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            dropdownMenu.classList.toggle('active');
        });

        document.addEventListener('click', function (e) {
            if (!dropdownMenu.contains(e.target) && !dropdownBtn.contains(e.target)) {
                dropdownMenu.classList.remove('active');
            }
        });
    }

    // Category Toggle (hidden 즉시 반영)
    const categoryOptions = document.querySelectorAll('#categoryToggle .category-option');
    const catInput = document.getElementById('categoryId');

    if (categoryOptions && catInput) {
        categoryOptions.forEach(option => {
            option.addEventListener('click', function () {
                categoryOptions.forEach(opt => opt.classList.remove('active'));
                this.classList.add('active');

                const v = this.dataset.category;
                catInput.value = v;

                console.log('categoryId set immediately =>', v);
            });
        });
    }

    // Image Upload
    const imageUploadArea = document.getElementById('imageUploadArea');
    const imageInput = document.getElementById('imageInput');
    const uploadCounter = document.querySelector('.upload-counter');
    let uploadedImages = [];

    if (imageUploadArea && imageInput) {
        imageUploadArea.addEventListener('click', function () {
            if (uploadedImages.length >= 10) return;
            imageInput.click();
        });

        imageInput.addEventListener('change', function (e) {
            const files = Array.from(e.target.files);
            const remainingSlots = 10 - uploadedImages.length;
            const filesToAdd = files.slice(0, remainingSlots);

            uploadedImages = uploadedImages.concat(filesToAdd);
            if (uploadCounter) {
                uploadCounter.textContent = `${uploadedImages.length}/10`;
            }

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
        dongSelect.addEventListener('change', () => {
            const opt = dongSelect.options[dongSelect.selectedIndex];
            dongNameHidden.value = opt?.dataset?.fullname || '';
        });
        const opt = dongSelect.options[dongSelect.selectedIndex];
        dongNameHidden.value = opt?.dataset?.fullname || '';
    }

    // Form Submit
    const errandForm = document.getElementById('errandForm');
    if (errandForm) {
        errandForm.addEventListener('submit', function (e) {
            const catInput = document.getElementById('categoryId');

            if (!catInput || !catInput.value) {
                e.preventDefault();
                alert('카테고리를 선택해주세요.');
                return;
            }
        });
    }

    // Title Counter
    var input = document.querySelector('input[name="title"]');
    var counter = document.getElementById('titleCounter');
    var MAX = 50;

    if (input && counter) {
        function render() {
            counter.textContent = input.value.length + ' / ' + MAX;
        }

        input.addEventListener('input', render);
        input.addEventListener('compositionend', render);
        render();
    }
});
