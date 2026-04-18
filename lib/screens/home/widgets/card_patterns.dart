import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─── 1. Neon Streaks ─────────────────────────────────────────────────────────
// Reference: Bold diagonal light rays — cyan, blue-violet, pink — on deep black

class NeonStreakPainter extends CustomPainter {
  final List<Color> colors;
  const NeonStreakPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final c0 = colors.isNotEmpty ? colors[0] : const Color(0xFF22D3EE);
    final c1 = colors.length > 1 ? colors[1] : const Color(0xFFA855F7);
    final c2 = colors.length > 2 ? colors[2] : const Color(0xFFEC4899);

    const angle = -0.58; // ~33 deg, matches reference diagonal

    // Beam positions spread across card
    final beams = [
      (x: 0.18, color: c0,         gW: 80.0, cW: 18.0, gOp: 0.16, cOp: 0.65),
      (x: 0.48, color: c1,         gW: 100.0, cW: 22.0, gOp: 0.14, cOp: 0.60),
      (x: 0.78, color: c2,         gW: 85.0, cW: 20.0, gOp: 0.15, cOp: 0.62),
    ];

    for (final b in beams) {
      // Outer soft glow (wide)
      _beam(canvas, size, x: b.x, angle: angle, color: b.color, w: b.gW,   op: b.gOp * 0.5);
      // Mid glow
      _beam(canvas, size, x: b.x, angle: angle, color: b.color, w: b.gW * 0.55, op: b.gOp);
      // Core bright
      _beam(canvas, size, x: b.x, angle: angle, color: b.color, w: b.cW,   op: b.cOp);
      // White highlight
      _beam(canvas, size, x: b.x, angle: angle, color: Colors.white,        w: b.cW * 0.22, op: 0.35);
    }

    // Subtle secondary beam between c0 and c1
    _beam(canvas, size, x: 0.33, angle: angle,
        color: Color.lerp(c0, c1, 0.5)!, w: 55, op: 0.07);
    _beam(canvas, size, x: 0.33, angle: angle,
        color: Color.lerp(c0, c1, 0.5)!, w: 10, op: 0.28);
  }

  void _beam(Canvas canvas, Size size, {
    required double x, required double angle,
    required Color color, required double w, required double op,
  }) {
    canvas.save();
    canvas.translate(x * size.width, size.height * 0.5);
    canvas.rotate(angle);
    final len  = size.height * 2.6;
    final rect = Rect.fromCenter(center: Offset.zero, width: w * 2, height: len);
    canvas.drawRect(rect, Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color.withValues(alpha: op * 0.2),
          color.withValues(alpha: op),
          color.withValues(alpha: op),
          color.withValues(alpha: op * 0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.06, 0.35, 0.65, 0.94, 1.0],
        begin: Alignment.centerLeft,
        end:   Alignment.centerRight,
      ).createShader(rect));
    canvas.restore();
  }

  @override
  bool shouldRepaint(NeonStreakPainter _) => false;
}

// ─── 2. Circuit Board ────────────────────────────────────────────────────────
// Reference: Teal/cyan PCB traces cascading from top, particle scatter, dark navy bg

class CircuitBoardPainter extends CustomPainter {
  final List<Color> colors;
  const CircuitBoardPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final color  = colors.isNotEmpty ? colors[0] : const Color(0xFF22D3EE);
    final color2 = colors.length > 1 ? colors[1] : color;
    final w = size.width;
    final h = size.height;

