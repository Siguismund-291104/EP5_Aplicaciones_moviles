import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alumnos_provider.dart';
import '../widgets/formulario_alumno.dart';
import '../widgets/alumno_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alumnos = context.watch<AlumnosProvider>().alumnos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestor de Alumnos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => context.read<AlumnosProvider>().limpiarLista(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const FormularioAlumno(),
            const SizedBox(height: 20),

            alumnos.isEmpty
                ? const Text(
                    "No hay alumnos registrados",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: alumnos.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, i) => AlumnoItem(alumno: alumnos[i]),
                  ),
          ],
        ),
      ),
    );
  }
}
