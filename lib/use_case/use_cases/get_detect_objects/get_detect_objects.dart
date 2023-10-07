import 'dart:io';

import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:meta/meta.dart';

import '../../../domain/repository/index.dart';
import '../../dto/index.dart';
import 'i_get_detect_objects.dart';

@immutable
class GetDetectObjects implements IGetDetectObjects {
  final IModelRepository _modelRepository;

  const GetDetectObjects({
    required IModelRepository modelRepository,
  }) : _modelRepository = modelRepository;

  @override
  Future<List<DetectedObjectDto>> executeAsync(
      {required String filePath}) async {
    final objectDetector = _modelRepository.objectDetector;
    if (objectDetector == null) return <DetectedObjectDto>[];

    final imageFile = File(filePath);
    if (!imageFile.existsSync()) return <DetectedObjectDto>[];

    final inputImage = InputImage.fromFile(imageFile);
    final result = await objectDetector.processImage(inputImage);
    return result.map((object) => DetectedObjectDto(object)).toList();
  }
}
