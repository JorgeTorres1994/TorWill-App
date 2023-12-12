/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temas_Examen/lista_temas_examen.dart';

class ListaTemariosExamen extends StatefulWidget {
  @override
  _ListaExamenesPorTemarioState createState() =>
      _ListaExamenesPorTemarioState();
}

class _ListaExamenesPorTemarioState extends State<ListaTemariosExamen> {
  List<Map<String, dynamic>> temarios = [];

  Future<List<Map<String, dynamic>>> getTemarios() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('temario').get();

    return querySnapshot.docs
        .map((DocumentSnapshot document) =>
            document.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Cargar los temarios al inicio
    getTemarios().then((temariosList) {
      setState(() {
        temarios = temariosList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona el temario de tu examen'),
      ),
      body: temarios.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: temarios.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    temarios[index]['name'],
                    style:
                        TextStyle(fontSize: 20.0), // Tamaño de texto ajustado
                  ),
                  leading: Image.asset(
                    'images/temariosExamen.png',
                    width: 100.0, // Ancho de la imagen ajustado
                    height: 100.0, // Altura de la imagen ajustada
                  ),
                  onTap: () {
                    // Lógica de selección del temario
                    _onTemarioSelected(temarios[index]);
                  },
                  // Efecto de selección
                  selected: temarios[index]['selected'] ?? false,
                  tileColor: temarios[index]['selected'] ?? false
                      ? Colors.blue.withOpacity(0.3)
                      : null,
                  // Otros estilos según tus necesidades
                );
              },
            ),
    );
  }

  void _onTemarioSelected(Map<String, dynamic> temario) {}
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temas_Examen/lista_temas_examen.dart';

class ListaTemariosExamen extends StatefulWidget {
  @override
  _ListaExamenesPorTemarioState createState() =>
      _ListaExamenesPorTemarioState();
}

class _ListaExamenesPorTemarioState extends State<ListaTemariosExamen> {
  List<Map<String, dynamic>> temarios = [];

  Future<List<Map<String, dynamic>>> getTemarios() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('temario').get();

    return querySnapshot.docs
        .map((DocumentSnapshot document) =>
            document.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Cargar los temarios al inicio
    getTemarios().then((temariosList) {
      setState(() {
        temarios = temariosList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona el temario de tu examen'),
      ),
      body: temarios.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: temarios.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    temarios[index]['name'],
                    style: TextStyle(fontSize: 20.0),
                  ),
                  leading: Image.asset(
                    'images/temariosExamen.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                  onTap: () {
                    // Lógica de selección del temario
                    _onTemarioSelected(temarios[index]);
                  },
                  selected: temarios[index]['selected'] ?? false,
                  tileColor: temarios[index]['selected'] ?? false
                      ? Colors.blue.withOpacity(0.3)
                      : null,
                );
              },
            ),
    );
  }

  void _onTemarioSelected(Map<String, dynamic> temario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaTemasExamen(temario: temario),
      ),
    );
  }
}
