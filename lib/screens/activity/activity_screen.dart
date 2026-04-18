import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/mock_data.dart';
import '../../models/transaction.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  TxType? _filter; // null = All

  List<Tx> get _filtered {
    if (_filter == null) return mockTxsExtended;
    return mockTxsExtended.where((t) => t.type == _filter).toList();
  }

  // Group by date
  Map<String, List<Tx>> get _grouped {
    final map = <String, List<Tx>>{};
    for (final tx in _filtered) {
      (map[tx.date] ??= []).add(tx);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;
    final dateKeys = grouped.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            width: 36, height: 36,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0x0FFFFFFF), width: 1),
            ),
            child: const Icon(Icons.filter_list_rounded,
                color: AppColors.textSecondary, size: 18),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          _FilterTabs(
            current: _filter,
            onChanged: (t) => setState(() => _filter = t),
          ),
          const SizedBox(height: 4),
          // List
          Expanded(
            child: _filtered.isEmpty
                ? _Empty()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
                    itemCount: dateKeys.length,
                    itemBuilder: (ctx, i) {
                      final date = dateKeys[i];
                      final txs  = grouped[date]!;
                      return _DateGroup(date: date, txs: txs);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}

// ─── Filter Tabs ─────────────────────────────────────────────────────────────

class _FilterTabs extends StatelessWidget {
  final TxType? current;
  final ValueChanged<TxType?> onChanged;
  const _FilterTabs({required this.current, required this.onChanged});

  static const _tabs = [
    (label: 'All',     type: null as TxType?),
    (label: 'Send',    type: TxType.send),
    (label: 'Receive', type: TxType.receive),
    (label: 'Swap',    type: TxType.swap),
    (label: 'Stake',   type: TxType.stake),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final tab     = _tabs[i];
          final active  = current == tab.type;
          return GestureDetector(
            onTap: () => onChanged(tab.type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.emerald : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active
                      ? AppColors.emerald
                      : const Color(0x0FFFFFFF),
                  width: 1,
                ),
              ),
              child: Text(
                tab.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Date Group ──────────────────────────────────────────────────────────────

class _DateGroup extends StatelessWidget {
  final String date;
  final List<Tx> txs;
  const _DateGroup({required this.date, required this.txs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(date,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x0FFFFFFF), width: 1),
          ),
          child: Column(
            children: [
              for (int i = 0; i < txs.length; i++) ...[
                _TxRow(tx: txs[i]),
                if (i < txs.length - 1)
                  const Divider(
                    height: 1, thickness: 1,
                    color: Color(0x0AFFFFFF),
                    indent: 16, endIndent: 16,
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Transaction Row ─────────────────────────────────────────────────────────

class _TxRow extends StatelessWidget {
  final Tx tx;
  const _TxRow({required this.tx});

  IconData get _icon {
    switch (tx.type) {
      case TxType.receive: return Icons.arrow_downward_rounded;
      case TxType.send:    return Icons.arrow_upward_rounded;
      case TxType.swap:    return Icons.swap_horiz_rounded;
      case TxType.stake:   return Icons.bolt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: tx.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tx.color.withValues(alpha: 0.20), width: 1),
              ),
              child: Icon(_icon, color: tx.color, size: 18),
            ),
            const SizedBox(width: 12),
            // Left text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(tx.sub,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(tx.time,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textDim,
                    ),
                  ),
                ],
              ),
            ),
            // Right text
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(tx.amount,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: tx.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(tx.usd,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                _StatusBadge(status: tx.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _TxDetailSheet(tx: tx),
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.emeraldDim,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(status,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: AppColors.emerald,
        ),
      ),
    );
  }
}

// ─── Detail Bottom Sheet ──────────────────────────────────────────────────────

class _TxDetailSheet extends StatelessWidget {
  final Tx tx;
  const _TxDetailSheet({required this.tx});

  IconData get _icon {
    switch (tx.type) {
      case TxType.receive: return Icons.arrow_downward_rounded;
      case TxType.send:    return Icons.arrow_upward_rounded;
      case TxType.swap:    return Icons.swap_horiz_rounded;
      case TxType.stake:   return Icons.bolt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Big icon
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: tx.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: tx.color.withValues(alpha: 0.25), width: 1),
            ),
            child: Icon(_icon, color: tx.color, size: 28),
          ),
          const SizedBox(height: 14),
          Text(tx.title,
            style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(tx.amount,
            style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w700, color: tx.color,
            ),
          ),
          const SizedBox(height: 2),
          Text(tx.usd,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          // Details
          _DetailTile(label: 'Date', value: '${tx.date} · ${tx.time}'),
          _DetailTile(label: 'Status',
            value: tx.status,
            valueColor: AppColors.emerald,
          ),
          _DetailTile(label: 'Fee', value: tx.fee),
          // Hash row with copy
          _HashTile(hash: tx.hash),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailTile({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
            )),
        ],
      ),
    );
  }
}

class _HashTile extends StatelessWidget {
  final String hash;
  const _HashTile({required this.hash});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Tx Hash',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Row(
            children: [
              Text(hash,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                )),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: hash));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hash copied'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Icon(Icons.copy_rounded,
                    size: 15, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_rounded, size: 48, color: AppColors.textDim),
          SizedBox(height: 12),
          Text('No transactions', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
