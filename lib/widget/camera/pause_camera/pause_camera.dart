import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'pause_camera_isolate.dart';

class PauseCameraImage {
  final File file;
  final int width;
  final int height;
  const PauseCameraImage({
    required this.file,
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
    this.aspectRatio = 5 / 4,
  });

  @override
  State<PauseCamera> createState() => _PauseCameraState();
}

class _PauseCameraState extends State<PauseCamera> {
  late final String _tempDir;
  File? _image;

  List<CameraDescription> _cameras = [];
  CameraController? _controller;

  String _errorMessage = '';

  bool _isCameraReady = false;
  bool _isNotScanning = true;
  bool _isPause = false;

  int _recordCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tempDir = await getTemporaryDirectory();
      setState(() {
        _tempDir = tempDir.path;
        _errorMessage = L10n.of(context)!.pauseCameraStart;
      });
    });
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
      ResolutionPreset.max,
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
                L10n.of(context)!.pauseCameraErrorCameraAccessDenied;
            break;
          default:
            _errorMessage = L10n.of(context)!.pauseCameraErrorUndefined;
            break;
        }
        _isCameraReady = false;
      }
    });

    setState(() {});
  }

  Future<void> _stopCamera() async {
    await _controller?.dispose();
    _deleteImage();
    setState(() {
      _errorMessage = L10n.of(context)!.pauseCameraStart;
      _isCameraReady = false;
    });
  }

  Future<void> _startRecording() async {
    if (widget.onLoading != null) {
      widget.onLoading!();
    }
    setState(() {
      _isNotScanning = false;
    });
    // この処理で非同期操作をステートの変更後に行う
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _deleteImage();
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
      if (widget.changeImageFile == null) return;

      final imagePath = '$_tempDir/temp_image_$_recordCount.png';
      final image = await CameraIsolate.convertAndSaveCameraImage(
          cameraImage, _cameras[0], imagePath, widget.aspectRatio);
      if (image == null) {
        // 画像の取得に失敗した場合は、画像をnullにする
        widget.changeImageFile!(null);
        setState(() {
          _image = null;
        });
        return;
      }
      final imageFile = File(imagePath);
      widget.changeImageFile!(
        PauseCameraImage(
          file: imageFile,
          width: image.width,
          height: image.height,
        ),
      );
      setState(() {
        _image = imageFile;
      });
    } finally {
      if (widget.onLoaded != null) {
        widget.onLoaded!();
      }
      setState(() {
        _recordCount++;
        _isNotScanning = true;
        _isPause = true;
      });
    }
  }

  void _deleteImage() {
    if (mounted && _image != null && _image!.existsSync()) {
      _image!.deleteSync();
      setState(() {
        _image = null;
      });
    }
  }

  void _clear() {
    // ページ遷移の際にTemp画像を削除
    _deleteImage();

    // フレームの描画が完了した直後にコールバックを実行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ここで画面遷移などの処理を行う
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _clear();
        return false;
      },
      child: Column(
        children: [
          _isCameraReady &&
                  _controller != null &&
                  _controller!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: widget.aspectRatio,
                  child:
                      _isPause && _image != null && widget.stackWidget != null
                          ? widget.stackWidget
                          : Stack(
                              children: [
                                ClipRect(
                                  child: Transform.scale(
                                    scale: _controller!.value.aspectRatio *
                                        widget.aspectRatio,
                                    child: Center(
                                      child: CameraPreview(_controller!),
                                    ),
                                  ),
                                )
                              ],
                            ),
                )
              : ColoredBox(
                  color: CupertinoColors.systemGrey,
                  child: AspectRatio(
                    aspectRatio: widget.aspectRatio,
                    child: Center(
                      child: Text(
                        _errorMessage,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: CupertinoColors.systemBackground),
                      ),
                    ),
                  ),
                ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: CupertinoColors.systemBackground,
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.quaternarySystemFill,
                  offset: Offset(0, 2),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  // カメラを起動している場合は非活性にする
                  // カメラの起動ボタン
                  onPressed: _isCameraReady ? null : _startCamera,
                  color: CupertinoColors.activeBlue,
                  disabledColor: CupertinoColors.quaternarySystemFill,
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    CupertinoIcons.videocam_fill,
                    color: CupertinoColors.white,
                  ),
                ),
                !_isPause
                    ? CupertinoButton(
                        // カメラを起動しているかつ読み込み中ではない場合は活性にする
                        // 一時停止ボタン
                        onPressed: _isCameraReady && _isNotScanning
                            ? _startRecording
                            : null,
                        color: CupertinoColors.activeGreen,
                        disabledColor: CupertinoColors.quaternarySystemFill,
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          CupertinoIcons.pause_circle,
                          color: CupertinoColors.white,
                        ),
                      )
                    : CupertinoButton(
                        // カメラを起動している場合は活性にする
                        // 再開ボタン
                        onPressed: _isCameraReady ? _resumeCamera : null,
                        color: CupertinoColors.activeGreen,
                        disabledColor: CupertinoColors.quaternarySystemFill,
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          CupertinoIcons.play_arrow_solid,
                          color: CupertinoColors.white,
                        ),
                      ),
                CupertinoButton(
                  onPressed:
                      // カメラを起動しており、読み込み中でも停止中でもない場合は活性にする
                      _isCameraReady && _isNotScanning && !_isPause
                          ? _stopCamera
                          : null,
                  color: CupertinoColors.destructiveRed,
                  disabledColor: CupertinoColors.quaternarySystemFill,
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    CupertinoIcons.stop_circle,
                    color: CupertinoColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
