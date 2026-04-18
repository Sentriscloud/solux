import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated tilt-aware wave painter.
/// [t] = animation value 0..1 (repeating)
/// [tiltX] = normalized accelerometer x, -1..1
/// [tiltY] = normalized accelerometer y, -1..1
class TiltWavePainter extends CustomPainter {
  final double t;
  final double tiltX;
  final double tiltY;

  const TiltWavePainter({
    required this.t,
    required this.tiltX,
    required this.tiltY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final phaseShift = tiltX * math.pi * 1.2;
    final yShift = tiltY * size.height * 0.08;

    final waves = [
      _WaveCfg(
        color: const Color(0xFFEC4899),
        opacity: 0.30,
        yBase: size.height * 0.32 + yShift,
        amplitude: size.height * 0.11,
        speedMult: 1.0,
        phase: phaseShift,
        strokeWidth: 1.8,
      ),
      _WaveCfg(
        color: const Color(0xFFA855F7),
        opacity: 0.25,
        yBase: size.height * 0.52 + yShift * 0.7,
        amplitude: size.height * 0.09,
        speedMult: 0.75,
        phase: phaseShift + 1.8,
        strokeWidth: 1.4,
      ),
      _WaveCfg(
        color: const Color(0xFF6366F1),
        opacity: 0.18,
        yBase: size.height * 0.68 + yShift * 0.5,
        amplitude: size.height * 0.07,
        speedMult: 0.55,
        phase: phaseShift + 3.6,
        strokeWidth: 1.0,
      ),
      _WaveCfg(
        color: const Color(0xFF3B82F6),
        opacity: 0.10,
        yBase: size.height * 0.80 + yShift * 0.3,
        amplitude: size.height * 0.05,
        speedMult: 0.4,
        phase: phaseShift + 5.0,
        strokeWidth: 0.8,
      ),
    ];

    for (final w in waves) {
      _drawWave(canvas, size, w);
    }
  }

  void _drawWave(Canvas canvas, Size size, _WaveCfg w) {
    final paint = Paint()
      ..color = w.color.withValues(alpha: w.opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w.strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final basePhase = (t * w.speedMult + w.phase / (2 * math.pi)) * 2 * math.pi;

    const steps = 60;
    for (int i = 0; i <= steps; i++) {
      final x = size.width * i / steps;
      final pct = i / steps;
      final y = w.yBase +
          w.amplitude * math.sin(basePhase + pct * 2 * math.pi * 1.5) +
          w.amplitude * 0.35 * math.sin(basePhase * 1.3 + pct * 2 * math.pi * 2.5);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TiltWavePainter old) =>
      old.t != t || old.tiltX != tiltX || old.tiltY != tiltY;
}

/// Holographic shimmer — moves with tilt.
class HoloShimmerPainter extends CustomPainter {
  final double tiltX;
  final double tiltY;

  const HoloShimmerPainter({required this.tiltX, required this.tiltY});

  @override
  void paint(Canvas canvas, Size size) {
    // Map tilt to shimmer position 0..1
    final centerX = ((tiltX + 1) / 2).clamp(0.05, 0.95);
    final centerY = ((-tiltY + 1) / 2).clamp(0.05, 0.95);

    final shimmerPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(centerX * 2 - 1, centerY * 2 - 1),
        radius: 0.6,
        colors: const [
          Color(0x22FFFFFF),
          Color(0x15B4BCFF),
          Color(0x08FF9FFF),
          Color(0x00000000),
        ],
        stops: const [0.0, 0.3, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      shimmerPaint,
    );

    // Rainbow edge catch (like holographic foil)
    final edgePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-1 + tiltX * 2, -1),
        end: Alignment(1 + tiltX * 2, 1),
        colors: const [
          Color(0x00000000),
          Color(0x0A7C3AED),
          Color(0x10818CF8),
          Color(0x08FFFFFF),
          Color(0x0A3B82F6),
          Color(0x00000000),
        ],
        stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      edgePaint,
    );
  }

  @override
  bool shouldRepaint(HoloShimmerPainter old) =>
      old.tiltX != tiltX || old.tiltY != tiltY;
}

class _WaveCfg {
  final Color color;
  final double opacity;
  final double yBase;
  final double amplitude;
  final double speedMult;
  final double phase;
  final double strokeWidth;

  const _WaveCfg({
    required this.color,
    required this.opacity,
    required this.yBase,
    required this.amplitude,
    required this.speedMult,
    required this.phase,
    required this.strokeWidth,
  });
}
