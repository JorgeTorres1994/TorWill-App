/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Examen_Estudiante_Screen/ExamenEstudianteScreen.dart';

class ListaTemasExamen extends StatefulWidget {
  final Map<String, dynamic> temario;

  ListaTemasExamen({required this.temario});

  @override
  _ListaTemasExamenState createState() => _ListaTemasExamenState();
}

class _ListaTemasExamenState extends State<ListaTemasExamen> {
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
        title: Text('Temas del Examen'),
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
                    return ListTile(
                      leading: Image.asset(
                        'images/temasExamen.png',
                        width: 50.0,
                        height: 50.0,
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
                            builder: (context) => ExamenEstudianteScreen(
                              temaId: temaId,
                            ),
                          ),
                        );
                      },
                      selected: temas[index]['selected'] ?? false,
                      tileColor: temas[index]['selected'] ?? false
                          ? Colors.blue.withOpacity(0.3)
                          : null,
                    );
                  },
                ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Examen_Estudiante_Screen/ExamenEstudianteScreen.dart';

class ListaTemasExamen extends StatefulWidget {
  final Map<String, dynamic> temario;

  ListaTemasExamen({required this.temario});

  @override
  _ListaTemasExamenState createState() => _ListaTemasExamenState();
}

class _ListaTemasExamenState extends State<ListaTemasExamen> {
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
        temas = temasSnapshot.docs.map((DocumentSnapshot document) {
          return {
            ...document.data() as Map<String, dynamic>,
            'selected': false,
            'temaId': document.id,
          };
        }).toList();
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
        title: Text('Temas del Examen'),
        backgroundColor: Colors.blueAccent,
      ),
      body: cargando
          ? Center(child: CircularProgressIndicator())
          : temas.isEmpty
              ? Center(child: Text('No existen temas para este temario.'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: temas.length,
                        itemBuilder: (context, index) {
                          final tema = temas[index];
                          bool isSelected = tema['selected'];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: isSelected ? 10 : 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  gradient: LinearGradient(
                                    colors: isSelected
                                        ? [Colors.grey[300]!, Colors.grey[500]!]
                                        : [
                                            Colors.grey[100]!,
                                            Colors.grey[300]!
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15.0),
                                  title: Text(
                                    '${index + 1}. ${tema['name']}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('images/temasExamen.png'),
                                    radius: 30,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ExamenEstudianteScreen(
                                          temaId: tema['temaId'],
                                        ),
                                      ),
                                    );
                                  },
                                  selected: isSelected,
                                  selectedTileColor: Colors.grey[200],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total de temas: ${temas.length}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
    );
  }
}
