import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FamiliarCard extends StatelessWidget {
  final String nombre;
  final String padecimiento;
  final String foto; // Si viene vacío "", mostramos el icono verde
  final bool seleccionado;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const FamiliarCard({
    super.key,
    required this.nombre,
    required this.padecimiento,
    required this.foto,
    this.seleccionado = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const Color azul = Color(0xFF0088FF);
    const Color verde = Color(0xFF14AE5C); // Color verde solicitado
    const Color grisTexto = Color(0xFF96A7AF);

    // Lógica del Avatar: Imagen vs Icono
    Widget avatarWidget;

    if (foto.isEmpty) {
      // CASO NOTIFICACIÓN: Mostrar Icono Verde
      avatarWidget = CircleAvatar(
        radius: 25,
        backgroundColor: verde.withOpacity(0.1), // Fondo verde suave
        child: const Icon(
          Icons.notifications_active, // Icono de campana
          color: verde, 
          size: 24,
        ),
      );
    } else {
      // CASO NORMAL: Mostrar Foto
      ImageProvider avatarImg;
      if (foto.startsWith('/') || foto.contains('user') || foto.contains('storage')) {
        avatarImg = FileImage(File(foto));
      } else {
        avatarImg = AssetImage(foto);
      }
      
      avatarWidget = CircleAvatar(
        radius: 25,
        backgroundImage: avatarImg,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: seleccionado ? azul : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Usamos el widget calculado arriba
            avatarWidget,

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: GoogleFonts.assistant(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: seleccionado ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    padecimiento,
                    style: GoogleFonts.assistant(
                      fontSize: 13,
                      color: seleccionado ? Colors.white70 : grisTexto,
                    ),
                  ),
                ],
              ),
            ),

            // MENÚ DE OPCIONES
            PopupMenuButton(
              icon: Icon(
                Icons.more_horiz,
                color: seleccionado ? Colors.white : azul,
              ),
              onSelected: (value) {
                if (value == 'delete' && onDelete != null) {
                  onDelete!();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 10),
                      Text("Eliminar"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}