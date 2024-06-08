/*import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temas/DetallesTemaScreen.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temas/RegistrarTemas.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temas/EditarTemas.dart';

class ListarTemas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Temas'),
      ),
      body: TemaList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrarTemas()),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class TemaList extends StatefulWidget {
  @override
  _TemarioListState createState() => _TemarioListState();
}

class _TemarioListState extends State<TemaList> {
  late TextEditingController searchController;
  String? _selectedTemaId;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  Future<void> _eliminarTema(String temaId) async {
    try {
      var temaRef = FirebaseFirestore.instance.collection('temas').doc(temaId);
      temaRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El tema se eliminó correctamente'),
        ),
      );

      setState(() {});
    } catch (error) {
      print('Error al eliminar el tema: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar el tema. Por favor, inténtalo de nuevo.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Buscar por nombre',
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('temas').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var temas = snapshot.data!.docs;

              var filteredTemas = temas.where((tema) {
                var name = (tema.data() as Map<String, dynamic>)['name'];
                return name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
              }).toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredTemas.length,
                      itemBuilder: (context, index) {
                        var tema =
                            filteredTemas[index].data() as Map<String, dynamic>;
                        var temaId = filteredTemas[index].id;
                        var name = tema['name'];
                        var temarioRef = tema['temarioRef'];

                        return Card(
                          margin: EdgeInsets.all(8.0),
                          color: _selectedTemaId == temaId ? Colors.blue : null,
                          child: ListTile(
                            leading: Image.asset(
                              'images/temas.png',
                              width: 48,
                              height: 48,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tema: $name'),
                                Text(
                                  'Temario: $temarioRef',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              _seleccionarTema(temaId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetallesTemaScreen(temaId: temaId),
                                ),
                              );
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditarTemas(temaId: temaId),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Eliminar Tema'),
                                          content: Text(
                                            '¿Estás seguro de que deseas eliminar este tema?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _eliminarTema(temaId);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Eliminar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Cantidad de Temas: ${filteredTemas.length}',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _seleccionarTema(String temaId) {
    setState(() {
      _selectedTemaId = temaId;
    });
  }
}
*/

import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temas/DetallesTemaScreen.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temas/RegistrarTemas.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temas/EditarTemas.dart';

class ListarTemas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Temas'),
      ),
      body: TemaList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrarTemas()),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class TemaList extends StatefulWidget {
  @override
  _TemarioListState createState() => _TemarioListState();
}

class _TemarioListState extends State<TemaList> {
  late TextEditingController searchController;
  String? _selectedTemaId;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  Future<void> _eliminarTema(String temaId) async {
    try {
      var temaRef = FirebaseFirestore.instance.collection('temas').doc(temaId);
      temaRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El tema se eliminó correctamente'),
        ),
      );

      setState(() {});
    } catch (error) {
      print('Error al eliminar el tema: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar el tema. Por favor, inténtalo de nuevo.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Buscar por nombre',
              suffixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('temas').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var temas = snapshot.data!.docs;

              var filteredTemas = temas.where((tema) {
                var name = (tema.data() as Map<String, dynamic>)['name'];
                return name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
              }).toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredTemas.length,
                      itemBuilder: (context, index) {
                        var tema =
                            filteredTemas[index].data() as Map<String, dynamic>;
                        var temaId = filteredTemas[index].id;
                        var name = tema['name'];
                        var temarioRef = tema['temarioRef'];

                        return Card(
                          margin: EdgeInsets.all(8.0),
                          color: _selectedTemaId == temaId ? Colors.blue : null,
                          child: ListTile(
                            leading: Image.asset(
                              'images/temas.png',
                              width: 48,
                              height: 48,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tema: $name'),
                                Text(
                                  'Temario: $temarioRef',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              _seleccionarTema(temaId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetallesTemaScreen(temaId: temaId),
                                ),
                              );
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditarTemas(temaId: temaId),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Eliminar Tema'),
                                          content: Text(
                                            '¿Estás seguro de que deseas eliminar este tema?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _eliminarTema(temaId);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Eliminar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Cantidad de Temas: ${filteredTemas.length}',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _seleccionarTema(String temaId) {
    setState(() {
      _selectedTemaId = temaId;
    });
  }
}
