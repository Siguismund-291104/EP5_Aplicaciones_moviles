import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mi_receta/provider/mireceta_provider.dart';
import 'screens/login.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecetasProvider()),
      ],
      child: const MiRecetaApp(),
    ),
  );
}

class MiRecetaApp extends StatelessWidget {
  const MiRecetaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Receta Médica',
      home: const PantallaBienvenida(),
    );
  }
}

class PantallaBienvenida extends StatelessWidget {
  const PantallaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Blanco de fondo
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagen
                Image.asset(
                  'assets/medicos.jpg',
                  height: 180,
                ),
                const SizedBox(height: 40),

                // Título
                Text(
                  'Mi receta médica',
                  style: GoogleFonts.assistant(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),

                // Texto descriptivo
                Text(
                  'Mi receta médica no es una app de consultas ni ayuda médica, '
                  'nuestro objetivo es proporcionar recordatorios de lo que un médico te ha recetado.\n'
                  'No te automediques.',
                  style: GoogleFonts.assistant(
                    fontSize: 14,
                    fontWeight: FontWeight.w600, 
                    color: Colors.black,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 70),

                // Botón
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088FF), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Comenzar',
                          style: GoogleFonts.assistant(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}