import '../../dto/index.dart';

abstract class IGetFirstWeekMeals {
  Future<List<MealDto>> executeAsync();
}
