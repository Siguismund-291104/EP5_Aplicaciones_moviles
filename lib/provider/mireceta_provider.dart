import 'package:flutter/material.dart';
import 'package:mi_receta/database/dbhelper.dart';

class RecetasProvider extends ChangeNotifier {
  Map<String, dynamic>? usuarioActual;
  Map<String, dynamic>? familiarActual;

  // Datos en memoria
  List<Map<String, dynamic>> usuarios = [];
  List<Map<String, dynamic>> familiares = [];
  List<Map<String, dynamic>> medicamentos = [];
  List<Map<String, dynamic>> cuidados = [];
  List<Map<String, dynamic>> alimentacion = [];
  List<Map<String, dynamic>> duraciones = [];

  // Notificaciones generadas
  List<Map<String, String>> notificaciones = [];

  RecetasProvider() {
    cargarDatos();
  }

  // ============================================================
  //   CARGA DE DATOS DESDE LA BASE DE DATOS
  // ============================================================
  Future<void> cargarDatos({int? usuarioId, int? familiarId}) async {
    if (usuarioId == null && familiarId == null) {
      usuarios = await DBHelper.getUsuarios();
      notifyListeners();
      return;
    }

    if (usuarioId != null) {
      familiares = await DBHelper.getFamiliares(usuarioId);
    }

    if (familiarId != null) {
      medicamentos = await DBHelper.getMedicamentos(familiarId);
      cuidados = await DBHelper.getCuidados(familiarId);
      alimentacion = await DBHelper.getAlimentacion(familiarId);
      duraciones = await DBHelper.getDuraciones(familiarId);

      actualizarNotificaciones();
    }

    notifyListeners();
  }

  // ============================================================
  //   USUARIO
  // ============================================================
  void setUsuarioActual(Map<String, dynamic> usuario) {
    usuarioActual = usuario;
    cargarDatos(usuarioId: usuario['id']);
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    return await DBHelper.validarUsuario(email, password);
  }

  Future<void> agregarUsuario(String nombre, String email, String password, {String? foto}) async {
    await DBHelper.insertarUsuario(nombre, email, password, foto: foto);
    await cargarDatos();
  }

  Future<void> editarUsuario(int id, String nombre, String email, {String? foto, String? estado}) async {
    await DBHelper.actualizarUsuario(id, nombre, email, foto: foto, estado: estado);
    await cargarDatos();
  }

  Future<void> eliminarUsuario(int id) async {
    await DBHelper.eliminarUsuario(id);
    await cargarDatos();
  }

  // ============================================================
  //   FAMILIARES
  // ============================================================
  void setFamiliarActual(Map<String, dynamic> familiar) {
    familiarActual = familiar;
    cargarDatos(familiarId: familiar['id']);
  }

  Future<void> agregarFamiliar({
    required int usuarioId,
    required String nombre,
    required String parentesco,
    String? foto,
    String? estado,
  }) async {
    await DBHelper.insertarFamiliar(
      usuarioId,
      nombre,
      parentesco: parentesco,
      foto: foto,
      estado: estado,
    );

    await cargarDatos(usuarioId: usuarioId);
  }

  Future<void> eliminarFamiliar(int familiarId) async {
    await DBHelper.eliminarFamiliar(familiarId);
    await cargarDatos(usuarioId: usuarioActual!['id']);
  }

  // ============================================================
  //   MEDICAMENTOS
  // ============================================================
  Future<void> agregarMedicamento({
    required String nombre,
    required String dosis,
    required int cadaCuantasHoras,
    required TimeOfDay horaPrimeraDosis,
    String? foto,
  }) async {
    if (familiarActual == null) return;

    final familiarId = familiarActual!['id'];

    // Convertir horaPrimeraDosis a String formato HH:mm
    final horaStr =
        '${horaPrimeraDosis.hour.toString().padLeft(2, '0')}:${horaPrimeraDosis.minute.toString().padLeft(2, '0')}';

    // Insertar en la BD
    await DBHelper.insertarMedicamento(
      familiarId,
      nombre,
      dosis,
      cadaCuantasHoras,
      horaStr,
      foto: foto,
    );

    await cargarDatos(familiarId: familiarId);
  }

  Future<void> eliminarMedicamento(int id) async {
    if (familiarActual == null) return;
    await DBHelper.eliminarMedicamento(id);
    await cargarDatos(familiarId: familiarActual!['id']);
  }

  // ============================================================
  //   CUIDADOS
  // ============================================================
  Future<void> agregarCuidado(int familiarId, String descripcion) async {
    await DBHelper.insertarCuidado(familiarId, descripcion);
    await cargarDatos(familiarId: familiarId);
  }

  // ============================================================
  //   ALIMENTACIÓN
  // ============================================================
  Future<void> agregarAlimentacion(int familiarId, String descripcion) async {
    await DBHelper.insertarAlimentacion(familiarId, descripcion);
    await cargarDatos(familiarId: familiarId);
  }

  // ============================================================
  //   DURACIÓN DE TRATAMIENTOS
  // ============================================================
  Future<void> agregarDuracion(int familiarId, String fechaInicio, String fechaFin) async {
    await DBHelper.insertarDuracion(familiarId, fechaInicio, fechaFin);
    await cargarDatos(familiarId: familiarId);
  }

