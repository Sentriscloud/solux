import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../providers/wallet_provider.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

const _kCardBg        = Color(0xFF0D0D0D);
const _kCardRadius    = 20.0;
const _kBorderColor   = Color(0x0FFFFFFF); // rgba(255,255,255,0.06)
const _kHexRadius     = 18.0;
const _kHexBase       = Color(0x0FFFFFFF); // hex outline rgba(255,255,255,0.06)
const _kHexLight      = Color(0x17FFFFFF); // light edge rgba(255,255,255,0.09)
const _kHexDark       = Color(0x99000000); // dark edge rgba(0,0,0,0.60)
const _kEtchLine      = Color(0x0AFFFFFF); // etch mark rgba(255,255,255,0.04)
const _kTextPrimary   = Color(0xD9FFFFFF); // rgba(255,255,255,0.85)
const _kTextLabel     = Color(0x4DFFFFFF); // rgba(255,255,255,0.30)
const _kTextSub       = Color(0x33FFFFFF); // rgba(255,255,255,0.20)
const _kBadgeBg       = Color(0xFF111111);
const _kBadgeBorder   = Color(0x1FFFFFFF); // rgba(255,255,255,0.12)
const _kAddrBorder    = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
const _kAddrBg        = Color(0x0CFFFFFF);
const _kGreen         = Color(0xFF22C55E);
const _kGreenBg       = Color(0x1422C55E); // rgba(34,197,94,0.08)

// ─── Widget ──────────────────────────────────────────────────────────────────

class MetalBalanceCard extends ConsumerStatefulWidget {
  const MetalBalanceCard({super.key});

  @override
  ConsumerState<MetalBalanceCard> createState() => _MetalBalanceCardState();
}

class _MetalBalanceCardState extends ConsumerState<MetalBalanceCard> {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  double _smoothX = 0, _smoothY = 0;

