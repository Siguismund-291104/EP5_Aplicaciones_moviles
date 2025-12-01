import 'package:flutter/material.dart';
import '../models/alumno.dart';

class AlumnosProvider extends ChangeNotifier {
  final List<Alumno> _lista = [];

  List<Alumno> get alumnos => _lista;

  void agregarAlumno(Alumno alumno) {
    _lista.add(alumno);
    notifyListeners();
  }

  void limpiarLista() {
    _lista.clear();
    notifyListeners();
  }
}
