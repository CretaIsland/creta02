import 'package:flutter/material.dart';

class GlowingButton extends StatefulWidget {
  final Color color1;
  final Color color2;
  final String text;
  final IconData icon1;
  final IconData icon2;
  final void Function() onPressed;

  const GlowingButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon1 = Icons.lightbulb,
    this.icon2 = Icons.lightbulb_outline,
    this.color1 = Colors.cyan,
    this.color2 = Colors.greenAccent,
  }) : super(key: key);

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton> {
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
          height: 40,
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(
              colors: [widget.color1, widget.color2],
            ),
            boxShadow: glowing
                ? [
                    BoxShadow(
                      color: widget.color1.withOpacity(0.6),
                      spreadRadius: 3,
                      blurRadius: 16,
                      offset: const Offset(-8, 0),
                    ),
                    BoxShadow(
                      color: widget.color2.withOpacity(0.6),
                      spreadRadius: 3,
                      blurRadius: 16,
                      offset: const Offset(8, 0),
                    ),
                    BoxShadow(
                      color: widget.color1.withOpacity(0.2),
                      spreadRadius: 16,
                      blurRadius: 32,
                      offset: const Offset(-8, 0),
                    ),
                    BoxShadow(
                      color: widget.color2.withOpacity(0.2),
                      spreadRadius: 16,
                      blurRadius: 32,
                      offset: const Offset(8, 0),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(glowing ? widget.icon2 : widget.icon2, color: Colors.white),
              Text(
                widget.text,
                style:
                    const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
