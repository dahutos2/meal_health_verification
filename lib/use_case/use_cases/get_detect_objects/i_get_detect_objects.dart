import '../../dto/index.dart';

abstract class IGetDetectObjects {
  Future<List<DetectedObjectDto>> executeAsync({required String filePath});
}
