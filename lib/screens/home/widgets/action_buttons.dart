import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_colors.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    const actions = [
      _Action('Send',    Icons.arrow_upward_rounded,   '/send'),
      _Action('Receive', Icons.arrow_downward_rounded, '/receive'),
      _Action('Swap',    Icons.swap_horiz_rounded,     '/swap'),
      _Action('Stake',   Icons.bolt_rounded,           '/stake'),
      _Action('Buy',     Icons.add_rounded,            '/buy'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions.map((a) => _ActionButton(action: a)).toList(),
    );
  }
}

class _Action {
  final String label;
  final IconData icon;
  final String route;
  const _Action(this.label, this.icon, this.route);
}

class _ActionButton extends StatelessWidget {
  final _Action action;
  const _ActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(action.route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x12FFFFFF), width: 1),
            ),
            child: Icon(
              action.icon,
              color: Colors.white.withValues(alpha: 0.75),
              size: 22,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            action.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.50),
            ),
          ),
        ],
      ),
    );
  }
}