    final tracePaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final tracePaint2 = Paint()
      ..color = color2.withValues(alpha: 0.20)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final viaPaint = Paint()..color = color.withValues(alpha: 0.60);
    final viaRing  = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Primary traces — cascade from top, fan downward
    final traces1 = <List<Offset>>[
      [Offset(0.50*w, 0.02*h), Offset(0.50*w, 0.12*h), Offset(0.70*w, 0.12*h), Offset(0.70*w, 0.28*h)],
      [Offset(0.50*w, 0.02*h), Offset(0.50*w, 0.22*h), Offset(0.34*w, 0.22*h), Offset(0.34*w, 0.40*h)],
      [Offset(0.70*w, 0.12*h), Offset(0.88*w, 0.12*h), Offset(0.88*w, 0.38*h)],
      [Offset(0.70*w, 0.28*h), Offset(0.84*w, 0.28*h)],
      [Offset(0.34*w, 0.40*h), Offset(0.20*w, 0.40*h), Offset(0.20*w, 0.62*h)],
      [Offset(0.34*w, 0.40*h), Offset(0.34*w, 0.58*h), Offset(0.54*w, 0.58*h), Offset(0.54*w, 0.76*h)],
      [Offset(0.88*w, 0.38*h), Offset(0.88*w, 0.54*h), Offset(0.68*w, 0.54*h)],
      [Offset(0.68*w, 0.54*h), Offset(0.68*w, 0.72*h), Offset(0.80*w, 0.72*h)],
      [Offset(0.20*w, 0.62*h), Offset(0.36*w, 0.62*h)],
      [Offset(0.20*w, 0.62*h), Offset(0.20*w, 0.82*h), Offset(0.40*w, 0.82*h)],
      [Offset(0.54*w, 0.76*h), Offset(0.54*w, 0.90*h), Offset(0.70*w, 0.90*h)],
    ];

    // Secondary thinner traces
    final traces2 = <List<Offset>>[
      [Offset(0.06*w, 0.08*h), Offset(0.22*w, 0.08*h), Offset(0.22*w, 0.24*h)],
      [Offset(0.22*w, 0.24*h), Offset(0.10*w, 0.24*h), Offset(0.10*w, 0.46*h)],
      [Offset(0.62*w, 0.02*h), Offset(0.62*w, 0.08*h), Offset(0.78*w, 0.08*h)],
      [Offset(0.92*w, 0.60*h), Offset(0.92*w, 0.80*h)],
      [Offset(0.06*w, 0.54*h), Offset(0.14*w, 0.54*h)],
      [Offset(0.44*w, 0.94*h), Offset(0.60*w, 0.94*h)],
    ];

    for (final pts in traces1) {
      final path = Path()..moveTo(pts[0].dx, pts[0].dy);
      for (int i = 1; i < pts.length; i++) { path.lineTo(pts[i].dx, pts[i].dy); }
      canvas.drawPath(path, tracePaint);
      for (final pt in pts) {
        canvas.drawCircle(pt, 2.5, viaPaint);
        canvas.drawCircle(pt, 5.0, viaRing);
      }
    }
    for (final pts in traces2) {
      final path = Path()..moveTo(pts[0].dx, pts[0].dy);
      for (int i = 1; i < pts.length; i++) { path.lineTo(pts[i].dx, pts[i].dy); }
      canvas.drawPath(path, tracePaint2);
      for (final pt in pts) {
        canvas.drawCircle(pt, 1.8, viaPaint..color = color.withValues(alpha: 0.35));
      }
    }

    // Particle scatter (sparkle dots in lower half)
    final rng = math.Random(42);
    for (int i = 0; i < 36; i++) {
      final px = rng.nextDouble() * w;
      final py = h * 0.4 + rng.nextDouble() * h * 0.6;
      final r  = rng.nextDouble() * 1.2 + 0.3;
      final op = rng.nextDouble() * 0.30 + 0.05;
      canvas.drawCircle(
        Offset(px, py), r,
        Paint()..color = color.withValues(alpha: op),
      );
    }

    // Radial glow top-center
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.7),
        radius: 1.0,
        colors: [color.withValues(alpha: 0.14), Colors.transparent],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h)));
  }

  @override
  bool shouldRepaint(CircuitBoardPainter _) => false;
}

// ─── 3. Hex Grid ─────────────────────────────────────────────────────────────
// Reference: Deep navy blue card, full hex honeycomb, electric neon glow at center

class HexGridPainter extends CustomPainter {
  final List<Color> colors;
  const HexGridPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final color  = colors.isNotEmpty ? colors[0] : const Color(0xFF22D3EE);
    final glow   = colors.length > 1 ? colors[1] : color;
    final w = size.width;
    final h = size.height;

    const r   = 15.0;
    final rh   = r * math.sqrt(3) / 2;
    final rowH = rh * 2;
    const colW = r * 1.5;
    final rows = (h / rowH).ceil() + 2;
    final cols = (w / colW).ceil() + 2;

