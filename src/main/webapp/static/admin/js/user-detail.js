// 메모 저장 기능 (AJAX 예시)
function saveMemo() {
    const memoContent = document.getElementById('adminMemo').value;
    const userId = '${user.userId}'; // EL로 현재 보고 있는 유저 ID 주입

    if (!userId) {
        alert("유저 정보를 찾을 수 없습니다.");
        return;
    }

    // 실제 API 연동 시 주석 해제 및 수정
    /*
    fetch('${pageContext.request.contextPath}/api/admin/users/' + userId + '/memo', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ memo: memoContent })
    })
    .then(res => res.json())
    .then(data => {
        if(data.result === 'success') alert('메모가 저장되었습니다.');
        else alert('저장 실패');
    });
    */

    // 테스트용 알림
    console.log("저장할 메모:", memoContent);
    alert("관리자 메모가 저장되었습니다. (UI 테스트)");
}
