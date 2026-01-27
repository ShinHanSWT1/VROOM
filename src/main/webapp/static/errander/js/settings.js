/**
 * Errander Settings Page JavaScript
 * 설정 페이지 - 동네 설정, 인증, 차단 관리
 */

// Settings page JavaScript
// Sample data - replace with API calls in production
const userProfile = {
    isPhoneVerified: true,
    isEmailVerified: false
};

const dongCode3 = '';
const dongCode4 = '';

const locationList = [
    { dongCode: '1168010100', dongName: '서울시 강남구 역삼동' },
    { dongCode: '1168010200', dongName: '서울시 강남구 논현동' },
    { dongCode: '1168010300', dongName: '서울시 강남구 압구정동' },
    { dongCode: '1168010400', dongName: '서울시 강남구 청담동' },
    { dongCode: '1168010500', dongName: '서울시 강남구 삼성동' },
    { dongCode: '1168010600', dongName: '서울시 강남구 대치동' },
    { dongCode: '1168010700', dongName: '서울시 강남구 개포동' },
    { dongCode: '1168010800', dongName: '서울시 강남구 도곡동' }
];

const blockedUserCount = 0;

function initPage() {
    // Populate location selects
    const location1Select = document.getElementById('location1');
    const location2Select = document.getElementById('location2');
    
    locationList.forEach(location => {
        const option1 = document.createElement('option');
        option1.value = location.dongCode;
        option1.textContent = location.dongName;
        if (location.dongCode === dongCode3) {
            option1.selected = true;
        }
        location1Select.appendChild(option1);
        
        const option2 = document.createElement('option');
        option2.value = location.dongCode;
        option2.textContent = location.dongName;
        if (location.dongCode === dongCode4) {
            option2.selected = true;
        }
        location2Select.appendChild(option2);
    });
    
    // Update verification badges
    const phoneBadge = document.getElementById('phoneVerificationBadge');
    if (userProfile.isPhoneVerified) {
        phoneBadge.textContent = '인증 완료';
        phoneBadge.classList.add('verified');
        phoneBadge.classList.remove('pending');
    } else {
        phoneBadge.textContent = '미인증';
        phoneBadge.classList.add('pending');
        phoneBadge.classList.remove('verified');
    }
    
    const emailBadge = document.getElementById('emailVerificationBadge');
    if (userProfile.isEmailVerified) {
        emailBadge.textContent = '인증 완료';
        emailBadge.classList.add('verified');
        emailBadge.classList.remove('pending');
    } else {
        emailBadge.textContent = '미인증';
        emailBadge.classList.add('pending');
        emailBadge.classList.remove('verified');
    }
    
    // Update blocked user count
    document.getElementById('blockedUserCount').textContent = blockedUserCount;
}

function saveLocationSettings(event) {
    event.preventDefault();
    
    const location1 = document.getElementById('location1').value;
    const location2 = document.getElementById('location2').value;
    
    if (!location1 && !location2) {
        alert('최소 1개의 동네를 선택해주세요.');
        return false;
    }
    
    if (location1 && location2 && location1 === location2) {
        alert('서로 다른 동네를 선택해주세요.');
        return false;
    }
    
    // In production, make API call here
    fetch('/api/rider/mypage/settings/location', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            dongCode3: location1,
            dongCode4: location2
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('동네 설정이 저장되었습니다.');
        } else {
            alert('동네 설정 저장 중 오류가 발생했습니다.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('동네 설정 저장 중 오류가 발생했습니다.');
    });
}

function goToVerification() {
    // Navigate to verification page
    alert('인증 페이지로 이동합니다.');
    // location.href = '/rider/verify';
}

function manageBlockedUsers() {
    // Navigate to blocked users management page
    alert('차단된 사용자 관리 페이지로 이동합니다.');
    // location.href = '/rider/mypage/settings/blocked-users';
}

// Initialize on page load
initPage();
