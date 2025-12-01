import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mi_receta/provider/mireceta_provider.dart';
import 'package:mi_receta/screens/login.dart';
import 'package:mi_receta/widgets/nav1.dart';
import 'package:mi_receta/alertas/alerta_campos.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repetirController = TextEditingController();

  bool _aceptoTerminos = false;
  String? _foto; // ruta de la foto seleccionada

  Future<void> _seleccionarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _foto = image.path;
      });
    }
  }

  void _registrar() async {
  if (_nombreController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _repetirController.text.isEmpty) {
    AlertaCampos.mostrar(context, 'Por favor, llena todos los campos.');
    return;
  }

  if (_passwordController.text != _repetirController.text) {
    AlertaCampos.mostrar(context, 'Las contraseñas no coinciden.');
    return;
  }

  if (!_aceptoTerminos) {
    AlertaCampos.mostrar(context, 'Debes aceptar los términos y condiciones.');
    return;
  }

  if (_foto == null) {
    AlertaCampos.mostrar(context, 'Debes seleccionar una foto de perfil.');
    return;
  }

  final provider = Provider.of<RecetasProvider>(context, listen: false);

  // Crear usuario
  await provider.agregarUsuario(
    _nombreController.text,
    _emailController.text,
    _passwordController.text,
    foto: _foto,
  );

  // Recuperar el usuario recién creado
  final usuario = provider.usuarios.firstWhere(
    (u) => u['email'] == _emailController.text,
  );

  // Guardarlo como usuario actual
  provider.setUsuarioActual(usuario);

  // Ir al HomeNav
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomeNav()),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                'Registro',
                style: GoogleFonts.assistant(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),

              // Foto de perfil
              GestureDetector(
                onTap: _seleccionarFoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _foto != null ? FileImage(File(_foto!)) : null,
                  child: _foto == null
                      ? const Icon(Icons.add_a_photo, size: 40, color: Colors.white)
                      : null,
                  backgroundColor: const Color(0xFF96A7AF),
                ),
              ),
              const SizedBox(height: 20),

              // Nombre
              TextField(
                controller: _nombreController,
                decoration: _campo('Nombre completo'),
              ),
              const SizedBox(height: 15),

              // Email
              TextField(
                controller: _emailController,
                decoration: _campo('Correo electrónico'),
              ),
              const SizedBox(height: 15),

              // Contraseña
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _campo('Contraseña'),
              ),
              const SizedBox(height: 15),

              // Repetir contraseña
              TextField(
                controller: _repetirController,
                obscureText: true,
                decoration: _campo('Repite la contraseña'),
              ),
              const SizedBox(height: 20),

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
              const SizedBox(height: 10),

              // Botón de registro
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _aceptoTerminos ? _registrar : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088FF),
                    disabledBackgroundColor: const Color(0xFF96A7AF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Registrarse',
                    style: GoogleFonts.assistant(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Link a login
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  '¿Ya tienes una cuenta? Inicia sesión',
                  style: GoogleFonts.assistant(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0088FF),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
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