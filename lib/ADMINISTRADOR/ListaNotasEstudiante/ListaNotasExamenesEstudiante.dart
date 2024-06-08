/*DESCARGA Y MUESTRA DE NOTAS POR ALUMNO FORMATO PDF FUNCIONANDO PARCIALMENTE*/

/*
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

class ListaNotasExamenEstudiante extends StatefulWidget {
  @override
  _ListaNotasExamenEstudianteState createState() =>
      _ListaNotasExamenEstudianteState();
}

class _ListaNotasExamenEstudianteState
    extends State<ListaNotasExamenEstudiante> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Uint8List> generatePdfTotal(List<DocumentSnapshot> resultados) async {
    final pdf = pdfLib.Document();

    for (var resultado in resultados) {
      var userId = resultado['idUsuario'] as String? ?? '';
      var examenId = resultado['idExamen'] as String? ?? '';

      var userSnapshot = await _firestore.collection('users').doc(userId).get();
      var userData = userSnapshot.data() as Map<String, dynamic>?;

      var displayName = userData?['display_name'] ?? 'Anónimo';
      var gender = userData?['gender'] ?? 'Masculino';
      var photoUrl =
          gender == 'Masculino' ? 'images/chico.png' : 'images/leyendo.png';

      var examenSnapshot =
          await _firestore.collection('Examen').doc(examenId).get();
      var examenData = examenSnapshot.data() as Map<String, dynamic>?;

      var nombreExamen = examenData?['nombre'] ?? 'Desconocido';

      final response = await http.get(Uri.parse(photoUrl));
      final Uint8List imageData = response.bodyBytes;

      pdf.addPage(
        pdfLib.Page(
          build: (context) {
            return pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Image(
                  pdfLib.MemoryImage(imageData),
                  width: 100,
                  height: 100,
                ),
                pdfLib.Text('Nombre: $displayName'),
                pdfLib.Text('Examen: $nombreExamen'),
                pdfLib.Text('Puntaje: ${resultado['puntajeTotal']}'),
                pdfLib.Text(
                  'Fecha: ${DateFormat('dd/MM/yyyy').format((resultado['fecha'] as Timestamp).toDate())}',
                ),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  Future<Uint8List> generatePdfPorEstudiante(
      String displayName,
      String nombreExamen,
      String puntajeTotal,
      String fecha,
      String photoUrl) async {
    final pdf = pdfLib.Document();

    // Descargar la imagen
    final response = await http.get(Uri.parse(photoUrl));
    final Uint8List imageData = response.bodyBytes;

    pdf.addPage(
      pdfLib.Page(
        build: (context) {
          return pdfLib.Column(
            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
            children: [
              pdfLib.Image(
                pdfLib.MemoryImage(imageData),
                width: 100,
                height: 100,
              ),
              pdfLib.Text('Nombre: $displayName'),
              pdfLib.Text('Examen: $nombreExamen'),
              pdfLib.Text('Puntaje: $puntajeTotal'),
              pdfLib.Text('Fecha: $fecha'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  void downloadFile(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Notas de Exámenes'),
            SizedBox(width: 8), // Espacio entre el texto y el botón
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () async {
                var snapshot = await _firestore
                    .collection('ResultadoExamenEstudiante')
                    .get();
                var resultados = snapshot.docs;
                var pdfBytes = await generatePdfTotal(resultados);
                downloadFile(pdfBytes, 'notas_examenes.pdf');
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('ResultadoExamenEstudiante').snapshots(),
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

                  var gender = userData?['gender'] ??
                      'Masculino'; // Asumo que el campo se llama 'gender'

                  var photoUrl = gender == 'Masculino'
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
                          trailing: IconButton(
                            icon: Icon(Icons.file_download),
                            onPressed: () async {
                              var pdfBytes = await generatePdfPorEstudiante(
                                  displayName,
                                  nombreExamen,
                                  puntajeTotal,
                                  fecha,
                                  photoUrl);
                              downloadFile(pdfBytes, 'notas_examen_$index.pdf');
                            },
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

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

class ListaNotasExamenEstudiante extends StatefulWidget {
  final String? idExamen; // Cambio aquí

  ListaNotasExamenEstudiante(
      {Key? key, this.idExamen})
      : super(key: key);
  @override
  _ListaNotasExamenEstudianteState createState() =>
      _ListaNotasExamenEstudianteState();
}

class _ListaNotasExamenEstudianteState
    extends State<ListaNotasExamenEstudiante> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Uint8List> generatePdfTotal(List<DocumentSnapshot> resultados) async {
    final pdf = pdfLib.Document();

    for (var resultado in resultados) {
      var userId = resultado['idUsuario'] as String? ?? '';
      var examenId = resultado['idExamen'] as String? ?? '';

      var userSnapshot = await _firestore.collection('users').doc(userId).get();
      var userData = userSnapshot.data() as Map<String, dynamic>?;

      var displayName = userData?['display_name'] ?? 'Anónimo';
      var gender = userData?['gender'] ?? 'Masculino';
      var photoUrl =
          gender == 'Masculino' ? 'images/chico.png' : 'images/leyendo.png';

      var examenSnapshot =
          await _firestore.collection('Examen').doc(examenId).get();
      var examenData = examenSnapshot.data() as Map<String, dynamic>?;

      var nombreExamen = examenData?['nombre'] ?? 'Desconocido';

      final response = await http.get(Uri.parse(photoUrl));
      final Uint8List imageData = response.bodyBytes;

      pdf.addPage(
        pdfLib.Page(
          build: (context) {
            return pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Image(
                  pdfLib.MemoryImage(imageData),
                  width: 100,
                  height: 100,
                ),
                pdfLib.Text('Nombre: $displayName'),
                pdfLib.Text('Examen: $nombreExamen'),
                pdfLib.Text('Puntaje: ${resultado['puntajeTotal']}'),
                pdfLib.Text(
                  'Fecha: ${DateFormat('dd/MM/yyyy').format((resultado['fecha'] as Timestamp).toDate())}',
                ),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  Future<Uint8List> generatePdfPorEstudiante(
      String displayName,
      String nombreExamen,
      String puntajeTotal,
      String fecha,
      String photoUrl) async {
    final pdf = pdfLib.Document();

    // Descargar la imagen
    final response = await http.get(Uri.parse(photoUrl));
    final Uint8List imageData = response.bodyBytes;

    pdf.addPage(
      pdfLib.Page(
        build: (context) {
          return pdfLib.Column(
            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
            children: [
              pdfLib.Image(
                pdfLib.MemoryImage(imageData),
                width: 100,
                height: 100,
              ),
              pdfLib.Text('Nombre: $displayName'),
              pdfLib.Text('Examen: $nombreExamen'),
              pdfLib.Text('Puntaje: $puntajeTotal'),
              pdfLib.Text('Fecha: $fecha'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  void downloadFile(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Notas de Exámenes'),
            SizedBox(width: 8), // Espacio entre el texto y el botón
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              /*onPressed: () async {
                var snapshot = await _firestore
                    .collection('ResultadoExamenEstudiante')
                    .get();
                var resultados = snapshot.docs;
                var pdfBytes = await generatePdfTotal(resultados);
                downloadFile(pdfBytes, 'notas_examenes.pdf');
              },*/
              onPressed: () async {
                var snapshot = await _firestore
                    .collection('ResultadoExamenEstudiante')
                    .where('idExamen',
                        isEqualTo: widget.idExamen) // Cambio aquí
                    .get();
                var resultados = snapshot.docs;
                var pdfBytes = await generatePdfTotal(resultados);
                downloadFile(pdfBytes, 'notas_examenes.pdf');
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('ResultadoExamenEstudiante')
        .where('idExamen', isEqualTo: widget.idExamen)  // Cambio aquí
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

              var userId = resultado['idUsuario'] as String? ?? '';
              var examenId = resultado['idExamen'] as String? ?? '';

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) return SizedBox();

                  var userData =
                      userSnapshot.data!.data() as Map<String, dynamic>?;
                  var displayName = userData?['display_name'] ?? 'Anónimo';

                  var gender = userData?['gender'] ??
                      'Masculino'; // Asumo que el campo se llama 'gender'

                  var photoUrl = gender == 'Masculino'
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
                          trailing: IconButton(
                            icon: Icon(Icons.file_download),
                            onPressed: () async {
                              var pdfBytes = await generatePdfPorEstudiante(
                                  displayName,
                                  nombreExamen,
                                  puntajeTotal,
                                  fecha,
                                  photoUrl);
                              downloadFile(pdfBytes, 'notas_examen_$index.pdf');
                            },
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