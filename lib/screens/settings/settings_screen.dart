import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/custom_app_bar.dart';
import '../home/widgets/aurora_painter.dart';
import 'widgets/skin_selector.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometric = false;
  bool _testnet = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(title: 'Settings', showBack: true),
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                // APPEARANCE
                _GlassSection(
                  title: 'APPEARANCE',
                  icon: Icons.palette_outlined,
                  iconColor: AppColors.pink,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.pink.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.style_outlined,
                                    color: AppColors.pink, size: 18),
                              ),
                              const SizedBox(width: 12),
                              const Text('Card Skin', style: AppText.body),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const SkinSelector(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // NETWORK
                _GlassSection(
                  title: 'NETWORK',
                  icon: Icons.language_outlined,
                  iconColor: AppColors.accentBlue,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.cell_tower_rounded,
                                color: AppColors.accentBlue, size: 18),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                              child: Text('Network', style: AppText.body)),
                          _GlassToggle(
                            options: const ['Mainnet', 'Testnet'],
                            selectedIndex: _testnet ? 1 : 0,
                            onChanged: (i) => setState(() => _testnet = i == 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // NOTIFICATIONS
                _GlassSection(
                  title: 'NOTIFICATIONS',
                  icon: Icons.notifications_outlined,
                  iconColor: AppColors.accentCyan,
                  children: [
                    _SwitchRow(
                      icon: Icons.notifications_active_outlined,
                      iconColor: AppColors.accentCyan,
                      title: 'Push Notifications',
                      subtitle: 'Transaction alerts',
                      value: _notifications,
                      onChanged: (v) => setState(() => _notifications = v),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // SECURITY
                _GlassSection(
                  title: 'SECURITY',
                  icon: Icons.security_outlined,
                  iconColor: AppColors.violet,
                  children: [
                    _SwitchRow(
                      icon: Icons.fingerprint_rounded,
                      iconColor: AppColors.violet,
                      title: 'Biometric',
                      subtitle: 'Face ID / Fingerprint',
                      value: _biometric,
                      onChanged: (v) => setState(() => _biometric = v),
                    ),
                    _ArrowRow(
                      icon: Icons.lock_reset_rounded,
                      iconColor: AppColors.accentPurple,
                      title: 'Change PIN',
                      onTap: () => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Coming soon'))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // BACKUP
                _GlassSection(
                  title: 'BACKUP',
                  icon: Icons.backup_outlined,
                  iconColor: AppColors.accentAmber,
                  children: [
                    _ArrowRow(
                      icon: Icons.key_rounded,
                      iconColor: AppColors.accentAmber,
                      title: 'View Seed Phrase',
                      onTap: () => _showWarningDialog(context, 'Seed Phrase'),
                    ),
                    _ArrowRow(
                      icon: Icons.vpn_key_rounded,
                      iconColor: AppColors.accentRose,
                      title: 'Export Private Key',
                      onTap: () => _showWarningDialog(context, 'Private Key'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ABOUT
                _GlassSection(
                  title: 'ABOUT',
                  icon: Icons.info_outline_rounded,
                  iconColor: AppColors.textSecondary,
                  children: [
                    const _InfoRow(title: 'Version', value: '1.0.0'),
                    _ArrowRow(
                      icon: Icons.language_rounded,
                      iconColor: AppColors.accentBlue,
                      title: 'Website',
                      onTap: () {},
                    ),
                    _ArrowRow(
                      icon: Icons.alternate_email_rounded,
                      iconColor: AppColors.indigo,
                      title: 'Twitter',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showWarningDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.accentAmber, size: 22),
            const SizedBox(width: 8),
            Text('View $type',
                style: const TextStyle(
                    color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Text(
          'Never share your $type with anyone. Anyone with access can steal your assets.',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Coming soon')));
            },
            child: const Text('Proceed',
                style: TextStyle(color: AppColors.accentAmber)),
          ),
        ],
      ),
    );
  }
}

class _GlassSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;
  const _GlassSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.glassPrimary,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.glassBorder, width: 1),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < children.length; i++) ...[
                    children[i],
                    if (i < children.length - 1)
                      const Divider(
                        color: Color(0x1AFFFFFF),
                        height: 1,
                        indent: 48,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.body),
                Text(subtitle, style: AppText.caption),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            // activeThumbColor / inactiveThumbColor / activeTrackColor /
            // inactiveTrackColor were renamed in Flutter 3.32+. Build host
            // is on 3.29.2 — use the legacy `activeColor` + thumb/track
            // overrides via WidgetStateProperty until the toolchain bumps.
            activeColor: Colors.white,
            activeTrackColor: AppColors.violet,
            inactiveThumbColor: AppColors.textMuted,
            inactiveTrackColor: AppColors.glassBorder,
          ),
        ],
      ),
    );
  }
}

class _ArrowRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  const _ArrowRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: AppText.body)),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppText.body)),
          Text(value, style: AppText.caption),
        ],
      ),
    );
  }
}

class _GlassToggle extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  const _GlassToggle({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.glassShimmer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.asMap().entries.map((entry) {
          final i = entry.key;
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: selected ? AppColors.gradientPinkViolet : null,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
