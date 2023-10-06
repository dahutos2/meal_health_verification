import 'package:meta/meta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../api/api.dart';
import '../notifier/notifier.dart';

final mealServiceProvider = Provider.autoDispose(
  (ref) => MealService(dbHelper: ref.read(dbHelperProvider)),
);

@immutable
class MealService {
  final DbHelper _dbHelper;

  const MealService({required DbHelper dbHelper}) : _dbHelper = dbHelper;

  Meal toMeal(Map<String, dynamic> data) {
    final int? id =
        data['id'] != null ? int.parse(data['id'].toString()) : null;
    final String name = data['name'].toString();
    final DateTime date = DateTime.parse(data['date'].toString());
    final int labelRating = int.parse(data['label_rating'].toString());
    final int healthRating = int.parse(data['health_rating'].toString());

    return Meal(
      id: id,
      name: name,
      date: date,
      labelRating: labelRating,
      healthRating: healthRating,
    );
  }

  Future<T?> transaction<T>(Future<T> Function() f) async {
    return await _dbHelper.transaction<T>(() async => await f());
  }

  Future<List<Meal>> findByDateRange(
      DateTime startDate, DateTime endDate) async {
    // 日付を正しいフォーマットに変換
    final String start = startDate.toIso8601String();
    final String end = endDate.toIso8601String();

    final list = await _dbHelper.rawQuery(
      'SELECT * FROM meals WHERE date BETWEEN ? AND ?',
      <String>[start, end],
    );

    if (list == null || list.isEmpty) {
      return <Meal>[];
    }

    return list.map((data) => toMeal(data)).toList();
  }

  Future<void> add(Meal meal) async {
    // 新しいエントリを追加
    await _dbHelper.rawInsert(
      'INSERT INTO meals (name, date, label_rating, health_rating) VALUES (?, ?, ?, ?)',
      <dynamic>[
        meal.name,
        meal.date.toIso8601String(),
        meal.labelRating,
        meal.healthRating,
      ],
    );
  }
}
