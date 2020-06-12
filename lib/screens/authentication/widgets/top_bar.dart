import 'package:CineMe/constant.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 200,
      ),
      // should assigned with an object extending CustomPainter
      painter: CurvePainter(),
    );
  }
}

// painting will be in this class
class CurvePainter extends CustomPainter {
  /* paint three line above each other each in diffrent path and in diffrent color
  canvas is just like a paper to paint on. size is the size of the canvas and painting should be within size bounds*/
  @override
  void paint(Canvas canvas, Size size) {
    // determine the path that each line should take
    Path path = Path();
    // control the painting on the canvas
    Paint paint = Paint();

    // .lineTo : add straight line from the starting point to anthor (x,y)point
    // the starting point is the top left corner of the canvas
    path.lineTo(0, size.height * 0.75);
    // quadratic bezier- X^2 function shape*like have a circle* - adds curve from the current point to the given(x2,y2) point
    // x1,y1 is the control point which is like a static point for the top of the have circle shape
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.70,
        size.width * 0.17, size.height * 0.90);
    path.quadraticBezierTo(
        size.width * 0.20, size.height, size.width * 0.25, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.40, size.height * 0.40,
        size.width * 0.50, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.60, size.height * 0.85,
        size.width * 0.65, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.70, size.height * 0.90, size.width, 0);
    path.close();
    path.close();
    paint.color = kDeepPurple;
    // draw with the coordinates we have set
    canvas.drawPath(path, paint);

// Layer 2
    path = Path();
    path.lineTo(0, size.height * 0.80);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.80,
        size.width * 0.15, size.height * 0.60);
    path.quadraticBezierTo(size.width * 0.20, size.height * 0.45,
        size.width * 0.27, size.height * 0.60);
    path.quadraticBezierTo(
        size.width * 0.45, size.height, size.width * 0.50, size.height * 0.80);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.45,
        size.width * 0.75, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.93, size.width, size.height * 0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = kDeepPurple.withOpacity(0.7);
    canvas.drawPath(path, paint);

// layer 3
    path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.55,
        size.width * 0.22, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.30, size.height * 0.90,
        size.width * 0.40, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.52, size.height * 0.50,
        size.width * 0.65, size.height * 0.70);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.85, size.width, size.height * 0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = kDeepPurple.withOpacity(0.3);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
