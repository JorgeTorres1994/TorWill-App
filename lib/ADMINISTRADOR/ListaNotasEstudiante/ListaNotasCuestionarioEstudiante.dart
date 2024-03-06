/*import 'package:flutter/material.dart';
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
                  var gender = userData?['gender'] ??
                      'Masculino'; // Asumo que el campo se llama 'gender'

                  // Cambia la URL de la foto según el género
                  var photoUrl = gender == 'Masculino'
                      ? 'images/chico.png'
                      : 'images/leyendo.png';

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
*/

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

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

  Future<Uint8List> generatePdfTotal(List<DocumentSnapshot> resultados) async {
    final pdf = pdfLib.Document();

    for (var resultado in resultados) {
      var userId = resultado['idUsuario'] as String? ?? '';
      var cuestionarioId = resultado['idCuestionario'] as String? ?? '';

      var userSnapshot = await _firestore.collection('users').doc(userId).get();
      var userData = userSnapshot.data() as Map<String, dynamic>?;

      var displayName = userData?['display_name'] ?? 'Anónimo';
      var gender = userData?['gender'] ?? 'Masculino';
      var photoUrl =
          gender == 'Masculino' ? 'images/chico.png' : 'images/leyendo.png';

      var cuestionarioSnapshot =
          await _firestore.collection('Cuestionario').doc(cuestionarioId).get();
      var cuestionarioData = cuestionarioSnapshot.data() as Map<String, dynamic>?;

      var nombreCuestionario = cuestionarioData?['nombre'] ?? 'Desconocido';

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
                pdfLib.Text('Cuestionario: $nombreCuestionario'),
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
      String nombreCuestionario,
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
              pdfLib.Text('Cuestionario: $nombreCuestionario'),
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
        //title: Text('Notas de Cuestionarios'),
        title: Row(
          children: [
            Text('Notas de Cuestionarios'),
            SizedBox(width: 8), // Espacio entre el texto y el botón
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () async {
                var snapshot = await _firestore
                    .collection('ResultadoCuestionarioEstudiante')
                    .get();
                var resultados = snapshot.docs;
                var pdfBytes = await generatePdfTotal(resultados);
                downloadFile(pdfBytes, 'notas_cuestionario.pdf');
              },
            ),
          ],
        ),
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
                  var gender = userData?['gender'] ??
                      'Masculino'; // Asumo que el campo se llama 'gender'

                  // Cambia la URL de la foto según el género
                  var photoUrl = gender == 'Masculino'
                      ? 'images/chico.png'
                      : 'images/leyendo.png';

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
                          trailing: IconButton(
                            icon: Icon(Icons.file_download),
                            onPressed: () async {
                              var pdfBytes = await generatePdfPorEstudiante(
                                  displayName,
                                  nombreCuestionario,
                                  puntajeTotal,
                                  fecha,
                                  photoUrl);
                              downloadFile(pdfBytes, 'notas_cuestionario_$index.pdf');
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
