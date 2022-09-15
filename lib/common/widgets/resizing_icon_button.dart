import 'package:flutter/material.dart';

class GlowingIconButton extends StatefulWidget {
  final void Function() onPressed;
  final double width;
  final double height;
  final String assetPath;

  const GlowingIconButton({
    Key? key,
    required this.onPressed,
    required this.assetPath,
    this.width = 160,
    this.height = 40,
  }) : super(key: key);

  @override
  State<GlowingIconButton> createState() => _GlowingIconButtonState();
}

class _GlowingIconButtonState extends State<GlowingIconButton> {
  bool glowing = false;
  double scale = 1.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (detais) {
        widget.onPressed.call();
      },
      child: MouseRegion(
        onExit: (val) {
          setState(() {
            glowing = false;
            scale = 1.0;
          });
        },
        onEnter: (val) {
          setState(() {
            glowing = true;
            scale = 1.1;
          });
        },
        child: AnimatedContainer(
          transform: Matrix4.identity()..scale(scale),
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          width: widget.width,
          child: Center(
            child: Image(
                image: AssetImage(widget.assetPath),
                width: widget.width,
                height: widget.height,
                fit: BoxFit.scaleDown,
                alignment: FractionalOffset.center),
          ),
        ),
      ),
    );
  }
}
