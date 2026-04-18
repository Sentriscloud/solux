import 'package:flutter/material.dart';

class TintedBadge extends StatelessWidget {
  final Color color;
  final Widget child;

  const TintedBadge({super.key, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: child,
    );
  }
}
