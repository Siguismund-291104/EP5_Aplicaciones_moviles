import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mi_receta/provider/mireceta_provider.dart';
import 'package:mi_receta/alertas/alerta_campos.dart';

class AgregarFamiliar extends StatefulWidget {
  const AgregarFamiliar({super.key});

  @override
  State<AgregarFamiliar> createState() => _AgregarFamiliarState();
}

class _AgregarFamiliarState extends State<AgregarFamiliar> {
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _parentesco = TextEditingController();

  String? _foto;

  Future<void> _seleccionarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() => _foto = img.path);
    }
  }

  void _guardarFamiliar() async {
    if (_nombre.text.isEmpty || _parentesco.text.isEmpty || _foto == null) {
      AlertaCampos.mostrar(context, "Completa todos los campos.");
      return;
    }

    final provider = Provider.of<RecetasProvider>(context, listen: false);

    await provider.agregarFamiliar(
      usuarioId: provider.usuarioActual!['id'],
      nombre: _nombre.text,
      parentesco: _parentesco.text,
      foto: _foto!,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Agregar familiar",
          style: GoogleFonts.assistant(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(height: 10),

            GestureDetector(
              onTap: _seleccionarFoto,
              child: CircleAvatar(
                radius: 55,
                backgroundImage:
                    _foto != null ? FileImage(File(_foto!)) : null,
                backgroundColor: const Color(0xFF96A7AF),
                child: _foto == null
                    ? const Icon(Icons.add_a_photo,
                        color: Colors.white, size: 40)
                    : null,
              ),
            ),

            const SizedBox(height: 25),

            _input("Nombre completo", _nombre),
            const SizedBox(height: 15),

            _input("Parentesco (ej. mamá, abuelo...)", _parentesco),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _guardarFamiliar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Guardar familiar",
                  style: GoogleFonts.assistant(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String texto, TextEditingController ctrl,
      {TextInputType tipo = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: tipo,
      decoration: InputDecoration(
        hintText: texto,
        hintStyle: GoogleFonts.assistant(
          color: const Color(0xFF96A7AF),
          fontSize: 13,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF96A7AF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF96A7AF)),
        ),
      ),
    );
  }
}
