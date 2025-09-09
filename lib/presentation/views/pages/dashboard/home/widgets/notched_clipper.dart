import 'package:flutter/material.dart';

class NotchedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const notchRadius = 22.0; // hẹp hơn một chút
    const cornerRadius = 16.0; // bo góc ngoài
    const notchCorner = 6.0; // nông hơn (ăn xuống ít hơn)

    final centerX = size.width / 2;

    final path = Path()
      ..moveTo(cornerRadius, 0)
      // Trước notch
      ..lineTo(centerX - notchRadius - notchCorner, 0)
      // Mép trái notch
      ..arcToPoint(
        Offset(centerX - notchRadius, notchCorner),
        radius: const Radius.circular(notchCorner),
        clockwise: true,
      )
      // Đường lõm chính
      ..arcToPoint(
        Offset(centerX + notchRadius, notchCorner),
        radius: const Radius.circular(notchRadius),
        clockwise: false,
      )
      // Mép phải notch
      ..arcToPoint(
        Offset(centerX + notchRadius + notchCorner, 0),
        radius: const Radius.circular(notchCorner),
        clockwise: true,
      )
      // Góc trên phải
      ..lineTo(size.width - cornerRadius, 0)
      ..arcToPoint(Offset(size.width, cornerRadius), radius: const Radius.circular(cornerRadius))
      // Góc dưới phải
      ..lineTo(size.width, size.height - cornerRadius)
      ..arcToPoint(Offset(size.width - cornerRadius, size.height), radius: const Radius.circular(cornerRadius))
      // Góc dưới trái
      ..lineTo(cornerRadius, size.height)
      ..arcToPoint(Offset(0, size.height - cornerRadius), radius: const Radius.circular(cornerRadius))
      // Góc trên trái
      ..lineTo(0, cornerRadius)
      ..arcToPoint(Offset(cornerRadius, 0), radius: const Radius.circular(cornerRadius))
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