    // Center of glow
    final cx = w * 0.5;
    final cy = h * 0.38;

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final hx = col * colW;
        final hy = row * rowH + (col.isOdd ? rowH * 0.5 : 0);

        // Distance from glow center (normalized)
        final dist = math.sqrt(math.pow(hx - cx, 2) + math.pow(hy - cy, 2));
        final maxDist = math.sqrt(w * w + h * h) * 0.6;
        final t = (1.0 - (dist / maxDist).clamp(0.0, 1.0));

        // Hex fill in glow zone
        if (t > 0.55) {
          final fillOp = ((t - 0.55) / 0.45 * 0.12).clamp(0.0, 0.12);
          _hexPath(canvas, Offset(hx, hy), r - 1,
              Paint()..color = color.withValues(alpha: fillOp));
        }

        // Hex stroke — brighter near center
        final strokeOp = (0.08 + t * 0.30).clamp(0.0, 0.38);
        _hexPath(canvas, Offset(hx, hy), r,
            Paint()
              ..color = color.withValues(alpha: strokeOp)
              ..strokeWidth = t > 0.5 ? 1.0 : 0.7
              ..style = PaintingStyle.stroke);
      }
    }

    // Strong multi-stop radial glow
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.24),
        radius: 0.80,
        colors: [
          glow.withValues(alpha: 0.38),
          glow.withValues(alpha: 0.16),
          glow.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.65, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h)));

    // Inner bright core glow
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -0.24),
        radius: 0.35,
        colors: [glow.withValues(alpha: 0.25), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, w, h)));
  }

  void _hexPath(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final a = math.pi / 3 * i;
      final x = c.dx + r * math.cos(a);
      final y = c.dy + r * math.sin(a);
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HexGridPainter _) => false;
}

// ─── 4. Isometric Cubes ──────────────────────────────────────────────────────
// Reference: Dark gray cubes tiling card, ONE bright accent cube in center

class IsoCubePainter extends CustomPainter {
  final List<Color> colors;
  const IsoCubePainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final accent = colors.isNotEmpty ? colors[0] : const Color(0xFF6366F1);

    const cw = 24.0;
    const ch = cw * 0.58;
    final cols = (size.width  / cw).ceil() + 2;
    final rows = (size.height / (ch * 1.5)).ceil() + 2;

    // Accent cube position (center-ish)
    final accentCol = (cols * 0.5).round();
    final accentRow = (rows * 0.42).round();

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final ox = col * cw + (row.isOdd ? cw * 0.5 : 0);
        final oy = row * ch * 1.5;
        final isAccent = (row == accentRow && col == accentCol);

        if (isAccent) {
          // Bright accent cube
          _drawCube(canvas, Offset(ox, oy), cw, ch,
            accent.withValues(alpha: 0.85),
            accent.withValues(alpha: 0.55),
            accent.withValues(alpha: 0.35),
            edgeColor: accent.withValues(alpha: 0.90),
            edgeW: 0.8,
          );
          // Glow around accent cube
          final center = Offset(ox, oy + ch * 0.5);
          canvas.drawCircle(center, cw * 1.4,
            Paint()
              ..color = accent.withValues(alpha: 0.18)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12));
        } else {
          // Dark cube (barely visible)
          _drawCube(canvas, Offset(ox, oy), cw, ch,
            const Color(0xFFFFFFFF).withValues(alpha: 0.045),
            const Color(0xFFFFFFFF).withValues(alpha: 0.030),
            const Color(0xFFFFFFFF).withValues(alpha: 0.015),
            edgeColor: const Color(0xFFFFFFFF).withValues(alpha: 0.06),
            edgeW: 0.5,
          );
        }
      }
    }
  }

  void _drawCube(Canvas canvas, Offset o, double cw, double ch,
      Color top, Color left, Color right, {
        required Color edgeColor, required double edgeW,
      }) {
    final hw = cw * 0.5;
    final hh = ch * 0.5;

    final topPath = Path()
      ..moveTo(o.dx,        o.dy - hh)
      ..lineTo(o.dx + hw,   o.dy)
      ..lineTo(o.dx,        o.dy + hh)
      ..lineTo(o.dx - hw,   o.dy)
      ..close();

    final leftPath = Path()
      ..moveTo(o.dx - hw,   o.dy)
      ..lineTo(o.dx,        o.dy + hh)
      ..lineTo(o.dx,        o.dy + hh + ch)
      ..lineTo(o.dx - hw,   o.dy + ch)
      ..close();

    final rightPath = Path()
      ..moveTo(o.dx,        o.dy + hh)
      ..lineTo(o.dx + hw,   o.dy)
      ..lineTo(o.dx + hw,   o.dy + ch)
      ..lineTo(o.dx,        o.dy + hh + ch)
      ..close();

    canvas.drawPath(topPath,   Paint()..color = top);
    canvas.drawPath(leftPath,  Paint()..color = left);
    canvas.drawPath(rightPath, Paint()..color = right);

    final edgePaint = Paint()
      ..color = edgeColor
      ..strokeWidth = edgeW
      ..style = PaintingStyle.stroke;
    canvas.drawPath(topPath,   edgePaint);
    canvas.drawPath(leftPath,  edgePaint);
    canvas.drawPath(rightPath, edgePaint);
  }

  @override
  bool shouldRepaint(IsoCubePainter _) => false;
}

