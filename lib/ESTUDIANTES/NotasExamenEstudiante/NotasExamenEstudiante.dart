/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotasExamenEstudiante extends StatefulWidget {
  final String idUsuario;
  final String idExamen;

  NotasExamenEstudiante(
      {Key? key, required this.idUsuario, required this.idExamen})
      : super(key: key);

  @override
  _NotasExamenEstudianteState createState() => _NotasExamenEstudianteState();
}

class _NotasExamenEstudianteState extends State<NotasExamenEstudiante> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas de tus Exámenes'),
        backgroundColor: Colors.lightGreen,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('ResultadoExamenEstudiante')
            .where('idUsuario', isEqualTo: widget.idUsuario)
            .where('idExamen',
                isEqualTo: widget.idExamen) // Filtrar por ID del examen
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
              var nombreExamen = ''; // Inicialmente vacío

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore
                    .collection('Examen')
                    .doc(resultado['idExamen'])
                    .get(),
                builder: (context, examSnapshot) {
                  if (examSnapshot.connectionState == ConnectionState.done &&
                      examSnapshot.data != null) {
                    nombreExamen = examSnapshot.data!['nombre'];
                  }
                  var imageToShow =
                      'images/enhorabuena.png'; // Ruta de la imagen

                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 3,
                    color: Colors.blueAccent,
                    child: ListTile(
                      title: Text(
                        nombreExamen,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            'Puntaje: $puntajeTotal',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Fecha: $fecha',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      trailing: Container(
                        width: 90, // Ajusta el ancho según tus preferencias
                        height:
                            double.infinity, // Ocupa todo el alto disponible
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            imageToShow,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
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

class NotasExamenEstudiante extends StatefulWidget {
  final String idUsuario;
  final String idExamen;

  NotasExamenEstudiante(
      {Key? key, required this.idUsuario, required this.idExamen})
      : super(key: key);

  @override
  _NotasExamenEstudianteState createState() => _NotasExamenEstudianteState();
}

class _NotasExamenEstudianteState extends State<NotasExamenEstudiante> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas de tus Exámenes'),
        backgroundColor: Colors.lightGreen,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('ResultadoExamenEstudiante')
            .where('idUsuario', isEqualTo: widget.idUsuario)
            .where('idExamen',
                isEqualTo: widget.idExamen) // Filtrar por ID del examen
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
              /*var fecha = DateFormat('dd/MM/yyyy')
                  .format((resultado['fecha'] as Timestamp).toDate());*/
              var puntajeTotal = resultado['puntajeTotal'].toString();
              var nombreExamen = ''; // Inicialmente vacío

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore
                    .collection('Examen')
                    .doc(resultado['idExamen'])
                    .get(),
                builder: (context, examSnapshot) {
                  if (examSnapshot.connectionState == ConnectionState.done &&
                      examSnapshot.data != null) {
                    nombreExamen = examSnapshot.data!['nombre'];
                  }
                  var imageToShow =
                      'images/enhorabuena.png'; // Ruta de la imagen

                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 3,
                    color: Colors.blueAccent,
                    child: ListTile(
                      title: Text(
                        nombreExamen,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            'Puntaje: $puntajeTotal',
                            style: TextStyle(color: Colors.white),
                          ),
                          /*Text(
                            'Fecha: $fecha',
                            style: TextStyle(color: Colors.white),
                          ),*/
                        ],
                      ),
                      trailing: Container(
                        width: 90, // Ajusta el ancho según tus preferencias
                        height:
                            double.infinity, // Ocupa todo el alto disponible
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            imageToShow,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
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