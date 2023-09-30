import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../service/service.dart';

final mealNotifierProvider = ChangeNotifierProvider.autoDispose(
  (ref) => MealNotifier(
    service: ref.read(mealServiceProvider),
  ),
);

class Meal {
  final int? id; // データベースで自動生成されるID
  final String name; // 食事の名前
  final DateTime date; // 食事の日付
  final int healthRating; // 健康度の評価

  Meal({
    this.id,
    required this.name,
    required this.date,
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
    final DateTime now = DateTime.now();
    final DateTime lastMonday = now.subtract(
      Duration(days: now.weekday + (now.weekday == DateTime.monday ? 6 : -1)),
    );
    final DateTime startOfLastWeek = DateTime(
      lastMonday.year,
      lastMonday.month,
      lastMonday.day,
    );
    _service.findByDateRange(startOfLastWeek, lastMonday).then((list) {
      _list = list;
      notifyListeners();
    });
  }

  Future<List<Meal>> findByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _service.findByDateRange(startDate, endDate);
  }

  void saveBook({
    required String name,
    required int healthRating,
  }) {
    final DateTime now = DateTime.now();
    final meal = Meal(
      name: name,
      date: now,
      healthRating: healthRating,
    );
    _service.add(meal).then((_) {
      _list?.add(meal);
      notifyListeners();
    });
  }
}
