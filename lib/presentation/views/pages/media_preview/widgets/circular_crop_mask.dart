import 'package:flutter/material.dart';

class CircularCropMask extends StatelessWidget {
  final double radius;

  const CircularCropMask({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: CircularCropMaskPainter(radius: radius));
  }
}

class CircularCropMaskPainter extends CustomPainter {
  final double radius;

  CircularCropMaskPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    final overlayPath = Path.combine(
      PathOperation.difference,
      fullPath,
      circlePath,
    );

    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.37)
      ..style = PaintingStyle.fill;
    canvas.drawPath(overlayPath, overlayPaint);

    final gridPaint = Paint()
      ..color = const Color(0xFF99A1AF)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    canvas.save();
    canvas.clipPath(circlePath);

    final dx = radius / 3;
    final dy = radius / 3;

    canvas.drawLine(
      Offset(center.dx - dx, center.dy - radius),
      Offset(center.dx - dx, center.dy + radius),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx + dx, center.dy - radius),
      Offset(center.dx + dx, center.dy + radius),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius, center.dy - dy),
      Offset(center.dx + radius, center.dy - dy),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius, center.dy + dy),
      Offset(center.dx + radius, center.dy + dy),
      gridPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CircularCropMaskPainter oldDelegate) =>
      oldDelegate.radius != radius;
}
