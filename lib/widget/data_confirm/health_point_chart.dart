import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../share/colors.dart';

class HealthPointChart extends StatefulWidget {
  const HealthPointChart({super.key, required this.graphHistoryData});

  final Map<DateTime, double> graphHistoryData;

  @override
  State<HealthPointChart> createState() => _HealthPointChartState();
}

class _HealthPointChartState extends State<HealthPointChart> {
  List<Color> gradientColors = [
    ColorType.footer.background,
    ColorType.footer.background.withOpacity(0.5),
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
    final style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: ColorType.dataConfirm.chartLine);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('月', style: style);
        break;
      case 1:
        text = Text('火', style: style);
        break;
      case 2:
        text = Text('水', style: style);
        break;
      case 3:
        text = Text('木', style: style);
        break;
      case 4:
        text = Text('金', style: style);
        break;
      case 5:
        text = Text('土', style: style);
        break;
      case 6:
        text = Text('日', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: ColorType.dataConfirm.chartLine);
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
          return FlLine(
            color: ColorType.dataConfirm.chartLine,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: ColorType.dataConfirm.chartLine,
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
        border: Border.all(color: ColorType.dataConfirm.chartLine),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: [..._getFlSpotList(_getWeeklyData(widget.graphHistoryData))],
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
    if (weeklyData.isEmpty) return <FlSpot>[];

    var index = 0;
    return weeklyData.entries
        .map((e) => FlSpot((index++).toDouble(), e.value))
        .toList();
  }

  /// 1週間分のデータからグラフ表示用のデータを抽出する
  Map<DateTime, double> _getWeeklyData(Map<DateTime, double> foodHistory) {
    if (foodHistory.isEmpty) return <DateTime, double>{};

    var sortedFoodHistory = SplayTreeMap<DateTime, double>.from(
        foodHistory, (DateTime a, DateTime b) => a.compareTo(b)).entries;
    var retMap = <DateTime, double>{};

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
}
