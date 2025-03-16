import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const CustomBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 12),
        ),
      ),
    );
  }
}
