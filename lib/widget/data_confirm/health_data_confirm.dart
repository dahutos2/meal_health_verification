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

  @override
  void initState() {
    super.initState();

    var notifier = ref.read(mealNotifierProvider.notifier);
    Future.delayed(Duration.zero, () async {
      notifier.displayList();
      setState(() {
        healthData = notifier.list ?? <Meal>[];
      });
    });
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
    return Column(
      children: [
        // 健康ポイントの折れ線グラフ表示部
        Expanded(
          child: HealthPointChart(
            graphHistoryData: graphHistoryData,
          ),
        ),
        // 食事履歴リスト表示部
        Expanded(
          child: dailyFoodHistory.isEmpty
              ? const Center(child: ColorfulLoadPage())
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
                          return Text(_getDisplayDate(context, dailyData.key));
                        }
                        return Row(
                          children: [
                            const SizedBox(width: 10),
                            Text(_getDisplayTimeAndFood(context,
                                dailyData.value.entries.elementAt(index - 1)))
                          ],
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// class HealthDataConfirm extends StatelessWidget {
//   const HealthDataConfirm({super.key});
//
//   /// 日付の表示用文字列取得メソッド
//   /// 例:日本語→9月25日(月)
//   String _getDisplayDate(BuildContext context, DateTime date) {
//     var languageCode = Localizations.localeOf(context).languageCode;
//     return DateFormat.MMMEd(languageCode).format(date);
//   }
//
//   /// 時間の表示用文字列取得メソッド
//   /// 例:日本語→18:01
//   String _getDisplayTime(BuildContext context, DateTime date) {
//     var languageCode = Localizations.localeOf(context).languageCode;
//     return DateFormat.Hm(languageCode).format(date);
//   }
//
//   /// 日時で別れているMapを日毎のMapにまとめる
//   Map<DateTime, Map<DateTime, String>> _getDailyFoodHistory(
//       Map<DateTime, String> foodHistory) {
//     var sortedFoodHistory = SplayTreeMap<DateTime, String>.from(
//         foodHistory, (DateTime a, DateTime b) => -a.compareTo(b));
//     var dailyFoodHistory = <DateTime, Map<DateTime, String>>{};
//
//     sortedFoodHistory.forEach((key, value) {
//       var day = DateTime(key.year, key.month, key.day);
//       var dayFoodHistory = <DateTime, String>{};
//
//       if (dailyFoodHistory.containsKey(day)) {
//         dayFoodHistory = dailyFoodHistory[day]!;
//         dayFoodHistory[key] = value;
//       } else {
//         dayFoodHistory[key] = value;
//       }
//
//       dailyFoodHistory[day] = dayFoodHistory;
//     });
//
//     return dailyFoodHistory;
//   }
//
//   /// 時間と食事名の表示用文字列を取得
//   String _getDisplayTimeAndFood(
//       BuildContext context, MapEntry<DateTime, String> entry) {
//     var timeString = _getDisplayTime(context, entry.key);
//     var foodString = entry.value;
//     return '$timeString $foodString';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var dailyFoodHistory = _getDailyFoodHistory(historyList);
//     return Column(
//       children: [
//         // 健康ポイントの折れ線グラフ表示部
//         const Expanded(
//           child: HealthPointChart(),
//         ),
//         // 食事履歴リスト表示部
//         Expanded(
//           child: ListView.builder(
//             itemCount: dailyFoodHistory.length,
//             itemBuilder: (BuildContext context, int index) {
//               var dailyData = dailyFoodHistory.entries.elementAt(index);
//               return ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: dailyData.value.length + 1,
//                 itemBuilder: (BuildContext context, int index) {
//                   if (index == 0) {
//                     return Text(_getDisplayDate(context, dailyData.key));
//                   }
//                   return Row(
//                     children: [
//                       const SizedBox(width: 10),
//                       Text(_getDisplayTimeAndFood(context,
//                           dailyData.value.entries.elementAt(index - 1)))
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// Map<DateTime, String> historyList = {
//   DateTime(1, 1, 1, 1, 1): '食べたもの1',
//   DateTime(1, 1, 1, 2, 1): '食べたもの2',
//   DateTime(1, 1, 1, 3, 1): '食べたもの3',
//   DateTime(1, 1, 2, 1, 1): '食べたもの1',
//   DateTime(1, 1, 2, 2, 1): '食べたもの2',
//   DateTime(1, 1, 2, 3, 1): '食べたもの3',
//   DateTime(1, 1, 3, 1, 1): '食べたもの1',
//   DateTime(1, 1, 3, 2, 1): '食べたもの2',
//   DateTime(1, 1, 3, 3, 1): '食べたもの3',
//   DateTime(1, 1, 4, 1, 1): '食べたもの1',
//   DateTime(1, 1, 4, 2, 1): '食べたもの2',
//   DateTime(1, 1, 4, 3, 1): '食べたもの3',
//   DateTime(1, 1, 5, 1, 1): '食べたもの1',
//   DateTime(1, 1, 5, 2, 1): '食べたもの2',
//   DateTime(1, 1, 5, 3, 1): '食べたもの3',
//   DateTime(1, 1, 6, 1, 1): '食べたもの1',
//   DateTime(1, 1, 7, 2, 1): '食べたもの2',
//   DateTime(1, 1, 7, 3, 1): '食べたもの3',
//   DateTime(1, 1, 8, 1, 1): '食べたもの1',
//   DateTime(1, 1, 8, 2, 1): '食べたもの2',
//   DateTime(1, 1, 8, 18, 1): '食べたもの3',
// };
