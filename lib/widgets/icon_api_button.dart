import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconApiButton extends StatelessWidget {
  IconApiButton({
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
  });
  final Color backgroundColor;
  final FaIcon icon;
  final Color foregroundColor;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: backgroundColor,
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 3.0),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => onPressed(),
        icon: icon,
        color: foregroundColor,
      ),
    );
  }
}
