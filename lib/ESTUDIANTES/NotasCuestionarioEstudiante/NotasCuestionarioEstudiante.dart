/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotasCuestionarioEstudiante extends StatefulWidget {
  final String idUsuario;
  final String idCuestionario;

  NotasCuestionarioEstudiante({Key? key, required this.idUsuario, required this.idCuestionario})
      : super(key: key);

  @override
  _NotasCuestionarioEstudianteState createState() =>
      _NotasCuestionarioEstudianteState();
}

class _NotasCuestionarioEstudianteState
    extends State<NotasCuestionarioEstudiante> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nota de tu Cuestionario'),
        backgroundColor: Colors.lightGreen,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('ResultadoCuestionarioEstudiante')
            .where('idUsuario', isEqualTo: widget.idUsuario)
            .where('idCuestionario', isEqualTo: widget.idCuestionario) // Filtrar por ID del cuestionario
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
              var nombreCuestionario = ''; // Inicialmente vacío
              var imageToShow =
                  'images/enhorabuena.png'; // Ruta de la imagen por defecto

              // Obtener el nombre del cuestionario de forma asíncrona
              return FutureBuilder<DocumentSnapshot>(
                future: _firestore
                    .collection('Cuestionario')
                    .doc(resultado['idCuestionario'])
                    .get(),
                builder: (context, examSnapshot) {
                  if (examSnapshot.connectionState == ConnectionState.done &&
                      examSnapshot.data != null) {
                    nombreCuestionario = examSnapshot.data!['nombre'];
                  }
                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 3,
                    color: Colors.blueAccent,
                    child: ListTile(
                      title: Text(
                        nombreCuestionario,
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

class NotasCuestionarioEstudiante extends StatefulWidget {
  final String idUsuario;
  final String idCuestionario;

  NotasCuestionarioEstudiante({Key? key, required this.idUsuario, required this.idCuestionario})
      : super(key: key);

  @override
  _NotasCuestionarioEstudianteState createState() =>
      _NotasCuestionarioEstudianteState();
}

class _NotasCuestionarioEstudianteState
    extends State<NotasCuestionarioEstudiante> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nota de tu Cuestionario'),
        backgroundColor: Colors.lightGreen,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('ResultadoCuestionarioEstudiante')
            .where('idUsuario', isEqualTo: widget.idUsuario)
            .where('idCuestionario', isEqualTo: widget.idCuestionario) // Filtrar por ID del cuestionario
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
              var nombreCuestionario = ''; // Inicialmente vacío
              var imageToShow =
                  'images/enhorabuena.png'; // Ruta de la imagen por defecto

              // Obtener el nombre del cuestionario de forma asíncrona
              return FutureBuilder<DocumentSnapshot>(
                future: _firestore
                    .collection('Cuestionario')
                    .doc(resultado['idCuestionario'])
                    .get(),
                builder: (context, examSnapshot) {
                  if (examSnapshot.connectionState == ConnectionState.done &&
                      examSnapshot.data != null) {
                    nombreCuestionario = examSnapshot.data!['nombre'];
                  }
                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 3,
                    color: Colors.blueAccent,
                    child: ListTile(
                      title: Text(
                        nombreCuestionario,
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
