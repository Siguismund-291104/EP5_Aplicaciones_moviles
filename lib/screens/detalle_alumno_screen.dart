import 'package:flutter/material.dart';
import '../models/alumno.dart';

class DetalleAlumnoScreen extends StatelessWidget {
  const DetalleAlumnoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Alumno alumno = ModalRoute.of(context)!.settings.arguments as Alumno;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          alumno.nombre,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // logo
            Image.asset('assets/image/logo.png', height: 120),

            const SizedBox(height: 10),
            const Text(
              "Calificaciones",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7B0000),
              ),
            ),
            const SizedBox(height: 25),

            // Carrera
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Carrera: ${alumno.carrera}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),

            // Promedio
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Promedio: ${alumno.promedio.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: alumno.aprobado ? Colors.green : Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Estado
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Estado: ${alumno.aprobado ? 'Aprobado' : 'Reprobado'}",
                style: TextStyle(
                  fontSize: 20,
                  color: alumno.aprobado ? Colors.green : Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Cajas rositas con las 4 calificaciones (solo números)
            califBox(alumno.c1),
            const SizedBox(height: 10),
            califBox(alumno.c2),
            const SizedBox(height: 10),
            califBox(alumno.c3),
            const SizedBox(height: 10),
            califBox(alumno.c4),
          ],
        ),
      ),
    );
  }

  Widget califBox(double valor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE1E1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        valor.toStringAsFixed(2),
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
