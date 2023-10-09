function calculate() {
    const length = document.getElementById('length').value;
    const times = document.getElementById('times').value;
    const data = [];
    const progressDiv = document.getElementById('progress');
    for (let i = 0; i < times; i++) {
        const array = Array.from({ length: length }, () => Math.round(Math.random() * 100));
        const mean = array.reduce((sum, value) => sum + value, 0) / length;
        const variance = array.reduce((sum, value) => sum + Math.pow(value - mean, 2), 0) / length;
        const stdDev = Math.sqrt(variance);
        data.push(stdDev);

        // 進捗率を更新
        if (i % 100 === 0) {  // 100回ごとに進捗を更新
            const progress = ((i / times) * 100).toFixed(2);
            progressDiv.innerText = `進捗: ${progress}%`;
        }
    }
    const frequency = {};
    data.forEach(value => {
        const key = value.toFixed(1);
        frequency[key] = (frequency[key] || 0) + 1;
    });
    const labels = Object.keys(frequency).map(key => parseFloat(key)).filter(value => value <= 50);
    const chartData = labels.map(label => frequency[label.toFixed(1)]);
    const ctx = document.getElementById('chart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Frequency',
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
                    min: 0,
                    max: 50,
                    title: {
                        display: true,
                        text: 'Standard Deviation'
                    }
                },
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Count'
                    }
                }
            }
        }
    });
}
