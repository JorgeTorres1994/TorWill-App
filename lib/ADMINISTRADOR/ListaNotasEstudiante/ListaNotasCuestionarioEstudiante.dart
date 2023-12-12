/*import 'package:app_web_matematicas_v7/form_estudiante/NotasCuestionarioEstudiante/NotasCuestionarioEstudiante.dart';
import 'package:app_web_matematicas_v7/form_estudiante/NotasExamenEstudiante/NotasExamenEstudiante.dart';
import 'package:flutter/material.dart';

class NotasScreen extends StatelessWidget {
  final String userId;

  NotasScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una opción'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Cuestionarios'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        NotasCuestionarioEstudiante(idUsuario: userId),
                  ),
                );
              },
            ),
            SizedBox(height: 20), // Espacio entre botones
            ElevatedButton(
              child: Text('Exámenes'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        NotasExamenEstudiante(idUsuario: userId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ListaNotasCuestionarioEstudiante extends StatefulWidget {
  final String? idUsuario;

  ListaNotasCuestionarioEstudiante({Key? key, this.idUsuario})
      : super(key: key);

  @override
  _ListaNotasCuestionarioEstudianteState createState() =>
      _ListaNotasCuestionarioEstudianteState();
}

class _ListaNotasCuestionarioEstudianteState
    extends State<ListaNotasCuestionarioEstudiante> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas de Cuestionarios'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.idUsuario != null
            ? _firestore
                .collection('ResultadoCuestionarioEstudiante')
                .where('idUsuario', isEqualTo: widget.idUsuario)
                .snapshots()
            : _firestore
                .collection('ResultadoCuestionarioEstudiante')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay resultados disponibles.'));
          }

          List<DocumentSnapshot> resultados = snapshot.data!.docs;

          return ListView.builder(
            itemCount: resultados.length,
            itemBuilder: (context, index) {
              var resultado = resultados[index];
              var fecha = DateFormat('dd/MM/yyyy')
                  .format((resultado['fecha'] as Timestamp).toDate());
              var puntajeTotal = resultado['puntajeTotal'].toString();

              // Manejar nulos para evitar excepciones
              var userId = resultado['idUsuario'] as String? ?? '';
              var cuestionarioId = resultado['idCuestionario'] as String? ?? '';

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) return SizedBox();

                  var userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;

                  // Proporcionar un valor predeterminado para el nombre de usuario
                  var displayName = userData?['display_name'] ?? 'Anónimo';
                  var photoUrl = userData?['photo_url'] ?? '';

                  return FutureBuilder<DocumentSnapshot>(
                    future: _firestore
                        .collection('Cuestionario')
                        .doc(cuestionarioId)
                        .get(),
                    builder: (context, cuestionarioSnapshot) {
                      if (!cuestionarioSnapshot.hasData) return SizedBox();

                      var cuestionarioData = cuestionarioSnapshot.data!.data()
                          as Map<String, dynamic>?;

                      // Proporcionar un valor predeterminado para el nombre del cuestionario
                      var nombreCuestionario =
                          cuestionarioData?['nombre'] ?? 'Desconocido';

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(photoUrl),
                            backgroundColor: Colors.grey,
                          ),
                          title: Text(displayName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nombreCuestionario),
                              Text('Fecha: $fecha'),
                              Text('Puntaje: $puntajeTotal'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
