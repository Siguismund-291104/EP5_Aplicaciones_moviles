import 'package:flutter/material.dart';

class AlertaCampos {
  static void mostrar(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Atención',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0088FF), // Azul principal
              fontFamily: 'Assistant',
            ),
          ),
          content: Text(
            mensaje,
            style: const TextStyle(
              fontFamily: 'Assistant',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Aceptar',
                style: TextStyle(
                  fontFamily: 'Assistant',
                  color: Color(0xFF14AE5C), // Verde principal
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}