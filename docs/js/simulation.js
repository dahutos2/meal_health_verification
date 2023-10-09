function calculate() {
    const length = document.getElementById('length').value;
    const times = document.getElementById('times').value;
    const data = [];
    for (let i = 0; i < times; i++) {
        const array = Array.from({ length: length }, () => Math.random() * 100);
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
    const labels = Object.keys(frequency);
    const chartData = labels.map(label => frequency[label]);
    const ctx = document.getElementById('chart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Frequency',
                data: chartData,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                x: {
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
