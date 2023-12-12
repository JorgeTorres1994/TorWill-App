/* import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/Bienvenida/Lista_Temas_Cuestionario.dart/lista_temas_cuestionario.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/ChatScreen/ChatScreen.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temarios_Examen/Lista_Temarios_Examen.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Notas_Estudiantes/notas_estudiantes.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/PerfilEstudiante/PerfilEstudiante.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/PerfilProfesor/PerfilProfesor.dart';
import 'package:nueva_app_web_matematicas/Login.dart';

class DashboardEstudiante extends StatefulWidget {
  @override
  _DashboardEstudianteState createState() => _DashboardEstudianteState();
}

class _DashboardEstudianteState extends State<DashboardEstudiante> {
  late User? _user;
  late Map<String, dynamic> _userData = {};
  List<Map<String, dynamic>> temarios = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTemarios();
  }

  Future<void> _loadUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          _userData = userSnapshot.data() as Map<String, dynamic>;
        });
      }
    }
  }

  Future<void> _loadTemarios() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('temario').get();

      setState(() {
        temarios = querySnapshot.docs
            .map((DocumentSnapshot document) =>
                document.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (error) {
      print('Error al cargar los temarios: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Estudiante'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Lógica para manejar las notificaciones
            },
          ),
        ],
        flexibleSpace: Container(
          color: Colors.grey[300], // Color del banner
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: _user != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 37,
                          backgroundImage: AssetImage(
                            _userData['gender'] == 'Masculino'
                                ? 'images/chico.png'
                                : 'images/leyendo.png',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _userData['display_name'] ?? 'Usuario',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
            buildDrawerOption(context, Icons.home, 'Inicio', () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardEstudiante()));
            }),
            buildDrawerOption(context, Icons.person, 'Profesor', () async {
              // Obtener el ID del usuario con isAdmin = true
              var querySnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .where('isAdmin', isEqualTo: true)
                  .get();

              if (querySnapshot.docs.isNotEmpty) {
                var userId = querySnapshot.docs.first.id;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilProfesor(userId: userId),
                  ),
                );
              } else {
                // Manejar el caso en el que no se encuentre un usuario con isAdmin = true
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('No se encontró un usuario con isAdmin = true'),
                  ),
                );
              }
            }),
            buildDrawerOption(context, Icons.assignment, 'Examenes', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListaTemariosExamen(),
                ),
              );
            }),
            buildDrawerOption(context, Icons.stars, 'Notas', () {
              String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NotasEstudiantesScreen(userId: userId)));
            }),
            buildDrawerOption(context, Icons.person, 'Perfil', () {
              // Obtener el usuario actual
              User? user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                // Pasar el userId del usuario actual al EditarPerfil
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilEstudiante(userId: user.uid),
                  ),
                );
              } else {
                // Manejar el caso en el que el usuario no está autenticado
                print('Usuario no autenticado');
                _showSnackBar('Debes iniciar sesión para editar tu perfil');
              }
            }),
            buildDrawerOption(context, Icons.message, 'Mensajería', () async {
              // Obtener el usuario actual
              User? user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                // Obtener el ID del estudiante que inició sesión
                var studentId = user.uid;

                // Obtener el ID del profesor con isAdmin = true
                var querySnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .where('isAdmin', isEqualTo: true)
                    .limit(1)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  var professorId = querySnapshot.docs.first.id;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        studentUserId: studentId,
                        professorUserId: professorId,
                      ),
                    ),
                  );
                } else {
                  // Manejar el caso en el que no se encuentre un usuario con isAdmin = true
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('No se encontró un profesor con isAdmin = true'),
                    ),
                  );
                }
              } else {
                // Manejar el caso en que el usuario no está autenticado
                print('Usuario no autenticado');
                _showSnackBar('Debes iniciar sesión para usar la mensajería');
              }
            }),
            buildDrawerOption(context, Icons.exit_to_app, 'Cerrar Sesión', () {
              _confirmLogout(context);
            }),
          ],
        ),
      ),
      body: Center(
        child: temarios.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: temarios.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      temarios[index]['name'],
                      style: TextStyle(fontSize: 20.0),
                    ),
                    leading: Image.asset(
                      'images/temario.png', // Puedes cambiar el nombre de la imagen si es diferente
                      width: 100.0,
                      height: 100.0,
                    ),
                    onTap: () {
                      _onTemarioSelected(temarios[index]);
                    },
                  );
                },
              ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                logout(context);
                Navigator.of(context).pop();
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  void logout(BuildContext context) async {
    try {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print('Error al cerrar sesión: $e');
      String errorMessage = 'Ocurrió un error al cerrar sesión';
      if (e is FirebaseAuthException) {
        errorMessage = _logoutAuthError(e);
      }
      _showSnackBar(errorMessage);
    }
  }

  String _logoutAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      default:
        return 'Error desconocido al cerrar sesión';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget buildDrawerOption(
      BuildContext context, IconData icon, String label, Function onTap) {
    return ListTile(
      leading:
          Icon(icon, size: 30, color: Theme.of(context).colorScheme.secondary),
      title: Text(label, style: TextStyle(fontSize: 18)),
      onTap: onTap as void Function()?,
    );
  }

  void _onTemarioSelected(Map<String, dynamic> selectedTemario) {
    // Puedes hacer lo que necesites con el temario seleccionado
    print('Temario seleccionado: $selectedTemario');
    // También puedes actualizar el estado para marcar el temario como seleccionado
    setState(() {
      temarios.forEach((temario) {
        temario['selected'] = false;
      });
      selectedTemario['selected'] = true;
    });

    // Acceder a la lista de temas del temario seleccionado
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaTemasCuestionario(temario: selectedTemario),
      ),
    );
  }
}


*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/Bienvenida/Lista_Temas_Cuestionario.dart/lista_temas_cuestionario.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/ChatScreen/ChatScreen.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temarios_Examen/Lista_Temarios_Examen.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Notas_Estudiantes/notas_estudiantes.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/PerfilEstudiante/PerfilEstudiante.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/PerfilProfesor/PerfilProfesor.dart';
import 'package:nueva_app_web_matematicas/Login.dart';

class DashboardEstudiante extends StatefulWidget {
  @override
  _DashboardEstudianteState createState() => _DashboardEstudianteState();
}

class _DashboardEstudianteState extends State<DashboardEstudiante> {
  late User? _user;
  late Map<String, dynamic> _userData = {};
  List<Map<String, dynamic>> temarios = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTemarios();
  }

  Future<void> _loadUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          _userData = userSnapshot.data() as Map<String, dynamic>;
        });
      }
    }
  }

  Future<void> _loadTemarios() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('temario').get();

      setState(() {
        temarios = querySnapshot.docs
            .map((DocumentSnapshot document) =>
                document.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (error) {
      print('Error al cargar los temarios: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Estudiante'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Lógica para manejar las notificaciones
            },
          ),
        ],
        flexibleSpace: Container(
          color: Colors.grey[300], // Color del banner
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: _user != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 37,
                          backgroundImage: AssetImage(
                            _userData['gender'] == 'Masculino'
                                ? 'images/chico.png'
                                : 'images/leyendo.png',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _userData['display_name'] ?? 'Usuario',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : CircularProgressIndicator(),
            ),
            buildDrawerOption(context, Icons.home, 'Inicio', () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DashboardEstudiante()));
            }),
            buildDrawerOption(context, Icons.person, 'Profesor', () async {
              // Obtener el ID del usuario con isAdmin = true
              var querySnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .where('isAdmin', isEqualTo: true)
                  .get();

              if (querySnapshot.docs.isNotEmpty) {
                var userId = querySnapshot.docs.first.id;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilProfesor(userId: userId),
                  ),
                );
              } else {
                // Manejar el caso en el que no se encuentre un usuario con isAdmin = true
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('No se encontró un usuario con isAdmin = true'),
                  ),
                );
              }
            }),
            buildDrawerOption(context, Icons.assignment, 'Examenes', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListaTemariosExamen(),
                ),
              );
            }),
            buildDrawerOption(context, Icons.stars, 'Notas', () {
              String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NotasEstudiantesScreen(userId: userId)));
            }),
            buildDrawerOption(context, Icons.person, 'Perfil', () {
              // Obtener el usuario actual
              User? user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                // Pasar el userId del usuario actual al EditarPerfil
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilEstudiante(userId: user.uid),
                  ),
                );
              } else {
                // Manejar el caso en el que el usuario no está autenticado
                print('Usuario no autenticado');
                _showSnackBar('Debes iniciar sesión para editar tu perfil');
              }
            }),
            buildDrawerOption(context, Icons.message, 'Mensajería', () async {
              // Obtener el usuario actual
              User? user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                // Obtener el ID del estudiante que inició sesión
                var studentId = user.uid;

                // Obtener el ID del profesor con isAdmin = true
                var querySnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .where('isAdmin', isEqualTo: true)
                    .limit(1)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  var professorId = querySnapshot.docs.first.id;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        studentUserId: studentId,
                        professorUserId: professorId,
                      ),
                    ),
                  );
                } else {
                  // Manejar el caso en el que no se encuentre un usuario con isAdmin = true
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('No se encontró un profesor con isAdmin = true'),
                    ),
                  );
                }
              } else {
                // Manejar el caso en que el usuario no está autenticado
                print('Usuario no autenticado');
                _showSnackBar('Debes iniciar sesión para usar la mensajería');
              }
            }),
            buildDrawerOption(context, Icons.exit_to_app, 'Cerrar Sesión', () {
              _confirmLogout(context);
            }),
          ],
        ),
      ),
      body: Center(
        child: temarios.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: temarios.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      temarios[index]['name'],
                      style: TextStyle(fontSize: 20.0),
                    ),
                    leading: Image.asset(
                      'images/cuestionario.png', // Puedes cambiar el nombre de la imagen si es diferente
                      width: 100.0,
                      height: 100.0,
                    ),
                    onTap: () {
                      _onTemarioSelected(temarios[index]);
                    },
                  );
                },
              ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                logout(context);
                Navigator.of(context).pop();
              },
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  void logout(BuildContext context) async {
    try {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print('Error al cerrar sesión: $e');
      String errorMessage = 'Ocurrió un error al cerrar sesión';
      if (e is FirebaseAuthException) {
        errorMessage = _logoutAuthError(e);
      }
      _showSnackBar(errorMessage);
    }
  }

  String _logoutAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      default:
        return 'Error desconocido al cerrar sesión';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget buildDrawerOption(
      BuildContext context, IconData icon, String label, Function onTap) {
    return ListTile(
      leading:
          Icon(icon, size: 30, color: Theme.of(context).colorScheme.secondary),
      title: Text(label, style: TextStyle(fontSize: 18)),
      onTap: onTap as void Function()?,
    );
  }

  void _onTemarioSelected(Map<String, dynamic> selectedTemario) {
    // Puedes hacer lo que necesites con el temario seleccionado
    print('Temario seleccionado: $selectedTemario');
    // También puedes actualizar el estado para marcar el temario como seleccionado
    setState(() {
      temarios.forEach((temario) {
        temario['selected'] = false;
      });
      selectedTemario['selected'] = true;
    });

    // Acceder a la lista de temas del temario seleccionado
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaTemasCuestionario(temario: selectedTemario),
      ),
    );
  }
}
