import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/familiar_card.dart';
import '../widgets/duracion_card.dart';
import '../widgets/appbar.dart';
import '../provider/mireceta_provider.dart';

class AlimentacionPage extends StatefulWidget {
  final int familiarId;

  const AlimentacionPage({super.key, required this.familiarId});

  @override
  State<AlimentacionPage> createState() => _AlimentacionPageState();
}

class _AlimentacionPageState extends State<AlimentacionPage> {
  bool cargado = false;

  @override
  void initState() {
    super.initState();

    /// Cargar datos desde el provider SOLO UNA VEZ
    Future.microtask(() async {
      final provider = Provider.of<RecetasProvider>(context, listen: false);
      await provider.cargarDatos(familiarId: widget.familiarId);
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

    final familiar = provider.familiares.firstWhere(
      (f) => f['id'] == widget.familiarId,
      orElse: () => {},
    );

    final alimentos = provider.alimentacion;

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Paciente",
                style: GoogleFonts.assistant(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Tarjeta del familiar seleccionado
            FamiliarCard(
              nombre: familiar['nombre'] ?? 'Sin nombre',
              padecimiento: familiar['estado'] ?? 'Sano',
              foto: familiar['foto'] ?? 'assets/foto_perfil.jpg',
              seleccionado: true,
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Alimentación",
                  style: GoogleFonts.assistant(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
              ],
            ),

            const SizedBox(height: 20),

            /// Lista de recomendaciones de alimentación
            Expanded(
              child: alimentos.isEmpty
                  ? const Center(
                      child: Text("No hay recomendaciones de alimentación"),
                    )
                  : ListView.builder(
                      itemCount: alimentos.length,
                      itemBuilder: (context, index) {
                        final item = alimentos[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.favorite,
                                  color: Color(0xFF14AE5C), size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item['descripcion'] ?? '',
                                  style: GoogleFonts.assistant(
                                    fontSize: 15,
                                    color: const Color(0xFF4A4A4A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 15),

            Text(
              "Duración",
              style: GoogleFonts.assistant(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// Duración dinámica
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
    // weekday va de 1 (Lun) a 7 (Dom), ajustamos para índice 0=Dom
    final diaSemana = dias[(fecha.weekday % 7)];
    return '${fecha.day.toString().padLeft(2, '0')} $diaSemana';
  }
}
