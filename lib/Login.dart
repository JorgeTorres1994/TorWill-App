/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Dashboard_Profesor/dashboard_profesor.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF92A8D1), // Azul suave
                Color(0xFFD4A5A5), // Rosa suave
                Colors.white,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF92A8D1), // Azul suave
              Color(0xFFD4A5A5), // Rosa suave
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Sección de Imagen
                Image.asset(
                  'images/leyendo.png',
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 8),

                // Sección de Texto Referencial
                const Text(
                  'Inicio de Sesión',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),

                // Sección de Inicio de Sesión
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    if (email.isNotEmpty && password.isNotEmpty) {
                      await _signInWithEmailAndPassword(
                          context, context, email, password);
                    } else {
                      _showMessage(
                          context, 'Por favor, completa todos los campos.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Iniciar Sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context,
      BuildContext navContext, String email, String password) async {
    try {
      // Iniciar sesión con Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // El usuario ha iniciado sesión exitosamente
      print('Usuario autenticado: ${userCredential.user?.email}');

      // Muestra un mensaje de éxito
      _showMessage(context, 'Inicio de sesión exitoso');

      // Navegar al Dashboard usando Navigator.push
      Navigator.pushReplacement(
        navContext,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } catch (e) {
      // Si hay un error al iniciar sesión, puedes manejarlo aquí
      print('Error al iniciar sesión: $e');

      // Muestra un mensaje de error
      _showMessage(
          context, 'Error al iniciar sesión. Verifica tus credenciales.');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Dashboard_Profesor/dashboard_profesor.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/dashboard_estudiante.dart';
import 'package:nueva_app_web_matematicas/forgot_password_page.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF92A8D1), // Azul suave
                Color(0xFFD4A5A5), // Rosa suave
                Colors.white,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF92A8D1), // Azul suave
              Color(0xFFD4A5A5), // Rosa suave
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Sección de Imagen
                Image.asset(
                  'images/gorra.png',
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 8),

                // Sección de Texto Referencial
                const Text(
                  'Inicio de Sesión',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),

                // Sección de Inicio de Sesión
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    if (email.isNotEmpty && password.isNotEmpty) {
                      await _signInWithEmailAndPassword(
                          context, context, email, password);
                    } else {
                      _showMessage(
                          context, 'Por favor, completa todos los campos.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Iniciar Sesión'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const RecuperarPasswordScreen();
                          }));
                        },
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          //style: TextStyle(color: Colors.grey[600]),
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context,
      BuildContext navContext, String email, String password) async {
    try {
      // Iniciar sesión con Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtener datos adicionales del usuario
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        var isAdmin = userData['isAdmin'] ?? false;

        // El usuario ha iniciado sesión exitosamente
        print('Usuario autenticado: ${user.email}, isAdmin: $isAdmin');

        // Muestra un mensaje de éxito
        _showMessage(context, 'Inicio de sesión exitoso');

        // Redirige al Dashboard o DashboardEstudiante
        if (isAdmin) {
          Navigator.pushReplacement(
              navContext, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          Navigator.pushReplacement(navContext,
              MaterialPageRoute(builder: (context) => DashboardEstudiante()));
        }
      }
    } catch (e) {
      // Si hay un error al iniciar sesión, puedes manejarlo aquí
      print('Error al iniciar sesión: $e');

      // Muestra un mensaje de error
      _showMessage(
          context, 'Error al iniciar sesión. Verifica tus credenciales.');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
