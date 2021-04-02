import "package:flutter/material.dart";

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final Color primary;
  final VoidCallback onPressed;
  final double borderRadius;
  final double height;

  CustomElevatedButton({@required this.child, this.primary, this.onPressed, this.borderRadius=10.0, this.height=50.0}):
  assert(borderRadius!=null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: primary,
          onSurface: primary,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              style: BorderStyle.solid,
              width: 0.5,
            ),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
        ),
        child: child,
      ),
    );
  }
}
