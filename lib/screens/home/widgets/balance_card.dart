import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../models/card_skin.dart';
import '../../../providers/skin_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../theme/app_colors.dart';
import 'aurora_painter.dart';
import 'card_patterns.dart';

class BalanceCard extends ConsumerStatefulWidget {
  const BalanceCard({super.key});

  @override
  ConsumerState<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends ConsumerState<BalanceCard> {
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
    final skin   = ref.watch(cardSkinProvider);
    final config = skinConfigs[skin]!;

    final cardGradient = LinearGradient(
      colors: [config.bgFrom, config.bgTo],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final glowColor = config.glowColor;

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
            gradient: cardGradient,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.glassBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.45),
                blurRadius: 36,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: glowColor.withValues(alpha: 0.20),
                blurRadius: 24,
                offset: const Offset(-8, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                // Layer 1: Card pattern (skin-specific)
                Positioned.fill(
                  child: CustomPaint(
                    painter: buildCardPatternPainter(
                      config.pattern,
                      config.patternColors,
                    ),
                  ),
                ),
                // Layer 2: Tilt-reactive parallax orbs
                Positioned.fill(
                  child: CustomPaint(
                    painter: TiltCardOrbPainter(
                      tiltX: _smoothX,
                      tiltY: _smoothY,
                    ),
                  ),
                ),
                // Layer 3: Geometric diamond chain at top
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: SizedBox(
                    height: 24,
                    child: CustomPaint(
                      painter: CardGeometricPainter(
                        colors: config.accentColors,
                      ),
                    ),
                  ),
                ),
                // Layer 4: Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _TopRow(hidden: hidden, ref: ref),
                      _BalanceSection(hidden: hidden),
                      const _BottomRow(),
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

// ─── Top Row ────────────────────────────────────────────────────────────────

class _TopRow extends StatelessWidget {
  final bool hidden;
  final WidgetRef ref;
  const _TopRow({required this.hidden, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                gradient: AppColors.gradientPinkViolet,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.bolt_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 9),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Solux',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 5, height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'SRX Mainnet',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () =>
              ref.read(balanceHiddenProvider.notifier).state = !hidden,
          child: Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: const Color(0x15FFFFFF),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: const Color(0x12FFFFFF), width: 1),
            ),
            child: Icon(
              hidden
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              size: 14,
              color: Colors.white.withValues(alpha: 0.45),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Balance Section ─────────────────────────────────────────────────────────

class _BalanceSection extends StatelessWidget {
  final bool hidden;
  const _BalanceSection({required this.hidden});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TOTAL BALANCE',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          hidden ? '••••••' : '\$1,870.00',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          hidden ? '≈ ••••• SRX' : '≈ 12,500 SRX',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─── Bottom Row ──────────────────────────────────────────────────────────────

class _BottomRow extends StatelessWidget {
  const _BottomRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.glassHover,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy_outlined, size: 11, color: AppColors.textMuted),
              SizedBox(width: 5),
              Text(
                'srx1 •••• k3a7',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.successBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.trending_up_rounded,
                  size: 10, color: AppColors.success),
              SizedBox(width: 3),
              Text(
                '+2.4%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
