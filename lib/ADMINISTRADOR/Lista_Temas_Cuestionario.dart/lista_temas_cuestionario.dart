/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          temas = snapshot.data!.docs;

          if (temas.isEmpty) {
            return Center(
              child: Text('No hay temas asociados a este temario.'),
            );
          }

          return ListView.builder(
            itemCount: temas.length,
            itemBuilder: (context, index) {
              final tema = temas[index].data() as Map<String, dynamic>;
              final temaId = temas[index].id;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  title: Text('${index + 1}. ${tema['name']}'),
                  subtitle: Text(''),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      'images/temasExamen.png',
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.school),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MaterialEscolarPage(
                                temaId: temaId
                              ),
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
                              builder: (context) => CuestionarioEstudianteScreen(
                                temaId: temaId,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          temas = snapshot.data!.docs;

          if (temas.isEmpty) {
            return Center(
              child: Text('No hay temas asociados a este temario.'),
            );
          }

          return ListView.builder(
            itemCount: temas.length,
            itemBuilder: (context, index) {
              final tema = temas[index].data() as Map<String, dynamic>;
              final temaId = temas[index].id;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: ListTile(
                  title: Text('${index + 1}. ${tema['name']}'),
                  subtitle: Text(''),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      'images/temasExamen.png',
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.school),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MaterialEscolarPage(
                                temaId: temaId
                              ),
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
                              builder: (context) => CuestionarioEstudianteScreen(
                                temaId: temaId,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
