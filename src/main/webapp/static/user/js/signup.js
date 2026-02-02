document.addEventListener('DOMContentLoaded', function() {
    const emailInput = document.getElementById('signup-email');
    const passwordInput = document.getElementById('signup-password');
    const nicknameInput = document.getElementById('nickname');
    const phoneInput = document.getElementById('phone');
    const signupBtn = document.getElementById('signupBtn');

    // 전화번호: 숫자만 허용 + 11자리 제한
    phoneInput.addEventListener('input', function () {
        this.value = this.value.replace(/[^0-9]/g, '').slice(0, 11);
    });

    // 유효성 검사 변수
    let emailValid = false;
    let phoneValid = false;
    let nicknameValid = false;
    let dong1Valid = false;
    let dong2Valid = true; // 주소 2는 선택 항목이므로 기본 true

    // 모든 입력 필드에 대한 이벤트 리스너
    const inputs = [emailInput, passwordInput, nicknameInput, phoneInput];

    inputs.forEach(input => {
        if (!input) return;

        // 입력 처리
        input.addEventListener('input', function() {
            if (this.value.length > 0) {
                this.classList.add('has-value');

                // 비밀번호 특별 처리
                if (this === passwordInput) {
                    const value = this.value;
                    if (value.length >= 4) {
                        this.classList.add('valid');
                    } else {
                        this.classList.remove('valid');
                    }
                }
            } else {
                this.classList.remove('has-value', 'valid');
            }
            validateSignup();
        });

        // 포커스 처리
        input.addEventListener('focus', function() {
            this.style.backgroundColor = 'var(--color-white)';
        });

        input.addEventListener('blur', function() {
            if (!this.value) {
                this.style.backgroundColor = 'var(--color-light-gray)';
            }
        });
    });

    // OAuth 사용자 여부 (window.signupConfig에서 가져옴)
    const isOAuth = window.signupConfig ? window.signupConfig.isOAuth : false;
    const contextPath = window.signupConfig ? window.signupConfig.contextPath : '';

    // 이메일 형식 검사 (정규식)
    function isValidEmail(email) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email);
    }

    // 이메일 중복 체크
    let emailTimer = null;

    // OAuth 회원가입 시 이메일/닉네임 미리 채워져 있으면 유효 처리
    if (isOAuth) {
        if ($('#signup-email').val().trim()) {
            emailValid = true;
        }
        if ($('#nickname').val().trim()) {
            nicknameValid = true;
        }
    }

    emailInput.addEventListener('input', function () {
        clearTimeout(emailTimer);

        const email = $(this).val().trim();
        const msg = $('#emailMsg');

        if (!email) {
            msg.text('');
            emailValid = false;
            validateSignup();
            return;
        }

        // 형식 검사 (즉시)
        if (!isValidEmail(email)) {
            msg.text('이메일 형식이 올바르지 않습니다');
            msg.attr('class', 'input-guide error');
            emailValid = false;
            validateSignup();
            return;
        }

        emailTimer = setTimeout(() => {
            $.ajax({
                url: contextPath + '/auth/check-email',
                type: 'GET',
                data: { email: email },
                dataType: 'json',
                success: function(exists) {
                    const msg = $('#emailMsg');
                    if (exists) {
                        msg.text('✖ 이미 가입된 이메일입니다');
                        msg.attr('class', 'input-guide error');
                        emailValid = false;
                    } else {
                        msg.text('✔ 사용 가능한 이메일입니다');
                        msg.attr('class', 'input-guide success');
                        emailValid = true;
                    }
                    validateSignup();
                }
            });
        }, 400); // 0.4초 후 실행
    });

    // 전화번호 중복 체크 (11자리 + 중복 아님)
    phoneInput.addEventListener('blur', function () {
        const phone = $(this).val().trim();
        const msg = $('#phoneMsg');

        if (!phone) return;

        if (phone.length !== 11) {
            msg.text('전화번호는 11자리여야 합니다');
            msg.attr('class', 'input-guide error');
            phoneValid = false;
            validateSignup();
            return;
        }

        $.ajax({
            url: contextPath + '/auth/check-phone',
            type: 'GET',
            data: { phone: phone },
            dataType: 'json',
            success: function(exists) {
                if (exists) {
                    msg.text('✖ 이미 등록된 번호입니다');
                    msg.attr('class', 'input-guide error');
                    phoneValid = false;
                } else {
                    msg.text('✔ 사용 가능한 번호입니다');
                    msg.attr('class', 'input-guide success');
                    phoneValid = true;
                }
                validateSignup();
            }
        });
    });

    // 닉네임 중복 체크
    let nicknameTimer = null;

    nicknameInput.addEventListener('input', function () {
        clearTimeout(nicknameTimer);

        const raw = $(this).val();
        const trimmed = raw.trim();
        const msg = $('#nicknameMsg');

        // 1. 앞/뒤 공백 자동 제거 (입력 보정)
        if (raw !== trimmed) {
            $(this).val(trimmed);
        }

        // 2. 중간 공백 실시간 차단 (AJAX 전에 컷)
        if (trimmed.includes(' ')) {
            msg.text('닉네임에는 공백을 사용할 수 없습니다.');
            msg.attr('class', 'input-guide error');
            nicknameValid = false;
            validateSignup();
            return;
        }

        // 3. 빈 값
        if (!trimmed) {
            msg.text('');
            nicknameValid = false;
            validateSignup();
            return;
        }

        // 4. 중복 체크 (AJAX)
        nicknameTimer = setTimeout(() => {
            $.ajax({
                url: contextPath + '/auth/check-nickname',
                type: 'GET',
                data: { nickname: trimmed },
                dataType: 'json',
                success: function (exists) {
                    if (exists) {
                        msg.text('✖ 이미 사용 중인 닉네임입니다.');
                        msg.attr('class', 'input-guide error');
                        nicknameValid = false;
                    } else {
                        msg.text('✔ 사용 가능한 닉네임입니다');
                        msg.attr('class', 'input-guide success');
                        nicknameValid = true;
                    }
                    validateSignup();
                }
            });
        }, 400);
    });

    function isSignupReady() {
        const passwordOk = isOAuth || ($('#signup-password').val() && $('#signup-password').val().length >= 4);
        return (
            emailValid &&
            nicknameValid &&
            phoneValid &&
            dong1Valid &&
            passwordOk
        );
    }

    function updateProgress() {
        let completed = 0;
        const total = 4;

        if (emailValid) completed++;
        if (nicknameValid) completed++;
        if (dong1Valid) completed++;

        // 비밀번호는 OAuth면 무조건 통과
        const passwordOk = isOAuth || ($('#signup-password').val() && $('#signup-password').val().length >= 4);
        if (passwordOk) completed++;

        const percent = (completed / total) * 100;

        $('#signupProgress')
            .css('width', percent + '%')
            .attr('aria-valuenow', percent);
    }

    function validateSignup() {
        const addrMsg = $('#addrMsg');
        if (!dong1Valid) {
            addrMsg.text('주소 1은 필수입니다');
        } else {
            addrMsg.text('');
        }

        $('#signupBtn').prop('disabled', !isSignupReady());
        updateProgress();
    }

    // 전역에서 dong1Valid 업데이트 가능하도록 window에 노출
    window.setDong1Valid = function(valid) {
        dong1Valid = valid;
        validateSignup();
    };

    window.validateSignup = validateSignup;

    // 페이지 로드 시 구 목록 로드 (하드코딩)
    function loadGus() {
        const gus = ['강남구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '서초구', '성동구', '성북구', '송파구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'];

        $.each(gus, function(i, gu) {
            $('#gu1').append($('<option>').val(gu).text(gu));
            $('#gu2').append($('<option>').val(gu).text(gu));
        });
    }

    // 구 선택 시 동 목록 로드
    function loadDongs(guSelectId, dongSelectId, dongCodeInputId) {
        const selectedGu = $(guSelectId).val();

        if (!selectedGu) {
            $(dongSelectId).prop('disabled', true).html('<option value="">동 선택</option>');
            $(dongCodeInputId).val('').trigger('change');
            return;
        }

        $.ajax({
            url: contextPath + '/location/getDongs',
            type: 'GET',
            data: { gunguName: selectedGu },
            dataType: 'json',
            success: function(dongs) {
                $(dongSelectId).prop('disabled', false).html('<option value="">동 선택</option>');

                $.each(dongs, function(i, dong) {
                    $(dongSelectId).append(
                        $('<option>')
                            .val(dong.dongCode)
                            .text(dong.dongName)
                    );
                });

                $(dongCodeInputId).val('').trigger('change');
            },
            error: function(err) {
                console.error('동 조회 실패', err);
                alert('동 정보를 불러오지 못했습니다.');
            }
        });
    }

    // 동 선택 시 dongCode 저장 (주소 2는 유효성에 영향 없음)
    function handleDongSelect(dongSelectId, dongCodeInputId, which) {
        const dongCode = $(dongSelectId).val();

        if (dongCode) {
            $(dongCodeInputId).val(dongCode);
            $(dongSelectId).addClass('has-value');
        } else {
            $(dongCodeInputId).val('');
            $(dongSelectId).removeClass('has-value');
        }

        if (which === 1) {
            $(dongCodeInputId).trigger('change'); // dong1Valid 갱신
        }
    }

    // 주소1 dongCode1 change → valid 플래그 갱신
    $('#dongCode1').on('change', function () {
        dong1Valid = $(this).val() !== '';
        validateSignup();
    });

    // 구 선택 이벤트 리스너
    $('#gu1').on('change', function() {
        $(this).addClass('has-value');
        loadDongs('#gu1', '#dong1', '#dongCode1');
    });

    $('#gu2').on('change', function() {
        $(this).addClass('has-value');
        loadDongs('#gu2', '#dong2', '#dongCode2');
    });

    // 동 선택 이벤트 리스너
    $('#dong1').on('change', function() {
        handleDongSelect('#dong1', '#dongCode1', 1);
    });

    $('#dong2').on('change', function() {
        handleDongSelect('#dong2', '#dongCode2', 2);
    });

    // 포커스 처리
    $('#gu1, #dong1, #gu2, #dong2').on('focus', function() {
        $(this).css('backgroundColor', 'var(--color-white)');
    }).on('blur', function() {
        if (!$(this).val()) {
            $(this).css('backgroundColor', 'var(--color-light-gray)');
        }
    });

    // 페이지 로드 시 구 목록 로드
    loadGus();

    // OAuth 회원가입 시 초기 버튼 상태 갱신
    if (isOAuth) {
        validateSignup();
    }

    // OAuth 회원가입 + 닉네임이 이미 채워져 있는 경우
    if (isOAuth && $('#nickname').val().trim()) {
        $('#nickname').trigger('input');
    }

    // Progress Bar 초기 표시
    updateProgress();

    // 회원가입 폼 제출 처리 (AJAX)
    $('#signupForm').on('submit', function(e) {
        e.preventDefault();

        if (!emailValid || !phoneValid || !nicknameValid || !dong1Valid) {
            return false;
        }

        const formData = new FormData(this);
        const originalBtnText = $('#signupBtn').text();

        $('#signupBtn').prop('disabled', true).text('처리 중...');

        $.ajax({
            url: contextPath + '/auth/signup',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    window.location.href = contextPath + '/auth/login';
                } else {
                    $('#signupBtn').prop('disabled', false).text(originalBtnText);
                    const errorMsg = response.message || '회원가입 중 오류가 발생했습니다.';
                    $('#globalError').text(errorMsg).show();
                }
            },
            error: function(xhr) {
                $('#signupBtn').prop('disabled', false).text(originalBtnText);
                let errorMsg = '요청을 처리하지 못했습니다. 다시 시도해주세요.';
                try {
                    const response = JSON.parse(xhr.responseText);
                    if (response.message) {
                        errorMsg = response.message;
                    }
                } catch (e) {
                    // JSON 파싱 실패 시 기본 메시지 사용
                }
                $('#globalError').text(errorMsg).show();
            }
        });

        return false;
    });

    // 입력 시작 시 에러 숨김
    document.querySelectorAll("input, select").forEach(el => {
        el.addEventListener("input", () => {
            const globalError = document.getElementById("globalError");
            if (globalError) {
                globalError.style.display = "none";
            }
        });
    });
});