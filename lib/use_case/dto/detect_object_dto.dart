import 'dart:ui';

import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:meta/meta.dart';

@immutable
class DetectedObjectDto {
  final int? id;
  final Rect boundingBox;
  final List<int> labelIndexes;

  DetectedObjectDto(DetectedObject source)
      : id = source.trackingId,
        boundingBox = source.boundingBox,
        labelIndexes = source.labels.map((label) => label.index).toList();

  @override
  bool operator ==(Object other) =>
      identical(other, this) || (other is DetectedObjectDto && other.id == id);

  @override
  int get hashCode => runtimeType.hashCode ^ id.hashCode;
}
