import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_alumnos/main.dart';

void main() {
  testWidgets('La aplicación inicia correctamente',
      (WidgetTester tester) async {
    // Build de la app
    await tester.pumpWidget(const MyApp());

    // Verifica que la pantalla de inicio cargó
    expect(find.text('Gestor de Alumnos'), findsOneWidget);

    // Verifica que el formulario está presente
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Carrera'), findsOneWidget);
  });
}
