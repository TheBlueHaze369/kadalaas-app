import 'dart:math' as math;

import 'package:flutter/material.dart';

class SittingPersonIcon extends StatelessWidget {
  const SittingPersonIcon({super.key, this.size = 28, this.color = Colors.black});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _SittingPersonPainter(color),
    );
  }
}

class ChecklistIcon extends StatelessWidget {
  const ChecklistIcon({super.key, this.size = 28, this.color = Colors.black});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _ChecklistPainter(color),
    );
  }
}

class IdeaHeadIcon extends StatelessWidget {
  const IdeaHeadIcon({super.key, this.size = 28, this.color = Colors.black});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _IdeaHeadPainter(color),
    );
  }
}

class _SittingPersonPainter extends CustomPainter {
  _SittingPersonPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.085
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    canvas.drawCircle(Offset(w * 0.42, h * 0.18), w * 0.11, paint);

    final body = Path()
      ..moveTo(w * 0.42, h * 0.30)
      ..quadraticBezierTo(w * 0.40, h * 0.48, w * 0.52, h * 0.55)
      ..quadraticBezierTo(w * 0.68, h * 0.58, w * 0.74, h * 0.50);
    canvas.drawPath(body, paint);

    canvas.drawLine(Offset(w * 0.48, h * 0.40), Offset(w * 0.62, h * 0.48), paint);

    canvas.drawLine(Offset(w * 0.50, h * 0.55), Offset(w * 0.38, h * 0.78), paint);
    canvas.drawLine(Offset(w * 0.52, h * 0.56), Offset(w * 0.62, h * 0.78), paint);

    canvas.drawLine(Offset(w * 0.22, h * 0.78), Offset(w * 0.78, h * 0.78), paint);
    canvas.drawLine(Offset(w * 0.26, h * 0.55), Offset(w * 0.26, h * 0.78), paint);
  }

  @override
  bool shouldRepaint(covariant _SittingPersonPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ChecklistPainter extends CustomPainter {
  _ChecklistPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    void row(double y) {
      canvas.drawLine(Offset(w * 0.12, y), Offset(w * 0.52, y), paint);
      final check = Path()
        ..moveTo(w * 0.62, y)
        ..lineTo(w * 0.72, y + h * 0.08)
        ..lineTo(w * 0.90, y - h * 0.10);
      canvas.drawPath(check, paint);
    }

    row(h * 0.34);
    row(h * 0.66);
  }

  @override
  bool shouldRepaint(covariant _ChecklistPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _IdeaHeadPainter extends CustomPainter {
  _IdeaHeadPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.42),
        width: w * 0.62,
        height: h * 0.68,
      ),
      math.pi * 0.15,
      math.pi * 1.70,
      false,
      paint,
    );

    canvas.drawLine(Offset(w * 0.38, h * 0.78), Offset(w * 0.62, h * 0.78), paint);

    final cx = w * 0.50;
    final cy = h * 0.42;
    final r = w * 0.13;
    canvas.drawCircle(Offset(cx, cy), r, paint);

    for (var i = 0; i < 6; i++) {
      final a = i * math.pi / 3;
      final inner = Offset(cx + math.cos(a) * r, cy + math.sin(a) * r);
      final outer = Offset(
        cx + math.cos(a) * r * 1.45,
        cy + math.sin(a) * r * 1.45,
      );
      canvas.drawLine(inner, outer, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _IdeaHeadPainter oldDelegate) =>
      oldDelegate.color != color;
}
