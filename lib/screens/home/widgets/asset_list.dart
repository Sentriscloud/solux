import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/token.dart';
import '../../../providers/wallet_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/token_icon.dart';

class AssetList extends ConsumerWidget {
  const AssetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(tokensProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'MY ASSETS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: AppColors.textMuted,
              ),
            ),
            Row(
              children: [
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.40),
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 10, color: Colors.white.withValues(alpha: 0.30)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Rows with dividers
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x12FFFFFF), width: 1),
          ),
          child: Column(
            children: [
              for (int i = 0; i < tokens.length; i++) ...[
                _AssetRow(token: tokens[i]),
                if (i < tokens.length - 1)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0x0AFFFFFF),
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AssetRow extends StatelessWidget {
  final Token token;
  const _AssetRow({required this.token});

  @override
  Widget build(BuildContext context) {
    final isPositive = token.change >= 0;
    final changeColor = isPositive ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Token icon
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: token.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: token.color.withValues(alpha: 0.20),
                width: 1,
              ),
            ),
            child: TokenIcon(symbol: token.symbol, color: token.color, size: 20),
          ),
          const SizedBox(width: 12),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token.symbol,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  token.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
          ),
          // Value + change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${token.usd.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${isPositive ? '+' : ''}${token.change}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: changeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
