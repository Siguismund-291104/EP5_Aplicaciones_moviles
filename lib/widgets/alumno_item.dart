import 'package:flutter/material.dart';
import '../models/alumno.dart';

class AlumnoItem extends StatelessWidget {
  final Alumno alumno;

  const AlumnoItem({super.key, required this.alumno});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: alumno.aprobado ? Colors.green.shade100 : Colors.red.shade100,
      child: ListTile(
        title: Text(alumno.nombre),
        subtitle: Text("Promedio: ${alumno.promedio.toStringAsFixed(1)}"),
        trailing: Icon(
          alumno.aprobado ? Icons.check_circle : Icons.cancel,
          color: alumno.aprobado ? Colors.green : Colors.red,
        ),
        onTap: () {
          Navigator.pushNamed(context, '/detalle', arguments: alumno);
        },
      ),
    );
  }
}
