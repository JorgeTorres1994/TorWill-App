/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool _isSeen = false;
  bool _isLoading = true;

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
    _initializeData();
  }

  Future<void> _initializeData() async {
    await verificarSiEsVisto(); // Verifica si el cuestionario ya ha sido visto
    await cargarPreguntasResueltas();
    setState(() {
      _isLoading = false; // Indica que la página ha terminado de cargar
    });
  }

  Future<void> cargarNombresCuestionariosResueltos() async {
    try {
      QuerySnapshot<Map<String, dynamic>> cuestionariosSnapshot =
          await cuestionariosCollection.get()
              as QuerySnapshot<Map<String, dynamic>>;

      setState(() {
        _selectedCuestionarioResuelto = cuestionariosSnapshot.docs.isNotEmpty
            ? {'id': cuestionariosSnapshot.docs[0].id, ...cuestionariosSnapshot.docs[0].data()}
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
                    isEqualTo: _selectedCuestionarioResuelto!['nombre']) // Comparar por nombre
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

  Future<void> verificarSiEsVisto() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('CuestionariosResueltosVistos')
          .where('idCuestionario',
              isEqualTo: _selectedCuestionarioResuelto!['nombre']) // Comparar por nombre
          .where('userId', isEqualTo: userId)
          .where('esVisto', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _isSeen = true;
        });
      }
    } catch (e) {
      print("Error checking if seen: $e");
    }
  }

  Future<void> marcarComoVisto() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text('¿Ya viste todas las preguntas resueltas?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
        await FirebaseFirestore.instance
            .collection('CuestionariosResueltosVistos')
            .add({
          'idCuestionario': _selectedCuestionarioResuelto!['id'], // Guardar el ID del cuestionario
          'temaId': _selectedCuestionarioResuelto!['temaId'],
          'userId': userId,
          'esVisto': true,
        });
        setState(() {
          _isSeen = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cuestionario marcado como visto.'),
        ));
      } catch (e) {
        print("Error marcando como visto: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuestionario Preguntas Resueltas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : preguntas.isEmpty
              ? Center(
                  child: Text(
                    'No se encontraron preguntas para el cuestionario con nombre: ${widget.selectedCuestionarioResuelto?['nombre']}',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'Lista de Preguntas Resueltas:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: preguntas.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> pregunta = preguntas[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                    'Pregunta: ${pregunta['pregunta'] ?? ''}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Opción 1: ${pregunta['opcion1'] ?? ''}'),
                                    Text(
                                        'Opción 2: ${pregunta['opcion2'] ?? ''}'),
                                    Text(
                                        'Opción 3: ${pregunta['opcion3'] ?? ''}'),
                                    Text(
                                        'Opción 4: ${pregunta['opcion4'] ?? ''}'),
                                    Text(
                                        'Respuesta: ${pregunta['respuesta'] ?? ''}'),
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
      floatingActionButton: _isLoading || preguntas.isEmpty
          ? null
          : Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isSeen)
                      Text(
                        'VISTO',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: _isSeen ? null : marcarComoVisto,
                      child: Icon(Icons.check),
                      backgroundColor: _isSeen ? Colors.grey : Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool _isSeen = false;
  bool _isLoading = true;

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
    _initializeData();
  }

  Future<void> _initializeData() async {
    await verificarSiEsVisto(); // Verifica si el cuestionario ya ha sido visto
    await cargarPreguntasResueltas();
    setState(() {
      _isLoading = false; // Indica que la página ha terminado de cargar
    });
  }

  Future<void> cargarNombresCuestionariosResueltos() async {
    try {
      QuerySnapshot<Map<String, dynamic>> cuestionariosSnapshot =
          await cuestionariosCollection.get()
              as QuerySnapshot<Map<String, dynamic>>;

      setState(() {
        _selectedCuestionarioResuelto = cuestionariosSnapshot.docs.isNotEmpty
            ? {'id': cuestionariosSnapshot.docs[0].id, ...cuestionariosSnapshot.docs[0].data()}
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
                    isEqualTo: _selectedCuestionarioResuelto!['nombre']) // Comparar por nombre
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

  Future<void> verificarSiEsVisto() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('CuestionariosResueltosVistos')
          .where('idCuestionario',
              isEqualTo: _selectedCuestionarioResuelto!['id']) // Usar el id en lugar del nombre
          .where('userId', isEqualTo: userId)
          .where('esVisto', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _isSeen = true;
        });
      }
      print("Verificado si es visto: $_isSeen");
    } catch (e) {
      print("Error checking if seen: $e");
    }
  }

  Future<void> marcarComoVisto() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text('¿Ya viste todas las preguntas resueltas?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
        await FirebaseFirestore.instance
            .collection('CuestionariosResueltosVistos')
            .add({
          'idCuestionario': _selectedCuestionarioResuelto!['id'], // Guardar el ID del cuestionario
          'temaId': _selectedCuestionarioResuelto!['temaId'],
          'userId': userId,
          'esVisto': true,
        });
        setState(() {
          _isSeen = true;
        });
        print("Marcado como visto: $_isSeen");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cuestionario marcado como visto.'),
        ));
      } catch (e) {
        print("Error marcando como visto: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuestionario Preguntas Resueltas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : preguntas.isEmpty
              ? Center(
                  child: Text(
                    'No se encontraron preguntas para el cuestionario con nombre: ${widget.selectedCuestionarioResuelto?['nombre']}',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'Lista de Preguntas Resueltas:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: preguntas.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> pregunta = preguntas[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                    'Pregunta: ${pregunta['pregunta'] ?? ''}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Opción 1: ${pregunta['opcion1'] ?? ''}'),
                                    Text(
                                        'Opción 2: ${pregunta['opcion2'] ?? ''}'),
                                    Text(
                                        'Opción 3: ${pregunta['opcion3'] ?? ''}'),
                                    Text(
                                        'Opción 4: ${pregunta['opcion4'] ?? ''}'),
                                    Text(
                                        'Respuesta: ${pregunta['respuesta'] ?? ''}'),
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
      floatingActionButton: _isLoading || preguntas.isEmpty
          ? null
          : Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isSeen)
                      Text(
                        'VISTO',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: _isSeen ? null : marcarComoVisto,
                      child: Icon(Icons.check),
                      backgroundColor: _isSeen ? Colors.grey : Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
