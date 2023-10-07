import 'package:flutter/material.dart';

import '../../../share/index.dart';

class PauseCameraButton extends StatefulWidget {
  final bool isEnabled;
  final bool isPause;
  final Future<void> Function() startRecording;
  final Future<void> Function() resumeCamera;
  const PauseCameraButton({
    super.key,
    required this.isEnabled,
    required this.isPause,
    required this.startRecording,
    required this.resumeCamera,
  });

  @override
  State<PauseCameraButton> createState() => _PauseCameraButtonState();
}

class _PauseCameraButtonState extends State<PauseCameraButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isPause
          ? widget.resumeCamera
          : widget.isEnabled
              ? widget.startRecording
              : null,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isEnabled
              ? ColorType.camera.button
              : ColorType.camera.buttonBlinking,
        ),
        child: CustomPaint(
          painter: BlinkingCameraButtonPainter(
            isPause: widget.isPause,
            isButtonEnabled: widget.isEnabled,
            animation: _animation,
          ),
        ),
      ),
    );
  }
}

class BlinkingCameraButtonPainter extends CustomPainter {
  final bool isButtonEnabled;
  final bool isPause;
  final Animation animation;

  BlinkingCameraButtonPainter({
    required this.isButtonEnabled,
    required this.isPause,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final outerPaint = Paint()
      ..color = isButtonEnabled
          ? ColorType.camera.buttonInner
          : ColorType.camera.buttonDisabled
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final innerCirclePaint = Paint()
      ..color = isButtonEnabled
          ? ColorType.camera.buttonOuter
          : ColorType.camera.buttonDisabled.withOpacity(animation.value)
      ..style = PaintingStyle.fill;

    final outerCircle = Offset(size.width / 2, size.height / 2);
    final innerCircle = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(outerCircle, size.width / 2, outerPaint);

    if (isPause) {
      // 一時停止中の場合、再生ボタンを描画
      final triangleHeight = size.width / 2.2;
      final triangleBaseHalf = size.width / 5;
      final leftLineX = outerCircle.dx - triangleBaseHalf + 2;
      final rightPointX = outerCircle.dx + triangleBaseHalf + 2;

      final Path trianglePath = Path()
        ..moveTo(leftLineX, innerCircle.dy - triangleHeight / 2)
        ..lineTo(leftLineX, innerCircle.dy + triangleHeight / 2)
        ..lineTo(rightPointX, innerCircle.dy)
        ..close();

      canvas.drawPath(trianglePath, innerCirclePaint);
    } else {
      // 一時停止中でない場合、通常の内側の円を描画
      canvas.drawCircle(innerCircle, size.width / 2 - outerPaint.strokeWidth,
          innerCirclePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
