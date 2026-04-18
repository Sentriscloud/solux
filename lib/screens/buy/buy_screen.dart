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

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  String _amount = '';
  int _selectedToken = 0;
  int _selectedPayment = 0;

  final _payments = const [
    _PaymentMethod('Bank Transfer', Icons.account_balance_rounded, 'IDR · 0% fee',   AppColors.accentGreen),
    _PaymentMethod('Kartu Debit',   Icons.credit_card_rounded,     'IDR · 1.5% fee', AppColors.accentBlue),
    _PaymentMethod('P2P',           Icons.people_rounded,          'IDR · Nego',      AppColors.accentPurple),
  ];

  @override
  Widget build(BuildContext context) {
    final token = mockTokens[_selectedToken];

    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Buy', showBack: true),
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
                        // Fiat display
                        Center(
                          child: Column(
                            children: [
                              const Text('IDR', style: AppText.labelUppercase),
                              const SizedBox(height: 4),
                              Text(
                                _amount.isEmpty ? '0' : _amount,
                                style: const TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.text,
                                  letterSpacing: -2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '≈ ${_amount.isEmpty ? '0' : _amount} ${token.symbol}',
                                style: AppText.caption,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Token selector
                        GestureDetector(
                          onTap: () => setState(() =>
                              _selectedToken = (_selectedToken + 1) % mockTokens.length),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.glassPrimary,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: AppColors.glassBorder, width: 1),
                                ),
                                child: Row(
                                  children: [
                                    TokenIcon(
                                        symbol: token.symbol,
                                        color: token.color,
                                        size: 34),
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
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Payment method header
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Payment Method', style: AppText.sectionTitle),
                        ),
                        const SizedBox(height: 12),
                        // Payment methods
                        ..._payments.asMap().entries.map((entry) {
                          final i = entry.key;
                          final p = entry.value;
                          final selected = i == _selectedPayment;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedPayment = i),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? p.color.withValues(alpha: 0.12)
                                          : AppColors.glassPrimary,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: selected
                                            ? p.color.withValues(alpha: 0.4)
                                            : AppColors.glassBorder,
                                        width: selected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 42, height: 42,
                                          decoration: BoxDecoration(
                                            color: p.color.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(p.icon, color: p.color, size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(p.name,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.text)),
                                            Text(p.sub, style: AppText.caption),
                                          ],
                                        ),
                                        const Spacer(),
                                        if (selected)
                                          Container(
                                            width: 22, height: 22,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [p.color, AppColors.accentBlue],
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.check_rounded,
                                                color: Colors.white, size: 14),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        Numpad(onChanged: (v) => setState(() => _amount = v)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: PrimaryButton(
                    label: 'Continue',
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

class _PaymentMethod {
  final String name;
  final IconData icon;
  final String sub;
  final Color color;
  const _PaymentMethod(this.name, this.icon, this.sub, this.color);
}
