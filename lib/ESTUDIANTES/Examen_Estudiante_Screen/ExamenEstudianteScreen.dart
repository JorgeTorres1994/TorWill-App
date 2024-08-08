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
  String selectedThemeId = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> examenes = [];
  List<DropdownMenuItem<String>> items = [];
  int selectedQuizIndex = -1;
  bool isLoading = true;  // Estado para controlar la carga

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
        isLoading = false;  // Actualiza el estado de carga
      });
    } catch (e) {
      print('Error al cargar examenes desde Firestore: $e');
      setState(() {
        isLoading = false;  // Actualiza el estado de carga en caso de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Examen"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : examenes.isEmpty
              ? Center(
                  child: Text(
                    'No hay exámenes disponibles para este tema.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
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
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Text('Tema: Cargando...');
                                              }
                                              if (!snapshot.hasData) {
                                                return Text('Tema: Desconocido');
                                              }
                                              String themeName = snapshot.data!['name'] as String;
                                              return Text('Tema: $themeName');
                                            },
                                          ),
                                          Text('Descripción: ${examen['descripcion'] ?? ''}'),
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
                                        debugPrint('Examen seleccionado: ${examen.toString()}');
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => ExamenPreguntasPropuestas(
                                            selectedExamen: examen, // Asegúrate de que este mapa contenga el campo idExamen
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
*/

import 'package:flutter/material.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExamenesFromFirestore();
  }

  Future<void> _loadExamenesFromFirestore() async {
    try {
      QuerySnapshot examenesSnapshot = await FirebaseFirestore.instance
          .collection('Examen')
          .where('temaId', isEqualTo: widget.temaId)
          .get();

      setState(() {
        isLoading = false;
        examenes = examenesSnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          };
        }).toList();
      });
    } catch (e) {
      print('Error al cargar examenes desde Firestore: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  /*ImageProvider<Object> getImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      return AssetImage('images/placeholder.png');
    }
  }*/

  ImageProvider<Object> getImage(String? imageUrl) {
    const String placeholderUrl =
        'https://cdn-icons-png.flaticon.com/128/2817/2817202.png';
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      return NetworkImage(placeholderUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Examen"),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: examenes.isEmpty
                      ? Center(
                          child: Text(
                              'No hay exámenes disponibles para este tema.',
                              style: TextStyle(fontSize: 18)))
                      : ListView.builder(
                          itemCount: examenes.length,
                          itemBuilder: (context, index) {
                            var examen = examenes[index];
                            return Card(
                              margin: EdgeInsets.all(8),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                title: Text(examen['nombre'] ?? 'N/A',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    examen['descripcion'] ?? 'Sin descripción'),
                                leading: CircleAvatar(
                                  backgroundImage: getImage(examen['imageUrl']),
                                  radius: 25,
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ExamenPreguntasPropuestas(
                                              selectedExamen: examen),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Total de exámenes: ${examenes.length}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}
