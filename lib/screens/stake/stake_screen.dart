import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/wallet_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/numpad.dart';
import '../../widgets/primary_button.dart';
import '../home/widgets/aurora_painter.dart';

class StakeScreen extends ConsumerStatefulWidget {
  const StakeScreen({super.key});

  @override
  ConsumerState<StakeScreen> createState() => _StakeScreenState();
}

class _StakeScreenState extends ConsumerState<StakeScreen> {
  String _amount = '';
  int _selectedValidator = 0;
  int _selectedDuration = 1; // 0=30d, 1=90d, 2=180d

  final _durations = ['30 Days', '90 Days', '180 Days'];
  final _apys = ['8%', '12%', '18%'];

  @override
  Widget build(BuildContext context) {
    final validators = ref.watch(validatorsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Stake', showBack: true),
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
                        // APY display
                        Center(
                          child: Column(
                            children: [
                              const Text('Est. APY', style: AppText.caption),
                              const SizedBox(height: 4),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    AppColors.gradientCandy.createShader(bounds),
                                child: Text(
                                  _apys[_selectedDuration],
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Duration selector
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.glassPrimary,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.glassBorder, width: 1),
                              ),
                              child: Row(
                                children: _durations.asMap().entries.map((entry) {
                                  final i = entry.key;
                                  final selected = i == _selectedDuration;
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedDuration = i),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          gradient: selected
                                              ? AppColors.gradientVioletBlue
                                              : null,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          entry.value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: selected
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Stats grid
                        Row(
                          children: [
                            const Expanded(child: _StatCard(label: 'Available', value: '12,500 SRX', color: AppColors.accentGreen)),
                            const SizedBox(width: 10),
                            Expanded(child: _StatCard(label: 'Lock Period', value: _durations[_selectedDuration], color: AppColors.accentPurple)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Amount display
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => setState(() => _amount = '12500'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.gradientPinkViolet,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Max',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Center(
                          child: Text('SRX', style: AppText.caption),
                        ),
                        const SizedBox(height: 16),
                        Numpad(onChanged: (v) => setState(() => _amount = v)),
                        const SizedBox(height: 20),
                        // Validator list
                        const Text('Select Validator', style: AppText.sectionTitle),
                        const SizedBox(height: 12),
                        ...validators.asMap().entries.map((entry) {
                          final i = entry.key;
                          final v = entry.value;
                          final selected = i == _selectedValidator;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedValidator = i),
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
                                          ? AppColors.violet.withValues(alpha: 0.15)
                                          : AppColors.glass,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: selected
                                            ? AppColors.violet.withValues(alpha: 0.5)
                                            : AppColors.glassBorder,
                                        width: selected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 38, height: 38,
                                          decoration: BoxDecoration(
                                            gradient: selected
                                                ? AppColors.gradientPinkViolet
                                                : null,
                                            color: selected
                                                ? null
                                                : AppColors.glassShimmer,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.dns_rounded,
                                              color: selected
                                                  ? Colors.white
                                                  : AppColors.textSecondary,
                                              size: 18),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(v.name,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppColors.text)),
                                              Row(
                                                children: [
                                                  Text('Commission: ${v.commission}',
                                                      style: AppText.caption),
                                                  const SizedBox(width: 8),
                                                  Text('Uptime: ${v.uptime}',
                                                      style: AppText.caption),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (selected)
                                          const Icon(Icons.check_circle_rounded,
                                              color: AppColors.violet, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: PrimaryButton(
                    label: 'Stake Now',
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.glassPrimary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppText.caption),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
