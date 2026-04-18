import 'package:flutter/material.dart';

class SendIcon extends CustomPainter {
  const SendIcon();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width * 0.2, size.height * 0.2);
    canvas.scale(0.6, 0.6);

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final s = size.width / 24;

    final shaft = Path()
      ..moveTo(3 * s, 12 * s)
      ..lineTo(18 * s, 12 * s);
    canvas.drawPath(shaft, paint);

    final head = Path()
      ..moveTo(13 * s, 7 * s)
      ..lineTo(18 * s, 12 * s)
      ..lineTo(13 * s, 17 * s);
    canvas.drawPath(head, paint);

    final vertPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final vert = Path()
      ..moveTo(21 * s, 5 * s)
      ..lineTo(21 * s, 19 * s);
    canvas.drawPath(vert, vertPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(SendIcon _) => false;
}

class ReceiveIcon extends CustomPainter {
  const ReceiveIcon();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width * 0.2, size.height * 0.2);
    canvas.scale(0.6, 0.6);

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final s = size.width / 24;

    final shaft = Path()
      ..moveTo(12 * s, 20 * s)
      ..lineTo(12 * s, 8 * s);
    canvas.drawPath(shaft, paint);

    final head = Path()
      ..moveTo(8 * s, 16 * s)
      ..lineTo(12 * s, 20 * s)
      ..lineTo(16 * s, 16 * s);
    canvas.drawPath(head, paint);

    final arc = Path()
      ..moveTo(5 * s, 8.5 * s)
      ..arcToPoint(
        Offset(19 * s, 8.5 * s),
        radius: Radius.circular(7 * s),
        largeArc: true,
        clockwise: true,
      );
    canvas.drawPath(arc, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(ReceiveIcon _) => false;
}

class SwapIcon extends CustomPainter {
  const SwapIcon();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width * 0.2, size.height * 0.2);
    canvas.scale(0.6, 0.6);

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final s = size.width / 24;

    final topHead = Path()
      ..moveTo(16 * s, 3 * s)
      ..lineTo(20 * s, 7 * s)
      ..lineTo(16 * s, 11 * s);
    canvas.drawPath(topHead, paint);

    final topShaft = Path()
      ..moveTo(20 * s, 7 * s)
      ..lineTo(8 * s, 7 * s)
      ..arcToPoint(Offset(8 * s, 15 * s), radius: Radius.circular(4 * s), clockwise: false)
      ..lineTo(8.5 * s, 15 * s);
    canvas.drawPath(topShaft, paint);

    final botHead = Path()
      ..moveTo(8 * s, 21 * s)
      ..lineTo(4 * s, 17 * s)
      ..lineTo(8 * s, 13 * s);
    canvas.drawPath(botHead, paint);

    final botShaft = Path()
      ..moveTo(4 * s, 17 * s)
      ..lineTo(16 * s, 17 * s)
      ..arcToPoint(Offset(16 * s, 9 * s), radius: Radius.circular(4 * s), clockwise: false)
      ..lineTo(15.5 * s, 9 * s);
    canvas.drawPath(botShaft, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(SwapIcon _) => false;
}

class StakeIcon extends CustomPainter {
  const StakeIcon();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width * 0.2, size.height * 0.2);
    canvas.scale(0.6, 0.6);

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final s = size.width / 24;

    final linkRight = Path()
      ..moveTo(10 * s, 13 * s)
      ..arcToPoint(
        Offset(17.54 * s, 13.54 * s),
        radius: Radius.circular(5 * s),
        clockwise: false,
      )
      ..relativeLineTo(3 * s, -3 * s)
      ..arcToPoint(
        Offset(13.47 * s, 3.47 * s),
        radius: Radius.circular(5 * s),
        clockwise: false,
      )
      ..relativeLineTo(-1.72 * s, 1.71 * s);
    canvas.drawPath(linkRight, paint);

    final linkLeft = Path()
      ..moveTo(14 * s, 11 * s)
      ..arcToPoint(
        Offset(6.46 * s, 10.46 * s),
        radius: Radius.circular(5 * s),
        clockwise: false,
      )
      ..relativeLineTo(-3 * s, 3 * s)
      ..arcToPoint(
        Offset(13.53 * s, 20.53 * s),
        radius: Radius.circular(5 * s),
        clockwise: false,
      )
      ..relativeLineTo(1.71 * s, -1.71 * s);
    canvas.drawPath(linkLeft, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(StakeIcon _) => false;
}

class BuyIcon extends CustomPainter {
  const BuyIcon();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width * 0.2, size.height * 0.2);
    canvas.scale(0.6, 0.6);

    final s = size.width / 24;

    final fillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2 * s, 5 * s, 20 * s, 14 * s),
      Radius.circular(3 * s),
    );
    canvas.drawRRect(rrect, fillPaint);

    final strokePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(rrect, strokePaint);

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(2 * s, 9 * s), Offset(22 * s, 9 * s), linePaint);
    canvas.drawLine(Offset(6 * s, 13 * s), Offset(10 * s, 13 * s), linePaint);
    canvas.drawLine(Offset(6 * s, 16 * s), Offset(8 * s, 16 * s), linePaint);

    final chipFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final chip = Path()
      ..moveTo(16 * s, 15 * s)
      ..lineTo(17.5 * s, 13.5 * s)
      ..lineTo(19 * s, 15 * s)
      ..lineTo(17.5 * s, 16.5 * s)
      ..close();
    canvas.drawPath(chip, chipFill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(BuyIcon _) => false;
}
