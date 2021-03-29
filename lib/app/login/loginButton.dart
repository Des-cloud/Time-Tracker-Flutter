import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/customElevatedButton.dart';

class LoginButton extends CustomElevatedButton{
  LoginButton({
    @required String text, Color color, Color textColor, VoidCallback onPressed, double borderRadius,
    double height
}) : assert(text!=null),super(
    child: Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 15.0,
      ),
    ),
    onPressed: onPressed,
    primary: color,
    borderRadius: borderRadius,
    height: height,
  );

}