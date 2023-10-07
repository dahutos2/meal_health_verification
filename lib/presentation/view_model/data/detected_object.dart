import 'dart:ui';

import 'package:meta/meta.dart';

@immutable
class DetectedObject {
  final Rect boundingBox;
  final List<int> labelIndexes;

  const DetectedObject({
    required this.boundingBox,
    required this.labelIndexes,
  });
}
