import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../extensions/index.dart';
import '../../../share/index.dart';
import 'pause_button.dart';
import 'pause_camera_isolate.dart';

class PauseCameraImage {
  final Uint8List bytes;
  final String filePath;
  final int width;
  final int height;
  const PauseCameraImage({
    required this.bytes,
    required this.filePath,
    required this.width,
    required this.height,
  });
}

class PauseCamera extends StatefulWidget {
  final ValueChanged<PauseCameraImage?>? changeImageFile;
  final void Function()? onLoading;
  final void Function()? onLoaded;
  final Widget? stackWidget;
  final double aspectRatio;
  const PauseCamera({
    super.key,
    this.changeImageFile,
    this.onLoading,
    this.onLoaded,
    this.stackWidget,
    this.aspectRatio = 11 / 14,
  });

  @override
  State<PauseCamera> createState() => _PauseCameraState();
}

class _PauseCameraState extends State<PauseCamera> {
  String _imagePath = '';

  List<CameraDescription> _cameras = [];
  CameraController? _controller;

  String _errorMessage = '';

  bool _isCameraReady = false;
  bool _isNotScanning = true;
  bool _isPause = false;

  double _zoomLevel = 1.0;
  double? _previousScale = 1;
  final double _minZoomLevel = 1.0;
  final double _maxZoomLevel = 8.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _errorMessage = L10n.of(context)!.pauseCameraStart;
      });
      final tempDir = await getTemporaryDirectory();
      await _startCamera();
      setState(() {
        _imagePath = '${tempDir.path}/pause_image.png';
      });
    });
  }

  @override
  void setState(void Function() func) {
    if (mounted) {
      super.setState(func);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _startCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      setState(() {
        _errorMessage = L10n.of(context)!.pauseCameraErrorNotExistCamera;
        _isCameraReady = false;
      });
      return;
    }

    _controller = CameraController(
      _cameras[0],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    );

    await _controller?.initialize().then(
      (_) {
        _isCameraReady = true;
      },
    ).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            _errorMessage =
                // ignore: use_build_context_synchronously
                L10n.of(context)!.pauseCameraErrorCameraAccessDenied;
            break;
          default:
            _errorMessage = L10n.of(context)!.pauseCameraErrorUndefined;
            break;
        }
        _isCameraReady = false;
      }
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_previousScale == null) return;

    double scaleChange = _computeScaleChange(details.scale, _previousScale!);

    setState(() {
      _zoomLevel =
          (_zoomLevel + scaleChange).clamp(_minZoomLevel, _maxZoomLevel);
    });

    _controller?.setZoomLevel(_zoomLevel);
    _previousScale = details.scale;
  }

  double _computeScaleChange(double currentScale, double previousScale) {
    double scaleDifference = currentScale - previousScale;

    // 変化率の基準値
    double baseRate = 0.05;

    // ズームインの場合
    if (scaleDifference > 0) {
      return baseRate;
    }
    // ズームアウトの場合
    else {
      return -baseRate;
    }
  }

  Future<void> _startRecording() async {
    if (widget.onLoading != null && mounted) {
      widget.onLoading!();
    }
    setState(() {
      _isNotScanning = false;
      _isPause = true;
    });
    // この処理で非同期操作をステートの変更後に行う
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller?.startImageStream(_processImage);
    });
  }

  Future<void> _resumeCamera() async {
    await _controller?.resumePreview();
    setState(() {
      _isPause = false;
    });
  }

  Future<void> _processImage(CameraImage cameraImage) async {
    try {
      await _controller?.stopImageStream();
      await _controller?.pausePreview();

      // nullの場合は止めるだけ
      if (widget.changeImageFile == null || !mounted) return;

      final image = await CameraIsolate.convertAndSaveCameraImage(
          cameraImage, _cameras[0], _imagePath, widget.aspectRatio);
      if (!mounted) return;
      if (image == null) {
        // 画像の取得に失敗した場合は、画像をnullにする
        widget.changeImageFile!(null);
        return;
      }
      final bytes = await CameraIsolate.convertToBytes(image);
      if (!mounted) return;
      widget.changeImageFile!(
        PauseCameraImage(
          bytes: bytes,
          filePath: _imagePath,
          width: image.width,
          height: image.height,
        ),
      );
    } finally {
      if (widget.onLoaded != null && mounted) {
        widget.onLoaded!();
      }

      setState(() {
        _isNotScanning = true;
      });
    }
  }

  void _deleteImage() {
    if (!mounted) return;
    var imageFile = File(_imagePath);
    if (imageFile.existsSync()) {
      imageFile.deleteSync();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        _deleteImage();
        return true;
      },
      child: Stack(
        children: [
          _isCameraReady &&
                  _controller != null &&
                  _controller!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: widget.aspectRatio,
                  child: Stack(
                    children: [
                      ClipRect(
                        child: Transform.scale(
                          scale: _controller!.value.aspectRatio *
                              widget.aspectRatio,
                          child: Center(
                            child: GestureDetector(
                              onScaleUpdate: _handleScaleUpdate,
                              child: CameraPreview(_controller!),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        left: MediaQuery.of(context).size.width * 0.5 - 30,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: ColorType.camera.zoomBackGround,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '${_zoomLevel.toStringAsFixed(1)} ×',
                            style: StyleType.camera.zoomRateText,
                          ),
                        ),
                      ),
                      if (widget.stackWidget != null && _isPause)
                        widget.stackWidget!
                    ],
                  ),
                )
              : ColoredBox(
                  color: ColorType.camera.errorBackGround,
                  child: AspectRatio(
                    aspectRatio: widget.aspectRatio,
                    child: Center(
                      child: Text(
                        _errorMessage,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: StyleType.camera.errorText,
                      ),
                    ),
                  ),
                ),
          Positioned(
            bottom: 0,
            child: Container(
              width: context.deviceWidth,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: ColorType.camera.buttonBackGround.withAlpha(240),
                boxShadow: [
                  BoxShadow(
                    color: ColorType.camera.buttonBackGroundShadow,
                    offset: const Offset(0, 2),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PauseCameraButton(
                    isEnabled: _isCameraReady && _isNotScanning,
                    isPause: _isPause && _isNotScanning,
                    startRecording: _startRecording,
                    resumeCamera: _resumeCamera,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
