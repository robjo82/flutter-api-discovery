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
            WidgetStateProperty.all(Colors.white), // Couleur de fond
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Bords arrondis
          ),
        ),
        shadowColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.5)),
        elevation: WidgetStateProperty.all(4), // Ombre
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max, // Ajuste la taille du bouton au contenu
        children: [
          Icon(
            icon,
            color: Colors.grey, // Couleur de l'icône
          ),
          const SizedBox(width: 8.0), // Espace entre l'icône et le texte
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[500], // Couleur du texte
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
