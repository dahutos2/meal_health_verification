import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as imglib;

class CameraIsolate {
  CameraIsolate._();

  static Future<imglib.Image?> convertAndSaveCameraImage(
    CameraImage cameraImage,
    CameraDescription camera,
    String imagePath,
    double aspectRatio,
  ) async {
    imglib.Image? img;
    if (cameraImage.format.group == ImageFormatGroup.yuv420) {
      final Map<String, dynamic> cameraImageData = {
        'width': cameraImage.width,
        'height': cameraImage.height,
        'bytesPerRow': cameraImage.planes[1].bytesPerRow,
        'uvPixelStride': cameraImage.planes[1].bytesPerPixel,
        'ypBytes': cameraImage.planes[0].bytes,
        'upBytes': cameraImage.planes[1].bytes,
        'vpBytes': cameraImage.planes[2].bytes,
        'angle': camera.sensorOrientation,
        'imagePath': imagePath,
        'aspectRatio': aspectRatio,
      };
      img = await compute(_yuv420ConvertAndSaveCameraImage, cameraImageData);
    } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
      final Map<String, dynamic> cameraImageData = {
        'width': cameraImage.width,
        'height': cameraImage.height,
        'data': cameraImage.planes[0].bytes,
        'stride': cameraImage.planes[0].bytesPerRow,
        'imagePath': imagePath,
        'aspectRatio': aspectRatio,
      };
      img = await compute(_bgra8888ConvertAndSaveCameraImage, cameraImageData);
    }
    return img;
  }

  static Future<imglib.Image> _yuv420ConvertAndSaveCameraImage(
      Map<String, dynamic> cameraImageData) async {
    final image = _yuv420ToImage(cameraImageData);
    final int angle = cameraImageData['angle'];
    final double aspectRatio = cameraImageData['aspectRatio'];
    imglib.Image clipImage;
    if (angle % 360 == 90) {
      clipImage = _clipImage(imglib.copyRotate(image, angle: 90), aspectRatio);
    } else if (angle % 360 == 180) {
      clipImage = _clipImage(imglib.copyRotate(image, angle: 180), aspectRatio);
    } else if (angle % 360 == 270) {
      clipImage = _clipImage(imglib.copyRotate(image, angle: 270), aspectRatio);
    }
    clipImage = _clipImage(image, aspectRatio);
    final String imagePath = cameraImageData['imagePath'];
    final imageFile = File(imagePath);
    imageFile.writeAsBytesSync(imglib.encodePng(clipImage));

    return clipImage;
  }

  static Future<imglib.Image> _bgra8888ConvertAndSaveCameraImage(
      Map<String, dynamic> cameraImageData) async {
    final image = _bgra8888ToImage(cameraImageData);
    final double aspectRatio = cameraImageData['aspectRatio'];
    final clipImage = _clipImage(image, aspectRatio);
    final String imagePath = cameraImageData['imagePath'];
    final imageFile = File(imagePath);
    imageFile.writeAsBytesSync(imglib.encodePng(clipImage));

    return clipImage;
  }

  static imglib.Image _bgra8888ToImage(Map<String, dynamic> cameraImageData) {
    final int width = cameraImageData['width'];
    final int height = cameraImageData['height'];
    final imglib.Image img = imglib.Image(width: width, height: height);

    final Uint8List data = cameraImageData['data'];
    final int stride = cameraImageData['stride'];

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int offset = y * stride + x * 4;
        final int b = data[offset];
        final int g = data[offset + 1];
        final int r = data[offset + 2];
        final int a = data[offset + 3];
        img.setPixelRgba(x, y, r, g, b, a);
      }
    }

    return img;
  }

  static imglib.Image _yuv420ToImage(Map<String, dynamic> cameraImageData) {
    final int width = cameraImageData['width'];
    final int height = cameraImageData['height'];
    final imglib.Image img = imglib.Image(width: width, height: height);

    final int uvRowStride = cameraImageData['bytesPerRow'];
    final int uvPixelStride = cameraImageData['uvPixelStride'];
    final Uint8List ypBytes = cameraImageData['ypBytes'];
    final Uint8List upBytes = cameraImageData['upBytes'];
    final Uint8List vpBytes = cameraImageData['vpBytes'];

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yp = ypBytes[index];
        final up = upBytes[uvIndex];
        final vp = vpBytes[uvIndex];

        // Convert YUV to RGB
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        // Set pixel color in image
        img.setPixelRgb(x, y, r, g, b);
      }
    }

    return img;
  }

  static imglib.Image _clipImage(
    imglib.Image originalImage,
    double aspectRatio,
  ) {
    final double originalWidth = originalImage.width.toDouble();
    final double originalHeight = originalImage.height.toDouble();
    final double originalAspectRatio = originalWidth / originalHeight;

    // ignore: avoid_multiple_declarations_per_line
    double scaledWidth, scaledHeight;
    if (originalAspectRatio > aspectRatio) {
      // 元画像の方が幅の比が大きい
      scaledWidth = originalHeight * aspectRatio;
      scaledHeight = originalHeight;
    } else {
      // 元画像の方が高さの比が大きい
      scaledWidth = originalWidth;

      // 0で割らないようにする
      scaledHeight = originalWidth / max(aspectRatio, 1e-10);
    }

    final int cropX = (originalWidth - scaledWidth) ~/ 2;
    final int cropY = (originalHeight - scaledHeight) ~/ 2;
    final int cropWidth = scaledWidth.toInt();
    final int cropHeight = scaledHeight.toInt();

    final imglib.Image croppedImage = imglib.copyCrop(
      originalImage,
      x: cropX,
      y: cropY,
      width: cropWidth,
      height: cropHeight,
    );

    return croppedImage;
  }
}
