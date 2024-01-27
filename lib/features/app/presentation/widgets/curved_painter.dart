import 'package:connecthub/constants/constants.dart';
import 'package:flutter/material.dart';

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = MyColors.buttonColor1
      ..strokeWidth = 15;

    var path = Path();

    path.moveTo(0, size.height * 0.5); // Adjusted to 50% of screen height
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.5,
        size.width * 0.5, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.7,
        size.width * 1.0, size.height * 0.6);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
