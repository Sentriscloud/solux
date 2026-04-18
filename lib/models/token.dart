import 'package:flutter/material.dart';

class Token {
  final String symbol;
  final String name;
  final double balance;
  final double usd;
  final double change;
  final Color color;

  const Token({
    required this.symbol,
    required this.name,
    required this.balance,
    required this.usd,
    required this.change,
    required this.color,
  });
}