// ─── 5. Stealth Metal ────────────────────────────────────────────────────────
// Reference: Black metal card — etched hex emboss, black-on-black, no bright colors

class StealthHexPainter extends CustomPainter {
  final List<Color> colors;
  const StealthHexPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    const r    = 22.0; // larger hexes to match reference
    final rh   = r * math.sqrt(3) / 2;
    final rowH = rh * 2;
    const colW = r * 1.5;
    final rows = (h / rowH).ceil() + 2;
    final cols = (w / colW).ceil() + 2;

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final cx = col * colW;
        final cy = row * rowH + (col.isOdd ? rowH * 0.5 : 0);
        final center = Offset(cx, cy);

        // Recessed interior — slightly darker than card bg
        _hex(canvas, center, r - 1.0,
          Paint()..color = const Color(0xFF040407));

        // Ridge border — the etched ridge line (slightly lighter)
        _hex(canvas, center, r,
          Paint()
            ..color = const Color(0xFF1E1E26)
            ..strokeWidth = 1.4
            ..style = PaintingStyle.stroke);

        // Inner highlight — very subtle top-lit sheen
        _hex(canvas, center, r - 1.5,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.025)
            ..strokeWidth = 0.5
            ..style = PaintingStyle.stroke);
      }
    }

    // Metal sheen — top-left ambient light (like ref card's slight gloss)
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.5, -0.7),
        radius: 0.85,
        colors: [
          Colors.white.withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h)));

    // Subtle connecting traces (very minimal, like ref card lines)
    final linePaint = Paint()
      ..color = const Color(0xFF1A1A22)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final traces = <List<Offset>>[
      [Offset(w*0.28, h*0.70), Offset(w*0.28, h*0.88), Offset(w*0.44, h*0.88)],
      [Offset(w*0.12, h*0.55), Offset(w*0.26, h*0.55)],
      [Offset(w*0.44, h*0.78), Offset(w*0.60, h*0.78)],
    ];
    for (final pts in traces) {
      final path = Path()..moveTo(pts[0].dx, pts[0].dy);
      for (int i = 1; i < pts.length; i++) { path.lineTo(pts[i].dx, pts[i].dy); }
      canvas.drawPath(path, linePaint);
      // Small dot at junction
      canvas.drawCircle(pts.last, 2.0,
          Paint()..color = const Color(0xFF1E1E26));
    }
  }

  void _hex(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final a = math.pi / 6 + math.pi / 3 * i; // pointy-top orientation
      final x = c.dx + r * math.cos(a);
      final y = c.dy + r * math.sin(a);
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StealthHexPainter _) => false;
}

// ─── Helper ──────────────────────────────────────────────────────────────────

CustomPainter buildCardPatternPainter(String pattern, List<Color> colors) {
  switch (pattern) {
    case 'circuit':  return CircuitBoardPainter(colors);
    case 'hex':      return HexGridPainter(colors);
    case 'cubes':    return IsoCubePainter(colors);
    case 'stealth':  return StealthHexPainter(colors);
    case 'neon':
    default:         return NeonStreakPainter(colors);
  }
}
