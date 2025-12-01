import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/appbar.dart';
import '../widgets/nav2.dart'; // Asegúrate de tener esta importación si usas navegación
import '../widgets/recordatorio_card.dart';
import '../widgets/familiar_card.dart';
import '../provider/mireceta_provider.dart';
import 'agregar_familiar.dart'; // Asegúrate de importar la pantalla de agregar

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recetasProvider = Provider.of<RecetasProvider>(context);

    final usuario = recetasProvider.usuarioActual;
    final familiares = recetasProvider.familiares;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBarUsuario(
        nombre: usuario?['nombre'] ?? 'Usuario',
        estado: usuario?['estado'] ?? 'Sano',
        foto: usuario?['foto'] ?? 'assets/foto_perfil.jpg',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------------------------
            // 🔹 PRÓXIMAS DOSIS
            // -------------------------------------------------
            Text(
              'Próximas dosis',
              style: GoogleFonts.assistant(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: recetasProvider.getMedicamentosHome(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final proximos = snapshot.data ?? [];

                  if (proximos.isEmpty) {
                    return Center(
                      child: Text(
                        "No hay próximas dosis",
                        style: GoogleFonts.assistant(fontSize: 14, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: proximos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final med = proximos[index];
                      
                      // 🔹 AQUI ESTÁ EL CAMBIO:
                      // Si index == 0, es el primero de la lista, por lo tanto se selecciona.
                      bool esElPrimero = (index == 0);

                      return RecordatorioCard(
                        nombre: med['familiar'] ?? 'Familiar',
                        padecimiento: med['diagnostico'] ?? '—',
                        medicamento: med['nombre'] ?? 'Medicamento',
                        hora: med['hora'] ?? '00:00',
                        foto: med['foto'] ?? 'assets/med_default.png',
                        
                        // Pasamos la condición aquí
                        seleccionado: esElPrimero, 
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------
            // 🔹 MI FAMILIA
            // -------------------------------------------------
            // ... (El resto de tu código sigue igual)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mi familia',
                  style: GoogleFonts.assistant(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AgregarFamiliar(),
                      ),
                    );
                  },
                  child: Text(
                    'Agregar',
                    style: GoogleFonts.assistant(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0088FF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            familiares.isEmpty
                ? Text(
                    'Aún no tienes familiares registrados.\nAgrega uno para comenzar.',
                    style: GoogleFonts.assistant(
                      fontSize: 14,
                      color: const Color(0xFF555555),
                    ),
                  )
                : Column(
                    children: familiares.map((f) {
                      return FamiliarCard(
                        nombre: f['nombre'] ?? 'Sin nombre',
                        padecimiento: f['estado'] ?? 'Sano',
                        foto: f['foto'] ?? 'assets/foto_perfil.jpg',
                        onDelete: () => recetasProvider.eliminarFamiliar(f['id']),
                        onTap: () {
                          recetasProvider.setFamiliarActual(f);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Nav2(
                                nombre: f['nombre'] ?? 'Sin nombre',
                                padecimiento: f['estado'] ?? 'Sano',
                                foto: f['foto'] ?? 'assets/foto_perfil.jpg',
                                familiarId: f['id'],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 25),

            // -------------------------------------------------
            // 🔹 ¡NO LO OLVIDES! (Recordatorios)
            // -------------------------------------------------
            Text(
              '¡No lo olvides!',
              style: GoogleFonts.assistant(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: recetasProvider.getRecordatoriosRandom(3),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text(
                    'No tienes recordatorios por ahora.',
                    style: GoogleFonts.assistant(fontSize: 14, color: const Color(0xFF555555)),
                  );
                }

                final recordatorios = snapshot.data!;

                return Column(
                  children: recordatorios.map((r) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF14AE5C), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            generarTextoRecordatorio(r),
                            style: GoogleFonts.assistant(
                              fontSize: 14,
                              color: const Color(0xFF555555),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // Método auxiliar para generar texto (lo moví dentro para que compile bien si lo copias todo)
  String generarTextoRecordatorio(Map<String, dynamic> r) {
    String nombreFamiliar = r['familiar'] ?? 'Familiar';

    if (r.containsKey('descripcion') && r['descripcion'] != null) {
      return "$nombreFamiliar requiere: ${r['descripcion']}";
    }
    if (r.containsKey('fecha_fin') && r['fecha_fin'] != null) {
      return "El tratamiento de $nombreFamiliar termina el ${r['fecha_fin']}";
    }
    if (r.containsKey('nombre') && r['nombre'] != null) {
      return "$nombreFamiliar debe tomar ${r['nombre']}";
    }
    return "$nombreFamiliar tiene un recordatorio pendiente.";
  }
} 