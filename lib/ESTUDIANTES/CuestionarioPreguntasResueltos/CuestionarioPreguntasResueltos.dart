/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CuestionarioPreguntasResueltos extends StatefulWidget {
  final Map<String, dynamic>? selectedCuestionarioResuelto;

  CuestionarioPreguntasResueltos({this.selectedCuestionarioResuelto});

  @override
  _CuestionarioPreguntasResueltosState createState() =>
      _CuestionarioPreguntasResueltosState();
}

class _CuestionarioPreguntasResueltosState
    extends State<CuestionarioPreguntasResueltos> {
  Map<String, dynamic>? _selectedCuestionarioResuelto;
  List<Map<String, dynamic>> preguntas = [];

  final CollectionReference cuestionarioPreguntasResueltosCollection =
      FirebaseFirestore.instance.collection('CuestionarioResueltos');

  final CollectionReference cuestionariosCollection =
      FirebaseFirestore.instance.collection('Cuestionario');

  @override
  void initState() {
    super.initState();
    if (widget.selectedCuestionarioResuelto != null) {
      setState(() {
        _selectedCuestionarioResuelto = widget.selectedCuestionarioResuelto;
      });
    } else {
      cargarNombresCuestionariosResueltos();
    }
    cargarPreguntasResueltas();
  }

  Future<void> cargarNombresCuestionariosResueltos() async {
    try {
      QuerySnapshot<Map<String, dynamic>> cuestionariosSnapshot =
          await cuestionariosCollection.get()
              as QuerySnapshot<Map<String, dynamic>>;

      setState(() {
        _selectedCuestionarioResuelto = cuestionariosSnapshot.docs.isNotEmpty
            ? cuestionariosSnapshot.docs[0].data()
            : null;
      });
    } catch (e) {
      print('Error al cargar nombres de cuestionarios resueltos: $e');
    }
  }

  Future<void> cargarPreguntasResueltas() async {
    try {
      if (_selectedCuestionarioResuelto != null) {
        QuerySnapshot<Map<String, dynamic>> preguntasSnapshot =
            await cuestionarioPreguntasResueltosCollection
                .where('idCuestionario',
                    isEqualTo: _selectedCuestionarioResuelto!['nombre'])
                .get() as QuerySnapshot<Map<String, dynamic>>;

        setState(() {
          preguntas = preguntasSnapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        });
      }
    } catch (e) {
      print('Error al cargar preguntas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuestionario Preguntas Resueltas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Lista de Preguntas Resueltas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: preguntas.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> pregunta = preguntas[index];
                  return Card(
                    child: ListTile(
                      title: Text('Pregunta: ${pregunta['pregunta'] ?? ''}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Opción 1: ${pregunta['opcion1'] ?? ''}'),
                          Text('Opción 2: ${pregunta['opcion2'] ?? ''}'),
                          Text('Opción 3: ${pregunta['opcion3'] ?? ''}'),
                          Text('Opción 4: ${pregunta['opcion4'] ?? ''}'),
                          Text('Respuesta: ${pregunta['respuesta'] ?? ''}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
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

class CuestionarioPreguntasResueltos extends StatefulWidget {
  final Map<String, dynamic>? selectedCuestionarioResuelto;

  CuestionarioPreguntasResueltos({this.selectedCuestionarioResuelto});

  @override
  _CuestionarioPreguntasResueltosState createState() =>
      _CuestionarioPreguntasResueltosState();
}

class _CuestionarioPreguntasResueltosState
    extends State<CuestionarioPreguntasResueltos> {
  Map<String, dynamic>? _selectedCuestionarioResuelto;
  List<Map<String, dynamic>> preguntas = [];

  final CollectionReference cuestionarioPreguntasResueltosCollection =
      FirebaseFirestore.instance.collection('CuestionarioResueltos');

  final CollectionReference cuestionariosCollection =
      FirebaseFirestore.instance.collection('Cuestionario');

  @override
  void initState() {
    super.initState();
    if (widget.selectedCuestionarioResuelto != null) {
      setState(() {
        _selectedCuestionarioResuelto = widget.selectedCuestionarioResuelto;
      });
    } else {
      cargarNombresCuestionariosResueltos();
    }
    cargarPreguntasResueltas();
  }

  Future<void> cargarNombresCuestionariosResueltos() async {
    try {
      QuerySnapshot<Map<String, dynamic>> cuestionariosSnapshot =
          await cuestionariosCollection.get()
              as QuerySnapshot<Map<String, dynamic>>;

      setState(() {
        _selectedCuestionarioResuelto = cuestionariosSnapshot.docs.isNotEmpty
            ? cuestionariosSnapshot.docs[0].data()
            : null;
      });
    } catch (e) {
      print('Error al cargar nombres de cuestionarios resueltos: $e');
    }
  }

  Future<void> cargarPreguntasResueltas() async {
    try {
      if (_selectedCuestionarioResuelto != null) {
        QuerySnapshot<Map<String, dynamic>> preguntasSnapshot =
            await cuestionarioPreguntasResueltosCollection
                .where('idCuestionario',
                    isEqualTo: _selectedCuestionarioResuelto!['nombre'])
                .get() as QuerySnapshot<Map<String, dynamic>>;

        setState(() {
          preguntas = preguntasSnapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        });
      }
    } catch (e) {
      print('Error al cargar preguntas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuestionario Preguntas Resueltas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Lista de Preguntas Resueltas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: preguntas.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> pregunta = preguntas[index];
                  return Card(
                    child: ListTile(
                      title: Text('Pregunta: ${pregunta['pregunta'] ?? ''}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Opción 1: ${pregunta['opcion1'] ?? ''}'),
                          Text('Opción 2: ${pregunta['opcion2'] ?? ''}'),
                          Text('Opción 3: ${pregunta['opcion3'] ?? ''}'),
                          Text('Opción 4: ${pregunta['opcion4'] ?? ''}'),
                          Text('Respuesta: ${pregunta['respuesta'] ?? ''}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
