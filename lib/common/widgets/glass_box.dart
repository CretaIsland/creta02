import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final Widget child;
  const GlassBox({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
    this.radius = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
          width: width,
          height: height,
          //color: Colors.white.withOpacity(0.2),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(radius),
              gradient:
                  LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                Colors.white.withOpacity(0.4),
                Colors.white.withOpacity(0.1),
              ])),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: child,
          )),
    );
  }
}
