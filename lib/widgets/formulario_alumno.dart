import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alumnos_provider.dart';
import '../models/alumno.dart';

class FormularioAlumno extends StatefulWidget {
  const FormularioAlumno({super.key});

  @override
  State<FormularioAlumno> createState() => _FormularioAlumnoState();
}

class _FormularioAlumnoState extends State<FormularioAlumno> {
  final _formKey = GlobalKey<FormState>();

  final nombreCtrl = TextEditingController();
  final carreraCtrl = TextEditingController();
  final c1Ctrl = TextEditingController();
  final c2Ctrl = TextEditingController();
  final c3Ctrl = TextEditingController();
  final c4Ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              campo("Nombre", nombreCtrl),
              campo("Carrera", carreraCtrl),
              campo("Calificación 1", c1Ctrl, number: true),
              campo("Calificación 2", c2Ctrl, number: true),
              campo("Calificación 3", c3Ctrl, number: true),
              campo("Calificación 4", c4Ctrl, number: true),

              const SizedBox(height: 10),

              ElevatedButton(
                child: const Text("Agregar Alumno"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final alumno = Alumno(
                      nombre: nombreCtrl.text,
                      carrera: carreraCtrl.text,
                      c1: double.parse(c1Ctrl.text),
                      c2: double.parse(c2Ctrl.text),
                      c3: double.parse(c3Ctrl.text),
                      c4: double.parse(c4Ctrl.text),
                    );

                    context.read<AlumnosProvider>().agregarAlumno(alumno);

                    _formKey.currentState!.reset();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget campo(
    String label,
    TextEditingController ctrl, {
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: ctrl,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.pink.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "Campo obligatorio";
          if (number) {
            final n = double.tryParse(value);
            if (n == null || n < 0 || n > 100) return "Debe ser 0 a 100";
          }
          return null;
        },
      ),
    );
  }
}
