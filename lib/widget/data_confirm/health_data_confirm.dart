import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:meal_health_verification/index.dart';

import 'health_point_chart.dart';

class HealthDataConfirm extends ConsumerStatefulWidget {
  const HealthDataConfirm({super.key});

  @override
  ConsumerState createState() => _HealthDataConfirmState();
}

class _HealthDataConfirmState extends ConsumerState<HealthDataConfirm> {
  var healthData = <Meal>[];
  var displayDurationBeginDate = DateTime.now()
      .subtract(Duration(days: DateTime.now().weekday - 1)); // 必ず月曜

  @override
  void initState() {
    super.initState();

    var state = ref.read(mealNotifierProvider).list;
    Future.delayed(
      Duration.zero,
      () async {
        setState(
          () {
            healthData = state ?? <Meal>[];
            final List<Meal> list = List.from(healthData)
              ..sort((Meal a, Meal b) => a.date.compareTo(b.date));
            displayDurationBeginDate = list.first.date
                .subtract(Duration(days: list.first.date.weekday - 1));
          },
        );
      },
    );
  }

  /// 日付の表示用文字列取得メソッド
  /// 例:日本語→9月25日(月)
  String _getDisplayDate(BuildContext context, DateTime date) {
    var languageCode = Localizations.localeOf(context).languageCode;
    return DateFormat.MMMEd(languageCode).format(date);
  }

  /// 時間の表示用文字列取得メソッド
  /// 例:日本語→18:01
  String _getDisplayTime(BuildContext context, DateTime date) {
    var languageCode = Localizations.localeOf(context).languageCode;
    return DateFormat.Hm(languageCode).format(date);
  }

  /// 日時で別れているMapを日毎のMapにまとめる
  Map<DateTime, Map<DateTime, String>> _getDailyFoodHistory(
      Map<DateTime, String> foodHistory) {
    var sortedFoodHistory = SplayTreeMap<DateTime, String>.from(
        foodHistory, (DateTime a, DateTime b) => -a.compareTo(b));
    var dailyFoodHistory = <DateTime, Map<DateTime, String>>{};

    sortedFoodHistory.forEach((key, value) {
      var day = DateTime(key.year, key.month, key.day);
      var dayFoodHistory = <DateTime, String>{};

      if (dailyFoodHistory.containsKey(day)) {
        dayFoodHistory = dailyFoodHistory[day]!;
        dayFoodHistory[key] = value;
      } else {
        dayFoodHistory[key] = value;
      }

      dailyFoodHistory[day] = dayFoodHistory;
    });

    return dailyFoodHistory;
  }

  /// 時間と食事名の表示用文字列を取得
  String _getDisplayTimeAndFood(
      BuildContext context, MapEntry<DateTime, String> entry) {
    var timeString = _getDisplayTime(context, entry.key);
    var foodString = entry.value;
    return '$timeString $foodString';
  }

  // グラフ用データに整形したMapを取得
  Map<DateTime, double> _getGraphHistoryData() {
    var retMap = <DateTime, double>{};
    for (var value in healthData) {
      retMap[value.date] = value.healthRating.toDouble();
    }
    return retMap;
  }

  // 食事履歴表示用データに整形したMapを取得
  Map<DateTime, String> _getFoodHistoryData() {
    var retMap = <DateTime, String>{};
    for (var value in healthData) {
      retMap[value.date] = value.name;
    }
    return retMap;
  }

  @override
  Widget build(BuildContext context) {
    var graphHistoryData = _getGraphHistoryData(); // グラフ用データに整形したもの渡す
    var foodHistoryData = _getFoodHistoryData(); // 食事履歴表示用データに整形したもの渡す
    var dailyFoodHistory = _getDailyFoodHistory(foodHistoryData);
    var languageCode = Localizations.localeOf(context).languageCode;

    String getDisplayDurationString(DateTime beginDate) {
      var beginDateString = DateFormat.MMMEd(languageCode).format(beginDate);
      var finishDateString = DateFormat.MMMEd(languageCode)
          .format(beginDate.add(const Duration(days: 6)));
      return '$beginDateString - $finishDateString';
    }

    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                final newBeginDate =
                    displayDurationBeginDate.subtract(const Duration(days: 7));
                final newHealthData = await ref
                    .read(mealNotifierProvider.notifier)
                    .findByDateRange(
                        startDate: newBeginDate,
                        endDate: newBeginDate.add(const Duration(days: 6)));
                setState(() {
                  healthData = newHealthData;
                  displayDurationBeginDate = newBeginDate;
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: ColorType.footer.background,
              ),
              child: const Text('先週'),
            ),
            const Spacer(),
            Text(getDisplayDurationString(displayDurationBeginDate)),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final newBeginDate =
                    displayDurationBeginDate.add(const Duration(days: 7));
                final newHealthData = await ref
                    .read(mealNotifierProvider.notifier)
                    .findByDateRange(
                        startDate: newBeginDate,
                        endDate: newBeginDate.add(const Duration(days: 6)));
                setState(() {
                  healthData = newHealthData;
                  displayDurationBeginDate = newBeginDate;
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: ColorType.footer.background,
              ),
              child: const Text('翌週'),
            ),
          ],
        ),
        // 健康ポイントの折れ線グラフ表示部
        Expanded(
          child: HealthPointChart(
            graphHistoryData: graphHistoryData,
          ),
        ),
        // 食事履歴リスト表示部
        Expanded(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: dailyFoodHistory.isEmpty
                ? Center(
                    child: SizedBox(
                        width: context.deviceWidth * 0.3,
                        height: context.deviceWidth * 0.3,
                        child: const ColorfulLoadPage()),
                  )
                : ListView.builder(
                    itemCount: dailyFoodHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      var dailyData = dailyFoodHistory.entries.elementAt(index);
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dailyData.value.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return Text(_getDisplayDate(context, dailyData.key),
                                style: StyleType.dataConfirm.dateText);
                          }
                          return Row(
                            children: [
                              const SizedBox(width: 10),
                              Text(
                                  _getDisplayTimeAndFood(
                                      context,
                                      dailyData.value.entries
                                          .elementAt(index - 1)),
                                  style: StyleType.dataConfirm.foodText)
                            ],
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
