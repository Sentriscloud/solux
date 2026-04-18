import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/token_icon.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBody: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          children: [
            _HeroSection(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _StatsRow(),
                  const SizedBox(height: 12),
                  _AssetsSummary(),
                  const SizedBox(height: 12),
                  _QuickActions(),
                  const SizedBox(height: 12),
                  _DangerZone(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, top + 24, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cardGradientStart, AppColors.cardGradientMid],
        ),
        border: Border(
          bottom: BorderSide(color: Color(0x0FFFFFFF), width: 1),
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppColors.emeraldDim,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.emerald, width: 2),
            ),
            child: const Center(
              child: Text('SY',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.emerald,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Name
          const Text("Satya's Wallet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          // Network badge
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.emerald,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Text('SRX Mainnet',
                style: TextStyle(fontSize: 12, color: AppColors.emerald),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Address row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('srx1 •••• •••• k3a7',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: AppColors.textDim,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(const ClipboardData(text: 'srx1q9xf3mkl...k3a7'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Address copied'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Icon(Icons.copy_rounded,
                    size: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showQR(context),
                child: const Icon(Icons.qr_code_rounded,
                    size: 16, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showQR(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('My Address',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: mockAddress,
                version: QrVersions.auto,
                size: 200,
              ),
            ),
            const SizedBox(height: 12),
            const Text('srx1q9xf3mkl...k3a7',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.emerald)),
          ),
        ],
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  static const _stats = [
    (value: '\$1,870', label: 'Balance'),
    (value: '8',       label: 'Total Tx'),
    (value: 'SRX',    label: 'Network'),
    (value: 'Apr 25', label: 'Member'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x0FFFFFFF), width: 1),
      ),
      child: Row(
        children: [
          for (int i = 0; i < _stats.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  Text(_stats[i].value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(_stats[i].label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (i < _stats.length - 1)
              Container(width: 1, height: 32, color: const Color(0x0FFFFFFF)),
          ],
        ],
      ),
    );
  }
}

// ─── Assets Summary ───────────────────────────────────────────────────────────

class _AssetsSummary extends StatelessWidget {
  static const _allocs = [0.67, 0.06, 0.27]; // SRX, SNTX, SRTX

  @override
  Widget build(BuildContext context) {
    final tokens = mockTokens;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x0FFFFFFF), width: 1),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Assets',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text('${tokens.length} tokens',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < tokens.length; i++) ...[
            _AssetRow(token: tokens[i], alloc: _allocs[i]),
            if (i < tokens.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _AssetRow extends StatelessWidget {
  final dynamic token;
  final double alloc;
  const _AssetRow({required this.token, required this.alloc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: token.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TokenIcon(symbol: token.symbol, color: token.color, size: 18),
        ),
        const SizedBox(width: 10),
        // Name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(token.symbol,
                    style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text('${token.balance.toStringAsFixed(0)} ${token.symbol}',
                    style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: alloc,
                  minHeight: 3,
                  backgroundColor: AppColors.glassBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(token.color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  static const _actions = [
    (icon: Icons.edit_rounded,     label: 'Edit Wallet Name',   color: AppColors.emerald, route: ''),
    (icon: Icons.qr_code_rounded,  label: 'Export QR Address',  color: AppColors.accentCyan, route: ''),
    (icon: Icons.security_rounded, label: 'Backup Seed Phrase', color: AppColors.amber,   route: '/settings'),
    (icon: Icons.key_rounded,      label: 'Export Private Key', color: AppColors.violet,  route: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x0FFFFFFF), width: 1),
      ),
      child: Column(
        children: [
          for (int i = 0; i < _actions.length; i++) ...[
            _ActionTile(
              icon: _actions[i].icon,
              label: _actions[i].label,
              color: _actions[i].color,
              onTap: () {
                if (_actions[i].route.isNotEmpty) {
                  context.push(_actions[i].route);
                }
              },
            ),
            if (i < _actions.length - 1)
              const Divider(
                height: 1, thickness: 1,
                color: Color(0x0AFFFFFF),
                indent: 56, endIndent: 16,
              ),
          ],
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({
    required this.icon, required this.label,
    required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: AppColors.textDim),
          ],
        ),
      ),
    );
  }
}

// ─── Danger Zone ─────────────────────────────────────────────────────────────

class _DangerZone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.danger.withValues(alpha: 0.20),
          width: 1,
        ),
      ),
      child: GestureDetector(
        onTap: () => _confirm(context),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.logout_rounded,
                    color: AppColors.danger, size: 18),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text('Disconnect Wallet',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.danger,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: AppColors.danger.withValues(alpha: 0.50)),
            ],
          ),
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Disconnect Wallet',
          style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary,
          ),
        ),
        content: const Text('Coming soon',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.emerald)),
          ),
        ],
      ),
    );
  }
}
