import 'package:meta/meta.dart';

import '../../domain/model/index.dart';
import '../../domain/repository/index.dart';

@immutable
class MealService {
  final IMealRepository _repository;

  const MealService({
    required IMealRepository repository,
  }) : _repository = repository;

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
    return await _repository.findByDateRange(startOfLastWeek, now);
  }
}
