// Password Toggle
const passwordInput = document.getElementById('adminPassword');
const passwordToggle = document.getElementById('passwordToggle');

passwordToggle.addEventListener('click', function() {
    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordInput.setAttribute('type', type);
    this.textContent = type === 'password' ? '👁️' : '🙈';
});

// Hide alert on input
document.querySelectorAll('.form-input').forEach(input => {
    input.addEventListener('input', function() {
        alertMessage.classList.remove('show');
    });
});
