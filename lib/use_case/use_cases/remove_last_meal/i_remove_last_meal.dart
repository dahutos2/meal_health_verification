import '../../dto/index.dart';

abstract class IRemoveLastMeal {
  Future<MealDto?> executeAsync();
}
