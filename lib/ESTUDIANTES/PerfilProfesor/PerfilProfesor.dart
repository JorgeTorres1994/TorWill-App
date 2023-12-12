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
      appBar: AppBar(
        title: Text('Perfil Profesor'),
      ),
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

          var userData = userSnapshot.data!.data() as Map<String, dynamic>;

          // Verificar si el usuario es un profesor (isAdmin = true)
          if (userData['isAdmin'] == true) {
            var gender = userData['gender'] ?? 'Masculino';
            var displayName = userData['display_name'] ?? 'Usuario';
            var email = userData['email'] ?? 'Correo no disponible';
            var createdTimestamp = userData['created_time'] as Timestamp?;
            var createdTime = createdTimestamp != null
                ? _formatDateTime(createdTimestamp.toDate())
                : 'Fecha no disponible';

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage(
                        gender == 'Masculino'
                            ? 'images/chico.png'
                            : 'images/leyendo.png',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Nombre: $displayName',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Género: $gender',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Correo: $email',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Fecha de Creación: $createdTime',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Si el usuario no es un profesor, puedes mostrar un mensaje o redirigir a otra pantalla.
            return Center(
              child: Text('Este usuario no es un profesor.'),
            );
          }
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    var formatter = DateFormat('d \'de\' MMMM \'del\' y', 'es');
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
      appBar: AppBar(
        title: Text('Perfil Profesor'),
      ),
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

          var userData = userSnapshot.data!.data() as Map<String, dynamic>;

          // Verificar si el usuario es un profesor (isAdmin = true)
          if (userData['isAdmin'] == true) {
            var gender = userData['gender'] ?? 'Masculino';
            var displayName = userData['display_name'] ?? 'Usuario';
            var email = userData['email'] ?? 'Correo no disponible';
            var createdTimestamp = userData['created_time'] as Timestamp?;
            var createdTime = createdTimestamp != null
                ? _formatDateTime(createdTimestamp.toDate())
                : 'Fecha no disponible';

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage(
                        gender == 'Masculino'
                            ? 'images/chico.png'
                            : 'images/leyendo.png',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Nombre: $displayName',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Género: $gender',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Correo: $email',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Fecha de Creación: $createdTime',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Si el usuario no es un profesor, puedes mostrar un mensaje o redirigir a otra pantalla.
            return Center(
              child: Text('Este usuario no es un profesor.'),
            );
          }
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    var formatter = DateFormat('d \'de\' MMMM \'del\' y', 'es');
    return formatter.format(dateTime);
  }
}
