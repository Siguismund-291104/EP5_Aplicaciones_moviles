import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecordatorioCard extends StatelessWidget {
  final String nombre;
  final String padecimiento;
  final String medicamento;
  final String hora;
  final String foto;
  final bool seleccionado;
  final VoidCallback? onTap;

  const RecordatorioCard({
    super.key,
    required this.nombre,
    required this.padecimiento,
    required this.medicamento,
    required this.hora,
    required this.foto,
    this.seleccionado = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color azul = const Color(0xFF0088FF);
    final Color grisTexto = const Color(0xFF96A7AF);

    ImageProvider getImage() {
      try {
        if (foto.isNotEmpty) {
          if (foto.startsWith('http')) {
            return NetworkImage(foto);
          } else if (File(foto).existsSync()) {
            return FileImage(File(foto));
          } else {
            return AssetImage(foto);
          }
        }
      } catch (_) {}
      return const AssetImage('assets/foto_perfil.jpg');
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(15),
        width: 260,
        decoration: BoxDecoration(
          color: seleccionado ? azul : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Fila superior (foto, nombre, tres puntos)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: getImage(),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombre,
                          style: GoogleFonts.assistant(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: seleccionado ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          padecimiento,
                          style: GoogleFonts.assistant(
                            fontSize: 12,
                            color: seleccionado ? Colors.white70 : grisTexto,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),

            const SizedBox(height: 20),

            // --- Medicamento
            Text(
              medicamento,
              style: GoogleFonts.assistant(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: seleccionado ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 5),

            // --- Hora
            Text(
              hora,
              style: GoogleFonts.assistant(
                fontSize: 12,
                color: seleccionado ? Colors.white70 : grisTexto,
              ),
            ),

            const Spacer(),

            // --- Icono de notificación (abajo a la derecha)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: seleccionado
                      ? Colors.blue[100]
                      : const Color(0xFF96A7AF).withOpacity(0.2),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.notifications_active,
                  color: seleccionado
                      ? Colors.blueAccent
                      : const Color(0xFF14AE5C),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}