  // ============================================================
  //   NOTIFICACIONES DINÁMICAS
  // ============================================================
  void actualizarNotificaciones() {
    notificaciones = [];

    for (var med in medicamentos) {
      notificaciones.add({
        "mensaje": "${med['familiar']} debe tomar ${med['nombre']} a las ${med['hora']}",
        "tiempo": "Próximo",
      });
    }

    for (var cuidado in cuidados) {
      notificaciones.add({
        "mensaje": "${cuidado['familiar']} requiere: ${cuidado['descripcion']}",
        "tiempo": "Hoy",
      });
    }

    notifyListeners();
  }

  // ============================================================
  //   MÉTODOS EXTRA (PARA LA HOME)
  // ============================================================
  Future<List<Map<String, dynamic>>> getRecordatoriosRandom(int cantidad) async {
    if (usuarioActual == null) return [];

    List<Map<String, dynamic>> lista = [];

    final familiaresBD = await DBHelper.getFamiliares(usuarioActual!['id']);

    for (var fam in familiaresBD) {
      final nombreFamiliar = fam['nombre'] ?? 'Familiar';
      final meds = await DBHelper.getMedicamentos(fam['id']);
      final cuidadosFam = await DBHelper.getCuidados(fam['id']);

      for (var med in meds) {
        lista.add({
          'familiar': nombreFamiliar,
          'nombre': med['nombre'],
          'hora': med['hora'] ?? '00:00',
        });
      }

      for (var cuidado in cuidadosFam) {
        lista.add({
          'familiar': nombreFamiliar,
          'descripcion': cuidado['descripcion'],
        });
      }
    }

    lista.shuffle();
    return lista.take(cantidad).toList();
  }

  Future<List<Map<String, dynamic>>> getMedicamentosHome() async {
      if (usuarioActual == null) return [];

      List<Map<String, dynamic>> listaCompleta = [];
      final ahora = DateTime.now();

      final familiaresBD = await DBHelper.getFamiliares(usuarioActual!['id']);

      for (var fam in familiaresBD) {
        final nombreFamiliar = fam['nombre'] ?? 'Familiar';
        final diagnostico = fam['estado'] ?? '—';
        final fotoFamiliar = fam['foto'] ?? 'assets/foto_perfil.jpg';
        final familiarId = fam['id'];

        final meds = await DBHelper.getMedicamentos(familiarId);

        if (meds.isEmpty) {
          listaCompleta.add({
            'familiar': nombreFamiliar,
            'diagnostico': diagnostico,
            'nombre': 'Sin medicamento',
            'hora': '00:00',
            'foto': fotoFamiliar,
          });
        } else {
          for (var med in meds) {
            final nombreMed = med['nombre'] ?? 'Medicamento';
            final fotoMed = med['foto'] ?? fotoFamiliar;
            final cadaHoras = med['cadaCuantasHoras'] ?? 24;
            final horaPrimeraDosis = med['hora'] ?? '08:00';

            // --- Calcular próxima dosis ---
            final partesHora = horaPrimeraDosis.split(':');
            int hora = int.parse(partesHora[0]);
            int minuto = int.parse(partesHora[1]);

            DateTime proximaDosis = DateTime(
              ahora.year,
              ahora.month,
              ahora.day,
              hora,
              minuto,
            );

            // Incrementar dosis hasta que sea después de la hora actual
            while (proximaDosis.isBefore(ahora)) {
              proximaDosis = proximaDosis.add(Duration(hours: cadaHoras));
            }

            final horaStr = '${proximaDosis.hour.toString().padLeft(2, '0')}:${proximaDosis.minute.toString().padLeft(2, '0')}';

            listaCompleta.add({
              'familiar': nombreFamiliar,
              'diagnostico': diagnostico,
              'nombre': nombreMed,
              'hora': horaStr,
              'foto': fotoMed,
            });
          }
        }
      }

      return listaCompleta;
    }

  Future<void> agregarReceta({ 
      required int familiarId, 
      required String diagnostico, 
      required List<String> alimentacionProhibida, 
      required List<String> cuidadosEspeciales, 
      required String fechaFin, // Formato "yyyy-MM-dd" 
    }) async { 
      // 1. Actualizar estado del familiar 
      await DBHelper.actualizarFamiliarEstado(familiarId, diagnostico); 

      // 2. Insertar alimentos prohibidos 
      for (var alimento in alimentacionProhibida) { 
        if (alimento.trim().isNotEmpty) { 
          await DBHelper.insertarAlimentacion(familiarId, alimento.trim()); 
        } 
      }

      // 3. Insertar cuidados especiales
      for (var cuidado in cuidadosEspeciales) {
        if (cuidado.trim().isNotEmpty) {
          await DBHelper.insertarCuidado(familiarId, cuidado.trim());
        }
      }

      // 4. Insertar duración (fechaInicio = hoy)
      final fechaInicio = DateTime.now().toIso8601String(); 
      await DBHelper.insertarDuracion(familiarId, fechaInicio, fechaFin);

      // 5. Recargar datos del familiar
      await cargarDatos(familiarId: familiarId);
    }


}