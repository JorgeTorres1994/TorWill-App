/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/CuestionarioPreguntasPropuestas/CuestionarioPreguntasPropuestas.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/CuestionarioPreguntasResueltos/CuestionarioPreguntasResueltos.dart';

class CuestionarioEstudianteScreen extends StatefulWidget {
  final String temaId;

  CuestionarioEstudianteScreen({required this.temaId});

  @override
  _CuestionarioEstudianteScreenState createState() =>
      _CuestionarioEstudianteScreenState();
}

class _CuestionarioEstudianteScreenState
    extends State<CuestionarioEstudianteScreen> {
  List<Map<String, dynamic>> cuestionarios = [];
  bool _isLoading = true;
  bool _esVisto = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadCuestionariosFromFirestore();
    _loadVistoState();
  }

  Future<void> _loadCuestionariosFromFirestore() async {
    try {
      QuerySnapshot cuestionariosSnapshot = await firestore
          .collection('Cuestionario')
          .where('temaId', isEqualTo: widget.temaId)
          .get();

      List<Map<String, dynamic>> loadedCuestionarios =
          cuestionariosSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      for (var cuestionario in loadedCuestionarios) {
        String cuestionarioId = cuestionario['id'];
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Verificar cuestionarios propuestos vistos
        QuerySnapshot propuestosSnapshot = await FirebaseFirestore.instance
            .collection('CuestionariosPropuestosVistos')
            .where('idCuestionario', isEqualTo: cuestionarioId)
            .where('userId', isEqualTo: userId)
            .where('esVisto', isEqualTo: true)
            .get();

        // Verificar cuestionarios resueltos vistos
        QuerySnapshot resueltosSnapshot = await FirebaseFirestore.instance
            .collection('CuestionariosResueltosVistos')
            .where('idCuestionario', isEqualTo: cuestionarioId)
            .where('userId', isEqualTo: userId)
            .where('esVisto', isEqualTo: true)
            .get();

        bool propuestosVistos = propuestosSnapshot.docs.isNotEmpty;
        bool resueltosVistos = resueltosSnapshot.docs.isNotEmpty;

        cuestionario['completado'] = propuestosVistos && resueltosVistos;
      }

      setState(() {
        cuestionarios = loadedCuestionarios;
      });
    } catch (e) {
      _showError('Error al cargar cuestionarios desde Firestore: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _marcarComoVisto() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      await firestore.collection('CuestionariosVistos').doc(widget.temaId).set({
        'userId': userId,
        'temaId': widget.temaId,
        'esVisto': true,
      });
      setState(() {
        _esVisto = true;
      });
      _showMessage('Cuestionarios marcados como vistos.');
    } catch (e) {
      _showError('Error al marcar cuestionarios como vistos: $e');
    }
  }

  Future<void> _loadVistoState() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      DocumentSnapshot vistoSnapshot = await firestore
          .collection('CuestionariosVistos')
          .doc(widget.temaId)
          .get();

      if (vistoSnapshot.exists) {
        setState(() {
          _esVisto = vistoSnapshot['esVisto'] as bool;
        });
      }
    } catch (e) {
      _showError('Error al cargar el estado de visto: $e');
    }
  }

  Future<void> _mostrarDialogoConfirmacion() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Ya viste todos los cuestionarios?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                _marcarComoVisto();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cuestionario"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : cuestionarios.isEmpty
              ? Center(child: Text('No hay cuestionarios disponibles.'))
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cuestionarios.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> examen =
                                    cuestionarios[index];
                                bool completado = examen['completado'] ?? false;

                                return Card(
                                  child: ListTile(
                                    title: Text(
                                        'Nombre: ${examen['nombre'] ?? ''}'),
                                    subtitle: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder<DocumentSnapshot>(
                                                future: firestore
                                                    .collection('temas')
                                                    .doc(examen['temaId'])
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Text(
                                                        'Tema: Cargando...');
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return Text(
                                                        'Tema: Desconocido');
                                                  }
                                                  String themeName = snapshot
                                                      .data!['name'] as String;
                                                  return Text(
                                                      'Tema: $themeName');
                                                },
                                              ),
                                              Text(
                                                  'Descripción: ${examen['descripcion'] ?? ''}'),
                                            ],
                                          ),
                                        ),
                                        if (examen['imageUrl'] != null)
                                          Container(
                                            width: 100,
                                            height: 100,
                                            child: Image.network(
                                              examen['imageUrl'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (completado)
                                          Text(
                                            'COMPLETADO',
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        IconButton(
                                          icon: Icon(Icons.book_online),
                                          onPressed: () {
                                            debugPrint(
                                                'Cuestionario seleccionado: ${examen.toString()}');
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CuestionarioPreguntasResueltos(
                                                          selectedCuestionarioResuelto:
                                                              examen,
                                                        )));
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.question_answer),
                                          onPressed: () {
                                            debugPrint(
                                                'Cuestionario seleccionado: ${examen.toString()}');
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CuestionarioPreguntasPropuestas(
                                                          selectedCuestionario:
                                                              examen,
                                                        )));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_esVisto)
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
                              onPressed:
                                  _esVisto ? null : _mostrarDialogoConfirmacion,
                              child: Icon(Icons.check),
                              backgroundColor:
                                  _esVisto ? Colors.grey : Colors.blue,
                            ),
                          ],
                        ),
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
import 'package:nueva_app_web_matematicas/ESTUDIANTES/CuestionarioPreguntasPropuestas/CuestionarioPreguntasPropuestas.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/CuestionarioPreguntasResueltos/CuestionarioPreguntasResueltos.dart';

