/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Cuestionario_Estudiante_Screen/CuestionarioEstudianteScreen.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/MaterialEscolarPage/MaterialEscolarPage.dart';

class ListaTemasCuestionario extends StatefulWidget {
  final String temarioRef;

  ListaTemasCuestionario({required this.temarioRef});

  @override
  _ListaTemasCuestionarioState createState() => _ListaTemasCuestionarioState();
}

class _ListaTemasCuestionarioState extends State<ListaTemasCuestionario> {
  late Future<List<DocumentSnapshot>> _temasFuture;
  int completados = 0;
  Set<String> temasCompletados = Set(); // Para rastrear temas ya contados

  @override
  void initState() {
    super.initState();
    _temasFuture = _fetchTemas();
  }

  Future<List<DocumentSnapshot>> _fetchTemas() async {
    final QuerySnapshot temasSnapshot = await FirebaseFirestore.instance
        .collection('temas')
        .where('temarioRef', isEqualTo: widget.temarioRef)
        .get();

    List<DocumentSnapshot> temas = temasSnapshot.docs;

    for (var tema in temas) {
      final temaId = tema.id;

      // Comprobamos si el tema está completado
      final cuestionariosSnapshot = await FirebaseFirestore.instance
          .collection('CuestionariosVistos')
          .where('temaId', isEqualTo: temaId)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('esVisto', isEqualTo: true)
          .get();

      final materialSnapshot = await FirebaseFirestore.instance
          .collection('MaterialVisto')
          .where('temaId', isEqualTo: temaId)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('esVisto', isEqualTo: true)
          .get();

      bool completado = cuestionariosSnapshot.docs.isNotEmpty &&
          materialSnapshot.docs.isNotEmpty;

      print("Tema $temaId completado: $completado");

      if (completado) {
        temasCompletados.add(temaId);
        completados++;
      }
    }

    print("Total de temas completados: $completados");
    return temas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Temas'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _temasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Esperando datos...");
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final temas = snapshot.data;

          if (temas == null || temas.isEmpty) {
            print("No hay temas asociados a este temario.");
            return Center(
                child: Text('No hay temas asociados a este temario.'));
          }

          int totalTemas = temas.length;
          print("Total de temas: $totalTemas");

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: temas.length,
                  itemBuilder: (context, index) {
                    final tema = temas[index].data() as Map<String, dynamic>;
                    final temaId = temas[index].id;
                    final completado = temasCompletados.contains(temaId);

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        title: Text('${index + 1}. ${tema['name']}'),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/temasExamen.png'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (completado)
                              Text(
                                'COMPLETADO',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.school),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MaterialEscolarPage(temaId: temaId),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.quiz),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CuestionarioEstudianteScreen(
                                            temaId: temaId),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$completados de $totalTemas temas completados (${(completados / totalTemas * 100).toStringAsFixed(1)}%)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
*/

/********************************************************************************************************************************/

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Cuestionario_Estudiante_Screen/CuestionarioEstudianteScreen.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/MaterialEscolarPage/MaterialEscolarPage.dart';

class ListaTemasCuestionario extends StatefulWidget {
  final String temarioRef;

  ListaTemasCuestionario({required this.temarioRef});

  @override
  _ListaTemasCuestionarioState createState() => _ListaTemasCuestionarioState();
}

class _ListaTemasCuestionarioState extends State<ListaTemasCuestionario> {
  late List<DocumentSnapshot> temas;
  int completados = 0;
  Set<String> temasCompletados = Set(); // Para rastrear temas ya contados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Temas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('temas')
            .where('temarioRef', isEqualTo: widget.temarioRef)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Esperando datos...");
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          temas = snapshot.data!.docs;

          if (temas.isEmpty) {
            print("No hay temas asociados a este temario.");
            return Center(
                child: Text('No hay temas asociados a este temario.'));
          }

          int totalTemas = temas.length;
          print("Total de temas: $totalTemas");

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: temas.length,
                  itemBuilder: (context, index) {
                    final tema = temas[index].data() as Map<String, dynamic>;
                    final temaId = temas[index].id;

                    return FutureBuilder<List<QuerySnapshot>>(
                      future: Future.wait([
                        FirebaseFirestore.instance
                            .collection('CuestionariosVistos')
                            .where('temaId', isEqualTo: temaId)
                            .where('userId',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .where('esVisto', isEqualTo: true)
                            .get(),
                        FirebaseFirestore.instance
                            .collection('MaterialVisto')
                            .where('temaId', isEqualTo: temaId)
                            .where('userId',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .where('esVisto', isEqualTo: true)
                            .get(),
                      ]),
                      builder: (context,
                          AsyncSnapshot<List<QuerySnapshot>> snapshots) {
                        if (snapshots.connectionState == ConnectionState.done) {
                          bool completado = snapshots.hasData &&
                              snapshots.data![0].docs.isNotEmpty &&
                              snapshots.data![1].docs.isNotEmpty;

                          print("Tema $temaId completado: $completado");

                          // Asegurar que solo incrementamos una vez y solo si está completado
                          if (completado) {
                            if (!temasCompletados.contains(temaId)) {
                              temasCompletados.add(temaId);
                              completados++;
                              print(
                                  "Incrementando temas completados: $completados");
                            }
                          } else {
                            // Si ya no está completado y estaba contado, lo removemos
                            if (temasCompletados.contains(temaId)) {
                              temasCompletados.remove(temaId);
                              completados--;
                              print(
                                  "Decrementando temas completados: $completados");
                            }
                          }

                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            elevation: 4,
                            child: ListTile(
                              title: Text('${index + 1}. ${tema['name']}'),
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/temasExamen.png'),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (completado)
                                    Text(
                                      'COMPLETADO',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(Icons.school),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MaterialEscolarPage(
                                                  temaId: temaId),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.quiz),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CuestionarioEstudianteScreen(
                                                  temaId: temaId),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$completados de $totalTemas temas completados (${(completados / totalTemas * 100).toStringAsFixed(1)}%)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Cuestionario_Estudiante_Screen/CuestionarioEstudianteScreen.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/MaterialEscolarPage/MaterialEscolarPage.dart';

class ListaTemasCuestionario extends StatefulWidget {
  final String temarioRef;

  ListaTemasCuestionario({required this.temarioRef});

  @override
  _ListaTemasCuestionarioState createState() => _ListaTemasCuestionarioState();
}

class _ListaTemasCuestionarioState extends State<ListaTemasCuestionario> {
  late Future<List<DocumentSnapshot>> _temasFuture;
  int completados = 0;
  Set<String> temasCompletados = Set(); // Para rastrear temas ya contados

  @override
  void initState() {
    super.initState();
    _temasFuture = _fetchTemas();
  }

  /*Future<List<DocumentSnapshot>> _fetchTemas() async {
    print("Iniciando la recuperación de temas del temarioRef: ${widget.temarioRef}");
    final QuerySnapshot temasSnapshot = await FirebaseFirestore.instance
        .collection('temas')
        .where('temarioRef', isEqualTo: widget.temarioRef)
        .get();

    List<DocumentSnapshot> temas = temasSnapshot.docs;
    print("Temas recuperados: ${temas.length}");

    for (var tema in temas) {
      final temaId = tema.id;
      print("Verificando tema: $temaId");

      final cuestionariosSnapshot = await FirebaseFirestore.instance
          .collection('CuestionariosVistos')
          .where('temaId', isEqualTo: temaId)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('esVisto', isEqualTo: true)
          .get();

      final materialSnapshot = await FirebaseFirestore.instance
          .collection('MaterialVisto')
          .where('temaId', isEqualTo: temaId)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('esVisto', isEqualTo: true)
          .get();

      bool completado = cuestionariosSnapshot.docs.isNotEmpty &&
                        materialSnapshot.docs.isNotEmpty;
      print("Cuestionarios vistos: ${cuestionariosSnapshot.docs.length}, Material visto: ${materialSnapshot.docs.length}");
      print("Tema $temaId completado: $completado");

      if (completado) {
        temasCompletados.add(temaId);
        completados++;
      }
    }

    print("Total de temas completados: $completados");
    return temas;
  }*/

  Future<List<DocumentSnapshot>> _fetchTemas() async {
  print("Iniciando la recuperación de temas del temarioRef: ${widget.temarioRef}");
  final QuerySnapshot temasSnapshot = await FirebaseFirestore.instance
      .collection('temas')
      .where('temarioRef', isEqualTo: widget.temarioRef)
      .get();

  List<DocumentSnapshot> temas = temasSnapshot.docs;
  print("Temas recuperados: ${temas.length}");

  for (var tema in temas) {
    final temaId = tema.id;
    final temaNombre = tema['name'];  // Extraer el nombre del tema del documento
    print("Verificando tema: $temaId, Nombre: $temaNombre");

    final cuestionariosSnapshot = await FirebaseFirestore.instance
        .collection('CuestionariosVistos')
        .where('temaId', isEqualTo: temaId)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('esVisto', isEqualTo: true)
        .get();

    final materialSnapshot = await FirebaseFirestore.instance
        .collection('MaterialVisto')
        .where('temaId', isEqualTo: temaId)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('esVisto', isEqualTo: true)
        .get();

    bool completado = cuestionariosSnapshot.docs.isNotEmpty &&
                      materialSnapshot.docs.isNotEmpty;
    print("Cuestionarios vistos: ${cuestionariosSnapshot.docs.length}, Material visto: ${materialSnapshot.docs.length}");
    print("Tema $temaId ($temaNombre) completado: $completado");

    if (completado) {
      temasCompletados.add(temaId);
      completados++;
      print("Tema completado: $temaNombre");  // Agregar esta línea para mostrar el nombre del tema completado
    }
  }

  print("Total de temas completados: $completados");
  return temas;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Temas'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _temasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Esperando datos...");
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final temas = snapshot.data;
          if (temas == null || temas.isEmpty) {
            print("No hay temas asociados a este temario.");
            return Center(child: Text('No hay temas asociados a este temario.'));
          }

          int totalTemas = temas.length;
          print("Total de temas: $totalTemas");

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: temas.length,
                  itemBuilder: (context, index) {
                    final tema = temas[index].data() as Map<String, dynamic>;
                    final temaId = temas[index].id;
                    final completado = temasCompletados.contains(temaId);
                    print("Construyendo widget para tema: $temaId, Completado: $completado");

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        title: Text('${index + 1}. ${tema['name']}'),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/temasExamen.png'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (completado)
                              Text(
                                'COMPLETADO',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.school),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MaterialEscolarPage(temaId: temaId),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.quiz),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CuestionarioEstudianteScreen(
                                            temaId: temaId),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$completados de $totalTemas temas completados (${(completados / totalTemas * 100).toStringAsFixed(1)}%)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
