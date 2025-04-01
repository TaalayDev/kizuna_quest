import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A fade transition page for GoRouter
class FadeTransitionPage extends CustomTransitionPage<void> {
  const FadeTransitionPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionsBuilder: fadeTransition,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
        );
}

/// Fade transition animation
Widget fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

/// Slide transition animation
Widget slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}

/// Scale transition animation
Widget scaleTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = 0.0;
  const end = 1.0;
  const curve = Curves.easeInOut;

  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  final scaleAnimation = animation.drive(tween);

  return ScaleTransition(
    scale: scaleAnimation,
    child: child,
  );
}

/// Slide and fade combined transition animation (for more dramatic effect)
Widget slideFadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(0.0, 0.2);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  final offsetAnimation = animation.drive(tween);

  return FadeTransition(
    opacity: animation,
    child: SlideTransition(
      position: offsetAnimation,
      child: child,
    ),
  );
}
