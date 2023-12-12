/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExamenPreguntasPropuestas extends StatefulWidget {
  final Map<String, dynamic> selectedExamen;

  ExamenPreguntasPropuestas({Key? key, required this.selectedExamen})
      : super(key: key);

  @override
  _ExamenPreguntasPropuestasState createState() =>
      _ExamenPreguntasPropuestasState();
}

class _ExamenPreguntasPropuestasState extends State<ExamenPreguntasPropuestas> {
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
    String? nombreExamen = widget.selectedExamen['nombre'];
    if (nombreExamen != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ExamenPreguntas')
          .where('idExamen', isEqualTo: nombreExamen)
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
    String idExamen = widget.selectedExamen['id'];

    // Registra el puntaje total en ResultadoExamenEstudiante
    await FirebaseFirestore.instance
        .collection('ResultadoExamenEstudiante')
        .add({
      'idUsuario': idUsuario,
      'idExamen': idExamen,
      'puntajeTotal':
          correctas * 2, // Asumiendo que cada respuesta correcta vale 2 puntos
      'fecha': FieldValue.serverTimestamp(),
    });

    // Registra el detalle de cada pregunta en DetalleExamen
    for (var pregunta in preguntas) {
      String preguntaId = pregunta['id'];
      bool esCorrecta = resultadoRespuestas[preguntaId] ?? false;
      int puntos = esCorrecta
          ? 2
          : 0; // Asumiendo que cada respuesta correcta vale 2 puntos

      await FirebaseFirestore.instance
          .collection('DetalleExamen')
          .doc(preguntaId)
          .set({
        'idExamenPreguntas': preguntaId,
        'puntos': puntos,
        'respondidoPor': idUsuario, // Opcional: para saber quién respondió
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
          title: Text('Resultado del Examen'),
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
        title: Text('Examen Preguntas Propuestas'),
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
                            'No se encontraron preguntas para el examen con nombre: ${widget.selectedExamen['nombre']}'),
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
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExamenPreguntasPropuestas extends StatefulWidget {
  final Map<String, dynamic> selectedExamen;

  ExamenPreguntasPropuestas({Key? key, required this.selectedExamen})
      : super(key: key);

  @override
  _ExamenPreguntasPropuestasState createState() =>
      _ExamenPreguntasPropuestasState();
}

class _ExamenPreguntasPropuestasState extends State<ExamenPreguntasPropuestas> {
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
    String? nombreExamen = widget.selectedExamen['nombre'];
    if (nombreExamen != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ExamenPreguntas')
          .where('idExamen', isEqualTo: nombreExamen)
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
    String idExamen = widget.selectedExamen['id'];

    // Registra el puntaje total en ResultadoExamenEstudiante
    await FirebaseFirestore.instance
        .collection('ResultadoExamenEstudiante')
        .add({
      'idUsuario': idUsuario,
      'idExamen': idExamen,
      'puntajeTotal':
          correctas * 2, // Asumiendo que cada respuesta correcta vale 2 puntos
      'fecha': FieldValue.serverTimestamp(),
    });

    // Registra el detalle de cada pregunta en DetalleExamen
    for (var pregunta in preguntas) {
      String preguntaId = pregunta['id'];
      bool esCorrecta = resultadoRespuestas[preguntaId] ?? false;
      int puntos = esCorrecta
          ? 2
          : 0; // Asumiendo que cada respuesta correcta vale 2 puntos

      await FirebaseFirestore.instance
          .collection('DetalleExamen')
          .doc(preguntaId)
          .set({
        'idExamenPreguntas': preguntaId,
        'puntos': puntos,
        'respondidoPor': idUsuario, // Opcional: para saber quién respondió
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
          title: Text('Resultado del Examen'),
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
        title: Text('Examen Preguntas Propuestas'),
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
                            'No se encontraron preguntas para el examen con nombre: ${widget.selectedExamen['nombre']}'),
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
