import '../../dto/index.dart';

abstract class IGetMealsByDateRange {
  Future<List<MealDto>> executeAsync({
    required DateTime startDate,
    required DateTime endDate,
  });
}
