import 'package:flutter/material.dart';

class TokenIcon extends StatelessWidget {
  final String symbol;
  final Color color;
  final double size;

  const TokenIcon({
    super.key,
    required this.symbol,
    required this.color,
    this.size = 42,
  });

  IconData _icon() {
    switch (symbol) {
      case 'SRX':  return Icons.star_rounded;
      case 'SNTX': return Icons.circle_outlined;
      case 'SRTX': return Icons.lock_rounded;
      default:     return Icons.token_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(_icon(), color: color, size: size * 0.48),
    );
  }
}
