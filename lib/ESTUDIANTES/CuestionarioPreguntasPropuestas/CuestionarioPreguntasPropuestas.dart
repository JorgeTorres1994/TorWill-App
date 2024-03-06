import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CuestionarioPreguntasPropuestas extends StatefulWidget {
  final Map<String, dynamic> selectedCuestionario;

  CuestionarioPreguntasPropuestas(
      {Key? key, required this.selectedCuestionario})
      : super(key: key);

  @override
  _CuestionarioPreguntasPropuestasState createState() =>
      _CuestionarioPreguntasPropuestasState();
}

class _CuestionarioPreguntasPropuestasState
    extends State<CuestionarioPreguntasPropuestas> {
  List<Map<String, dynamic>> preguntas = [];
  bool busquedaCompleta = false;
  Map<String, String?> respuestasUsuario = {};
  Map<String, bool> resultadoRespuestas = {};

  @override
  void initState() {
    super.initState();
    cargarPreguntas();
  }

  Future<void> cargarPreguntas() async {
    String? nombreCuestionario = widget.selectedCuestionario['nombre'];
    if (nombreCuestionario != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('CuestionarioPreguntas')
          .where('idCuestionario', isEqualTo: nombreCuestionario)
          .get();
      setState(() {
        busquedaCompleta = true;
        if (querySnapshot.docs.isNotEmpty) {
          preguntas = querySnapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            String preguntaId = doc.id;
            respuestasUsuario[preguntaId] = '';
            return {
              ...data,
              'id': preguntaId,
            };
          }).toList();
        } else {
          preguntas = [];
        }
      });
    } else {
      setState(() {
        busquedaCompleta = true;
      });
    }
  }

  void verificarRespuestas() async {
    int correctas = 0;
    Map<String, bool> resultadosTemporales = {};

    for (var pregunta in preguntas) {
      String? respuestaCorrecta = pregunta['respuesta'];
      String? respuestaUsuario = respuestasUsuario[pregunta['id']];
      bool esCorrecta =
          respuestaCorrecta != null && respuestaUsuario == respuestaCorrecta;
      resultadosTemporales[pregunta['id']] = esCorrecta;
      if (esCorrecta) correctas++;
    }

    setState(() {
      resultadoRespuestas = resultadosTemporales;
    });

    User? usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) {
      mostrarMensajeUsuarioNoIdentificado();
      return;
    }

    String idUsuario = usuario.uid;
    await registrarPuntajeTotal(correctas, idUsuario);

    final resultado =
        'Respondiste correctamente $correctas de ${preguntas.length} preguntas.';
    await mostrarDialogoResultado(resultado);
  }

  Future<void> registrarPuntajeTotal(int correctas, String idUsuario) async {
    String idCuestionario = widget.selectedCuestionario['id'];

    // Verificar si ya existe un resultado para este usuario y cuestionario
    var existingResult = await FirebaseFirestore.instance
        .collection('ResultadoCuestionarioEstudiante')
        .where('idUsuario', isEqualTo: idUsuario)
        .where('idCuestionario', isEqualTo: idCuestionario)
        .get();

    if (existingResult.docs.isNotEmpty) {
      // Ya existe un resultado, actualiza el puntajeTotal existente
      await existingResult.docs.first.reference.update({
        'puntajeTotal': correctas * 2, // Actualiza el puntajeTotal
        'fecha': FieldValue.serverTimestamp(),
      });
    } else {
      // No existe un resultado, agrega uno nuevo
      await FirebaseFirestore.instance
          .collection('ResultadoCuestionarioEstudiante')
          .add({
        'idUsuario': idUsuario,
        'idCuestionario': idCuestionario,
        'puntajeTotal': correctas * 2,
        'fecha': FieldValue.serverTimestamp(),
      });
    }

    // Registra el detalle de cada pregunta en DetalleCuestionario
    for (var pregunta in preguntas) {
      String preguntaId = pregunta['id'];
      bool esCorrecta = resultadoRespuestas[preguntaId] ?? false;
      int puntos = esCorrecta ? 5 : 0;

      await FirebaseFirestore.instance
          .collection('DetalleCuestionario')
          .doc(preguntaId)
          .set({
        'idCuestionarioPreguntas': preguntaId,
        'puntos': puntos,
        'respondidoPor': idUsuario,
      }, SetOptions(merge: true));
    }
  }

  void mostrarMensajeUsuarioNoIdentificado() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'No estás autenticado. Por favor, inicia sesión para continuar.'),
        duration: Duration(seconds: 5),
      ),
    );
  }

  Future<void> mostrarDialogoResultado(String resultado) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultado del Cuestionario'),
          content: Text(resultado),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el AlertDialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuestionario Preguntas Propuestas'),
      ),
      body: Column(
        children: [
          Expanded(
            child: busquedaCompleta
                ? (preguntas.isNotEmpty
                    ? ListView.builder(
                        itemCount: preguntas.length,
                        itemBuilder: (context, index) {
                          final pregunta = preguntas[index];
                          final preguntaId = pregunta['id'];
                          final esCorrecta = resultadoRespuestas[preguntaId];

                          return Card(
                            child: ExpansionTile(
                              title: Text(pregunta['pregunta'] ??
                                  'Pregunta no disponible'),
                              subtitle: esCorrecta != null
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          esCorrecta
                                              ? 'Correcto'
                                              : 'Incorrecto',
                                          style: TextStyle(
                                            color: esCorrecta
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                        Icon(
                                          esCorrecta
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: esCorrecta
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ],
                                    )
                                  : null,
                              children: <Widget>[
                                ...['opcion1', 'opcion2', 'opcion3', 'opcion4']
                                    .map((opcion) {
                                  return RadioListTile<String?>(
                                    title: Text(pregunta[opcion] ??
                                        'Opción no disponible'),
                                    value: pregunta[opcion],
                                    groupValue: respuestasUsuario[preguntaId],
                                    onChanged: (value) {
                                      if (resultadoRespuestas.isEmpty) {
                                        // Cambia solo si no se han enviado las respuestas
                                        setState(() {
                                          respuestasUsuario[preguntaId] = value;
                                        });
                                      }
                                    },
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                            'No se encontraron preguntas para el cuestionario con nombre: ${widget.selectedCuestionario['nombre']}'),
                      ))
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          if (busquedaCompleta &&
              preguntas.isNotEmpty &&
              resultadoRespuestas.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: verificarRespuestas,
                child: Text('Enviar Respuestas'),
              ),
            ),
        ],
      ),
    );
  }
}
