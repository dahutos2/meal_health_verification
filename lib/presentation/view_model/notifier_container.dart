import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../di_container.dart';
import 'notifier/index.dart';

final mealNotifierProvider = ChangeNotifierProvider(
  (ref) => MealNotifier(
    getFirstWeekMeals: ref.read(getFirstWeekMealsProvider),
    getMealsByDateRange: ref.read(getMealsByDateRangeProvider),
    getLabel: ref.read(getLabelProvider),
  ),
);

final recommendNotifierProvider = ChangeNotifierProvider.autoDispose(
  (ref) => RecommendNotifier(
    getRecommendLabelRating: ref.read(getRecommendLabelRatingProvider),
    getNewMeal: ref.read(getNewMealProvider),
    getLabel: ref.read(getLabelProvider),
    getDetectObjects: ref.read(getDetectObjectsProvider),
    meal: ref.read(mealNotifierProvider),
  ),
);
