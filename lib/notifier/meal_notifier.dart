import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../service/service.dart';

final mealNotifierProvider = ChangeNotifierProvider(
  (ref) => MealNotifier(
    service: ref.read(mealServiceProvider),
  ),
);

class Meal {
  final int? id; // データベースで自動生成されるID
  final String name; // 食事の名前
  final DateTime date; // 食事の日付
  final int labelRating; // 食事の度数
  final int healthRating; // 食事時点の健康度の評価

  Meal({
    this.id,
    required this.name,
    required this.date,
    required this.labelRating,
    required this.healthRating,
  });
}

class MealNotifier with ChangeNotifier {
  final MealService _service;

  MealNotifier({required MealService service}) : _service = service {
    displayList();
  }

  List<Meal>? _list;

  List<Meal>? get list =>
      _list == null ? null : List.unmodifiable(_list ?? <Meal>[]);

  void displayList() {
    findFirstWeek().then((list) {
      _list = list;
      notifyListeners();
    });
  }

  Future<List<Meal>> findFirstWeek() async {
    final DateTime now = DateTime.now();
    final bool isBefore6am = now.hour < 6;

    // 今日の日付を取得し、時間と分をリセット
    final DateTime today = DateTime(now.year, now.month, now.day);

    // 6時以前の場合は前の日を今日として扱う
    final DateTime effectiveToday =
        isBefore6am ? today.subtract(const Duration(days: 1)) : today;

    // 週の開始日を計算
    final DateTime lastMonday = effectiveToday.subtract(
      Duration(days: effectiveToday.weekday - 1),
    );

    // 週の開始日時を設定 (月曜日の6時)
    final DateTime startOfLastWeek = DateTime(
        lastMonday.year, lastMonday.month, lastMonday.day, 6, 0, 0, 0, 0);
    return await _service.findByDateRange(startOfLastWeek, now);
  }

  Future<List<Meal>> findByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _service.findByDateRange(startDate, endDate);
  }

  void add({
    required String name,
    required DateTime now,
    required int labelRating,
    required int healthRating,
  }) {
    final meal = Meal(
      name: name,
      date: now,
      labelRating: labelRating,
      healthRating: healthRating,
    );
    _service.add(meal).then((_) {
      _list?.add(meal);
      notifyListeners();
    });
  }
}
