import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static String _dbName = "mi_receta.db";

  static Future<Database> getDB() async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  static Future<void> _onCreateDB(Database db, int version) async {
    // USUARIOS
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        estado TEXT DEFAULT 'sano',
        foto TEXT
      )
    ''');

    // FAMILIARES
    await db.execute('''
      CREATE TABLE familiares(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        estado TEXT DEFAULT 'sano',
        parentesco TEXT,
        foto TEXT,
        FOREIGN KEY(usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
      )
    ''');

    // MEDICAMENTOS
    await db.execute('''
      CREATE TABLE medicamentos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        familiar_id INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        cantidad TEXT NOT NULL,
        frecuencia INTEGER NOT NULL,
        hora_primera_dosis TEXT NOT NULL,
        foto TEXT,
        FOREIGN KEY(familiar_id) REFERENCES familiares(id) ON DELETE CASCADE
      )
    ''');

    // CUIDADOS
    await db.execute('''
      CREATE TABLE cuidados(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        familiar_id INTEGER NOT NULL,
        descripcion TEXT NOT NULL,
        FOREIGN KEY(familiar_id) REFERENCES familiares(id) ON DELETE CASCADE
      )
    ''');

    // ALIMENTACION
    await db.execute('''
      CREATE TABLE alimentacion(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        familiar_id INTEGER NOT NULL,
        descripcion TEXT NOT NULL,
        FOREIGN KEY(familiar_id) REFERENCES familiares(id) ON DELETE CASCADE
      )
    ''');

    // DURACION/TRATAMIENTOS
    await db.execute('''
      CREATE TABLE duraciones(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        familiar_id INTEGER NOT NULL,
        fecha_inicio TEXT NOT NULL,
        fecha_fin TEXT NOT NULL,
        FOREIGN KEY(familiar_id) REFERENCES familiares(id) ON DELETE CASCADE
      )
    ''');
  }

  // ==================== USUARIOS ====================
  static Future<int> insertarUsuario(String nombre, String email, String password, {String? foto}) async {
    final db = await getDB();
    return db.insert("usuarios", {
      "nombre": nombre,
      "email": email,
      "password": password,
      "foto": foto,
    });
  }

  static Future<List<Map<String, dynamic>>> getUsuarios() async {
    final db = await getDB();
    return db.query("usuarios");
  }

  static Future<void> actualizarUsuario(int id, String nombre, String email, {String? foto, String? estado}) async {
    final db = await getDB();
    await db.update("usuarios", {
      "nombre": nombre,
      "email": email,
      if(foto != null) "foto": foto,
      if(estado != null) "estado": estado,
    }, where: "id = ?", whereArgs: [id]);
  }

  static Future<void> eliminarUsuario(int id) async {
    final db = await getDB();
    await db.delete("usuarios", where: "id = ?", whereArgs: [id]);
  }

  static Future<Map<String, dynamic>?> validarUsuario(String email, String password) async {
    final db = await getDB();
    final resultado = await db.query(
      "usuarios",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );
    if (resultado.isNotEmpty) return resultado.first;
    return null;
  }

  // ==================== FAMILIARES ====================
  static Future<int> insertarFamiliar(
    int usuarioId,
    String nombre, {
    String? parentesco,
    String? foto,
    String? estado,
  }) async {
    final db = await getDB();
    return db.insert("familiares", {
      "usuario_id": usuarioId,
      "nombre": nombre,
      "parentesco": parentesco,
      "foto": foto,
      "estado": estado ?? "sano",
    });
  }

  static Future<List<Map<String, dynamic>>> getFamiliares(int usuarioId) async {
    final db = await getDB();
    return db.query(
      "familiares",
      where: "usuario_id = ?",
      whereArgs: [usuarioId],
    );
  }

  static Future<void> actualizarFamiliarEstado(int id, String estado) async {
    final db = await getDB();
    await db.update(
      "familiares",
      {"estado": estado},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<void> eliminarFamiliar(int id) async {
    final db = await getDB();
    await db.delete("familiares", where: "id = ?", whereArgs: [id]);
  }

  // ==================== MEDICAMENTOS ====================
  static Future<int> insertarMedicamento(
    int familiarId,
    String nombre,
    String cantidad,
    int frecuencia,
    String horaPrimeraDosis,
    {String? foto}
  ) async {
    final db = await getDB();
    return db.insert("medicamentos", {
      "familiar_id": familiarId,
      "nombre": nombre,
      "cantidad": cantidad,
      "frecuencia": frecuencia,
      "hora_primera_dosis": horaPrimeraDosis,
      "foto": foto,
    });
  }

  static Future<List<Map<String, dynamic>>> getMedicamentos(int familiarId) async {
    final db = await getDB();
    final res = await db.query("medicamentos", where: "familiar_id = ?", whereArgs: [familiarId]);
    
    return res.map((m) => {
      'id': m['id'],
      'nombre': m['nombre'],
      'dosis': m['cantidad'],
      'cadaCuantasHoras': m['frecuencia'],
      'hora': m['hora_primera_dosis'],
      'foto': m['foto'],
      'familiar_id': m['familiar_id'],
    }).toList();
  }

  static Future<void> eliminarMedicamento(int id) async {
    final db = await getDB();
    await db.delete("medicamentos", where: "id = ?", whereArgs: [id]);
  }

  // ==================== CUIDADOS ====================
  static Future<int> insertarCuidado(int familiarId, String descripcion) async {
    final db = await getDB();
    return db.insert("cuidados", {"familiar_id": familiarId, "descripcion": descripcion});
  }

  static Future<List<Map<String, dynamic>>> getCuidados(int familiarId) async {
    final db = await getDB();
    return db.query("cuidados", where: "familiar_id = ?", whereArgs: [familiarId]);
  }

  // ==================== ALIMENTACION ====================
  static Future<int> insertarAlimentacion(int familiarId, String descripcion) async {
    final db = await getDB();
    return db.insert("alimentacion", {"familiar_id": familiarId, "descripcion": descripcion});
  }

  static Future<List<Map<String, dynamic>>> getAlimentacion(int familiarId) async {
    final db = await getDB();
    return db.query("alimentacion", where: "familiar_id = ?", whereArgs: [familiarId]);
  }

  // ==================== DURACIONES ====================
  static Future<int> insertarDuracion(int familiarId, String fechaInicio, String fechaFin) async {
    final db = await getDB();
    return db.insert("duraciones", {
      "familiar_id": familiarId,
      "fecha_inicio": fechaInicio,
      "fecha_fin": fechaFin,
    });
  }

  static Future<List<Map<String, dynamic>>> getDuraciones(int familiarId) async {
    final db = await getDB();
    return db.query("duraciones", where: "familiar_id = ?", whereArgs: [familiarId]);
  }
}
