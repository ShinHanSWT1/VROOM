<!--
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
-->

<style>
    :root {
        --color-primary: #6B8E23;
        --color-secondary: #F2CB05;
        --color-dark: #2C3E50;
        --color-gray: #7F8C8D;
        --color-light-gray: #ECF0F1;
        --color-white: #FFFFFF;
    }

    /* 모달 기본 스타일 (settlement.jsp와 동일) */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 9998;
        align-items: center;
        justify-content: center;
    }

    .modal-overlay.show {
        display: flex;
        animation: fadeIn 0.2s ease-out;
    }

    .modal {
        background: white;
        border-radius: 12px;
        padding: 2rem;
        max-width: 800px;
        width: 90%;
        max-height: 90vh;
        overflow-y: auto;
        z-index: 9999;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    }

    .modal-header {
        display: flex;
        justify-content: space-between;
        margin-bottom: 1.5rem;
        border-bottom: 1px solid #eee;
        padding-bottom: 1rem;
        align-items: center;
    }

    .modal-title {
        font-size: 1.4rem;
        font-weight: 700;
        color: var(--color-dark);
    }

    .modal-grid-layout {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 2rem;
    }

    .modal-section-title {
        font-size: 1rem;
        font-weight: 700;
        margin-bottom: 1rem;
        border-left: 4px solid var(--color-secondary);
        padding-left: 0.5rem;
        color: var(--color-dark);
    }

    /* 왼쪽 패널: 텍스트 입력 영역 */
    .info-label {
        display: block;
        color: var(--color-gray);
        font-weight: 600;
        margin-bottom: 0.5rem;
        font-size: 0.9rem;
    }

    .complete-message-box {
        width: 100%;
        height: 150px;
        padding: 1rem;
        border: 2px solid var(--color-light-gray);
        border-radius: 8px;
        resize: none;
        font-family: inherit;
        font-size: 1rem;
        transition: border-color 0.3s;
    }

    .complete-message-box:focus {
        outline: none;
        border-color: var(--color-primary);
    }

    /* 오른쪽 패널: 사진 업로드 영역 */
    .upload-container {
        width: 100%;
        height: 250px;
        border: 2px dashed var(--color-gray);
        border-radius: 8px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.3s;
        background-color: #FAFAFA;
        position: relative;
        overflow: hidden;
    }

    .upload-container:hover {
        border-color: var(--color-primary);
        background-color: #F0F4C3;
    }

    .upload-icon {
        font-size: 3rem;
        color: var(--color-gray);
        margin-bottom: 0.5rem;
    }

    .upload-text {
        color: var(--color-gray);
        font-weight: 600;
    }

    /* 이미지 미리보기 */
    #previewImage {
        width: 100%;
        height: 100%;
        object-fit: contain;
        display: none;
        position: absolute;
        top: 0;
        left: 0;
        background: white;
    }

    /* 푸터 및 버튼 */
    .modal-footer {
        display: flex;
        justify-content: flex-end;
        gap: 1rem;
        margin-top: 2rem;
        padding-top: 1rem;
        border-top: 1px solid #eee;
    }

    .modal-btn {
        padding: 0.8rem 1.5rem;
        border-radius: 8px;
        font-weight: 700;
        border: none;
        cursor: pointer;
        transition: 0.3s;
    }

    .btn-cancel {
        background: #eee;
        color: #333;
    }

    .btn-cancel:hover {
        background: #ddd;
    }

    .btn-confirm {
        background: linear-gradient(135deg, var(--color-primary) 0%, #4A6B1A 100%);
        color: white;
        box-shadow: 0 4px 6px rgba(107, 142, 35, 0.3);
    }

    .btn-confirm:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 12px rgba(107, 142, 35, 0.4);
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 모바일 반응형 */
    @media (max-width: 768px) {
        .modal-grid-layout {
            grid-template-columns: 1fr;
            gap: 1rem;
        }

        .upload-container {
            height: 200px;
        }
    }
</style>
<body>
<button onclick="openCompleteModal()">test</button>
</body>
<div class="modal-overlay" id="completeModal">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title">🏁 심부름 수행 완료 인증</h3>
            <button onclick="closeCompleteModal()"
                    style="background:none; border:none; font-size:1.5rem; cursor:pointer;">&times;
            </button>
        </div>

        <div class="modal-body">
            <div style="background: #F8F9FA; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">
                <span style="font-size: 0.9rem; color: var(--color-gray);">수행한 심부름</span>
                <div style="font-weight: 700; font-size: 1.1rem; color: var(--color-dark);" id="modalErrandTitle">
                    -
                </div>
            </div>

            <form id="completeForm" enctype="multipart/form-data">
                <div class="modal-grid-layout">
                    <div class="right-panel">
                        <div class="modal-section-title">📸 인증 사진 첨부 (필수)</div>
                        <div class="upload-container" id="uploadDropZone"
                             onclick="document.getElementById('proofFileInput').click()">
                            <span class="upload-icon">☁️</span>
                            <span class="upload-text">클릭하여 사진 업로드</span>
                            <span style="font-size: 0.8rem; color: #aaa; margin-top:5px;">(또는 파일을 여기로 드래그)</span>

                            <input type="file" id="proofFileInput" name="proofImage" accept="image/*"
                                   style="display: none;" onchange="previewFile(this)">

                            <img id="previewImage" src="" alt="미리보기">
                        </div>
                    </div>

                    <div class="left-panel">
                        <div class="modal-section-title">💬 완료 메시지</div>
                        <label class="info-label">요청자에게 보낼 메시지</label>
                        <textarea class="complete-message-box" id="completeMemo" name="memo"
                                  placeholder="예: 물건 구매하여 문 앞에 두었습니다. 확인 부탁드립니다!"></textarea>
                    </div>
                </div>
            </form>
        </div>

        <div class="modal-footer">
            <button class="modal-btn btn-cancel" onclick="closeCompleteModal()">취소</button>
            <button class="modal-btn btn-confirm" onclick="submitComplete()">수행 완료 확정</button>
        </div>
    </div>
</div>

<script>
    let currentErrandIdForComplete = null;

    // 모달 열기 함수
    function openCompleteModal(errandId, title) {
        currentErrandIdForComplete = errandId;
        document.getElementById('modalErrandTitle').innerText = title || '심부름 정보를 불러오는 중...';

        // 초기화
        document.getElementById('proofFileInput').value = '';
        document.getElementById('previewImage').style.display = 'none';
        document.getElementById('completeMemo').value = '';

        document.getElementById('completeModal').classList.add('show');
    }

    // 모달 닫기 함수
    function closeCompleteModal() {
        document.getElementById('completeModal').classList.remove('show');
        currentErrandIdForComplete = null;
    }

    // 이미지 미리보기 로직
    function previewFile(input) {
        const file = input.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                const preview = document.getElementById('previewImage');
                preview.src = e.target.result;
                preview.style.display = 'block';
            }
            reader.readAsDataURL(file);
        }
    }

    // 드래그 앤 드롭 지원 (선택 사항)
    const dropZone = document.getElementById('uploadDropZone');

    dropZone.addEventListener('dragover', (e) => {
        e.preventDefault();
        dropZone.style.backgroundColor = '#F0F4C3';
        dropZone.style.borderColor = '#6B8E23';
    });

    dropZone.addEventListener('dragleave', (e) => {
        e.preventDefault();
        dropZone.style.backgroundColor = '#FAFAFA';
        dropZone.style.borderColor = '#7F8C8D';
    });

    dropZone.addEventListener('drop', (e) => {
        e.preventDefault();
        dropZone.style.backgroundColor = '#FAFAFA';

        const files = e.dataTransfer.files;
        if (files.length > 0) {
            document.getElementById('proofFileInput').files = files;
            previewFile(document.getElementById('proofFileInput'));
        }
    });

    // 완료 확정 제출
    function submitComplete() {
        if (!currentErrandIdForComplete) return;

        const fileInput = document.getElementById('proofFileInput');
        const memo = document.getElementById('completeMemo').value;

        // 유효성 검사
        if (fileInput.files.length === 0) {
            alert('인증 사진을 반드시 첨부해야 합니다.');
            return;
        }

        if (!confirm('입력한 내용으로 수행 완료 처리를 하시겠습니까?')) return;

        // 파일 전송을 위해 FormData 사용
        const formData = new FormData();
        formData.append('errandId', currentErrandIdForComplete);
        formData.append('file', fileInput.files[0]); // 컨트롤러 파라미터명과 일치해야 함
        formData.append('memo', memo);

        /* [백엔드 참고]
           Controller는 @PostMapping("/api/errand/complete")
           매개변수로 (@RequestParam("file") MultipartFile file, ErrandDTO dto) 등을 받아야 함
        */

        fetch('${pageContext.request.contextPath}/api/errand/complete', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.result === 'success') {
                    alert('수행 완료 처리되었습니다.\n관리자 승인 후 정산이 진행됩니다.');
                    closeCompleteModal();
                    window.location.reload(); // 목록 갱신
                } else {
                    alert('처리 실패: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 통신 오류가 발생했습니다.');
            });
    }
</script>