class Alumno {
  String nombre;
  String carrera;
  double c1;
  double c2;
  double c3;
  double c4;

  Alumno({
    required this.nombre,
    required this.carrera,
    required this.c1,
    required this.c2,
    required this.c3,
    required this.c4,
  });

  double get promedio => (c1 + c2 + c3 + c4) / 4;

  bool get aprobado => promedio >= 70;
}
