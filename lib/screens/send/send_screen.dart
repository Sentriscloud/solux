import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/numpad.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/token_icon.dart';
import '../home/widgets/aurora_painter.dart';

class SendScreen extends ConsumerStatefulWidget {
  const SendScreen({super.key});

  @override
  ConsumerState<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends ConsumerState<SendScreen> {
  String _toAddress = '';
  String _amount = '';
  int _selectedToken = 0;

  double get _usdValue {
    final amt = double.tryParse(_amount) ?? 0;
    const prices = [0.10, 0.0024, 1.00];
    return amt * prices[_selectedToken];
  }

  @override
  Widget build(BuildContext context) {
    final token = mockTokens[_selectedToken];

    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Send',
        showBack: true,
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('QR scan coming soon'))),
            icon: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.glassPrimary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glassBorder, width: 1),
              ),
              child: const Icon(Icons.qr_code_scanner_rounded,
                  size: 18, color: AppColors.text),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Token selector
                        _GlassSelector(
                          child: Row(
                            children: [
                              TokenIcon(symbol: token.symbol, color: token.color, size: 36),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(token.symbol,
                                      style: const TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.text)),
                                  Text('Balance: ${token.balance.toStringAsFixed(0)} ${token.symbol}',
                                      style: AppText.caption),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textSecondary),
                            ],
                          ),
                          onTap: () => setState(
                              () => _selectedToken = (_selectedToken + 1) % mockTokens.length),
                        ),
                        const SizedBox(height: 12),
                        // To field
                        _ToField(
                          value: _toAddress,
                          onChanged: (v) => setState(() => _toAddress = v),
                        ),
                        const SizedBox(height: 12),
                        // Recent contacts
                        _RecentContacts(),
                        const SizedBox(height: 24),
                        // Amount display
                        Center(
                          child: Column(
                            children: [
                              Text(
                                _amount.isEmpty ? '0' : _amount,
                                style: const TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.text,
                                  letterSpacing: -2,
                                ),
                              ),
                              Text(
                                '≈ \$${_usdValue.toStringAsFixed(2)}',
                                style: AppText.caption,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Max / Half buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _QuickBtn('Max', () => setState(
                                () => _amount = token.balance.toStringAsFixed(0))),
                            const SizedBox(width: 12),
                            _QuickBtn('Half', () => setState(
                                () => _amount = (token.balance / 2).toStringAsFixed(0))),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Numpad(onChanged: (v) => setState(() => _amount = v)),
                        const SizedBox(height: 12),
                        // Network fee
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.glassPrimary,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.glassBorder, width: 1),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.local_gas_station_rounded,
                                      size: 16, color: AppColors.textSecondary),
                                  SizedBox(width: 8),
                                  Text('Network fee', style: AppText.caption),
                                  Spacer(),
                                  Text(
                                    '5 SRX ≈ \$0.50',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.text),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: PrimaryButton(
                    label: 'Review Transaction',
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

class _GlassSelector extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _GlassSelector({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
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
      ),
    );
  }
}

class _ToField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _ToField({required this.value, required this.onChanged});

  @override
  State<_ToField> createState() => _ToFieldState();
}

class _ToFieldState extends State<_ToField> {
  late final TextEditingController _ctrl;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _focused
              ? AppColors.violet.withValues(alpha: 0.05)
              : AppColors.glass,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _focused
                ? AppColors.violet.withValues(alpha: 0.5)
                : AppColors.glassBorder,
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _ctrl,
          onChanged: widget.onChanged,
          style: const TextStyle(fontSize: 13, color: AppColors.text),
          decoration: InputDecoration(
            hintText: 'To address (srx1...)',
            hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            prefixIcon: const Icon(Icons.send_rounded,
                color: AppColors.textSecondary, size: 18),
            suffixIcon: _ctrl.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _ctrl.clear();
                      widget.onChanged('');
                    },
                    icon: const Icon(Icons.clear_rounded,
                        size: 18, color: AppColors.textSecondary),
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true,
          ),
        ),
      ),
    );
  }
}

class _RecentContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent', style: AppText.caption),
        const SizedBox(height: 10),
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: mockContacts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final c = mockContacts[i];
              return Column(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: c.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: c.color.withValues(alpha: 0.25), width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      c.initials,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: c.color),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(c.name,
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.textSecondary)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuickBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickBtn(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          gradient: AppColors.gradientPinkViolet,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40A855F7),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
