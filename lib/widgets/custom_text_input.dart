import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final Color? backgroundColor;
  final IconData? icon; 
  final String placeholder;
  final double borderRadius;
  final TextEditingController controller;

  const CustomTextInput({
    super.key,
    required this.backgroundColor,
    this.icon,
    required this.placeholder,
    required this.borderRadius,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.grey), // Icône à gauche
            const SizedBox(width: 8.0), // Espacement entre l'icône et l'input
          ],
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: placeholder, // Placeholder text
                border: InputBorder.none, // Pas de bordure visible
              ),
              style: const TextStyle(color: Colors.black), // Couleur du texte
            ),
          ),
        ],
      ),
    );
  }
}
