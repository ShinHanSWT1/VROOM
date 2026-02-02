/**
 * Errander Activity Page JavaScript
 * 나의 거래 페이지 - FullCalendar & 일별 수익
 */

function formatCurrency(amount) {
    return '₩' + amount.toLocaleString('ko-KR');
}

document.addEventListener('DOMContentLoaded', function() {
    const calendarEl = document.getElementById('calendar');

    const calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: ''
        },
        buttonText: {
            today: '오늘'
        },
        events: function(fetchInfo, successCallback, failureCallback) {
            // fetchInfo.start가 이전 달 끝일 수 있으므로 중간 날짜 기준으로 계산
            const mid = new Date((fetchInfo.start.getTime() + fetchInfo.end.getTime()) / 2);
            const year = mid.getFullYear();
            const month = mid.getMonth() + 1;

            $.ajax({
                url: '/vroom/errander/mypage/api/daily-earnings',
                type: 'GET',
                data: { year: year, month: month },
                success: function(data) {
                    const events = data.map(function(item) {
                        return {
                            title: formatCurrency(item.dailyEarning),
                            start: item.earnDate,
                            allDay: true,
                            // 추가 정보가 필요하면 extendedProps에 담을 수 있음
                            extendedProps: {
                                dailyEarning: item.dailyEarning
                            }
                        };
                    });
                    successCallback(events);
                },
                error: function(xhr, status, error) {
                    console.error("Failed to fetch earnings:", error);
                    failureCallback(error);
                }
            });
        },

        // 날짜 클릭 시
        dateClick: function(info) {
            var dateStr = info.dateStr;

            $.ajax({
                url: '/vroom/errander/mypage/api/daily-detail',
                type: 'GET',
                data: { date: dateStr },
                success: function(data) {
                    renderTransactionList(data, dateStr);
                },
                error: function() {
                    document.getElementById('transactionListContainer').innerHTML =
                        '<p style="text-align: center; color: var(--color-gray); padding: 2rem;">데이터를 불러오지 못했습니다.</p>';
                }
            });
        },

        // 이벤트(수익 금액) 클릭 시 해당 날짜 거래 내역 조회
        eventClick: function(info) {
            var dateStr = info.event.startStr;

            $.ajax({
                url: '/vroom/errander/mypage/api/daily-detail',
                type: 'GET',
                data: { date: dateStr },
                success: function(data) {
                    renderTransactionList(data, dateStr);
                },
                error: function() {
                    document.getElementById('transactionListContainer').innerHTML =
                        '<p style="text-align: center; color: var(--color-gray); padding: 2rem;">데이터를 불러오지 못했습니다.</p>';
                }
            });
        }
    });

    calendar.render();
});


function renderTransactionList(activities, dateStr) {
    var container = document.getElementById('transactionListContainer');
    container.innerHTML = '';

    var titleEl = document.querySelector('.transaction-list-title');
    if (titleEl) {
        titleEl.textContent = dateStr + ' 거래 내역 (' + activities.length + '건)';
    }

    if (activities.length === 0) {
        container.innerHTML = '<p style="text-align: center; color: var(--color-gray); padding: 2rem;">해당 날짜에 거래 내역이 없습니다.</p>';
        return;
    }

    activities.forEach(function(activity) {
        var item = document.createElement('div');
        item.className = 'transaction-item';
        item.onclick = function() { location.href = '/vroom/errand/detail?errandsId=' + activity.errandsId; };

        item.innerHTML =
            '<div class="transaction-info">' +
                '<div class="transaction-icon">🐝</div>' +
                '<div class="transaction-details">' +
                    '<div class="transaction-name">' + activity.title + '</div>' +
                    '<div class="transaction-date">' + (activity.dongFullName || '') + '</div>' +
                '</div>' +
            '</div>' +
            '<div class="transaction-amount">' + formatCurrency(activity.rewardAmount) + '</div>';

        container.appendChild(item);
    });
}
