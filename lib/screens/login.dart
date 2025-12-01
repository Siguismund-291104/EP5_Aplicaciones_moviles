import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mi_receta/screens/registro.dart';
import 'package:mi_receta/widgets/nav1.dart';
import 'package:mi_receta/alertas/alerta_campos.dart';
import 'package:mi_receta/provider/mireceta_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _aceptoTerminos = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      AlertaCampos.mostrar(context, 'Por favor, llena todos los campos.');
      return;
    }

    final provider = Provider.of<RecetasProvider>(context, listen: false);

    // Llamamos al método login del provider
    final usuario = await provider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (usuario != null) {
      // Guardar usuario actual en el provider
      provider.setUsuarioActual(usuario);

      // Redirigir a HomeNav
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeNav()),
      );
    } else {
      AlertaCampos.mostrar(context, 'Usuario o contraseña incorrectos.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Iniciar sesión',
                  style: GoogleFonts.assistant(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),

                // Email
                TextField(
                  controller: _emailController,
                  decoration: _campo('Correo electrónico'),
                ),
                const SizedBox(height: 20),

                // Contraseña
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _campo('Contraseña'),
                ),
                const SizedBox(height: 15),

                // Checkbox de términos
                Row(
                  children: [
                    Checkbox(
                      value: _aceptoTerminos,
                      activeColor: const Color(0xFF14AE5C),
                      onChanged: (value) {
                        setState(() {
                          _aceptoTerminos = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Acepto los términos y condiciones',
                        style: GoogleFonts.assistant(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Botón de login
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _aceptoTerminos ? _login : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _aceptoTerminos
                          ? const Color(0xFF0088FF)
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Iniciar sesión',
                      style: GoogleFonts.assistant(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Ir a registro
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Registro()),
                    );
                  },
                  child: Text(
                    '¿No tienes una cuenta? Regístrate',
                    style: GoogleFonts.assistant(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0088FF),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _campo(String texto) {
    return InputDecoration(
      hintText: texto,
      hintStyle: GoogleFonts.assistant(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF96A7AF),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF96A7AF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF96A7AF)),
      ),
    );
  }
}

