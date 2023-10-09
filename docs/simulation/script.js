let myChart;

function calculate() {
    const length = document.getElementById('length').value;
    const times = document.getElementById('times').value;
    const data = [];

    // 既存のグラフが存在する場合は破棄
    if (myChart) {
        myChart.destroy();
    }

    if (1 > length || length > 100) return;
    if (100 > times || times > 10000) return;

    for (let i = 0; i < times; i++) {
        const array = Array.from({ length: length }, () => Math.round(Math.random() * 100));
        const mean = array.reduce((sum, value) => sum + value, 0) / length;
        const variance = array.reduce((sum, value) => sum + Math.pow(value - mean, 2), 0) / length;
        const stdDev = Math.sqrt(variance);
        data.push(stdDev);
    }
    const frequency = {};
    data.forEach(value => {
        const key = value.toFixed(1);
        frequency[key] = (frequency[key] || 0) + 1;
    });

    // 0から50までのラベルを作成し、小数点第1位までの値を取得
    const labels = Array.from({ length: 501 }, (_, i) => parseFloat((i / 10).toFixed(1))).filter(value => value <= 50);

    // 存在しない値は0として扱う
    const chartData = labels.map(label => frequency[String(label)] || 0);

    const ctx = document.getElementById('chart').getContext('2d');
    myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: '標準偏差の分布',
                data: chartData,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1,
                fill: false
            }]
        },
        options: {
            scales: {
                x: {
                    title: {
                        display: true,
                        text: '標準偏差'
                    },
                    ticks: {
                        maxTicksLimit: 51,
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '回数'
                    }
                }
            }
        }
    });
    const chartElement = document.getElementById('chart');
    chartElement.scrollIntoView({ behavior: 'smooth' });
}

document.getElementById('length').addEventListener('input', function (e) {
    const value = parseInt(e.target.value, 10);
    if (value < 1) e.target.value = 1;
    if (value > 100) e.target.value = 100;
});

document.getElementById('times').addEventListener('input', function (e) {
    const value = parseInt(e.target.value, 10);
    if (value < 100) e.target.value = 100;
    if (value > 10000) e.target.value = 10000;
});
