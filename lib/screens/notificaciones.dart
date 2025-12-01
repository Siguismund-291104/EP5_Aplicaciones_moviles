import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/familiar_card.dart';
import '../widgets/appbar.dart';
import '../provider/mireceta_provider.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  // Ya no necesitamos el initState con addPostFrameCallback porque
  // el FutureBuilder se encargará de pedir los datos al cargar.

  @override
  Widget build(BuildContext context) {
    final recetasProvider = Provider.of<RecetasProvider>(context);
    // Nota: Usamos listen: false para llamar a la función en el future
    final recetasProviderNoListen = Provider.of<RecetasProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBarUsuario(
        nombre: recetasProvider.usuarioActual?['nombre'] ?? 'Usuario',
        estado: recetasProvider.usuarioActual?['estado'] ?? 'Sano',
        foto: recetasProvider.usuarioActual?['foto'] ?? 'assets/foto_perfil.jpg',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Notificaciones",
                style: GoogleFonts.assistant(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // ---------------------------------------------------------
            // AQUI ESTÁ EL CAMBIO PRINCIPAL: FutureBuilder
            // ---------------------------------------------------------
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                // Llamamos al MISMO método que usas en el Home
                future: recetasProviderNoListen.getMedicamentosHome(), 
                builder: (context, snapshot) {
                  
                  // 1. Cargando
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. Error o datos vacíos
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No hay notificaciones pendientes",
                        style: GoogleFonts.assistant(
                          fontSize: 14,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    );
                  }

                  // 3. Datos listos
                  final listaMedicamentos = snapshot.data!;

                  return ListView.builder(
                    itemCount: listaMedicamentos.length,
                    itemBuilder: (context, index) {
                      final item = listaMedicamentos[index];

                      // Armamos el mensaje igual que lo hacías antes
                      // pero usando los datos que vienen de getMedicamentosHome
                      String mensaje = "${item['familiar']} debe tomar ${item['nombre']} a las ${item['hora']}";
                      
                      // Si tienes descripción en lugar de medicamento:
                      if (item.containsKey('descripcion') && item['descripcion'] != null) {
                         mensaje = "${item['familiar']} requiere: ${item['descripcion']}";
                      }

                      return FamiliarCard(
                        nombre: item['familiar'] ?? 'Aviso',
                        padecimiento: mensaje,
                        
                        // Pasamos vacío para activar el icono VERDE que programamos antes
                        foto: '', 
                        
                        seleccionado: false,
                        onTap: () {
                          // Acción al tocar
                        },
                        onDelete: () {
                          // Lógica para borrar (opcional)
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}