  @override
  void initState() {
    super.initState();
    try {
      _accelSub = accelerometerEventStream(
        samplingPeriod: SensorInterval.uiInterval,
      ).listen((e) {
        if (!mounted) return;
        setState(() {
          final rawX = (e.x / 9.8).clamp(-1.0, 1.0);
          final rawY = (e.y / 9.8).clamp(-1.0, 1.0);
          _smoothX += (rawX - _smoothX) * 0.12;
          _smoothY += (rawY - _smoothY) * 0.12;
        });
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hidden = ref.watch(balanceHiddenProvider);

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0008)
        ..rotateX(_smoothY * 0.18)
        ..rotateY(-_smoothX * 0.18),
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1.72,
        child: Container(
          decoration: BoxDecoration(
            color: _kCardBg,
            borderRadius: BorderRadius.circular(_kCardRadius),
            border: Border.all(color: _kBorderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.80),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.40),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_kCardRadius),
            child: Stack(
              children: [
                // Layer 1: Debossed hex texture
                const Positioned.fill(
                  child: CustomPaint(painter: HexagonTexturePainter()),
                ),
                // Layer 2: Subtle etch marks
                const Positioned.fill(
                  child: CustomPaint(painter: _EtchMarkPainter()),
                ),
                // Layer 3: Top-left ambient sheen (metal light)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.04),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.08),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
                // Layer 4: Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _MetalTopRow(hidden: hidden, ref: ref),
                      _MetalBalanceSection(hidden: hidden),
                      _MetalBottomRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Hexagon Texture Painter ─────────────────────────────────────────────────

class HexagonTexturePainter extends CustomPainter {
  const HexagonTexturePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const r   = _kHexRadius;
    final hexW = r * math.sqrt(3);
    const hexH = r * 2;
    final cols = (size.width  / hexW).ceil() + 2;
    final rows = (size.height / (hexH * 0.75)).ceil() + 2;

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final cx = col * hexW + (row.isOdd ? hexW * 0.5 : 0);
        final cy = row * hexH * 0.75;
        _drawEmbossedHex(canvas, Offset(cx, cy), r);
      }
    }
  }

  List<Offset> _vertices(Offset c, double r) {
    // Pointy-top hexagon: vertex 0 = top (12 o'clock), goes clockwise
    return List.generate(6, (i) {
      final a = -math.pi / 2 + math.pi / 3 * i;
      return Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
    });
  }

  void _drawEmbossedHex(Canvas canvas, Offset c, double r) {
    final v = _vertices(c, r);

    // Base outline
    final path = Path()..moveTo(v[0].dx, v[0].dy);
    for (int i = 1; i < 6; i++) { path.lineTo(v[i].dx, v[i].dy); }
    path.close();
    canvas.drawPath(path, Paint()
      ..color = _kHexBase
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke);

    // Light edges — top-left faces (v5→v0, v0→v1) = catch ambient light
    final lightPaint = Paint()
      ..color = _kHexLight
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(v[5], v[0], lightPaint);
    canvas.drawLine(v[0], v[1], lightPaint);

    // Dark edges — bottom-right faces (v2→v3, v3→v4) = cast shadow
    final darkPaint = Paint()
      ..color = _kHexDark
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(v[2], v[3], darkPaint);
    canvas.drawLine(v[3], v[4], darkPaint);
  }

  @override
  bool shouldRepaint(HexagonTexturePainter _) => false;
}

// ─── Etch Mark Painter ───────────────────────────────────────────────────────

class _EtchMarkPainter extends CustomPainter {
  const _EtchMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = _kEtchLine
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 3 subtle diagonal etch lines at bottom-left
    final lines = [
      [Offset(w*0.06, h*0.78), Offset(w*0.18, h*0.64)],
      [Offset(w*0.10, h*0.84), Offset(w*0.24, h*0.68)],
      [Offset(w*0.04, h*0.92), Offset(w*0.14, h*0.80)],
    ];
    for (final l in lines) {
      canvas.drawLine(l[0], l[1], paint);
    }
  }

  @override
  bool shouldRepaint(_EtchMarkPainter _) => false;
}

// ─── Top Row ─────────────────────────────────────────────────────────────────

class _MetalTopRow extends StatelessWidget {
  final bool hidden;
  final WidgetRef ref;
  const _MetalTopRow({required this.hidden, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Hex logo badge
            _HexBadge(),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Solux',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kTextPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 5, height: 5,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: _kGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('SRX Mainnet',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: _kTextSub,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // Eye toggle
        GestureDetector(
          onTap: () => ref.read(balanceHiddenProvider.notifier).state = !hidden,
          child: Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: _kAddrBg,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _kAddrBorder, width: 1),
            ),
            child: Icon(
              hidden ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              size: 14,
              color: _kTextSub,
            ),
          ),
        ),
      ],
    );
  }
}

// Hexagon-shaped badge (custom clip)
class _HexBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: _kBadgeBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kBadgeBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.04),
            blurRadius: 0,
            offset: const Offset(0, -1), // inner top light
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.80),
            blurRadius: 0,
            offset: const Offset(0, 1), // inner bottom shadow
          ),
        ],
      ),
      child: const Icon(Icons.bolt_rounded, color: _kTextPrimary, size: 18),
    );
  }
}

// ─── Balance Section ─────────────────────────────────────────────────────────

class _MetalBalanceSection extends StatelessWidget {
  final bool hidden;
  const _MetalBalanceSection({required this.hidden});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TOTAL BALANCE',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.5,
            color: _kTextLabel,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hidden ? '••••••' : '\$1,870.00',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: _kTextPrimary,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          hidden ? '≈ ••••• SRX' : '≈ 12,500 SRX',
          style: const TextStyle(fontSize: 12, color: _kTextSub),
        ),
      ],
    );
  }
}

// ─── Bottom Row ──────────────────────────────────────────────────────────────

class _MetalBottomRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Address pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _kAddrBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kAddrBorder, width: 1),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy_outlined, size: 11, color: _kTextSub),
              SizedBox(width: 5),
              Text('srx1 •••• k3a7',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: _kTextSub,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        // Change pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: _kGreenBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _kGreen.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.trending_up_rounded, size: 10, color: _kGreen),
              SizedBox(width: 3),
              Text('+2.4%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _kGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
