import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../common/page_common.dart';
import 'data_confirm.dart';

class DataConfirm extends StatelessWidget {
  const DataConfirm({super.key});

  /// 日付の表示用文字列取得メソッド
  /// 例:日本語→9月25日(月)
  String _getDisplayDate(BuildContext context, DateTime date) {
    var languageCode = Localizations.localeOf(context).languageCode;
    return DateFormat.MMMEd(languageCode).format(date);
  }

  /// 日付の表示用文字列取得メソッド
  /// 例:日本語→9月25日(月)
  String _getDisplayTime(BuildContext context, DateTime date) {
    var languageCode = Localizations.localeOf(context).languageCode;
    return DateFormat.Hm(languageCode).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      headerTitle: L10n.of(context)!.dataConfirmTitle,
      body: Column(
        children: [
          // 健康ポイントの折れ線グラフ表示部
          const Expanded(
            child: HealthPointChart(),
          ),
          // 食事履歴リスト表示部
          Expanded(
            child: ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (BuildContext context, int index) {
                var dailyData = historyList.entries.elementAt(index);
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
                          Text(
                              '${_getDisplayTime(context, dailyData.value.entries.elementAt(index - 1).key)} ${dailyData.value.entries.elementAt(index - 1).value}')
                        ],
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

Map<DateTime, double> healthPointMap = {
  DateTime(1, 1, 1): 50,
  DateTime(1, 1, 2): 60,
  DateTime(1, 1, 3): 40,
  DateTime(1, 1, 4): 70,
  DateTime(1, 1, 5): 30,
  DateTime(1, 1, 6): 80,
  DateTime(1, 1, 7): 99,
};

Map<DateTime, Map<DateTime, String>> historyList = {
  DateTime(1, 1, 1): {
    DateTime(1, 1, 1, 1, 1): '食べたもの1',
    DateTime(1, 1, 1, 2, 1): '食べたもの2',
    DateTime(1, 1, 1, 3, 1): '食べたもの3',
  },
  DateTime(1, 1, 2): {
    DateTime(1, 1, 2, 1, 1): '食べたもの1',
    DateTime(1, 1, 2, 2, 1): '食べたもの2',
    DateTime(1, 1, 2, 3, 1): '食べたもの3',
  },
  DateTime(1, 1, 3): {
    DateTime(1, 1, 3, 1, 1): '食べたもの1',
    DateTime(1, 1, 3, 2, 1): '食べたもの2',
    DateTime(1, 1, 3, 3, 1): '食べたもの3',
  },
  DateTime(1, 1, 4): {
    DateTime(1, 1, 4, 1, 1): '食べたもの1',
    DateTime(1, 1, 4, 2, 1): '食べたもの2',
    DateTime(1, 1, 4, 3, 1): '食べたもの3',
  },
  DateTime(1, 1, 5): {
    DateTime(1, 1, 5, 1, 1): '食べたもの1',
    DateTime(1, 1, 5, 2, 1): '食べたもの2',
    DateTime(1, 1, 5, 3, 1): '食べたもの3',
  },
  DateTime(1, 1, 6): {
    DateTime(1, 1, 6, 1, 1): '食べたもの1',
    DateTime(1, 1, 6, 2, 1): '食べたもの2',
    DateTime(1, 1, 6, 3, 1): '食べたもの3',
  },
  DateTime(1, 1, 7): {
    DateTime(1, 1, 7, 1, 1): '食べたもの1',
    DateTime(1, 1, 7, 2, 1): '食べたもの2',
    DateTime(1, 1, 7, 3, 1): '食べたもの3',
  },
  DateTime(1, 1, 8): {
    DateTime(1, 1, 8, 1, 1): '食べたもの1',
    DateTime(1, 1, 8, 2, 1): '食べたもの2',
    DateTime(1, 1, 8, 3, 1): '食べたもの3',
  },
};
