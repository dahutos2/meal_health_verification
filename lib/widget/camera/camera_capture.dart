import 'package:flutter/material.dart';
import 'package:meal_health_verification/widget/camera/pause_camera/pause_camera.dart';

class Camera extends StatelessWidget {
  const Camera({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        PauseCamera(),
      ],
    );
  }
}
