import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const IconTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        shadowColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.5)),
        elevation: WidgetStateProperty.all(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          const SizedBox(width: 8.0),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
