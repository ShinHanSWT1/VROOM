document.addEventListener('DOMContentLoaded', function () {
    const contextPath = document.querySelector('meta[name="context-path"]')?.content || '';

    function showNoDataText(elementId) {
        const element = document.getElementById(elementId);
        if (element) {
            element.style.display = 'block';
        }
    }

    function hideNoDataText(elementId) {
        const element = document.getElementById(elementId);
        if (element) {
            element.style.display = 'none';
        }
    }

    // Errand Status Chart
    fetch(contextPath + '/api/admin/dashboard/errand-status')
        .then(res => res.json())
        .then(data => {
            const statusColorMap = {
                WAITING: '#FFC107',
                MATCHED: '#03A9F4',
                CONFIRMED1: '#4CAF50',
                CONFIRMED2: '#FF9800',
                COMPLETED: '#9E9E9E',
                CANCELED: '#F44336',
                HOLD: '#4c54af'
            };

            const ctx = document.getElementById('errandStatusChart');
            if (!ctx) return;

            const total = data.values.reduce((a, b) => a + b, 0);

            let chartLabels, chartValues, chartColors;

            if (total === 0) {
                chartLabels = ['데이터 없음'];
                chartValues = [1];
                chartColors = ['#E0E0E0'];
                showNoDataText('noDataTextErrandStatus');
            } else {
                chartLabels = data.labels;
                chartValues = data.values;
                chartColors = data.labels.map(status => statusColorMap[status]);
                hideNoDataText('noDataTextErrandStatus');
            }

            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: chartLabels,
                    datasets: [{
                        data: chartValues,
                        backgroundColor: chartColors,
                        hoverOffset: 8
                    }]
                },
                options: {
                    cutout: '65%',
                    layout: { padding: 20 },
                    plugins: {
                        legend: { display: total !== 0 },
                        tooltip: { enabled: total !== 0 }
                    }
                }
            });
        });

    // Errand Category Chart
    fetch(contextPath + '/api/admin/dashboard/errand-category')
        .then(res => res.json())
        .then(data => {
            const CATEGORY_COLORS = ['#FCB9AA', '#FFDBCC', '#ECEAE4', '#A2E1DB', '#55CBCD', '#C6DBDA', '#F6EAC2', '#CCE2CB'];
            const ctx = document.getElementById('errandCategoryChart');
            if (!ctx) return;

            const total = data.values.reduce((a, b) => a + b, 0);
            let chartLabels, chartValues;

            if (total === 0) {
                chartLabels = ['데이터 없음'];
                chartValues = [0];
                showNoDataText('noDataTextErrandCategory');
            } else {
                chartLabels = data.labels;
                chartValues = data.values;
                hideNoDataText('noDataTextErrandCategory');
            }

            const barColors = chartLabels.map((_, index) => CATEGORY_COLORS[index % CATEGORY_COLORS.length]);
            const barHoverColors = barColors.map(color => color + 'CC');

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: chartLabels,
                    datasets: [{
                        data: chartValues,
                        backgroundColor: barColors,
                        hoverBackgroundColor: barHoverColors,
                        borderWidth: 1,
                        borderRadius: 6,
                        barThickness: 28,
                        maxBarThickness: 32,
                        categoryPercentage: 0.6,
                        barPercentage: 0.8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            enabled: total !== 0,
                            backgroundColor: '#2C3E50',
                            titleColor: '#FFFFFF',
                            bodyColor: '#FFFFFF',
                            padding: 10,
                            cornerRadius: 6,
                            callbacks: {
                                label: (ctx) => ` ${ctx.raw.toLocaleString()}건`
                            }
                        }
                    },
                    scales: {
                        x: { grid: { display: false }, ticks: { color: '#7F8C8D', font: { size: 11, weight: '500' } } },
                        y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' }, ticks: { precision: 0, color: '#7F8C8D', font: { size: 11 } } }
                    },
                    layout: { padding: { top: 10, left: 8, right: 8, bottom: 0 } }
                }
            });
        });

    // Errand Region Chart
    fetch(contextPath + '/api/admin/dashboard/errand-region')
        .then(res => res.json())
        .then(data => {
            const ctx = document.getElementById('errandRegionChart');
            const tbody = document.getElementById('regionSummaryBody');
            if (!ctx || !tbody) return;

            const hasData = data && data.chart && data.chart.labels && data.chart.labels.length > 0;
            let chartLabels, chartValues;

            if (hasData) {
                chartLabels = data.chart.labels;
                chartValues = data.chart.values;
                hideNoDataText('noDataTextRegion');
            } else {
                chartLabels = ['서울', '경기', '인천', '부산', '대구'];
                chartValues = [0, 0, 0, 0, 0];
                showNoDataText('noDataTextRegion');
                document.getElementById('noDataTextRegion').innerText = "데이터가 집계되지 않았습니다.";
            }

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: chartLabels,
                    datasets: [{
                        label: '등록 건수',
                        data: chartValues,
                        backgroundColor: hasData ? '#FFC107' : '#F5F5F5',
                        borderColor: hasData ? '#FFB300' : '#E0E0E0',
                        borderWidth: 1,
                        borderRadius: 4,
                        barPercentage: 0.5
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false }, tooltip: { enabled: hasData } },
                    scales: {
                        y: { beginAtZero: true, suggestedMax: hasData ? undefined : 10, grid: { color: 'rgba(0, 0, 0, 0.05)' }, ticks: { precision: 0, font: { size: 11 } } },
                        x: { grid: { display: false }, ticks: { font: { size: 11 } } }
                    }
                }
            });

            tbody.innerHTML = '';
            if (hasData) {
                data.table.forEach((row, index) => {
                    tbody.innerHTML += `
                        <tr>
                            <td style="font-weight: 600;"><span style="color:var(--color-accent); margin-right:4px;">${index + 1}.</span> ${row.region}</td>
                            <td>${row.total.toLocaleString()}건</td>
                            <td><div style="display:flex; align-items:center; gap:5px;"><div style="width:50px; height:4px; background:#eee; border-radius:2px;"><div style="width:${row.completionRate}%; height:100%; background:#27AE60; border-radius:2px;"></div></div><span style="font-size:0.8rem">${row.completionRate}%</span></div></td>
                            <td>${row.avgPrice.toLocaleString()}원</td>
                        </tr>`;
                });
            } else {
                tbody.innerHTML = `<tr><td colspan="4" style="text-align: center; color: var(--color-gray); padding: 2rem 1rem;"><div style="font-size: 2rem; margin-bottom: 0.5rem;">📭</div><div>아직 등록된 심부름 데이터가 없습니다.</div></td></tr>`;
            }
        })
        .catch(err => console.error('지역별 데이터 로드 실패:', err));

    // Hourly Trend Chart
    fetch(contextPath + '/api/admin/dashboard/errand-hourly-trend')
        .then(res => res.json())
        .then(data => {
            const ctx = document.getElementById('hourlyTrendChart');
            if (!ctx) return;

            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: '시간대별 심부름 등록',
                        data: data.values,
                        borderColor: '#FFC107',
                        backgroundColor: 'rgba(255,193,7,0.2)',
                        tension: 0.3,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    plugins: { legend: { display: false } },
                    scales: { y: { beginAtZero: true, ticks: { precision: 0 } } }
                }
            });
        });

    // Issue Summary
    fetch(contextPath + '/api/admin/dashboard/issue-summary')
        .then(res => res.json())
        .then(data => {
            document.getElementById('issuePending').innerText = data.pending || 0;
            document.getElementById('issueProcessing').innerText = data.processing || 0;
            document.getElementById('issueCompleted').innerText = data.completed || 0;
        })
        .catch(err => console.error('이슈 요약 로드 실패:', err));

    // Settlement Summary
    fetch(contextPath + '/api/admin/dashboard/settlement-summary')
        .then(res => res.json())
        .then(data => {
            const formatMoney = (num) => (num || 0).toLocaleString() + '원';
            const formatCount = (num) => (num || 0).toLocaleString() + '건';

            document.getElementById('settleToday').innerText = formatMoney(data.today_amount);
            document.getElementById('settleWaiting').innerText = formatCount(data.pending_count);
            document.getElementById('settleMonth').innerText = formatMoney(data.month_amount);
        })
        .catch(err => console.error('정산 요약 로드 실패:', err));
});
