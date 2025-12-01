import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/mireceta_provider.dart';
import 'package:mi_receta/alertas/alerta_campos.dart';

class FormularioMedicamentoPage extends StatefulWidget {
  final int familiarId;

  const FormularioMedicamentoPage({super.key, required this.familiarId});

  @override
  State<FormularioMedicamentoPage> createState() => _FormularioMedicamentoPageState();
}

class _FormularioMedicamentoPageState extends State<FormularioMedicamentoPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dosisController = TextEditingController();
  TimeOfDay? _horaPrimeraDosis;

  String? _fotoSeleccionada;
  int? _cadaCuantasHoras;

  final List<int> opcionesHoras = [6, 8, 12, 24];

  final ImagePicker _picker = ImagePicker();

  Future<void> _seleccionarHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _horaPrimeraDosis = picked);
  }

  Future<void> _seleccionarFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _fotoSeleccionada = image.path);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecetasProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Medicamento', style: GoogleFonts.assistant(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecciona la foto', style: GoogleFonts.assistant(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _seleccionarFoto,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _fotoSeleccionada != null ? FileImage(File(_fotoSeleccionada!)) : null,
                child: _fotoSeleccionada == null
                    ? const Icon(Icons.add_a_photo, size: 30, color: Colors.white)
                    : null,
                backgroundColor: const Color(0xFF96A7AF),
              ),
            ),
            const SizedBox(height: 15),

            Text('Nombre del medicamento', style: GoogleFonts.assistant(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(controller: _nombreController, decoration: _campo("Ej: Paracetamol")),
            const SizedBox(height: 15),

            Text('Dosis', style: GoogleFonts.assistant(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(controller: _dosisController, keyboardType: TextInputType.number, decoration: _campo("Ej: 500 mg")),
            const SizedBox(height: 15),

            Text('Cada cuántas horas', style: GoogleFonts.assistant(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButton<int>(
              isExpanded: true,
              value: _cadaCuantasHoras,
              hint: const Text("Selecciona cada cuántas horas"),
              items: opcionesHoras.map((h) => DropdownMenuItem<int>(value: h, child: Text("$h horas"))).toList(),
              onChanged: (val) => setState(() => _cadaCuantasHoras = val),
            ),
            const SizedBox(height: 15),

            Text('Hora de la primera dosis', style: GoogleFonts.assistant(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _seleccionarHora(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_horaPrimeraDosis != null ? _horaPrimeraDosis!.format(context) : "Selecciona la hora", style: GoogleFonts.assistant(fontSize: 15)),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_fotoSeleccionada == null || _nombreController.text.trim().isEmpty || _dosisController.text.trim().isEmpty || _cadaCuantasHoras == null || _horaPrimeraDosis == null) {
                    AlertaCampos.mostrar(context, "Completa todos los campos para continuar.");
                    return;
                  }

                  provider.agregarMedicamento(
                    nombre: _nombreController.text.trim(),
                    dosis: _dosisController.text.trim(),
                    foto: _fotoSeleccionada!,
                    cadaCuantasHoras: _cadaCuantasHoras!,
                    horaPrimeraDosis: _horaPrimeraDosis!,
                  );

                  AlertaCampos.mostrar(context, "Medicamento agregado exitosamente");
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                ),
                child: Text('Agregar', style: GoogleFonts.assistant(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _campo(String texto) {
    return InputDecoration(
      hintText: texto,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF96A7AF))),
    );
  }
}
