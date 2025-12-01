import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../screens/alimentos.dart';
import '../screens/cuidados.dart';
import '../screens/detalle_familiar.dart';
import '../provider/mireceta_provider.dart';

class Nav2 extends StatefulWidget {
  final String nombre;
  final String padecimiento;
  final String foto;
  final int familiarId;

  const Nav2({
    super.key,
    required this.nombre,
    required this.padecimiento,
    required this.foto,
    required this.familiarId,
  });

  @override
  State<Nav2> createState() => _Nav2State();
}

class _Nav2State extends State<Nav2> {
  int _selectedIndex = 1;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // carga de datos (se queda como lo tenías)
    final recetasProvider = Provider.of<RecetasProvider>(context, listen: false);
    recetasProvider.cargarDatos(familiarId: widget.familiarId);

    _screens = [
      AlimentacionPage(
        familiarId: widget.familiarId,
      ),
     DetalleFamiliarPage(),
      CuidadosPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.restaurant_menu_rounded, 'Alimentación', 0),
            _buildNavItem(Icons.medical_services_rounded, 'Medicación', 1),
            _buildNavItem(Icons.health_and_safety_rounded, 'Cuidados', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF14AE5C).withOpacity(0.09)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF14AE5C)
                  : const Color(0xFF96A7AF),
              size: 28,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.assistant(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF14AE5C)
                  : const Color(0xFF96A7AF),
            ),
          ),
        ],
      ),
    );
  }
}
