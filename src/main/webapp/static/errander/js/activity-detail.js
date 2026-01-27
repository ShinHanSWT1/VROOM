/**
 * Errander Activity Detail Page JavaScript
 * 거래 상세 페이지
 */

// Activity detail page JavaScript
// Sample data - replace with API calls in production
const requesterInfo = {
    name: '홍길동',
    nickname: '길동이',
    trustScore: 95,
    completedCount: 42
};

const vroomSchedule = {
    createdDate: '2024-01-10',
    scheduledDate: '2024-01-15',
    scheduledTime: '14:30',
    completedTime: '15:45'
};

const vroomLocation = {
    startAddress: '서울시 강남구 역삼동 123-45',
    endAddress: '서울시 강남구 역삼동 678-90'
};

const paymentInfo = {
    baseAmount: 10000,
    additionalAmount: 5000,
    fee: 1000,
    finalAmount: 14000
};

const reviewInfo = {
    rating: 4.5,
    content: '매우 친절하고 빠르게 심부름을 완료해주셨어요! 다음에도 부탁드리고 싶습니다.'
};

function formatCurrency(amount) {
    return '₩' + amount.toLocaleString('ko-KR');
}

function initPage() {
    // Get vroomId from URL
    const urlParams = new URLSearchParams(window.location.search);
    const vroomId = urlParams.get('id');
    
    // In production, fetch data from API using vroomId
    // For now, use sample data
    
    // Update requester info
    document.getElementById('requesterName').textContent = requesterInfo.name;
    document.getElementById('requesterNickname').textContent = requesterInfo.nickname;
    document.getElementById('requesterTrustScore').textContent = requesterInfo.trustScore;
    document.getElementById('requesterCompletedCount').textContent = requesterInfo.completedCount;
    
    // Update schedule
    document.getElementById('createdDate').textContent = vroomSchedule.createdDate;
    document.getElementById('scheduledDate').textContent = vroomSchedule.scheduledDate;
    document.getElementById('scheduledTime').textContent = vroomSchedule.scheduledTime;
    document.getElementById('completedTime').textContent = vroomSchedule.completedTime;
    
    // Update location
    document.getElementById('startAddress').textContent = vroomLocation.startAddress;
    document.getElementById('endAddress').textContent = vroomLocation.endAddress;
    
    // Update payment
    document.getElementById('baseAmount').textContent = formatCurrency(paymentInfo.baseAmount);
    document.getElementById('additionalAmount').textContent = formatCurrency(paymentInfo.additionalAmount);
    document.getElementById('fee').textContent = formatCurrency(paymentInfo.fee);
    document.getElementById('finalAmount').textContent = formatCurrency(paymentInfo.finalAmount);
    
    // Update review
    if (reviewInfo && reviewInfo.content) {
        document.getElementById('reviewRating').textContent = reviewInfo.rating + ' / 5.0';
        document.getElementById('reviewContent').textContent = reviewInfo.content;
    } else {
        document.getElementById('reviewContainer').innerHTML = 
            '<div class="review-content">아직 리뷰가 작성되지 않았습니다.</div>';
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', initPage);
