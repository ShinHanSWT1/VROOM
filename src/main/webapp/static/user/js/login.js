document.addEventListener('DOMContentLoaded', function() {
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const loginBtn = document.getElementById('loginBtn');

    // 이메일 입력 처리
    emailInput.addEventListener('input', function() {
        if (this.value.length > 0) {
            this.classList.add('has-value');
        } else {
            this.classList.remove('has-value');
        }
        checkLoginButton();
    });

    // 비밀번호 입력 처리
    passwordInput.addEventListener('input', function() {
        const value = this.value;
        if (value.length > 0) {
            this.classList.add('has-value');
            if (value.length >= 4) {
                this.classList.add('valid');
            } else {
                this.classList.remove('valid');
            }
        } else {
            this.classList.remove('has-value', 'valid');
        }
        checkLoginButton();
    });

    // 로그인 버튼 활성화 체크
    function checkLoginButton() {
        const emailValue = emailInput.value.trim();
        const passwordValue = passwordInput.value;

        if (emailValue.length > 0 && passwordValue.length >= 4) {
            loginBtn.disabled = false;
        } else {
            loginBtn.disabled = true;
        }
    }

    // 포커스 시 배경색 변경
    emailInput.addEventListener('focus', function() {
        this.style.backgroundColor = 'var(--color-white)';
    });

    emailInput.addEventListener('blur', function() {
        if (!this.value) {
            this.style.backgroundColor = 'var(--color-light-gray)';
        }
    });

    passwordInput.addEventListener('focus', function() {
        this.style.backgroundColor = 'var(--color-white)';
    });

    passwordInput.addEventListener('blur', function() {
        if (!this.value) {
            this.style.backgroundColor = 'var(--color-light-gray)';
        }
    });
});
