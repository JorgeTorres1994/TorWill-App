/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temas_Cuestionario.dart/lista_temas_cuestionario.dart';

class ListaTemariosEstudiantes extends StatefulWidget {
  ListaTemariosEstudiantes();

  @override
  _ListaTemariosEstudiantesState createState() =>
      _ListaTemariosEstudiantesState();
}

class _ListaTemariosEstudiantesState extends State<ListaTemariosEstudiantes> {
  late Future<List<DocumentSnapshot>> _temariosFuture;

  @override
  void initState() {
    super.initState();
    _temariosFuture = _fetchTemarios(); // Inicialización de la carga de datos
  }

  Future<List<DocumentSnapshot>> _fetchTemarios() async {
    final QuerySnapshot temariosSnapshot =
        await FirebaseFirestore.instance.collection('temario').get();

    return temariosSnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Temarios'),
        backgroundColor: Colors.white54,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _temariosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final temarios = snapshot.data;

          if (temarios == null || temarios.isEmpty) {
            return Center(child: Text('No hay temarios disponibles.'));
          }

          return ListView.builder(
            itemCount: temarios.length,
            itemBuilder: (context, index) {
              final temario = temarios[index].data() as Map<String, dynamic>;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: LinearGradient(
                        colors: [Colors.grey[300]!, Colors.grey[500]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15.0),
                      title: Text(
                        '${index + 1}. ${temario['name']}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('images/temasExamen.png'),
                        radius: 30,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListaTemasCuestionario(
                                temarioRef: temario['name']),
                          ),
                        );
                      },
                    ),
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
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temas_Cuestionario.dart/lista_temas_cuestionario.dart';

class ListaTemariosEstudiantes extends StatefulWidget {
  ListaTemariosEstudiantes();

  @override
  _ListaTemariosEstudiantesState createState() =>
      _ListaTemariosEstudiantesState();
}

class _ListaTemariosEstudiantesState extends State<ListaTemariosEstudiantes> {
  late Future<List<DocumentSnapshot>> _temariosFuture;

  @override
  void initState() {
    super.initState();
    _temariosFuture = _fetchTemarios(); // Inicialización de la carga de datos
  }

  /*Future<List<DocumentSnapshot>> _fetchTemarios() async {
    final QuerySnapshot temariosSnapshot =
        await FirebaseFirestore.instance.collection('temario').get();
    return temariosSnapshot.docs;
  }*/

  Future<List<DocumentSnapshot>> _fetchTemarios() async {
    final QuerySnapshot temariosSnapshot = await FirebaseFirestore.instance
        .collection('temario')
        .orderBy('name') // Añade ordenamiento por el campo 'name'
        .get();
    return temariosSnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Temarios'),
        backgroundColor: Colors.white54,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _temariosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final temarios = snapshot.data;
          if (temarios == null || temarios.isEmpty) {
            return Center(child: Text('No hay temarios disponibles.'));
          }
          int totalTemarios = temarios.length;

          return Stack(
            children: [
              ListView.builder(
                itemCount: temarios.length,
                itemBuilder: (context, index) {
                  final temario =
                      temarios[index].data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            colors: [Colors.grey[300]!, Colors.grey[500]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15.0),
                          title: Text(
                            '${index + 1}. ${temario['name']}',
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
                                builder: (context) => ListaTemasCuestionario(
                                    temarioRef: temario['name']),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Total de temarios: $totalTemarios',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
