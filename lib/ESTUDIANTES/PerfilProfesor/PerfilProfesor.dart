/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PerfilProfesor extends StatelessWidget {
  final String userId;

  PerfilProfesor({required this.userId}) {
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
              child: Text('Error al cargar los datos del profesor'),
            );
          } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return Center(
              child: Text('Profesor no encontrado'),
            );
          }

          var userData = userSnapshot.data!.data() as Map<String, dynamic>?;

          if (userData == null ||
              !userData.containsKey('isAdmin') ||
              !userData['isAdmin']) {
            return Center(
              child: Text('Este usuario no es un profesor.'),
            );
          }

          var gender = userData['gender'] ?? 'No especificado';
          var displayName = userData['display_name'] ?? 'Usuario';
          var email = userData['email'] ?? 'Correo no disponible';
          var age = userData['age']?.toString() ?? 'Edad no disponible';

          // Manejo de birthday como Timestamp o String
          var birthday;
          if (userData['birthday'] is Timestamp) {
            birthday =
                _formatDate((userData['birthday'] as Timestamp).toDate());
          } else if (userData['birthday'] is String) {
            birthday = userData[
                'birthday']; // Asume que ya está formateado correctamente
          } else {
            birthday = 'Fecha no disponible';
          }

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
                  'Profesor',
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
                          leading: Icon(Icons.cake, color: Colors.teal),
                          title: Text(
                            'Edad',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(age),
                        ),
                      ),
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
                          leading:
                              Icon(Icons.calendar_today, color: Colors.teal),
                          title: Text(
                            'Fecha de Cumpleaños',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(birthday),
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
    var formatter = DateFormat('d \'de\' MMMM \'del\' y', 'es');
    return formatter.format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    var formatter = DateFormat('d MMMM', 'es');
    return formatter.format(dateTime);
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PerfilProfesor extends StatelessWidget {
  final String userId;

  PerfilProfesor({required this.userId}) {
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
              child: Text('Error al cargar los datos del profesor'),
            );
          } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return Center(
              child: Text('Profesor no encontrado'),
            );
          }

          var userData = userSnapshot.data!.data() as Map<String, dynamic>?;

          if (userData == null ||
              !userData.containsKey('isAdmin') ||
              !userData['isAdmin']) {
            return Center(
              child: Text('Este usuario no es un profesor.'),
            );
          }

          var gender = userData['gender'] ?? 'No especificado';
          var displayName = userData['display_name'] ?? 'Usuario';
          var email = userData['email'] ?? 'Correo no disponible';
          var age = userData['age']?.toString() ?? 'Edad no disponible';

          // Manejo de birthday como Timestamp o String
          var birthday;
          if (userData['birthday'] is Timestamp) {
            birthday =
                _formatDate((userData['birthday'] as Timestamp).toDate());
          } else if (userData['birthday'] is String) {
            birthday = userData[
                'birthday']; // Asume que ya está formateado correctamente
          } else {
            birthday = 'Fecha no disponible';
          }

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
                  'Profesor',
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
                          leading: Icon(Icons.cake, color: Colors.teal),
                          title: Text(
                            'Edad',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(age),
                        ),
                      ),
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
                          leading:
                              Icon(Icons.calendar_today, color: Colors.teal),
                          title: Text(
                            'Fecha de Cumpleaños',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(birthday),
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
    var formatter = DateFormat('d \'de\' MMMM \'del\' y', 'es');
    return formatter.format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    var formatter = DateFormat('d MMMM', 'es');
    return formatter.format(dateTime);
  }
}
