/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Examenes_Preguntas_Propuestas/examenes_preguntas_propuestas.dart';

class ExamenEstudianteScreen extends StatefulWidget {
  final String temaId;

  ExamenEstudianteScreen({required this.temaId});

  @override
  _ExamenEstudianteScreenState createState() => _ExamenEstudianteScreenState();
}

class _ExamenEstudianteScreenState extends State<ExamenEstudianteScreen> {
  List<Map<String, dynamic>> examenes = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarExamenes();
  }

  void _cargarExamenes() async {
    try {
      print("Tema seleccionado: ${widget.temaId}");
      DocumentSnapshot temaSnapshot = await FirebaseFirestore.instance
          .collection('temas')
          .doc(widget.temaId)
          .get();

      if (!temaSnapshot.exists) {
        setState(() {
          cargando = false;
          examenes = [];
        });
        print("El tema no existe.");
        return;
      }

      QuerySnapshot examenesSnapshot = await FirebaseFirestore.instance
          .collection('Examen')
          .where('temaId', isEqualTo: widget.temaId)
          .get();

      if (examenesSnapshot.docs.isEmpty) {
        setState(() {
          cargando = false;
          examenes = [];
        });
        print("No hay exámenes disponibles para este tema.");
        return;
      }

      List<Map<String, dynamic>> examenesData =
          examenesSnapshot.docs.map((DocumentSnapshot document) {
        return {
          ...document.data() as Map<String, dynamic>,
          'selected': false,
          'temaName': temaSnapshot['name'],
        };
      }).toList();

      setState(() {
        cargando = false;
        examenes = examenesData;
      });

      print("Examenes cargados con éxito: ${examenes.length}");
    } catch (e) {
      setState(() {
        cargando = false;
        examenes = [];
      });
      print("Error al cargar exámenes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Examenes del Tema'),
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : examenes.isEmpty
              ? Center(
                  child: Text('No hay exámenes disponibles para este tema.'),
                )
              : ListView.builder(
                  itemCount: examenes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Image.asset(
                          'images/examen_resultado.png',
                          width: 50.0,
                          height: 50.0,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nombre: ${examenes[index]['nombre'] ?? ''}',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Text(
                              'Tema: ${examenes[index]['temaName'] ?? ''}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              'Descripción: ${examenes[index]['descripcion'] ?? ''}',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            examenes[index]['selected']
                                ? Icons.question_answer
                                : Icons.question_answer_outlined,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExamenPreguntasPropuestas(
                                  selectedExamen: examenes[
                                      index], // Pasa el examen seleccionado
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Examenes_Preguntas_Propuestas/examenes_preguntas_propuestas.dart';

class ExamenPage extends StatefulWidget {
  final String temaId;

  ExamenPage({required this.temaId});
  @override
  _ExamenPageState createState() => _ExamenPageState();
}

class _ExamenPageState extends State<ExamenPage> {
  String selectedThemeId = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> examenes = [];
  List<DropdownMenuItem<String>> items = [];
  int selectedQuizIndex = -1;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadExamenesFromFirestore();
  }

  Future<void> _loadExamenesFromFirestore() async {
    try {
      // Utiliza widget.temaId para cargar examenes específicos para ese tema.
      QuerySnapshot examenesSnapshot = await firestore
          .collection('Examen')
          .where('temaId', isEqualTo: widget.temaId) // Filtra por temaId
          .get();

      setState(() {
        examenes = examenesSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id, // Agrega el ID del documento al mapa
            ...data, // Agrega el resto de los datos del documento al mapa
          };
        }).toList();
      });
    } catch (e) {
      print('Error al cargar examenes desde Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Examen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: examenes.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> examen = examenes[index];
                  return Card(
                    child: ListTile(
                      title: Text('Nombre: ${examen['nombre'] ?? ''}'),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<DocumentSnapshot>(
                                  future: firestore
                                      .collection('temas')
                                      .doc(examen['temaId'])
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text('Tema: Cargando...');
                                    }
                                    if (!snapshot.hasData) {
                                      return Text('Tema: Desconocido');
                                    }
                                    String themeName =
                                        snapshot.data!['name'] as String;
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
                          IconButton(
                            icon: Icon(Icons.question_answer),
                            onPressed: () {
                              debugPrint(
                                  'Examen seleccionado: ${examen.toString()}');
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ExamenPreguntasPropuestas(
                                  selectedExamen:
                                      examen, // Asegúrate de que este mapa contenga el campo idExamen
                                ),
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
