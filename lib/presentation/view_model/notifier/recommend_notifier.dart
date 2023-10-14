import 'dart:math';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../use_case/use_cases/index_interface.dart';
import '../data/index.dart';
import 'meal_notifier.dart';

const int imageCount = 3;

class RecommendNotifier with ChangeNotifier {
  final IGetRecommendLabelRating _getRecommendLabelRating;
  final IGetNewMeal _getNewMeal;
  final IGetLabel _getLabel;
  final IGetDetectObjects _getDetectObjects;
  final MealNotifier _meal;

  RecommendNotifier({
    required IGetRecommendLabelRating getRecommendLabelRating,
    required IGetNewMeal getNewMeal,
    required IGetLabel getLabel,
    required IGetDetectObjects getDetectObjects,
    required MealNotifier meal,
  })  : _getRecommendLabelRating = getRecommendLabelRating,
        _getNewMeal = getNewMeal,
        _getLabel = getLabel,
        _getDetectObjects = getDetectObjects,
        _meal = meal;

  String getLabel(int labelIndex) {
    return _getLabel.execute(labelIndex: labelIndex);
  }

  Future<List<DetectedObject>> getDetectObjects(String filePath) async {
    final dtos = await _getDetectObjects.executeAsync(filePath: filePath);
    return dtos
        .map((dto) => DetectedObject(
              boundingBox: dto.boundingBox,
              labelIndexes: dto.labelIndexes,
            ))
        .toList();
  }

  Future<RecommendText> getRecommendText({required int labelIndex}) async {
    final meal = await _getNewMeal.executeAsync(labelIndex: labelIndex);
    _meal.add(dto: meal);
    return _getRecommendText(meal.healthRating);
  }

  RecommendText _getRecommendText(
    int healthRating,
  ) {
    if (0 <= healthRating && healthRating < 30) {
      return RecommendText(
          value: (L10n l10n) => l10n.recommendBadText,
          lottiePath: 'assets/lottie/low.json');
    } else if (30 <= healthRating && healthRating < 60) {
      return RecommendText(
          value: (L10n l10n) => l10n.recommendNormalText,
          lottiePath: 'assets/lottie/middle.json');
    } else if (60 <= healthRating && healthRating < 100) {
      return RecommendText(
          value: (L10n l10n) => l10n.recommendGoodText,
          lottiePath: 'assets/lottie/high.json');
    } else {
      // 範囲外のものは通常とする
      return RecommendText(
          value: (L10n l10n) => l10n.recommendBadText,
          lottiePath: 'assets/lottie/low.json');
    }
  }

  Future<List<RecommendImage>> getRecommendImages() async {
    final labelRating = await _getRecommendLabelRating.executeAsync();
    return _getRecommendImages(labelRating);
  }

  List<RecommendImage> _getRecommendImages(int healthRating) {
    if (0 <= healthRating && healthRating < 30) {
      return _getRandomRecommendImages(lowRateRecommends);
    } else if (30 <= healthRating && healthRating < 60) {
      return _getRandomRecommendImages(middleRateRecommends);
    } else if (60 <= healthRating && healthRating < 100) {
      return _getRandomRecommendImages(highRateRecommends);
    } else {
      // 範囲外のものは通常とする
      return _getRandomRecommendImages(middleRateRecommends);
    }
  }

  List<RecommendImage> _getRandomRecommendImages(List<RecommendImage> source) {
    if (source.isEmpty) {
      source = middleRateRecommends;
    }
    final result = <RecommendImage>[];
    int randomLimit = source.length;
    final random = Random();
    while (result.length < imageCount) {
      // リスト内の要素をランダムに取得する
      final targetIndex = random.nextInt(randomLimit);

      // すでに追加済みの場合はやり直す
      if (result.contains(source[targetIndex])) continue;

      result.add(source[targetIndex]);
    }

    return result;
  }

  final List<RecommendImage> lowRateRecommends = [
    RecommendImage(
        name: (L10n l10n) => l10n.recommendLowCake,
        imagePath: 'assets/images/cake.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendLowPizza,
        imagePath: 'assets/images/pizza.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendLowSpaghetti,
        imagePath: 'assets/images/spaghetti.jpg')
  ];
  final List<RecommendImage> middleRateRecommends = [
    RecommendImage(
        name: (L10n l10n) => l10n.recommendMiddleCurry,
        imagePath: 'assets/images/curry_vertical.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendMiddleHamburger,
        imagePath: 'assets/images/hamburger.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendMiddlePanCake,
        imagePath: 'assets/images/pan_cake.jpg')
  ];
  final List<RecommendImage> highRateRecommends = [
    RecommendImage(
        name: (L10n l10n) => l10n.recommendHighOatmeal,
        imagePath: 'assets/images/oatmeal.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendHighEggAndVegetable,
        imagePath: 'assets/images/eggAndVegetable.jpg'),
    RecommendImage(
        name: (L10n l10n) => l10n.recommendHighTomatoSoup,
        imagePath: 'assets/images/tomato_soup.jpg')
  ];

  // 健康度の算出ではモデルを使用しないように変更
  // ignore: unused_element
  // Future<int> __getHealthRating({
  //   required List<Meal> meals,
  //   String label = '',
  // }) async {
  //   if (_model.healthRating == null) return -1;

  //   try {
  //     // 画面が固まらないようにする
  //     final isolateInterpreter = await IsolateInterpreter.create(
  //         address: _model.healthRating!.address);

  //     final parseLabel = await _parseLabel(label);

  //     // 複数の健康度と、ラベルの特徴量から一つの健康度を返す
  //     var input = [
  //       [
  //         ...meals.map((meal) => meal.healthRating.toDouble()).toList(),
  //         ...parseLabel,
  //       ]
  //     ];
  //     var output = List.filled(1 * 1, 0).reshape([1, 1]);

  //     // 1 * 1 の2次元リスト
  //     await isolateInterpreter.run(input, output);
  //     return int.parse(output[0][0].toString());
  //   } catch (e) {
  //     // SimulatorではTFLiteは動作しない場合があるので
  //     // 例外時は、固定値を返す
  //     return -1;
  //   }
  // }

//
}
