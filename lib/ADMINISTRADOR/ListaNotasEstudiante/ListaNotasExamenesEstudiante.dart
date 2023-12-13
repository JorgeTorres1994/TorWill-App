/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ListaNotasExamenEstudiante extends StatefulWidget {
  final String? idUsuario;

  ListaNotasExamenEstudiante({Key? key, this.idUsuario}) : super(key: key);

  @override
  _ListaNotasExamenEstudianteState createState() =>
      _ListaNotasExamenEstudianteState();
}

class _ListaNotasExamenEstudianteState
    extends State<ListaNotasExamenEstudiante> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas de Exámenes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.idUsuario != null
            ? _firestore
                .collection('ResultadoExamenEstudiante')
                .where('idUsuario', isEqualTo: widget.idUsuario)
                .snapshots()
            : _firestore.collection('ResultadoExamenEstudiante').snapshots(),
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

              var userId = resultado['idUsuario'] as String? ?? '';
              var examenId = resultado['idExamen'] as String? ?? '';

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) return SizedBox();

                  var userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;
                  var displayName = userData?['display_name'] ?? 'Anónimo';
                  var photoUrl = userData?['photo_url'] ?? 'images/chico.png';

                  return FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('Examen').doc(examenId).get(),
                    builder: (context, examenSnapshot) {
                      if (!examenSnapshot.hasData) return SizedBox();

                      var examenData =
                          examenSnapshot.data!.data() as Map<String, dynamic>?;
                      var nombreExamen = examenData?['nombre'] ?? 'Desconocido';

                      return Card(
                        elevation: 3, // Añadir sombra
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(photoUrl),
                            backgroundColor: Colors.grey,
                          ),
                          title: Text(
                            displayName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                nombreExamen,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Puntaje: $puntajeTotal'),
                              Text('Fecha: $fecha'),
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

*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ListaNotasExamenEstudiante extends StatefulWidget {
  final String? idUsuario;

  ListaNotasExamenEstudiante({Key? key, this.idUsuario}) : super(key: key);

  @override
  _ListaNotasExamenEstudianteState createState() =>
      _ListaNotasExamenEstudianteState();
}

class _ListaNotasExamenEstudianteState
    extends State<ListaNotasExamenEstudiante> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas de Exámenes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.idUsuario != null
            ? _firestore
                .collection('ResultadoExamenEstudiante')
                .where('idUsuario', isEqualTo: widget.idUsuario)
                .snapshots()
            : _firestore.collection('ResultadoExamenEstudiante').snapshots(),
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

              var userId = resultado['idUsuario'] as String? ?? '';
              var examenId = resultado['idExamen'] as String? ?? '';

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) return SizedBox();

                  var userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;
                  var displayName = userData?['display_name'] ?? 'Anónimo';
                  var gender = userData?['gender'] ?? '';

                  // Determinar la ruta de la imagen según el gender
                  var imageAssetPath = gender == 'Masculino'
                      ? 'images/chico.png'
                      : 'images/leyendo.png';

                  return FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('Examen').doc(examenId).get(),
                    builder: (context, examenSnapshot) {
                      if (!examenSnapshot.hasData) return SizedBox();

                      var examenData =
                          examenSnapshot.data!.data() as Map<String, dynamic>?;
                      var nombreExamen = examenData?['nombre'] ?? 'Desconocido';

                      return Card(
                        elevation: 3,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(imageAssetPath),
                          ),
                          title: Text(
                            displayName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                nombreExamen,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Puntaje: $puntajeTotal'),
                              Text('Fecha: $fecha'),
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
