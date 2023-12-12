/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotasCuestionarioEstudiante extends StatefulWidget {
  final String idUsuario;

  NotasCuestionarioEstudiante({Key? key, required this.idUsuario})
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
        title: Text('Notas de tus Cuestionario'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('ResultadoCuestionarioEstudiante')
            .where('idUsuario', isEqualTo: widget.idUsuario)
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

              // Obtener el nombre del examen de forma asíncrona
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
                  return ListTile(
                    title: Text(nombreCuestionario),
                    subtitle: Text('Fecha: $fecha\nPuntaje: $puntajeTotal'),
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

  NotasCuestionarioEstudiante({Key? key, required this.idUsuario})
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
        title: Text('Notas de tus Cuestionarios'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('ResultadoCuestionarioEstudiante')
            .where('idUsuario', isEqualTo: widget.idUsuario)
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

              // Obtener el nombre del examen de forma asíncrona
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
                  return ListTile(
                    title: Text(nombreCuestionario),
                    subtitle: Text('Fecha: $fecha\nPuntaje: $puntajeTotal'),
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
