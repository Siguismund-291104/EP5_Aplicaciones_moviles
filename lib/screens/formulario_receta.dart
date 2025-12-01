import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mi_receta/alertas/alerta_campos.dart';
import 'package:mi_receta/widgets/nav1.dart';
import 'package:provider/provider.dart';
import '../widgets/familiar_card.dart';
import '../provider/mireceta_provider.dart';


class FormularioRecetaScreen extends StatefulWidget {
  const FormularioRecetaScreen({super.key});

  @override
  State<FormularioRecetaScreen> createState() => _FormularioRecetaScreenState();
}

class _FormularioRecetaScreenState extends State<FormularioRecetaScreen> {
  final TextEditingController _diagnosticoController = TextEditingController();
  final List<TextEditingController> _alimentosControllers = [TextEditingController()];
  final List<TextEditingController> _cuidadosControllers = [TextEditingController()];
  final TextEditingController _fechaController = TextEditingController();

  int? _familiarSeleccionadoId;

  Widget _buildInput(TextEditingController controller,
      {String hint = "", bool withAdd = false, VoidCallback? onAdd}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF007BFF).withOpacity(0.19),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black54),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
            ),
          ),
          if (withAdd)
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle, color: Colors.green, size: 22),
            ),
        ],
      ),
    );
  }

  Widget _buildDynamicList(String title, List<TextEditingController> list, VoidCallback onAdd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.assistant(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Column(
          children: List.generate(list.length, (index) {
            final isLast = index == list.length - 1;
            return _buildInput(
              list[index],
              withAdd: isLast,
              onAdd: onAdd,
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final recetasProvider = Provider.of<RecetasProvider>(context);
    final familiares = recetasProvider.familiares;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nueva Receta',
          style: GoogleFonts.assistant(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona el familiar',
              style: GoogleFonts.assistant(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            familiares.isEmpty
                ? Text(
                    'No tienes familiares registrados.',
                    style: GoogleFonts.assistant(fontSize: 14),
                  )
                : Column(
                    children: familiares.map((f) {
                      final selected = _familiarSeleccionadoId == f['id'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _familiarSeleccionadoId = f['id'];
                          });
                        },
                        child: FamiliarCard(
                          nombre: f['nombre'],
                          padecimiento: f['estado'],
                          foto: f['foto'] ?? 'assets/foto_perfil.jpg',
                          seleccionado: selected,
                        ),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 20),
            Text(
              'Diagnóstico',
              style: GoogleFonts.assistant(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            _buildInput(_diagnosticoController, hint: "Ingrese el padecimiento"),
            const SizedBox(height: 15),
            _buildDynamicList("Alimentos prohibidos", _alimentosControllers, () {
              setState(() {
                _alimentosControllers.add(TextEditingController());
              });
            }),
            const SizedBox(height: 15),
            _buildDynamicList("Cuidados especiales", _cuidadosControllers, () {
              setState(() {
                _cuidadosControllers.add(TextEditingController());
              });
            }),
            const SizedBox(height: 15),
            Text(
              'Fecha de fin del tratamiento (aaaa-mm-dd)',
              style: GoogleFonts.assistant(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            _buildInput(_fechaController, hint: "Ej: 2025-12-15"),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Validaciones
                  if (_familiarSeleccionadoId == null) {
                    AlertaCampos.mostrar(context, "Selecciona un familiar");
                    return;
                  }

                  final fecha = _fechaController.text.trim();
                  final fechaValida = RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(fecha);
                  if (!fechaValida) {
                    AlertaCampos.mostrar(context, "Ingresa la fecha en el formato correcto: aaaa-mm-dd");
                    return;
                  }

                  // Guardar receta
                  await recetasProvider.agregarReceta(
                    familiarId: _familiarSeleccionadoId!,
                    diagnostico: _diagnosticoController.text.trim(),
                    alimentacionProhibida: _alimentosControllers.map((c) => c.text).toList(),
                    cuidadosEspeciales: _cuidadosControllers.map((c) => c.text).toList(),
                    fechaFin: fecha,
                  );

                  AlertaCampos.mostrar(context, "Receta agregada exitosamente");

                  // Cambiar al índice 1 (HomeScreen)
                  HomeNav.of(context)?.setIndex(1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                ),
                child: Text(
                  'Aceptar',
                  style: GoogleFonts.assistant(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
