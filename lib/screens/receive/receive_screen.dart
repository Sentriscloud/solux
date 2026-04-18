import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/mock_data.dart';
import '../../providers/wallet_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/token_icon.dart';
import '../home/widgets/aurora_painter.dart';

class ReceiveScreen extends ConsumerStatefulWidget {
  const ReceiveScreen({super.key});

  @override
  ConsumerState<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ConsumerState<ReceiveScreen> {
  int _selectedToken = 0;

  @override
  Widget build(BuildContext context) {
    final token = mockTokens[_selectedToken];
    final address = ref.watch(addressProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Receive', showBack: true),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.bg, AppColors.bgElevated],
                ),
              ),
            ),
          ),
          const Positioned.fill(child: CustomPaint(painter: BgOrbPainter())),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                children: [
                  // Token selector
                  _GlassCard(
                    child: GestureDetector(
                      onTap: () => setState(
                          () => _selectedToken = (_selectedToken + 1) % mockTokens.length),
                      child: Row(
                        children: [
                          TokenIcon(symbol: token.symbol, color: token.color, size: 36),
                          const SizedBox(width: 10),
                          Text(token.symbol,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.text)),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // QR Code card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.glassPrimary,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.glassBorder, width: 1),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x507C3AED),
                                blurRadius: 32,
                                offset: Offset(0, 12)),
                          ],
                        ),
                        child: Column(
                          children: [
                            // QR
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: QrImageView(
                                data: address,
                                size: 190,
                                backgroundColor: Colors.white,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: Colors.black,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Address
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.glassShimmer,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: AppColors.glassBorder, width: 1),
                              ),
                              child: Text(
                                address,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Copy + Share buttons
                  Row(
                    children: [
                      Expanded(
                        child: _ActionBtn(
                          icon: Icons.copy_rounded,
                          label: 'Copy Address',
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: address));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Address copied!')),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionBtn(
                          icon: Icons.share_rounded,
                          label: 'Share',
                          onTap: () => Share.share('My SRX address: $address'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Warning note
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.accentAmber.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.accentAmber.withValues(alpha: 0.20),
                              width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                color: AppColors.accentAmber.withValues(alpha: 0.8),
                                size: 18),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Only send SRX network tokens to this address.',
                                style: TextStyle(
                                    fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.glassPrimary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: AppColors.gradientPinkViolet,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Color(0x40A855F7), blurRadius: 16, offset: Offset(0, 6)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
