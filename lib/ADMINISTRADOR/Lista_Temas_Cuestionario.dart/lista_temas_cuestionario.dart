/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Cuestionario_Estudiante_Screen/CuestionarioEstudianteScreen.dart';

class ListaTemasCuestionario extends StatefulWidget {
  final Map<String, dynamic> temario;

  ListaTemasCuestionario({required this.temario});

  @override
  _ListaTemasExamenState createState() => _ListaTemasExamenState();
}

class _ListaTemasExamenState extends State<ListaTemasCuestionario> {
  List<Map<String, dynamic>> temas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarTemas();
  }

  void _cargarTemas() async {
    try {
      QuerySnapshot temasSnapshot = await FirebaseFirestore.instance
          .collection('temas')
          .where('temarioRef', isEqualTo: widget.temario['name'])
          .get();

      setState(() {
        cargando = false;
        temas = temasSnapshot.docs
            .map((DocumentSnapshot document) => {
                  ...document.data() as Map<String, dynamic>,
                  'selected': false,
                  'temaId': document.id, // Asegúrate de agregar el campo 'id'
                })
            .toList();
      });
    } catch (e) {
      setState(() {
        cargando = false;
      });
      print("Error al cargar temas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temas del Cuestionario'),
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : temas.isEmpty
              ? Center(
                  child: Text('No existen temas para este temario.'),
                )
              : ListView.builder(
                  itemCount: temas.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5.0,
                      margin: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8.0,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(
                            'images/temasExamen.png',
                          ),
                        ),
                        title: Text(
                          temas[index]['name'] ?? '',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onTap: () {
                          String temaId = temas[index]['temaId'] ?? '';
                          print("Tema seleccionado: $temaId");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CuestionarioEstudianteScreen(
                                temaId: temaId,
                              ),
                            ),
                          );
                        },
                        selected: temas[index]['selected'] ?? false,
                        tileColor: temas[index]['selected'] ?? false
                            ? Colors.blue.withOpacity(0.3)
                            : null,
                      ),
                    );
                  },
                ),
    );
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/MaterialEscolarPage/MaterialEscolarPage.dart';

class ListaTemasCuestionario extends StatefulWidget {
  final String temarioRef;

  ListaTemasCuestionario({required this.temarioRef});

  @override
  _ListaTemasCuestionarioState createState() => _ListaTemasCuestionarioState();
}

class _ListaTemasCuestionarioState extends State<ListaTemasCuestionario> {
  List<String> selectedTemas = [];
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
                  subtitle: Text('Más información sobre el tema'),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      'images/temasExamen.png',
                    ),
                  ),
                  tileColor: selectedTemas.contains(temaId)
                      ? Colors.blue.withOpacity(0.2)
                      : null,
                  onTap: () async {
                    final temaIndex =
                        temas.indexWhere((element) => element.id == temaId);
                    if (temaIndex != -1) {
                      final tema =
                          temas[temaIndex].data() as Map<String, dynamic>;

                      String urlDelVideo = tema['video'] ?? '';
                      String urlDeRecording = tema['recording'] ?? '';

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MaterialEscolarPage(
                            temaId: temaId,
                            urlDelVideo: urlDelVideo,
                            urlDeRecording: urlDeRecording,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
