import '../model/index.dart';

abstract class IMealRepository {
  Future<T?> transaction<T>(Future<T> Function() f);
  Future<List<Meal>> findByDateRange(DateTime startDate, DateTime endDate);
  Future<void> save(Meal meal);
}
