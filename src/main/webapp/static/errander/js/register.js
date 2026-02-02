// register.js - 부름이 등록 페이지 스크립트

document.addEventListener('DOMContentLoaded', function() {
    // 주소 선택 관련 변수
    const gu1Select = document.getElementById('gu1');
    const dong1Select = document.getElementById('dong1');
    const dongCode1Input = document.getElementById('dongCode1');
    const gu2Select = document.getElementById('gu2');
    const dong2Select = document.getElementById('dong2');
    const dongCode2Input = document.getElementById('dongCode2');

    // 목업 데이터 (실제로는 API 호출)
    const mockGus = ['강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구', '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'];

    // 페이지 로드 시 구 목록 로드
    function loadGus() {
        mockGus.forEach(gu => {
            // gu1용 option
            const option1 = document.createElement('option');
            option1.value = gu;
            option1.textContent = gu;
            gu1Select.appendChild(option1);

            // gu2용 option
            const option2 = document.createElement('option');
            option2.value = gu;
            option2.textContent = gu;
            gu2Select.appendChild(option2);
        });
    }

    // 구 선택 시 동 목록 로드
    function loadDongs(guSelect, dongSelect, dongCodeInput) {
        const selectedGu = guSelect.value;

        if (!selectedGu) {
            dongSelect.disabled = true;
            dongSelect.innerHTML = '<option value="">동 선택</option>';
            dongCodeInput.value = '';
            dongSelect.classList.remove('has-value');
            return;
        }

        fetch(contextPath + '/location/getDongs?gunguName=' + encodeURIComponent(selectedGu))
            .then(res => res.json())
            .then(dongs => {

                dongSelect.disabled = false;
                dongSelect.innerHTML = '<option value="">동 선택</option>';

                dongs.forEach(dong => {
                    const option = document.createElement('option');
                    option.value = dong.dongName;
                    option.textContent = dong.dongName;
                    option.dataset.code = dong.dongCode;
                    dongSelect.appendChild(option);
                });

                dongCodeInput.value = '';
                dongSelect.classList.remove('has-value');
            })
            .catch(err => {
                console.error('동 조회 실패', err);
                alert('동 정보를 불러오지 못했습니다.');
            });
    }

    // 동 선택 시 dong_code 저장
    function handleDongSelect(dongSelect, dongCodeInput) {
        const selectedOption = dongSelect.options[dongSelect.selectedIndex];

        if (selectedOption.value && selectedOption.dataset.code) {
            dongCodeInput.value = selectedOption.dataset.code;
            dongSelect.classList.add('has-value');
        } else {
            dongCodeInput.value = '';
            dongSelect.classList.remove('has-value');
        }
    }

    // 구 선택 이벤트 리스너
    gu1Select.addEventListener('change', function() {
        this.classList.add('has-value');
        loadDongs(gu1Select, dong1Select, dongCode1Input);
    });

    gu2Select.addEventListener('change', function() {
        this.classList.add('has-value');
        loadDongs(gu2Select, dong2Select, dongCode2Input);
    });

    // 동 선택 이벤트 리스너
    dong1Select.addEventListener('change', function() {
        handleDongSelect(dong1Select, dongCode1Input);
    });

    dong2Select.addEventListener('change', function() {
        handleDongSelect(dong2Select, dongCode2Input);
    });

    // 포커스 처리
    [gu1Select, dong1Select, gu2Select, dong2Select].forEach(select => {
        select.addEventListener('focus', function() {
            this.style.backgroundColor = 'var(--color-white)';
        });

        select.addEventListener('blur', function() {
            if (!this.value) {
                this.style.backgroundColor = 'var(--color-light-gray)';
            }
        });
    });

    // 페이지 로드 시 구 목록 로드
    loadGus();
});
