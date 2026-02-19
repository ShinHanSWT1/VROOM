/**
 * 날짜 포맷팅 유틸 함수
 * @param {string | number | Date} dateInput - 변환할 날짜 데이터 (Timestamp, ISO String 등)
 * @returns {string} "YYYY-MM-DD HH:mm" 형식의 문자열 (유효하지 않으면 '-' 반환)
 */
function formatDateTime(dateInput) {
    if (!dateInput) return '-'; // 데이터가 없으면 하이픈 반환

    const date = new Date(dateInput);

    // 유효하지 않은 날짜인 경우 처리
    if (isNaN(date.getTime())) return '-';

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 +1
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');

    return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
}

/**
 * 날짜만 필요한 경우 (YYYY-MM-DD)
 */
function formatDate(dateInput) {
    if (!dateInput) return '-';
    const date = new Date(dateInput);
    if (isNaN(date.getTime())) return '-';

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');

    return year + '-' + month + '-' + day;
}