class CuestionarioEstudianteScreen extends StatefulWidget {
  final String temaId;

  CuestionarioEstudianteScreen({required this.temaId});

  @override
  _CuestionarioEstudianteScreenState createState() =>
      _CuestionarioEstudianteScreenState();
}

class _CuestionarioEstudianteScreenState
    extends State<CuestionarioEstudianteScreen> {
  List<Map<String, dynamic>> cuestionarios = [];
  bool _isLoading = true;
  bool _esVisto = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadCuestionariosFromFirestore();
    _loadVistoState();
  }

  Future<void> _loadCuestionariosFromFirestore() async {
    try {
      QuerySnapshot cuestionariosSnapshot = await firestore
          .collection('Cuestionario')
          .where('temaId', isEqualTo: widget.temaId)
          .get();

      List<Map<String, dynamic>> loadedCuestionarios =
          cuestionariosSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      for (var cuestionario in loadedCuestionarios) {
        String cuestionarioId = cuestionario['id'];
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Verificar cuestionarios propuestos vistos
        QuerySnapshot propuestosSnapshot = await FirebaseFirestore.instance
            .collection('CuestionariosPropuestosVistos')
            .where('idCuestionario', isEqualTo: cuestionarioId)
            .where('userId', isEqualTo: userId)
            .where('esVisto', isEqualTo: true)
            .get();

        // Verificar cuestionarios resueltos vistos
        QuerySnapshot resueltosSnapshot = await FirebaseFirestore.instance
            .collection('CuestionariosResueltosVistos')
            .where('idCuestionario', isEqualTo: cuestionarioId)
            .where('userId', isEqualTo: userId)
            .where('esVisto', isEqualTo: true)
            .get();

        bool propuestosVistos = propuestosSnapshot.docs.isNotEmpty;
        bool resueltosVistos = resueltosSnapshot.docs.isNotEmpty;

        cuestionario['completado'] = propuestosVistos && resueltosVistos;
      }

      setState(() {
        cuestionarios = loadedCuestionarios;
      });
    } catch (e) {
      _showError('Error al cargar cuestionarios desde Firestore: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _marcarComoVisto() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      await firestore.collection('CuestionariosVistos').doc(widget.temaId).set({
        'userId': userId,
        'temaId': widget.temaId,
        'esVisto': true,
      });
      setState(() {
        _esVisto = true;
      });
      _showMessage('Cuestionarios marcados como vistos.');
    } catch (e) {
      _showError('Error al marcar cuestionarios como vistos: $e');
    }
  }

  Future<void> _loadVistoState() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      DocumentSnapshot vistoSnapshot = await firestore
          .collection('CuestionariosVistos')
          .doc(widget.temaId)
          .get();

      if (vistoSnapshot.exists) {
        setState(() {
          _esVisto = vistoSnapshot['esVisto'] as bool;
        });
      }
    } catch (e) {
      _showError('Error al cargar el estado de visto: $e');
    }
  }

  Future<void> _mostrarDialogoConfirmacion() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Ya viste todos los cuestionarios?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                _marcarComoVisto();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cuestionario"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : cuestionarios.isEmpty
              ? Center(child: Text('No hay cuestionarios disponibles.'))
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cuestionarios.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> examen =
                                    cuestionarios[index];
                                bool completado = examen['completado'] ?? false;

                                return Card(
                                    child:
                                        /*ListTile(
                                    title: Text(
                                        'Nombre: ${examen['nombre'] ?? ''}'),
                                    subtitle: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder<DocumentSnapshot>(
                                                future: firestore
                                                    .collection('temas')
                                                    .doc(examen['temaId'])
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Text(
                                                        'Tema: Cargando...');
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return Text(
                                                        'Tema: Desconocido');
                                                  }
                                                  String themeName = snapshot
                                                      .data!['name'] as String;
                                                  return Text(
                                                      'Tema: $themeName');
                                                },
                                              ),
                                              Text(
                                                  'Descripción: ${examen['descripcion'] ?? ''}'),
                                            ],
                                          ),
                                        ),
                                        if (examen['imageUrl'] != null)
                                          Container(
                                            width: 100,
                                            height: 100,
                                            child: Image.network(
                                              examen['imageUrl'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (completado)
                                          Text(
                                            'COMPLETADO',
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        IconButton(
                                          icon: Icon(Icons.book_online),
                                          onPressed: () {
                                            debugPrint(
                                                'Cuestionario seleccionado: ${examen.toString()}');
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CuestionarioPreguntasResueltos(
                                                          selectedCuestionarioResuelto:
                                                              examen,
                                                        )));
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.question_answer),
                                          onPressed: () {
                                            debugPrint(
                                                'Cuestionario seleccionado: ${examen.toString()}');
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CuestionarioPreguntasPropuestas(
                                                          selectedCuestionario:
                                                              examen,
                                                        )));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),*/
                                        ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      examen['imageUrl'] ??
                                          'https://cdn-icons-png.flaticon.com/128/3226/3226979.png',
                                    ),
                                  ),
                                  title:
                                      Text('Nombre: ${examen['nombre'] ?? ''}'),
                                  subtitle: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FutureBuilder<DocumentSnapshot>(
                                              future: firestore
                                                  .collection('temas')
                                                  .doc(examen['temaId'])
                                                  .get(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Text(
                                                      'Tema: Cargando...');
                                                }
                                                if (!snapshot.hasData) {
                                                  return Text(
                                                      'Tema: Desconocido');
                                                }
                                                String themeName = snapshot
                                                    .data!['name'] as String;
                                                return Text('Tema: $themeName');
                                              },
                                            ),
                                            Text(
                                                'Descripción: ${examen['descripcion'] ?? ''}'),
                                          ],
                                        ),
                                      ),
                                      if (examen['imageUrl'] != null)
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: Image.network(
                                            examen['imageUrl'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (completado)
                                        Text(
                                          'COMPLETADO',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      IconButton(
                                        icon: Icon(Icons.book_online),
                                        onPressed: () {
                                          debugPrint(
                                              'Cuestionario seleccionado: ${examen.toString()}');
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CuestionarioPreguntasResueltos(
                                                        selectedCuestionarioResuelto:
                                                            examen,
                                                      )));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.question_answer),
                                        onPressed: () {
                                          debugPrint(
                                              'Cuestionario seleccionado: ${examen.toString()}');
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CuestionarioPreguntasPropuestas(
                                                        selectedCuestionario:
                                                            examen,
                                                      )));
                                        },
                                      ),
                                    ],
                                  ),
                                ));
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_esVisto)
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
                              onPressed:
                                  _esVisto ? null : _mostrarDialogoConfirmacion,
                              child: Icon(Icons.check),
                              backgroundColor:
                                  _esVisto ? Colors.grey : Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
