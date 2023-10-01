import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../api/api.dart';
import '../service/service.dart';
import 'meal_notifier.dart';

final recommendNotifierProvider = ChangeNotifierProvider.autoDispose(
  (ref) => RecommendNotifier(
    service: ref.read(recommendServiceProvider),
    meal: ref.read(mealNotifierProvider),
    model: ref.read(modelHelperProvider),
  ),
);

class RecommendText {
  final String Function(L10n) value;
  final String lottiePath;
  RecommendText({
    required this.value,
    required this.lottiePath,
  });
}

class RecommendImage {
  final String Function(L10n) name;
  final String imagePath;
  RecommendImage({
    required this.name,
    required this.imagePath,
  });
}

class RecommendNotifier with ChangeNotifier {
  final RecommendService _service;
  final MealNotifier _meal;
  final ModelHelper _model;

  RecommendNotifier({
    required RecommendService service,
    required MealNotifier meal,
    required ModelHelper model,
  })  : _service = service,
        _meal = meal,
        _model = model;

  Future<RecommendText> getRecommendText({required String label}) async {
    final meals = _meal.list ?? <Meal>[];
    final healthRating = await _getHealthRating(meals: meals, label: label);
    _meal.add(name: label, healthRating: healthRating);
    return _service.getRecommendText(healthRating);
  }

  Future<List<RecommendImage>> getRecommendImages() async {
    final meals = await _meal.findFirstWeek();
    final healthRating = await _getHealthRating(meals: meals);
    return _service.getRecommendImages(healthRating);
  }

  Future<int> _getHealthRating({
    required List<Meal> meals,
    String label = '',
  }) async {
    if (_model.healthRating == null) return -1;

    try {
      // 画面が固まらないようにする
      final isolateInterpreter = await IsolateInterpreter.create(
          address: _model.healthRating!.address);

      final parseLabel = await _parseLabel(label);

      // 複数の健康度と、ラベルの特徴量から一つの健康度を返す
      var input = [
        [
          ...meals.map((meal) => meal.healthRating.toDouble()).toList(),
          ...parseLabel,
        ]
      ];
      var output = List.filled(1 * 1, 0).reshape([1, 1]);

      // 1 * 1 の2次元リスト
      await isolateInterpreter.run(input, output);
      return int.parse(output[0][0].toString());
    } catch (e) {
      // SimulatorではTFLiteは動作しない場合があるので
      // 例外時は、固定値を返す
      return -1;
    }
  }

  Future<List<double>> _parseLabel(String labels) async {
    // 文字列の特徴量を抽出する
    if (_model.mealFeature == null || labels.isEmpty) return [0.0];

    try {
      // 画面が固まらないようにする
      final isolateInterpreter =
          await IsolateInterpreter.create(address: _model.mealFeature!.address);

      // ラベルのバッファから、健康度推論用の単語の特徴量を返す
      // トークナイザが存在しないのでトークン化は行わない
      final inputBytes = utf8.encode(labels);
      final input = Uint8List.fromList(inputBytes).buffer.asFloat32List();
      final output = List.filled(228, 0.0);

      await isolateInterpreter.run(input, output);

      return output;
    } catch (e) {
      // SimulatorではTFLiteは動作しない場合があるので
      // 例外時は、空のリストを返す
      return [0.0];
    }
  }
}
