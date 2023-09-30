import 'package:flutter/material.dart';

/// 画面遷移を管理するクラス
/// ```dart
/// ・PageRouteBuilder<T> slideInToRight<T>({required Widget nextPage})
/// ・PageRouteBuilder<T> slideInToLeft<T>({required Widget nextPage})
/// ・PageRouteBuilder<T> slideInToTop<T>({required Widget nextPage})
/// ・PageRouteBuilder<T> slideInToBottom<T>({required Widget nextPage})
/// ・PageRouteBuilder<T> fadeIn<T>({required Widget nextPage})
/// ・PageRouteBuilder<T> blackOut<T>({required Widget nextPage})
/// ・PageRouteBuilder<T> whiteOut<T>({required Widget nextPage})
/// ・PageRouteBuilder<T> wipe<T>({required Widget nextPage})
/// ```
class RouteType {
  RouteType._();

  static PageRouteBuilder<T> slideInToRight<T>({required Widget nextPage}) =>
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );

  static PageRouteBuilder<T> slideInToLeft<T>({required Widget nextPage}) =>
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );

  static PageRouteBuilder<T> slideInToTop<T>({required Widget nextPage}) =>
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );

  static PageRouteBuilder<T> slideInToBottom<T>({required Widget nextPage}) =>
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );

  static PageRouteBuilder<T> fadeIn<T>({required Widget nextPage}) =>
      PageRouteBuilder<T>(
        pageBuilder: (_, animation, secondaryAnimation) => nextPage,
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          double begin = 0.0;
          double end = 1.0;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          final doubleAnimation = animation.drive(tween);
          return FadeTransition(
            opacity: doubleAnimation,
            alwaysIncludeSemantics: true,
            child: child,
          );
        },
      );

  static PageRouteBuilder<T> blackOut<T>({required Widget nextPage}) =>
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionDuration: const Duration(seconds: 2),
        reverseTransitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final color = ColorTween(
            begin: Colors.transparent,
            end: Colors.black,
          ).animate(CurvedAnimation(
            parent: animation,
            // 前半
            curve: const Interval(
              0.0,
              0.5,
              curve: Curves.easeInOut,
            ),
          ));
          final opacity = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            // 後半
            curve: const Interval(
              0.5,
              1.0,
              curve: Curves.easeInOut,
            ),
          ));
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Container(
                color: color.value,
                child: Opacity(
                  opacity: opacity.value,
                  child: child,
                ),
              );
            },
            child: child,
          );
        },
      );

  static PageRouteBuilder<T> whiteOut<T>({required Widget nextPage}) =>
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionDuration: const Duration(seconds: 2),
        reverseTransitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final color = ColorTween(
            begin: Colors.transparent,
            end: Colors.white,
          ).animate(CurvedAnimation(
            parent: animation,
            // 前半
            curve: const Interval(
              0.0,
              0.5,
              curve: Curves.easeInOut,
            ),
          ));
          final opacity = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            // 後半
            curve: const Interval(
              0.5,
              1.0,
              curve: Curves.easeInOut,
            ),
          ));
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Container(
                color: color.value,
                child: Opacity(
                  opacity: opacity.value,
                  child: child,
                ),
              );
            },
            child: child,
          );
        },
      );

  static PageRouteBuilder<T> wipe<T>({required Widget nextPage}) =>
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final opacity = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return ClipPath(
                clipper: WipeClippter(opacity.value),
                child: child,
              );
            },
            child: child,
          );
        },
      );
}

class WipeClippter extends CustomClipper<Path> {
  const WipeClippter(this.progress) : super();

  final double progress;

  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * progress,
        height: size.height,
      ))
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
