import 'package:flutter/material.dart';

class Mascot extends StatelessWidget {
  final String? task;
  final bool isShaking;
  final bool isPopping;

  const Mascot({super.key, this.task, required this.isShaking, required this.isPopping});

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isPopping) {
      child = AnimatedScale(
        scale: 1.4,
        duration: const Duration(milliseconds: 300),
        child: Image.asset(
          'assets/pop/popcorn_done.png',
          height: 140,
        ),
      );
    } else if (task != null) {
      child = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: isShaking ? 1 : 0),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          final double offset = isShaking ? ((value * 16) % 4 - 2).toDouble() : 0.0;
          return Transform.translate(
            offset: Offset(offset, 0),
            child: child,
          );
        },
        child: Image.asset(
          'assets/pop/corn_kernel.png',
          height: 140,
        ),
      );
    } else {
      child = Image.asset(
        'assets/pop/corn_idle.png',
        height: 140,
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }
}
