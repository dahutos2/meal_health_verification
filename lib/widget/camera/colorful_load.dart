import 'package:flutter/material.dart';

class ColorfulLoadPage extends StatefulWidget {
  const ColorfulLoadPage({super.key});

  @override
  State<ColorfulLoadPage> createState() => _ColorfulLoadPageState();
}

class _ColorfulLoadPageState extends State<ColorfulLoadPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
      // reverseをtrueに設定してアニメーションを前後に繰り返します
    )..repeat(reverse: true);

    _colorAnimation = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          tween: ColorTween(begin: Colors.red, end: Colors.orange),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(begin: Colors.yellow, end: Colors.green),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(begin: Colors.green, end: Colors.blue),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(begin: Colors.blue, end: Colors.indigo),
          weight: 1,
        ),
        TweenSequenceItem(
          tween: ColorTween(begin: Colors.indigo, end: Colors.purple),
          weight: 1,
        ),
      ],
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _colorAnimation,
      builder: (BuildContext context, Color? color, Widget? child) {
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color!),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
