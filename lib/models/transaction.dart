import 'package:flutter/material.dart';

enum TxType { receive, send, swap, stake }

class Tx {
  final TxType type;
  final String title;
  final String sub;
  final String amount;
  final String usd;
  final Color color;
  final String date;
  final String time;
  final String status;
  final String fee;
  final String hash;

  const Tx({
    required this.type,
    required this.title,
    required this.sub,
    required this.amount,
    required this.usd,
    required this.color,
    this.date   = '',
    this.time   = '',
    this.status = 'Confirmed',
    this.fee    = '0.001 SRX',
    this.hash   = '',
  });
}
