/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotasExamenEstudiante extends StatefulWidget {
  final String idUsuario;

  NotasExamenEstudiante({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _NotasExamenEstudianteState createState() => _NotasExamenEstudianteState();
}

class _NotasExamenEstudianteState extends State<NotasExamenEstudiante> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas de tus Examenes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('ResultadoExamenEstudiante')
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
              var nombreExamen = ''; // Inicialmente vacío

              // Obtener el nombre del examen de forma asíncrona
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
                  return ListTile(
                    title: Text(nombreExamen),
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

class NotasExamenEstudiante extends StatefulWidget {
  final String idUsuario;

  NotasExamenEstudiante({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _NotasExamenEstudianteState createState() => _NotasExamenEstudianteState();
}

class _NotasExamenEstudianteState extends State<NotasExamenEstudiante> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas de tus Examenes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('ResultadoExamenEstudiante')
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
              var nombreExamen = ''; // Inicialmente vacío

              // Obtener el nombre del examen de forma asíncrona
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
                  return ListTile(
                    title: Text(nombreExamen),
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
