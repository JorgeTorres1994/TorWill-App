/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temarios/EditarTemario.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temarios/RegistrarTemarios.dart';

class ListarTemario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Temarios'),
      ),
      body: TemarioList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrarTemario()),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class TemarioList extends StatefulWidget {
  @override
  _TemarioListState createState() => _TemarioListState();
}

class _TemarioListState extends State<TemarioList> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
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
            stream:
                FirebaseFirestore.instance.collection('temario').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var temarios = snapshot.data!.docs;

              var filteredTemarios = temarios.where((temario) {
                var name = (temario.data() as Map<String, dynamic>)['name'];
                return name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
              }).toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredTemarios.length,
                      itemBuilder: (context, index) {
                        var temario = filteredTemarios[index].data()
                            as Map<String, dynamic>;
                        var name = temario['name'];
                        var description = temario['description'];

                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.asset(
                              'images/temario.png', // Ruta de la imagen por defecto
                              width: 48, // Ancho de la imagen
                              height: 48, // Altura de la imagen
                            ),
                            title: Text(name),
                            subtitle: Text(description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    var temarioId = temario['temario_id'];
                                    if (temarioId != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditarTemario(
                                            temario: temario,
                                            temarioId: temarioId,
                                          ),
                                        ),
                                      );
                                    } else {
                                      print('Error: ID del temario es nulo');
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Eliminar Temario'),
                                          content: Text(
                                            '¿Estás seguro de que deseas eliminar este temario?',
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
                                                _eliminarTemario(
                                                    temario['temario_id']);
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
                    'Cantidad de Temarios: ${filteredTemarios.length}',
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

  void _eliminarTemario(String temarioId) {
    try {
      var temarioRef =
          FirebaseFirestore.instance.collection('temario').doc(temarioId);
      temarioRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El temario se eliminó correctamente'),
        ),
      );

      setState(() {});
    } catch (error) {
      print('Error al eliminar el temario: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar el temario. Por favor, inténtalo de nuevo.',
          ),
        ),
      );
    }
  }
}

*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temarios/EditarTemario.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temarios/RegistrarTemarios.dart';

class ListarTemario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Temarios'),
      ),
      body: TemarioList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrarTemario()),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class TemarioList extends StatefulWidget {
  @override
  _TemarioListState createState() => _TemarioListState();
}

class _TemarioListState extends State<TemarioList> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
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
            stream:
                FirebaseFirestore.instance.collection('temario').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var temarios = snapshot.data!.docs;

              var filteredTemarios = temarios.where((temario) {
                var name = (temario.data() as Map<String, dynamic>)['name'];
                return name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
              }).toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredTemarios.length,
                      itemBuilder: (context, index) {
                        var temario = filteredTemarios[index].data()
                            as Map<String, dynamic>;
                        var name = temario['name'];
                        var description = temario['description'];

                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.asset(
                              'images/temario.png', // Ruta de la imagen por defecto
                              width: 48, // Ancho de la imagen
                              height: 48, // Altura de la imagen
                            ),
                            title: Text(name),
                            subtitle: Text(description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    var temarioId = temario['temario_id'];
                                    if (temarioId != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditarTemario(
                                            temario: temario,
                                            temarioId: temarioId,
                                          ),
                                        ),
                                      );
                                    } else {
                                      print('Error: ID del temario es nulo');
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Eliminar Temario'),
                                          content: Text(
                                            '¿Estás seguro de que deseas eliminar este temario?',
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
                                                _eliminarTemario(
                                                    temario['temario_id']);
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
                    'Cantidad de Temarios: ${filteredTemarios.length}',
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

  void _eliminarTemario(String temarioId) {
    try {
      var temarioRef =
          FirebaseFirestore.instance.collection('temario').doc(temarioId);
      temarioRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El temario se eliminó correctamente'),
        ),
      );

      setState(() {});
    } catch (error) {
      print('Error al eliminar el temario: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar el temario. Por favor, inténtalo de nuevo.',
          ),
        ),
      );
    }
  }
}
