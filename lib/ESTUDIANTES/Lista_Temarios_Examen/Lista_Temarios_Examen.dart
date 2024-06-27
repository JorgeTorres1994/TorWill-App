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
  _ListaExamenesPorTemarioState createState() => _ListaExamenesPorTemarioState();
}

class _ListaExamenesPorTemarioState extends State<ListaTemariosExamen> {
  List<Map<String, dynamic>> temarios = [];

  Future<List<Map<String, dynamic>>> getTemarios() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('temario').get();

    return querySnapshot.docs.map((DocumentSnapshot document) => document.data() as Map<String, dynamic>).toList();
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
        backgroundColor: Colors.blueAccent,
      ),
      body: temarios.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: temarios.length,
              itemBuilder: (context, index) {
                final temario = temarios[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: LinearGradient(
                          colors: [Colors.blue[100]!, Colors.blue[400]!],
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
                            color: Colors.white,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/temariosExamen.png'),
                          radius: 30,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 30,
                        ),
                        onTap: () {
                          _onTemarioSelected(temario);
                        },
                        selected: temario['selected'] ?? false,
                        selectedTileColor: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _onTemarioSelected(Map<String, dynamic> temario) {
    setState(() {
      temarios.forEach((element) {
        element['selected'] = false;
      });
      temario['selected'] = true;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaTemasExamen(temario: temario),
      ),
    );
  }
}
