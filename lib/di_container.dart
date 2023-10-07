import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'infrastructure/api/index.dart';
import 'infrastructure/repository_sql/index.dart';
import 'domain/service/index.dart';
import 'use_case/use_cases/index.dart';

// API
final dbHelperProvider = Provider<DbHelper>(
  (_) => DbHelper(),
);
final modelHelperProvider = Provider<ModelHelper>(
  (_) => ModelHelper(),
);

// Repository
final mealRepositoryProvider = Provider.autoDispose(
  (ref) => MealRepositorySql(dbHelper: ref.read(dbHelperProvider)),
);

// Service
final mealServiceProvider = Provider.autoDispose(
  (ref) => MealService(repository: ref.read(mealRepositoryProvider)),
);
final modelServiceProvider = Provider.autoDispose(
  (ref) => ModelService(repository: ref.read(modelHelperProvider)),
);

// UseCase
final getFirstWeekMealsProvider = Provider.autoDispose(
  (ref) => GetFirstWeekMeals(
    mealService: ref.read(mealServiceProvider),
  ),
);
final getMealsByDateRangeProvider = Provider.autoDispose(
  (ref) => GetMealsByDateRange(
    mealRepository: ref.read(mealRepositoryProvider),
  ),
);
final getLabelProvider = Provider.autoDispose(
  (ref) => GetLabel(
    modelService: ref.read(modelServiceProvider),
  ),
);
final getNewMealProvider = Provider.autoDispose(
  (ref) => GetNewMeal(
    mealService: ref.read(mealServiceProvider),
    modelService: ref.read(modelServiceProvider),
    mealRepository: ref.read(mealRepositoryProvider),
  ),
);
final getRecommendLabelRatingProvider = Provider.autoDispose(
  (ref) => GetRecommendLabelRating(
    mealService: ref.read(mealServiceProvider),
    modelService: ref.read(modelServiceProvider),
  ),
);
final getDetectObjectsProvider = Provider.autoDispose(
  (ref) => GetDetectObjects(
    modelRepository: ref.read(modelHelperProvider),
  ),
);
