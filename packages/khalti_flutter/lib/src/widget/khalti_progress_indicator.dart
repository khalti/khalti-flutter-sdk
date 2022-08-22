// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:khalti_flutter/src/helper/assets.dart';

import 'image.dart';

/// The progress indicator with Khalti Icon.
class KhaltiProgressIndicator extends StatefulWidget {
  /// Creates [KhaltiProgressIndicator] with the provided [size].
  const KhaltiProgressIndicator({Key? key, this.size = 80}) : super(key: key);

  /// The [size] of the indicator.
  final double size;

  @override
  State<KhaltiProgressIndicator> createState() {
    return _KhaltiProgressIndicatorState();
  }
}

/// KhaltiProgressIndicator state class
class _KhaltiProgressIndicatorState extends State<KhaltiProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            painter: _ProgressPainter(fraction: _animation.value),
            child: SizedBox.square(
              dimension: widget.size - 16 * 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Opacity(
                    opacity: sin(_animation.value * pi),
                    child: const KhaltiImage.asset(asset: a_khaltiInnerLogo),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  _ProgressPainter({required this.fraction});

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final activeLength = width + height;

    final paint = Paint()
      ..color = const Color(0xFF5C2D91)
      ..strokeWidth = width / 14
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path()
      ..lineTo(width, 0)
      ..lineTo(width * 0.915, height * 0.75)
      ..lineTo(width * 0.5, height)
      ..lineTo(width * 0.085, height * 0.75)
      ..close();
    final activePath = Path();

    for (final metric in path.computeMetrics()) {
      final total = metric.length;
      final offset = fraction * total;
      var start = 0 + offset;
      var end = start + activeLength;

      if (end > total) {
        activePath
          ..addPath(metric.extractPath(start, total), Offset.zero)
          ..addPath(metric.extractPath(0, end - total), Offset.zero);
      } else {
        activePath.addPath(metric.extractPath(start, end), Offset.zero);
      }
    }

    canvas.drawPath(activePath, paint);
  }

  @override
  bool shouldRepaint(_ProgressPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
