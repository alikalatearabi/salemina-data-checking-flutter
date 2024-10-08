import 'package:flutter/material.dart';

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 50);

    path.quadraticBezierTo(size.width / 2, 0, 0, 50);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
