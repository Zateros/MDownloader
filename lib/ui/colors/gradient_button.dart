import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.onPressed,
      required this.colors,
      required this.child,
      this.borderRadius = 18})
      : super(key: key);

  final double width;
  final double height;
  final void Function() onPressed;
  final List<Color> colors;
  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          padding: const EdgeInsets.all(3),
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius))),
      onPressed: onPressed,
      child: SizedBox(
        width: width,
        height: height,
        child: Ink(
          width: 500,
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
