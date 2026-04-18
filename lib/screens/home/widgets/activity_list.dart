import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/transaction.dart';
import '../../../providers/wallet_provider.dart';
import '../../../theme/app_colors.dart';

class ActivityList extends ConsumerWidget {
  const ActivityList({super.key});

  IconData _icon(TxType type) {
    switch (type) {
      case TxType.receive: return Icons.arrow_downward_rounded;
      case TxType.send:    return Icons.arrow_upward_rounded;
      case TxType.swap:    return Icons.swap_horiz_rounded;
      case TxType.stake:   return Icons.bolt_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(txsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECENT ACTIVITY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: AppColors.textMuted,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.indigoLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: txs.map((tx) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.glassPrimary,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.glassBorder, width: 1),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        color: tx.color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: tx.color.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(_icon(tx.type), color: tx.color, size: 17),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tx.title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            tx.sub,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          tx.amount,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: tx.color,
                          ),
                        ),
                        Text(
                          tx.usd,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
