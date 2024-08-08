/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PerfilEstudiante extends StatelessWidget {
  final String userId;

  PerfilEstudiante({required this.userId}) {
    // Inicializar formateo de fechas para español
    initializeDateFormatting('es');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (userSnapshot.hasError) {
            return Center(
              child: Text('Error al cargar los datos del usuario'),
            );
          } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return Center(
              child: Text('Usuario no encontrado'),
            );
          }

          var userData = userSnapshot.data!.data() as Map<String, dynamic>;

          var gender = userData['gender'] ?? 'Masculino';
          var displayName = userData['display_name'] ?? 'Usuario';
          var email = userData['email'] ?? 'Correo no disponible';
          var password = userData['password'] ?? 'Contraseña no disponible';
          var createdTimestamp = userData['created_time'] as Timestamp?;
          var createdTime = createdTimestamp != null
              ? _formatDateTime(createdTimestamp.toDate())
              : 'Fecha no disponible';

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      child: Image.asset(
                        'images/profile_background.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: AssetImage(
                            gender == 'Masculino'
                                ? 'images/chico.png'
                                : 'images/leyendo.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Estudiante',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.person, color: Colors.teal),
                          title: Text(
                            'Género',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(gender),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.email, color: Colors.teal),
                          title: Text(
                            'Correo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(email),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.lock, color: Colors.teal),
                          title: Text(
                            'Contraseña',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(password),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.date_range, color: Colors.teal),
                          title: Text(
                            'Fecha de Creación',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(createdTime),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // Formatear la fecha como 'd de MMMM 'del' y
    var formatter = DateFormat('d \'de\' MMMM \'del\' y', 'es');
    return formatter.format(dateTime);
  }
}

  String _formatDateTime(DateTime dateTime) {
    // Formatear la fecha como 'd de MMMM 'del' y
    var formatter = DateFormat('d \'de\' MMMM \'del\' y', 'es');
    return formatter.format(dateTime);
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nueva_app_web_matematicas/Login.dart';

class PerfilEstudiante extends StatelessWidget {
  final String userId;

  PerfilEstudiante({required this.userId}) {
    // Inicializar formateo de fechas para español
    initializeDateFormatting('es');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (userSnapshot.hasError) {
            return Center(
              child: Text('Error al cargar los datos del usuario'),
            );
          } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return Center(
              child: Text('Usuario no encontrado'),
            );
          }

          var userData = userSnapshot.data!.data() as Map<String, dynamic>;

          var gender = userData['gender'] ?? 'Masculino';
          var displayName = userData['display_name'] ?? 'Usuario';
          var email = userData['email'] ?? 'Correo no disponible';
          var password = userData['password'] ?? 'Contraseña no disponible';
          var createdTimestamp = userData['created_time'] as Timestamp?;
          var createdTime = createdTimestamp != null
              ? _formatDateTime(createdTimestamp.toDate())
              : 'Fecha no disponible';

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Image.asset(
                        'images/profile_background.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: AssetImage(
                            gender == 'Masculino'
                                ? 'images/chico.png'
                                : 'images/leyendo.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Estudiante',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.person, color: Colors.teal),
                          title: Text(
                            'Género',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(gender),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.email, color: Colors.teal),
                          title: Text(
                            'Correo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(email),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.lock, color: Colors.teal),
                          title: Text(
                            'Contraseña',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(password),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.date_range, color: Colors.teal),
                          title: Text(
                            'Fecha de Creación',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(createdTime),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _logout(context);
                        },
                        child: Text('Cerrar Sesión'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  void _logout(BuildContext context) async {
    try {
      // Cerrar sesión de Firebase
      await FirebaseAuth.instance.signOut();
      // Navegar a la pantalla de inicio de sesión y eliminar todas las rutas anteriores
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Reemplaza con tu pantalla de inicio de sesión
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error al cerrar sesión: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión. Inténtalo de nuevo.')),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    // Formatear la fecha como 'd de MMMM 'del' y
    var formatter = DateFormat('d \'de\' MMMM \'del\' y', 'es');
    return formatter.format(dateTime);
  }
}
