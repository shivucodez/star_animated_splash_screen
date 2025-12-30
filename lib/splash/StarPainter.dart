import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'StarLayerConfig.dart';

class StarPainter extends CustomPainter {
  final Animation<double> animation;

  final Random random = Random();

  static const layers = [
    StarLayerConfig(
      count: 40,
      speedMultiplier: 0.6,
      minThickness: 1.0,
      maxThickness: 2.0,
      glow: 2,
      opacity: 0.25,
    ),
    StarLayerConfig(
      count: 50,
      speedMultiplier: 1.0,
      minThickness: 1.8,
      maxThickness: 3.0,
      glow: 4,
      opacity: 0.4,
    ),
    StarLayerConfig(
      count: 30,
      speedMultiplier: 1.6,
      minThickness: 3.0,
      maxThickness: 6.0,
      glow: 7,
      opacity: 0.9,
    ),
  ];

  late final List<List<double>> angles;
  late final List<List<double>> depths;
  late final List<List<Color>> colors;

  StarPainter({required this.animation}) : super(repaint: animation) {
    angles = [];
    depths = [];
    colors = [];

    for (final layer in layers) {
      angles.add(
        List.generate(layer.count, (_) => random.nextDouble() * 2 * pi),
      );
      depths.add(List.generate(layer.count, (_) => random.nextDouble()));
      colors.add(
        List.generate(
          layer.count,
              (_) => random.nextBool()
              ? const Color(0xFFFF2EC4)
              : const Color(0xFF2EDBFF),
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final t = animation.value;

    for (int l = 0; l < layers.length; l++) {
      final layer = layers[l];

      for (int i = 0; i < layer.count; i++) {
        double z = depths[l][i] - t * layer.speedMultiplier;
        if (z < 0) z += 1;

        final double scale = (1 - z).clamp(0.0, 1.0);

        final double angle = angles[l][i];
        final Offset dir = Offset(cos(angle), sin(angle));

        final double distance = scale * max(size.width, size.height) * 1.5;

        final Offset head = center + dir * distance;

        final double tailLength = (60 + scale * 220) * layer.speedMultiplier;

        final Offset tail = head - dir * tailLength;

        final Color neon = colors[l][i];

        final tailPaint = Paint()
          ..strokeWidth = lerpDouble(
            layer.minThickness,
            layer.maxThickness,
            scale,
          )!
          ..strokeCap = StrokeCap.round
          ..color = neon.withOpacity(layer.opacity * scale);

        canvas.drawLine(tail, head, tailPaint);

        final headPaint = Paint()
          ..strokeWidth = lerpDouble(
            layer.minThickness * 2,
            layer.maxThickness * 2,
            scale,
          )!
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            layer.glow.toDouble(),
          )
          ..color = neon.withOpacity(scale);

        canvas.drawLine(head - dir * 50, head, headPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}