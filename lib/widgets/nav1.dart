import 'package:flutter/material.dart';
import 'package:mi_receta/screens/formulario_receta.dart';
import 'package:mi_receta/screens/notificaciones.dart';
import '../screens/home.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();

  // Permite acceder al estado desde otros widgets
  static _HomeNavState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomeNavState>();
}

class _HomeNavState extends State<HomeNav> {
  int _selectedIndex = 1; // Por defecto: HomeScreen

  final List<Widget> _screens = const [
    FormularioRecetaScreen(),
    HomeScreen(),
    NotificacionesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void setIndex(int index) {
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
            _buildNavItem(Icons.add, 'Agregar', 0),
            _buildNavItem(Icons.home_rounded, 'Inicio', 1),
            _buildNavItem(Icons.notifications_rounded, 'Notificaciones', 2),
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
