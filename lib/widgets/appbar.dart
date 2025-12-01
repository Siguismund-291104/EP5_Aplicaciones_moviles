import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarUsuario extends StatelessWidget implements PreferredSizeWidget {
  final String nombre;
  final String estado;
  final String foto;

  const AppBarUsuario({
    super.key,
    required this.nombre,
    required this.estado,
    required this.foto,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider;

    // Si la ruta empieza con /storage/emulated/ o contiene \,
    // es una imagen local
    if (foto.contains('/')) {
      imageProvider = FileImage(File(foto));
    } else {
      imageProvider = AssetImage(foto);
    }

    return SafeArea(
      child: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Info del usuario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nombre,
                  style: GoogleFonts.assistant(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  estado,
                  style: GoogleFonts.assistant(
                    fontSize: 14,
                    color: const Color(0xFF96A7AF),
                  ),
                ),
              ],
            ),

            // FOTO DE PERFIL CORREGIDA
            CircleAvatar(
              radius: 28,
              backgroundImage: imageProvider,
            ),
          ],
        ),
      ),
    );
  }
}
  