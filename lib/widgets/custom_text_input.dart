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
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 8.0),
          ],
          Expanded(
              child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return suggestions.where((String suggestion) {
              return suggestion
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          }, onSelected: (String selection) {
            controller.text =
                selection;
          }, fieldViewBuilder: (BuildContext context,
                      TextEditingController fieldController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: placeholder,
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.black),
            );
          })),
        ],
      ),
    );
  }
}
