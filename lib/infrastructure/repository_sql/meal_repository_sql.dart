import 'package:meta/meta.dart';

import '../../domain/index.dart';
import '../api/index.dart';

@immutable
class MealRepositorySql implements IMealRepository {
  final DbHelper _dbHelper;

  const MealRepositorySql({required DbHelper dbHelper}) : _dbHelper = dbHelper;

  Meal toMeal(Map<String, dynamic> data) {
    final int? id =
        data[dbId] != null ? int.parse(data[dbId].toString()) : null;
    final int labelIndex = int.parse(data[dbLabelIndex].toString());
    final DateTime date = DateTime.parse(data[dbDate].toString());
    final int labelRating = int.parse(data[dbLabelRating].toString());
    final int healthRating = int.parse(data[dbHealthRating].toString());

    return Meal(
      id: id,
      labelIndex: labelIndex,
      date: date,
      labelRating: labelRating,
      healthRating: healthRating,
    );
  }

  @override
  Future<T?> transaction<T>(Future<T> Function() f) async {
    return await _dbHelper.transaction<T>(() async => await f());
  }

  @override
  Future<List<Meal>> findByDateRange(
      DateTime startDate, DateTime endDate) async {
    // 日付を正しいフォーマットに変換
    final String start = startDate.toIso8601String();
    final String end = endDate.toIso8601String();

    final list = await _dbHelper.rawQuery(
      'SELECT * FROM $dbMeals WHERE $dbDate BETWEEN ? AND ?',
      <String>[start, end],
    );

    if (list == null || list.isEmpty) {
      return <Meal>[];
    }

    return list.map((data) => toMeal(data)).toList();
  }

  @override
  Future<void> save(Meal meal) async {
    // 新しいエントリを追加
    await _dbHelper.rawInsert(
      'INSERT INTO $dbMeals ($dbLabelIndex, $dbDate, $dbLabelRating, $dbHealthRating) VALUES (?, ?, ?, ?)',
      <dynamic>[
        meal.labelIndex,
        meal.date.toIso8601String(),
        meal.labelRating.value,
        meal.healthRating.value,
      ],
    );
  }
}
