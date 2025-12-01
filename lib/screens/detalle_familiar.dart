import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/appbar.dart';
import '../widgets/familiar_card.dart';
import '../widgets/duracion_card.dart';
import '../provider/mireceta_provider.dart';
import 'formulario_medicamento.dart';

class DetalleFamiliarPage extends StatefulWidget {
  const DetalleFamiliarPage({super.key});

  @override
  State<DetalleFamiliarPage> createState() => _DetalleFamiliarPageState();
}

class _DetalleFamiliarPageState extends State<DetalleFamiliarPage> {
  bool cargado = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<RecetasProvider>(context, listen: false);
      await provider.cargarDatos(); // Cargar todo lo necesario
      setState(() => cargado = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecetasProvider>(context);

    if (!cargado) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final familiar = provider.familiarActual;
    if (familiar == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Detalle Familiar")),
        body: const Center(child: Text("No hay familiar seleccionado")),
      );
    }

    final medicamentos = provider.medicamentos;

    // Tomamos la última duración registrada
    final duracion = provider.duraciones.isNotEmpty
        ? provider.duraciones.last
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBarUsuario(
        nombre: provider.usuarioActual?['nombre'] ?? 'Usuario',
        estado: provider.usuarioActual?['estado'] ?? 'Sano',
        foto: provider.usuarioActual?['foto'] ?? 'assets/foto_perfil.jpg',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Paciente
            Text(
              "Paciente",
              style: GoogleFonts.assistant(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            FamiliarCard(
              nombre: familiar['nombre'],
              padecimiento: familiar['estado'] ?? 'Sin información',
              foto: familiar['foto'] ?? 'assets/foto_perfil.jpg',
              seleccionado: true,
            ),
            const SizedBox(height: 25),

            // Medicación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Medicación",
                  style: GoogleFonts.assistant(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FormularioMedicamentoPage(
                          familiarId: familiar['id'],
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Agregar",
                    style: GoogleFonts.assistant(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0088FF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            medicamentos.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Este familiar no tiene medicamentos registrados.",
                      style: GoogleFonts.assistant(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    children: medicamentos.map((med) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FamiliarCard(
                          nombre: med['nombre'],
                          padecimiento:
                              "Dosis: ${med['dosis']} - Cada ${med['cadaCuantasHoras']}h",
                          foto: med['foto'] ?? 'assets/med_default.png',
                          seleccionado: false,
                          onDelete: () async {
                            final provider = Provider.of<RecetasProvider>(
                                context,
                                listen: false);
                            await provider.eliminarMedicamento(med['id']);
                          },
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 25),

            // Duración dinámica
            Text(
              "Duración del tratamiento",
              style: GoogleFonts.assistant(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            DuracionCard(
              fechaInicio: duracion != null
                  ? _formatearFecha(duracion['fecha_inicio'])
                  : '--',
              fechaFin: duracion != null
                  ? _formatearFecha(duracion['fecha_fin'])
                  : '--',
            ),
          ],
        ),
      ),
    );
  }

  /// Formatea la fecha en "dd Ddd" (ej. 24 Mie)
  String _formatearFecha(String fechaIso) {
    final fecha = DateTime.parse(fechaIso);
    const dias = ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sáb'];
    final diaSemana = dias[fecha.weekday % 7];
    return '${fecha.day.toString().padLeft(2, '0')} $diaSemana';
  }
}
