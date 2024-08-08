/*import 'package:flutter/material.dart';
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
        backgroundColor: Colors.white54,
      ),
      body: temarios.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: temarios.length,
              itemBuilder: (context, index) {
                final temario = temarios[index];
                bool isSelected = temario['selected'] ?? false;
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
                              : [Colors.grey[100]!, Colors.grey[300]!],
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
                              AssetImage('images/temariosExamen.png'),
                          radius: 30,
                        ),
                        trailing: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.arrow_forward_ios,
                          color: Colors.black54,
                          size: 30,
                        ),
                        onTap: () => _onTemarioSelected(index),
                        selected: isSelected,
                        selectedTileColor: Colors.grey[200],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _onTemarioSelected(int index) {
    setState(() {
      for (int i = 0; i < temarios.length; i++) {
        temarios[i]['selected'] = i == index;
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaTemasExamen(temario: temarios[index]),
      ),
    );
  }
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

  /*Future<List<Map<String, dynamic>>> getTemarios() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('temario').get();
    return querySnapshot.docs
        .map((DocumentSnapshot document) =>
            document.data() as Map<String, dynamic>)
        .toList();
  }*/
  Future<List<Map<String, dynamic>>> getTemarios() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('temario')
        .orderBy('name') // Ordena alfabéticamente por el campo 'name'
        .get();
    return querySnapshot.docs
        .map((DocumentSnapshot document) =>
            document.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  void initState() {
    super.initState();
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
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: temarios.length,
                    itemBuilder: (context, index) {
                      final temario = temarios[index];
                      bool isSelected = temario['selected'] ?? false;
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
                                    : [Colors.grey[100]!, Colors.grey[300]!],
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
                                    AssetImage('images/temariosExamen.png'),
                                radius: 30,
                              ),
                              trailing: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.arrow_forward_ios,
                                color: Colors.black54,
                                size: 30,
                              ),
                              onTap: () => _onTemarioSelected(index),
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
                    'Total de temarios: ${temarios.length}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }

  void _onTemarioSelected(int index) {
    setState(() {
      for (int i = 0; i < temarios.length; i++) {
        temarios[i]['selected'] = i == index;
      }
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaTemasExamen(temario: temarios[index]),
      ),
    );
  }
}
