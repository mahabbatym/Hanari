import 'dart:math' as math;

import 'package:flutter/material.dart';

class PetalAnimation extends StatefulWidget {
  const PetalAnimation({super.key, required this.child});
  final Widget child;

  @override
  State<PetalAnimation> createState() => _PetalAnimationState();
}

class _PetalAnimationState extends State<PetalAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return TickerMode(
      enabled: !reduceMotion,
      child: reduceMotion
          ? CustomPaint(
              painter: _PetalPainter(
                0.3,
                Theme.of(context).colorScheme.tertiary,
              ),
              child: widget.child,
            )
          : RepaintBoundary(
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, _) => CustomPaint(
                  painter: _PetalPainter(
                    controller.value,
                    Theme.of(context).colorScheme.tertiary,
                  ),
                  child: widget.child,
                ),
              ),
            ),
    );
  }
}

class _PetalPainter extends CustomPainter {
  const _PetalPainter(this.progress, this.color);
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: .10);
    for (var i = 0; i < 8; i++) {
      final seed = i * 37.0;
      final x =
          (seed * 17 % 100) / 100 * size.width +
          math.sin(progress * math.pi * 2 + i) * 12;
      final y = ((progress + i / 8) % 1) * size.height;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * math.pi * 2 + i);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 7, height: 11),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _PetalPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
