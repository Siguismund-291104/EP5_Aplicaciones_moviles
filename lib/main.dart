import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/alumnos_provider.dart';
import 'screens/home_screen.dart';
import 'screens/inicio_screen.dart';
import 'screens/detalle_alumno_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AlumnosProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/inicio',
      routes: {
        '/inicio': (_) => const InicioScreen(),
        '/': (_) => const HomeScreen(),
        '/detalle': (_) => const DetalleAlumnoScreen(),
      },
    );
  }
}
