import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/familiar_card.dart';
import '../widgets/duracion_card.dart';
import '../widgets/appbar.dart';
import '../provider/mireceta_provider.dart';

class CuidadosPage extends StatefulWidget {
  const CuidadosPage({super.key});

  @override
  State<CuidadosPage> createState() => _CuidadosPageState();
}

class _CuidadosPageState extends State<CuidadosPage> {
  bool cargado = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<RecetasProvider>(context, listen: false);

      if (provider.familiarActual == null && provider.usuarioActual != null) {
        await provider.cargarDatos(usuarioId: provider.usuarioActual!['id']);

        if (provider.familiares.isNotEmpty) {
          provider.setFamiliarActual(provider.familiares.first);
        }
      }

      if (provider.familiarActual != null) {
        await provider.cargarDatos(familiarId: provider.familiarActual!['id']);
      }

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
        appBar: AppBar(title: const Text("Cuidados")),
        body: const Center(child: Text("No hay familiar seleccionado")),
      );
    }

    final cuidados = provider.cuidados;

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
            /// --- PACIENTE ---
            Center(
              child: Text(
                "Paciente",
                style: GoogleFonts.assistant(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FamiliarCard(
              nombre: familiar['nombre'],
              padecimiento: familiar['estado'] ?? 'Sin información',
              foto: familiar['foto'] ?? 'assets/foto_perfil.jpg',
              seleccionado: true,
            ),
            const SizedBox(height: 20),

            /// --- TÍTULO + Agregar ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cuidados",
                  style: GoogleFonts.assistant(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
              ],
            ),
            const SizedBox(height: 20),

            /// --- LISTA DE CUIDADOS ---
            Expanded(
              child: cuidados.isEmpty
                  ? Center(
                      child: Text(
                        "Este familiar no tiene cuidados registrados.",
                        style: GoogleFonts.assistant(fontSize: 15),
                      ),
                    )
                  : ListView.builder(
                      itemCount: cuidados.length,
                      itemBuilder: (context, index) {
                        final c = cuidados[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Color(0xFF14AE5C),
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  c['descripcion'] ?? '',
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

            /// --- DURACIÓN ---
            Text(
              "Duración",
              style: GoogleFonts.assistant(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
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
