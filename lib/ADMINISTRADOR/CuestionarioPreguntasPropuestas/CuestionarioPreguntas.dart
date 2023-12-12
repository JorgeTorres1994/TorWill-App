import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CuestionarioPreguntas extends StatefulWidget {
  final Map<String, dynamic>? selectedCuestionario;

  CuestionarioPreguntas({this.selectedCuestionario});

  @override
  _CuestionarioPreguntasState createState() => _CuestionarioPreguntasState();
}

class _CuestionarioPreguntasState extends State<CuestionarioPreguntas> {
  TextEditingController _preguntaController = TextEditingController();
  TextEditingController _opcion1Controller = TextEditingController();
  TextEditingController _opcion2Controller = TextEditingController();
  TextEditingController _opcion3Controller = TextEditingController();
  TextEditingController _opcion4Controller = TextEditingController();
  TextEditingController _respuestaController = TextEditingController();

  Map<String, dynamic>? _selectedCuestionario;
  List<Map<String, dynamic>> preguntas = [];
  String? _editingPreguntaId;

  final CollectionReference cuestionarioPreguntasCollection =
      FirebaseFirestore.instance.collection('CuestionarioPreguntas');

  final CollectionReference cuestionariosCollection =
      FirebaseFirestore.instance.collection('Cuestionario');

  @override
  void initState() {
    super.initState();
    if (widget.selectedCuestionario != null) {
      setState(() {
        _selectedCuestionario = widget.selectedCuestionario;
      });
    } else {
      cargarNombresCuestionarios();
    }
    cargarPreguntas();
  }

  Future<void> cargarNombresCuestionarios() async {
    try {
      QuerySnapshot<Map<String, dynamic>> cuestionariosSnapshot =
          await cuestionariosCollection.get()
              as QuerySnapshot<Map<String, dynamic>>;

      setState(() {
        _selectedCuestionario = cuestionariosSnapshot.docs.isNotEmpty
            ? cuestionariosSnapshot.docs[0].data()
            : null;
      });
    } catch (e) {
      print('Error al cargar nombres de cuestionarios: $e');
    }
  }

  Future<void> cargarPreguntas() async {
    try {
      if (_selectedCuestionario != null) {
        QuerySnapshot<Map<String, dynamic>> preguntasSnapshot =
            await cuestionarioPreguntasCollection
                .where('idCuestionario',
                    isEqualTo: _selectedCuestionario!['nombre'])
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
        title: Text('Cuestionario Preguntas Propuestas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _preguntaController,
              decoration: InputDecoration(labelText: 'Pregunta'),
            ),
            TextField(
              controller: _opcion1Controller,
              decoration: InputDecoration(labelText: 'Opción 1'),
            ),
            TextField(
              controller: _opcion2Controller,
              decoration: InputDecoration(labelText: 'Opción 2'),
            ),
            TextField(
              controller: _opcion3Controller,
              decoration: InputDecoration(labelText: 'Opción 3'),
            ),
            TextField(
              controller: _opcion4Controller,
              decoration: InputDecoration(labelText: 'Opción 4'),
            ),
            TextField(
              controller: _respuestaController,
              decoration: InputDecoration(labelText: 'Respuesta'),
            ),
            SizedBox(height: 16),
            _selectedCuestionario != null
                ? Text(
                    'Cuestionario Seleccionado: ${_selectedCuestionario!['nombre']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                : Container(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                agregarEditarPreguntaFirebase();
              },
              child: Text(_editingPreguntaId != null
                  ? 'Editar Pregunta'
                  : 'Agregar Pregunta'),
            ),
            SizedBox(height: 16),
            Text(
              'Lista de Preguntas:',
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              cargarDatosPregunta(pregunta);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              eliminarPreguntaFirebase(pregunta['id']);
                            },
                          ),
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

  Future<void> agregarEditarPreguntaFirebase() async {
    try {
      if (_editingPreguntaId != null) {
        await cuestionarioPreguntasCollection.doc(_editingPreguntaId).update({
          'pregunta': _preguntaController.text,
          'opcion1': _opcion1Controller.text,
          'opcion2': _opcion2Controller.text,
          'opcion3': _opcion3Controller.text,
          'opcion4': _opcion4Controller.text,
          'respuesta': _respuestaController.text,
        });
        _editingPreguntaId = null;
      } else {
        await cuestionarioPreguntasCollection.add({
          'pregunta': _preguntaController.text,
          'opcion1': _opcion1Controller.text,
          'opcion2': _opcion2Controller.text,
          'opcion3': _opcion3Controller.text,
          'opcion4': _opcion4Controller.text,
          'respuesta': _respuestaController.text,
          'idCuestionario': _selectedCuestionario!['nombre'],
        });
      }

      _limpiarCampos();
      cargarPreguntas();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_editingPreguntaId != null
              ? 'Pregunta editada con éxito'
              : 'Pregunta agregada con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error al agregar/editar pregunta: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La pregunta no pudo ser guardada/editada'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void cargarDatosPregunta(Map<String, dynamic> pregunta) {
    setState(() {
      _editingPreguntaId = pregunta['id'];
      _preguntaController.text = pregunta['pregunta'];
      _opcion1Controller.text = pregunta['opcion1'];
      _opcion2Controller.text = pregunta['opcion2'];
      _opcion3Controller.text = pregunta['opcion3'];
      _opcion4Controller.text = pregunta['opcion4'];
      _respuestaController.text = pregunta['respuesta'];
    });
  }

  Future<void> eliminarPreguntaFirebase(String preguntaId) async {
    try {
      await cuestionarioPreguntasCollection.doc(preguntaId).delete();
      cargarPreguntas();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pregunta eliminada con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error al eliminar pregunta: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La pregunta no pudo ser eliminada'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _limpiarCampos() {
    setState(() {
      _preguntaController.clear();
      _opcion1Controller.clear();
      _opcion2Controller.clear();
      _opcion3Controller.clear();
      _opcion4Controller.clear();
      _respuestaController.clear();
    });
  }
}
