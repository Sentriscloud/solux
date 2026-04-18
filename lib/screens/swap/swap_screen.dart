import 'dart:ui';
import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/numpad.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/token_icon.dart';
import '../home/widgets/aurora_painter.dart';

class SwapScreen extends StatefulWidget {
  const SwapScreen({super.key});

  @override
  State<SwapScreen> createState() => _SwapScreenState();
}

class _SwapScreenState extends State<SwapScreen> {
  int _fromIdx = 0;
  int _toIdx = 1;
  String _amount = '';
  bool _rotating = false;

  void _swapTokens() async {
    setState(() => _rotating = true);
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      final tmp = _fromIdx;
      _fromIdx = _toIdx;
      _toIdx = tmp;
      _rotating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final from = mockTokens[_fromIdx];
    final to = mockTokens[_toIdx];

    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Swap', showBack: true),
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      children: [
                        // From card
                        _TokenCard(label: 'From', token: from),
                        const SizedBox(height: 10),
                        // Swap button
                        Center(
                          child: GestureDetector(
                            onTap: _swapTokens,
                            child: AnimatedRotation(
                              turns: _rotating ? 0.5 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                width: 48, height: 48,
                                decoration: const BoxDecoration(
                                  gradient: AppColors.gradientPinkViolet,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x50A855F7),
                                      blurRadius: 20,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.swap_vert_rounded,
                                    color: Colors.white, size: 22),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // To card
                        _TokenCard(label: 'To', token: to),
                        const SizedBox(height: 24),
                        // Amount display
                        Center(
                          child: Text(
                            _amount.isEmpty ? '0' : _amount,
                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                              letterSpacing: -2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Numpad(onChanged: (v) => setState(() => _amount = v)),
                        const SizedBox(height: 16),
                        // Rate row
                        _InfoPill(
                          label: 'Rate',
                          value: '1 ${from.symbol} = 48 ${to.symbol}',
                        ),
                        const SizedBox(height: 8),
                        const _InfoPill(
                          label: 'Slippage',
                          value: '0.5%',
                          trailing: Icon(Icons.edit_rounded,
                              size: 14, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: PrimaryButton(
                    label: 'Preview Swap',
                    onTap: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Coming soon'))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenCard extends StatelessWidget {
  final String label;
  final dynamic token;
  const _TokenCard({required this.label, required this.token});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.glassPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: Row(
            children: [
              Text(label, style: AppText.caption),
              const Spacer(),
              TokenIcon(symbol: token.symbol, color: token.color, size: 32),
              const SizedBox(width: 8),
              Text(
                token.symbol,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.text),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;
  const _InfoPill({required this.label, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.glassPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: Row(
            children: [
              Text(label, style: AppText.caption),
              const Spacer(),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text)),
              if (trailing != null) ...[const SizedBox(width: 6), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
