import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HealthPointChart extends StatefulWidget {
  const HealthPointChart({super.key});

  @override
  State<HealthPointChart> createState() => _HealthPointChartState();
}

class _HealthPointChartState extends State<HealthPointChart> {
  List<Color> gradientColors = [
    Colors.red,
    Colors.redAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 16,
          left: 12,
          top: 24,
          bottom: 14,
        ),
        child: LineChart(mainData()),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('月', style: style);
        break;
      case 1:
        text = const Text('火', style: style);
        break;
      case 2:
        text = const Text('水', style: style);
        break;
      case 3:
        text = const Text('木', style: style);
        break;
      case 4:
        text = const Text('金', style: style);
        break;
      case 5:
        text = const Text('土', style: style);
        break;
      case 6:
        text = const Text('日', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 20:
        text = '20';
        break;
      case 40:
        text = '40';
        break;
      case 60:
        text = '60';
        break;
      case 80:
        text = '80';
        break;
      case 100:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 20,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: [..._getFlSpotList(_getWeeklyData(weeklyDataExample))],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getFlSpotList(Map<DateTime, double> weeklyData) {
    var index = 0;
    return weeklyData.entries
        .map((e) => FlSpot((index++).toDouble(), e.value))
        .toList();
  }

  /// 1週間分のデータからグラフ表示用のデータを抽出する
  Map<DateTime, double> _getWeeklyData(Map<DateTime, double> foodHistory) {
    var sortedFoodHistory = SplayTreeMap<DateTime, double>.from(
        foodHistory, (DateTime a, DateTime b) => a.compareTo(b)).entries;
    var retMap = <DateTime, double>{};

    // 月曜から順にデータを作成していく
    MapEntry<DateTime, double> dayData;

    // その週の最初の月曜を取得
    DateTime firstMonday = sortedFoodHistory.first.key
        .subtract(Duration(days: sortedFoodHistory.first.key.weekday - 1));
    firstMonday =
        DateTime(firstMonday.year, firstMonday.month, firstMonday.day);

    for (var value in sortedFoodHistory) {
      var dayDataDay = DateTime(value.key.year, value.key.month, value.key.day);
      retMap[dayDataDay] = value.value;
    }

    //　その週の最初の月曜から７日間るーぷして、
    // 空きの日程がないか確認。月曜がなければ０をあれば前日のスコアで埋める
    for (var day = firstMonday;
        day.isBefore(firstMonday.add(const Duration(days: 6)));
        day = day.add(const Duration(days: 1))) {
      if (retMap.containsKey(day)) continue;
      if (day.isAtSameMomentAs(firstMonday)) retMap[day] = 0.0;
      retMap[day] = retMap[day.subtract(const Duration(days: 1))] ?? 0;
    }

    retMap = SplayTreeMap<DateTime, double>.from(
        retMap, (DateTime a, DateTime b) => a.compareTo(b));
    return retMap;
  }

  Map<DateTime, double> weeklyDataExample = {
    DateTime(2023, 10, 3, 1): 54,
    DateTime(2023, 10, 3, 2): 54,
    DateTime(2023, 10, 3, 3): 88,
    DateTime(2023, 10, 5): 93,
    DateTime(2023, 10, 6): 21,
    DateTime(2023, 10, 7): 44,
  };
}
