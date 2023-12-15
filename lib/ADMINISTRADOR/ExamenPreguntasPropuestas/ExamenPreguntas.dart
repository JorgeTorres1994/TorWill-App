/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamenPreguntas extends StatefulWidget {
  final Map<String, dynamic>? selectedExamen;

  ExamenPreguntas({this.selectedExamen});

  @override
  _ExamenPreguntasState createState() => _ExamenPreguntasState();
}

class _ExamenPreguntasState extends State<ExamenPreguntas> {
  TextEditingController _preguntaController = TextEditingController();
  TextEditingController _opcion1Controller = TextEditingController();
  TextEditingController _opcion2Controller = TextEditingController();
  TextEditingController _opcion3Controller = TextEditingController();
  TextEditingController _opcion4Controller = TextEditingController();
  TextEditingController _respuestaController = TextEditingController();

  Map<String, dynamic>? _selectedExamen;
  List<Map<String, dynamic>> preguntas = [];
  String? _editingPreguntaId;

  final CollectionReference examenPreguntasCollection =
      FirebaseFirestore.instance.collection('ExamenPreguntas');

  final CollectionReference examenesCollection =
      FirebaseFirestore.instance.collection('Examen');

  @override
  void initState() {
    super.initState();
    if (widget.selectedExamen != null) {
      setState(() {
        _selectedExamen = widget.selectedExamen;
      });
    } else {
      cargarNombresExamenes();
    }
    cargarPreguntas();
  }

  Future<void> cargarNombresExamenes() async {
    try {
      QuerySnapshot<Map<String, dynamic>> examenesSnapshot =
          await examenesCollection.get() as QuerySnapshot<Map<String, dynamic>>;

      setState(() {
        _selectedExamen = examenesSnapshot.docs.isNotEmpty
            ? examenesSnapshot.docs[0].data()
            : null;
      });
    } catch (e) {
      print('Error al cargar nombres de examenes: $e');
    }
  }

