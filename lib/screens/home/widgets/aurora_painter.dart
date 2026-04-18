import 'package:flutter/material.dart';

/// Tilt-aware orb painter for balance card (parallax effect).
class TiltCardOrbPainter extends CustomPainter {
  final double tiltX;
  final double tiltY;

  const TiltCardOrbPainter({required this.tiltX, required this.tiltY});

  @override
  void paint(Canvas canvas, Size size) {
    const parallax = 28.0;
    final orbs = [
      _Orb(bx: 0.80, by: 0.20, r: size.width * 0.42, color: const Color(0xFFA855F7), opacity: 0.28),
      _Orb(bx: 0.12, by: 0.78, r: size.width * 0.36, color: const Color(0xFFEC4899), opacity: 0.20),
      _Orb(bx: 0.50, by: 0.08, r: size.width * 0.28, color: const Color(0xFF6366F1), opacity: 0.16),
    ];

    for (final orb in orbs) {
      final cx = orb.bx * size.width + tiltX * parallax * (orb.bx - 0.5);
      final cy = orb.by * size.height - tiltY * parallax * (orb.by - 0.5);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            orb.color.withValues(alpha: orb.opacity),
            orb.color.withValues(alpha: orb.opacity * 0.4),
            orb.color.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: orb.r));
      canvas.drawCircle(Offset(cx, cy), orb.r, paint);
    }
  }

  @override
  bool shouldRepaint(TiltCardOrbPainter old) =>
      old.tiltX != tiltX || old.tiltY != tiltY;
}

/// Static orb painter fallback (when no sensor data yet).
class CardOrbPainter extends CustomPainter {
  const CardOrbPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const orbs = [
      _Orb(bx: 0.80, by: 0.20, r: 140, color: Color(0xFF7C3AED), opacity: 0.25),
      _Orb(bx: 0.12, by: 0.78, r: 110, color: Color(0xFF3B82F6), opacity: 0.20),
      _Orb(bx: 0.50, by: 0.08, r: 90,  color: Color(0xFF818CF8), opacity: 0.14),
    ];
    for (final orb in orbs) {
      final cx = orb.bx * size.width;
      final cy = orb.by * size.height;
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            orb.color.withValues(alpha: orb.opacity),
            orb.color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: orb.r));
      canvas.drawCircle(Offset(cx, cy), orb.r, paint);
    }
  }

  @override
  bool shouldRepaint(CardOrbPainter _) => false;
}

/// Screen-level background orb painter.
class BgOrbPainter extends CustomPainter {
  const BgOrbPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const orbs = [
      _Orb(bx: 0.0,  by: 0.08, r: 200, color: Color(0xFFA855F7), opacity: 0.14),
      _Orb(bx: 1.0,  by: 0.06, r: 170, color: Color(0xFFEC4899), opacity: 0.11),
      _Orb(bx: 0.5,  by: 0.50, r: 150, color: Color(0xFF6366F1), opacity: 0.07),
    ];
    for (final orb in orbs) {
      final cx = orb.bx * size.width;
      final cy = orb.by * size.height;
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            orb.color.withValues(alpha: orb.opacity),
            orb.color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: orb.r));
      canvas.drawCircle(Offset(cx, cy), orb.r, paint);
    }
  }

  @override
  bool shouldRepaint(BgOrbPainter _) => false;
}

/// Subtle dot grid overlay.
class GridPainter extends CustomPainter {
  const GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x06FFFFFF)
      ..strokeWidth = 0.5;
    const step = 24.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter _) => false;
}

/// Geometric diamond-chain pattern for card top border.
class CardGeometricPainter extends CustomPainter {
  final List<Color> colors;
  const CardGeometricPainter({this.colors = const [
    Color(0xFFEC4899), Color(0xFFA855F7), Color(0xFF6366F1), Color(0xFF3B82F6),
  ]});

  @override
  void paint(Canvas canvas, Size size) {
    const diamondR = 3.5;
    const spacing  = 20.0;
    const lineY    = 14.0;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradColors = colors.length >= 2
        ? colors
        : [const Color(0xFFEC4899), const Color(0xFFA855F7), const Color(0xFF6366F1), const Color(0xFF3B82F6)];
    final shader = LinearGradient(colors: gradColors).createShader(rect);

    // Top glow line
    canvas.drawLine(
      Offset.zero,
      Offset(size.width, 0),
      Paint()..shader = shader..strokeWidth = 1.5,
    );

    // Connecting line through diamonds
    canvas.drawLine(
      const Offset(0, lineY),
      Offset(size.width, lineY),
      Paint()..shader = shader..strokeWidth = 0.6,
    );

    // Diamond chain
    final n = (size.width / spacing).ceil() + 1;
    for (int i = 0; i < n; i++) {
      final x = i * spacing + spacing * 0.5;
      final t = (x / size.width).clamp(0.0, 1.0);
      final color = Color.lerp(
        const Color(0xFFEC4899),
        const Color(0xFF3B82F6),
        t,
      )!;

      final diamond = Path()
        ..moveTo(x, lineY - diamondR)
        ..lineTo(x + diamondR, lineY)
        ..lineTo(x, lineY + diamondR)
        ..lineTo(x - diamondR, lineY)
        ..close();

      canvas.drawPath(diamond,
          Paint()..color = color..style = PaintingStyle.fill);

      // Mid-dot
      if (i < n - 1) {
        canvas.drawCircle(
          Offset(x + spacing * 0.5, lineY),
          1.0,
          Paint()..color = color.withValues(alpha: 0.35),
        );
      }
    }
  }

  @override
  bool shouldRepaint(CardGeometricPainter old) => old.colors != colors;
}

class _Orb {
  final double bx, by, r, opacity;
  final Color color;
  const _Orb({
    required this.bx,
    required this.by,
    required this.r,
    required this.color,
    required this.opacity,
  });
}
