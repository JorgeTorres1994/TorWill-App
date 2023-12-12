/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Examen_Estudiante_Screen/ExamenEstudianteScreen.dart';

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
                    return ListTile(
                      leading: Image.asset(
                        'images/temasExamen.png', // Ruta de la imagen por defecto
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
                            builder: (context) => ExamenPage(
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
                    return ListTile(
                      leading: Image.asset(
                        'images/temasExamen.png', // Ruta de la imagen por defecto
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
                            builder: (context) => ExamenPage(
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