  Future<void> cargarPreguntas() async {
    try {
      if (_selectedExamen != null) {
        QuerySnapshot<Map<String, dynamic>> preguntasSnapshot =
            await examenPreguntasCollection
                .where('idExamen', isEqualTo: _selectedExamen!['nombre'])
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
        title: Text('Examen Preguntas Propuestas'),
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
            _selectedExamen != null
                ? Text(
                    'Examen Seleccionado: ${_selectedExamen!['nombre']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                : Container(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    agregarEditarPreguntaFirebase();
                  },
                  child: Text(_editingPreguntaId != null
                      ? 'Editar Pregunta'
                      : 'Agregar Pregunta'),
                ),
                Row(
                  children: [
                    Text('Mostrar Preguntas'),
                    InkWell(
                      onTap: () {
                        mostrarListaPreguntas(context);
                      },
                      child: Icon(Icons.assignment_add),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> agregarEditarPreguntaFirebase() async {
    try {
      if (_editingPreguntaId != null) {
        await examenPreguntasCollection.doc(_editingPreguntaId).update({
          'pregunta': _preguntaController.text,
          'opcion1': _opcion1Controller.text,
          'opcion2': _opcion2Controller.text,
          'opcion3': _opcion3Controller.text,
          'opcion4': _opcion4Controller.text,
          'respuesta': _respuestaController.text,
        });
        _editingPreguntaId = null;
      } else {
        await examenPreguntasCollection.add({
          'pregunta': _preguntaController.text,
          'opcion1': _opcion1Controller.text,
          'opcion2': _opcion2Controller.text,
          'opcion3': _opcion3Controller.text,
          'opcion4': _opcion4Controller.text,
          'respuesta': _respuestaController.text,
          'idExamen': _selectedExamen!['nombre'],
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
      await examenPreguntasCollection.doc(preguntaId).delete();
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

  void mostrarListaPreguntas(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return preguntas.isEmpty
            ? AlertDialog(
                title: Text('Lista de Preguntas'),
                content: Text('No existen preguntas registradas.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cerrar'),
                  ),
                ],
              )
            : AlertDialog(
                title: Text('Lista de Preguntas'),
                content: SingleChildScrollView(
                  child: Column(
                    children: preguntas.map((pregunta) {
                      return ListTile(
                        title: Text(
                          'Pregunta: ${pregunta['pregunta'] ?? ''}',
                          style: TextStyle(
                            overflow: TextOverflow.visible,
                          ),
                        ),
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
                                Navigator.of(context)
                                    .pop(); // Cerrar el diálogo de lista al editar
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                eliminarPreguntaFirebase(pregunta['id']);
                                Navigator.of(context)
                                    .pop(); // Cerrar el diálogo de lista al eliminar
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cerrar'),
                  ),
                ],
              );
      },
    );
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
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamenPreguntas extends StatefulWidget {
  final Map<String, dynamic>? selectedExamen;

  ExamenPreguntas({this.selectedExamen});

  @override
  _ExamenPreguntasState createState() => _ExamenPreguntasState();
}

class _ExamenPreguntasState extends State<ExamenPreguntas> {
  TextEditingController _preguntaController = TextEditingController();
  TextEditingController _opcion1Controller = TextEditingController();
  TextEditingController _opcion2Controller = TextEditingController();
  TextEditingController _opcion3Controller = TextEditingController();
  TextEditingController _opcion4Controller = TextEditingController();
  TextEditingController _respuestaController = TextEditingController();

  Map<String, dynamic>? _selectedExamen;
  List<Map<String, dynamic>> preguntas = [];
  String? _editingPreguntaId;

  final CollectionReference examenPreguntasCollection =
      FirebaseFirestore.instance.collection('ExamenPreguntas');

  final CollectionReference examenesCollection =
      FirebaseFirestore.instance.collection('Examen');

  @override
  void initState() {
    super.initState();
    if (widget.selectedExamen != null) {
      setState(() {
        _selectedExamen = widget.selectedExamen;
      });
    } else {
      cargarNombresExamenes();
    }
    cargarPreguntas();
  }

  Future<void> cargarNombresExamenes() async {
    try {
      QuerySnapshot<Map<String, dynamic>> examenesSnapshot =
          await examenesCollection.get() as QuerySnapshot<Map<String, dynamic>>;

      setState(() {
        _selectedExamen = examenesSnapshot.docs.isNotEmpty
            ? examenesSnapshot.docs[0].data()
            : null;
      });
    } catch (e) {
      print('Error al cargar nombres de examenes: $e');
    }
  }

  Future<void> cargarPreguntas() async {
    try {
      if (_selectedExamen != null) {
        QuerySnapshot<Map<String, dynamic>> preguntasSnapshot =
            await examenPreguntasCollection
                .where('idExamen', isEqualTo: _selectedExamen!['nombre'])
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
        title: Text('Examen Preguntas Propuestas'),
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
            _selectedExamen != null
                ? Text(
                    'Examen Seleccionado: ${_selectedExamen!['nombre']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                : Container(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    agregarEditarPreguntaFirebase();
                  },
                  child: Text(_editingPreguntaId != null
                      ? 'Editar Pregunta'
                      : 'Agregar Pregunta'),
                ),
                Row(
                  children: [
                    Text('Mostrar Preguntas'),
                    InkWell(
                      onTap: () {
                        mostrarListaPreguntas(context);
                      },
                      child: Icon(Icons.assignment_add),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> agregarEditarPreguntaFirebase() async {
    try {
      if (_editingPreguntaId != null) {
        await examenPreguntasCollection.doc(_editingPreguntaId).update({
          'pregunta': _preguntaController.text,
          'opcion1': _opcion1Controller.text,
          'opcion2': _opcion2Controller.text,
          'opcion3': _opcion3Controller.text,
          'opcion4': _opcion4Controller.text,
          'respuesta': _respuestaController.text,
        });
        _editingPreguntaId = null;
      } else {
        await examenPreguntasCollection.add({
          'pregunta': _preguntaController.text,
          'opcion1': _opcion1Controller.text,
          'opcion2': _opcion2Controller.text,
          'opcion3': _opcion3Controller.text,
          'opcion4': _opcion4Controller.text,
          'respuesta': _respuestaController.text,
          'idExamen': _selectedExamen!['nombre'],
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
      await examenPreguntasCollection.doc(preguntaId).delete();
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

  void mostrarListaPreguntas(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return preguntas.isEmpty
            ? AlertDialog(
                title: Text('Lista de Preguntas'),
                content: Text('No existen preguntas registradas.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cerrar'),
                  ),
                ],
              )
            : AlertDialog(
                title: Text('Lista de Preguntas'),
                content: SingleChildScrollView(
                  child: Column(
                    children: preguntas.map((pregunta) {
                      return ListTile(
                        title: Text(
                          'Pregunta: ${pregunta['pregunta'] ?? ''}',
                          style: TextStyle(
                            overflow: TextOverflow.visible,
                          ),
                        ),
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
                                Navigator.of(context)
                                    .pop(); // Cerrar el diálogo de lista al editar
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                eliminarPreguntaFirebase(pregunta['id']);
                                Navigator.of(context)
                                    .pop(); // Cerrar el diálogo de lista al eliminar
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cerrar'),
                  ),
                ],
              );
      },
    );
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
