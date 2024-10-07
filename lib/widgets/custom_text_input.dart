import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final Color? backgroundColor;
  final IconData? icon;
  final String placeholder;
  final double borderRadius;
  final TextEditingController controller;
  final List<String> suggestions;

  const CustomTextInput({
    super.key,
    required this.backgroundColor,
    this.icon,
    required this.placeholder,
    required this.borderRadius,
    required this.controller,
    required this.suggestions,
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
              child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            // Filtrer la liste des suggestions en fonction du texte saisi
            return suggestions.where((String suggestion) {
              return suggestion
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          }, onSelected: (String selection) {
            controller.text =
                selection; // Met à jour le champ de texte avec la sélection
          }, fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
            return TextField(
              controller: fieldController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: placeholder,
                border: InputBorder.none, // Pas de bordure visible
              ),
              style: const TextStyle(color: Colors.black), // Couleur du texte
            );
          })),
        ],
      ),
    );
  }
}
