  import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DuracionCard extends StatelessWidget {
  final String fechaInicio;
  final String fechaFin;

  const DuracionCard({
    super.key,
    required this.fechaInicio,
    required this.fechaFin,
  });

  @override
  Widget build(BuildContext context) {
    const Color azul = Color(0xFF0088FF);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: azul.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildOvalo(fechaInicio),
          const SizedBox(width: 10),
          Text(
            "-",
            style: GoogleFonts.assistant(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: azul,
            ),
          ),
          const SizedBox(width: 10),
          _buildOvalo(fechaFin),
        ],
      ),
    );
  }

  Widget _buildOvalo(String texto) {
    const Color azul = Color(0xFF0088FF);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: azul,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        texto,
        style: GoogleFonts.assistant(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}