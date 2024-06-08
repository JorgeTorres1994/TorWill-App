/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Usuarios/editar_usuario.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Usuarios/registrar_usuario.dart';

class ListarUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LISTA DE USUARIOS'),
      ),
      body: UserList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrarUsuario()),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
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
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var users = snapshot.data!.docs;

              var filteredUsers = users.where((user) {
                var displayName =
                    (user.data() as Map<String, dynamic>)['display_name'];
                return displayName
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
              }).toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        var user =
                            filteredUsers[index].data() as Map<String, dynamic>;
                        var displayName = user['display_name'];
                        var gender = user['gender'];

                        // Definir las rutas de las imágenes según el género
                        var genderImagePath = gender == 'Masculino'
                            ? 'images/chico.png'
                            : 'images/leyendo.png';

                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(genderImagePath),
                            ),
                            title: Text(displayName),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    var userId = user['user_id'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditarUsuario(
                                          user: user,
                                          userId: userId,
                                        ),
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
                                          title: Text('Eliminar Usuario'),
                                          content: Text(
                                              '¿Estás seguro de que deseas eliminar este usuario?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _eliminarUsuario(
                                                    user['user_id']);
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
                    'Cantidad de Usuarios: ${filteredUsers.length}',
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

  void _eliminarUsuario(String userId) {
    try {
      var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      userRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El usuario se eliminó correctamente'),
        ),
      );

      setState(() {});
    } catch (error) {
      print('Error al eliminar el usuario: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al eliminar el usuario. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }
}

*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Usuarios/editar_usuario.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Usuarios/registrar_usuario.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:universal_html/html.dart' as html;

class ListarUsuario extends StatefulWidget {
  @override
  _ListarUsuarioState createState() => _ListarUsuarioState();
}

class _ListarUsuarioState extends State<ListarUsuario> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('LISTA DE ESTUDIANTES'),
      ),*/
      appBar: AppBar(
        title: Row(
          children: [
            Text('LISTA DE ESTUDIANTES'),
            SizedBox(width: 8), // Espacio entre el texto y el botón
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                _exportarPDF(); // Llamada para exportar los datos a PDF
              },
            ),
          ],
        ),
      ),
      body: UserList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrarUsuario()),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Future<void> _exportarPDF() async {
    final pdf = pdfLib.Document();

    // Consulta todos los usuarios
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('isAdmin', isEqualTo: false)
        .get();

    final users = querySnapshot.docs;

    // Agregar datos de usuarios al PDF
    for (var user in users) {
      pdf.addPage(
        pdfLib.MultiPage(
          build: (context) => [
            pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
              ['Nombre', 'Género'],
              [user['display_name'], user['gender']],
            ]),
          ],
        ),
      );
    }

    // Guardar el PDF en el dispositivo
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'lista_estudiantes.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
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
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('isAdmin', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var users = snapshot.data!.docs;

              var filteredUsers = users.where((user) {
                var displayName =
                    (user.data() as Map<String, dynamic>)['display_name'];
                return displayName
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
              }).toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        var user =
                            filteredUsers[index].data() as Map<String, dynamic>;
                        var displayName = user['display_name'];
                        var gender = user['gender'];

                        // Definir las rutas de las imágenes según el género
                        var genderImagePath = gender == 'Masculino'
                            ? 'images/chico.png'
                            : 'images/leyendo.png';

                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(genderImagePath),
                            ),
                            title: Text(displayName),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    var userId = user['user_id'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditarUsuario(
                                          user: user,
                                          userId: userId,
                                        ),
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
                                          title: Text('Eliminar Usuario'),
                                          content: Text(
                                              '¿Estás seguro de que deseas eliminar este usuario?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _eliminarUsuario(
                                                    user['user_id']);
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
                    'Cantidad de Estudiantes: ${filteredUsers.length}',
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

  void _eliminarUsuario(String userId) {
    try {
      var userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      userRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El usuario se eliminó correctamente'),
        ),
      );

      setState(() {});
    } catch (error) {
      print('Error al eliminar el usuario: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al eliminar el usuario. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }
}