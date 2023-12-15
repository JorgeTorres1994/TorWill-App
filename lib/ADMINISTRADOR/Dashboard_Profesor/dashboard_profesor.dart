/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Cuestionarios/CuestionarioScreen.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/EditarPerfilUsuario/EditarPerfil.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Examenes/ExamenScreen.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/SeleccionNotasScreen/SeleccionNotasScreen.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temarios/ListarTemarios.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temas/ListarTemas.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Usuarios/listar_usuario.dart';
import 'package:nueva_app_web_matematicas/Login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _darkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Panel Administrador'),
          backgroundColor: Colors.blue,
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DrawerHeader(
                  child: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        User? user = snapshot.data;
                        if (user != null) {
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .get(),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.done) {
                                if (userSnapshot.hasError) {
                                  return Text(
                                      'Error al cargar los datos del usuario');
                                }

                                var userData = userSnapshot.data?.data()
                                    as Map<String, dynamic>;
                                var gender = userData['gender'] ?? 'Masculino';
                                var displayName =
                                    userData['display_name'] ?? 'Usuario';

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 37,
                                      backgroundImage: AssetImage(
                                        gender == 'Masculino'
                                            ? 'images/chico.png'
                                            : 'images/leyendo.png',
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      displayName,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return CircularProgressIndicator();
                            },
                          );
                        }
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
                SizedBox(height: 25),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: 9,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Ink(
                      padding: const EdgeInsets.all(11.0),
                      decoration: const ShapeDecoration(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: DashboardItem(
                          icon: getIconForIndex(index),
                          iconSize: 24,
                          fontSize: 12,
                        ),
                        onPressed: () {
                          navigateToScreen(context, index);
                          print('Ícono seleccionado: $index');
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hola Buenos días',
                    style: TextStyle(
                      color: Color.fromARGB(255, 212, 212, 212),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Switch(
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() {
                        _darkMode = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    iconSize: 30,
                    onPressed: () {
                      print('Notificaciones seleccionadas');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int i = 0; i < 3; i++)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DashboardItem(
                              icon: getIconForIndex(i),
                              iconSize: 64,
                              fontSize: 20,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int i = 3; i < 6; i++)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DashboardItem(
                              icon: getIconForIndex(i),
                              iconSize: 64,
                              fontSize: 20,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.person;
      case 2:
        return Icons.article;
      case 3:
        return Icons.assignment;
      case 4:
        return Icons.assignment_turned_in;
      case 5:
        return Icons.assignment_add;
      case 6:
        return Icons.grade;
      case 7:
        return Icons.person_pin_outlined;
      case 8:
        return Icons.exit_to_app;
      default:
        return Icons.error;
    }
  }

  void navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListarUsuario()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListarTemario()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListarTemas()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CuestionarioScreen()));
        break;
      case 5:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExamenScreen()));
        break;
      case 6:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SeleccionNotasScreen()));
        break;
      case 7:
        // Obtener el usuario actual
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Pasar el userId del usuario actual al EditarPerfil
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditarPerfil(userId: user.uid),
            ),
          );
        } else {
          // Manejar el caso en el que el usuario no está autenticado
          print('Usuario no autenticado');
          _showSnackBar('Debes iniciar sesión para editar tu perfil');
        }
        break;

      case 8:
        _confirmLogout(context);
        break;
    }
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final double fontSize;

  const DashboardItem({
    super.key,
    required this.icon,
    this.iconSize = 48,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: Colors.blue,
        ),
        const SizedBox(height: 8),
        Text(
          getLabelForIcon(icon),
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String getLabelForIcon(IconData icon) {
    switch (icon) {
      case Icons.home:
        return 'Inicio';
      case Icons.person:
        return 'Usuarios';
      case Icons.article:
        return 'Temarios';
      case Icons.assignment:
        return 'Temas';
      case Icons.assignment_turned_in:
        return 'Prácticas';
      case Icons.assignment_add:
        return 'Examenes';
      case Icons.grade:
        return 'Notas';
      case Icons.person_pin_outlined:
        return 'Perfil';
      case Icons.exit_to_app:
        return 'Salir';
      default:
        return 'Desconocido';
    }
  }
}

*/

import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Cuestionarios/CuestionarioScreen.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/EditarPerfilUsuario/EditarPerfil.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Examenes/ExamenScreen.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/SeleccionNotasScreen/SeleccionNotasScreen.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temarios/ListarTemarios.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Temas/ListarTemas.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Usuarios/listar_usuario.dart';
import 'package:nueva_app_web_matematicas/Login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isHoveringUsuarios = false;
  bool _isHoveringTemarios = false;
  bool _isHoveringTemas = false;
  bool _isHoveringExamenes = false;
  bool _isHoveringCuestionarios = false;
  bool _isHoveringCalificaciones = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _darkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Panel Administrador'),
          backgroundColor: Colors.blue,
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                /*DrawerHeader(
                  child: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        User? user = snapshot.data;

                        if (user != null) {
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .get(),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.done) {
                                if (userSnapshot.hasError) {
                                  return Text(
                                      'Error al cargar los datos del usuario');
                                }

                                var userData = userSnapshot.data?.data()
                                    as Map<String, dynamic>;
                                var gender = userData['gender'] ?? 'Masculino';
                                var displayName =
                                    userData['display_name'] ?? 'Usuario';

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 37,
                                      backgroundImage: AssetImage(
                                        gender == 'Masculino'
                                            ? 'images/chico.png'
                                            : 'images/leyendo.png',
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      displayName,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return CircularProgressIndicator();
                            },
                          );
                        }
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),*/
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Profesor',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            User? user = snapshot.data;

                            if (user != null) {
                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .get(),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (userSnapshot.hasError) {
                                      return Text(
                                          'Error al cargar los datos del usuario');
                                    }

                                    var userData = userSnapshot.data?.data()
                                        as Map<String, dynamic>;
                                    var gender =
                                        userData['gender'] ?? 'Masculino';
                                    var displayName =
                                        userData['display_name'] ?? 'Usuario';

                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 37,
                                          backgroundImage: AssetImage(
                                            gender == 'Masculino'
                                                ? 'images/chico.png'
                                                : 'images/leyendo.png',
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          displayName,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  return CircularProgressIndicator();
                                },
                              );
                            }
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: 9,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Ink(
                      padding: const EdgeInsets.all(11.0),
                      decoration: const ShapeDecoration(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: DashboardItem(
                          icon: getIconForIndex(index),
                          iconSize: 24,
                          fontSize: 12,
                        ),
                        onPressed: () {
                          navigateToScreen(context, index);
                          print('Ícono seleccionado: $index');
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centra verticalmente
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centra horizontalmente
                children: [
                  Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Hola Buenos días',
                          style: TextStyle(
                            color: Color.fromARGB(255, 212, 212, 212),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Switch(
                          value: _darkMode,
                          onChanged: (value) {
                            setState(() {
                              _darkMode = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          iconSize: 30,
                          onPressed: () {
                            print('Notificaciones seleccionadas');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20.0,
                      runSpacing: 20.0,
                      children: [
                        _buildOptionButton(
                          'Estudiantes',
                          'images/estudiante.png',
                          _handleGenericButtonPress,
                        ),
                        _buildOptionButton(
                          'Temarios',
                          'images/categorias.png',
                          _handleGenericButtonPress,
                        ),
                        _buildOptionButton(
                          'Temas',
                          'images/temasExamen.png',
                          _handleGenericButtonPress,
                        ),
                        _buildOptionButton(
                          'Exámenes',
                          'images/certificado.png',
                          _handleGenericButtonPress,
                        ),
                        _buildOptionButton(
                          'Cuestionarios',
                          'images/boleta-de-calificaciones.png',
                          _handleGenericButtonPress,
                        ),
                        _buildOptionButton(
                          'Calificaciones',
                          'images/calificaciones.png',
                          _handleGenericButtonPress,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    String buttonText,
    String imagePath,
    Function onPressed,
  ) {
    return MouseRegion(
      onEnter: (_) => _onHover(true, buttonText),
      onExit: (_) => _onHover(false, ''),
      child: Container(
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white, // Puedes cambiar el color aquí
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onSurface: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            side: BorderSide(
              color:
                  _isHoveringCalificaciones && buttonText == "Calificaciones" ||
                          _isHoveringTemas && buttonText == "Temas" ||
                          _isHoveringTemarios && buttonText == "Temarios" ||
                          _isHoveringUsuarios && buttonText == "Estudiantes" ||
                          _isHoveringCuestionarios &&
                              buttonText == 'Cuestionarios' ||
                          _isHoveringExamenes && buttonText == 'Exámenes'
                      ? Colors.blue.shade200
                      : Colors.blue,
              width: 2,
            ),
          ),
          onPressed: () {
            onPressed(buttonText);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isHoveringCalificaciones &&
                              buttonText == "Calificaciones" ||
                          _isHoveringTemas && buttonText == "Temas" ||
                          _isHoveringTemarios && buttonText == "Temarios" ||
                          _isHoveringUsuarios && buttonText == "Estudiantes" ||
                          _isHoveringCuestionarios &&
                              buttonText == 'Cuestionarios' ||
                          _isHoveringExamenes && buttonText == 'Exámenes'
                      ? Colors.blue.shade200
                      : Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onHover(bool isHovering, String buttonText) {
    setState(() {
      if (isHovering) {
        if (buttonText == "Calificaciones") {
          _isHoveringCalificaciones = true;
          _isHoveringTemas = false;
          _isHoveringTemarios = false;
          _isHoveringUsuarios = false;
          _isHoveringCuestionarios = false;
          _isHoveringExamenes = false;
        } else if (buttonText == "Temas") {
          _isHoveringTemas = true;
          _isHoveringTemarios = false;
          _isHoveringUsuarios = false;
          _isHoveringCuestionarios = false;
          _isHoveringExamenes = false;
          _isHoveringCalificaciones = false;
        } else if (buttonText == 'Temarios') {
          _isHoveringTemarios = true;
          _isHoveringUsuarios = false;
          _isHoveringCuestionarios = false;
          _isHoveringExamenes = false;
          _isHoveringTemas = false;
          _isHoveringCalificaciones = false;
        } else if (buttonText == 'Estudiantes') {
          _isHoveringUsuarios = true;
          _isHoveringCuestionarios = false;
          _isHoveringExamenes = false;
          _isHoveringTemarios = false;
          _isHoveringTemas = false;
          _isHoveringCalificaciones = false;
        } else if (buttonText == 'Cuestionarios') {
          _isHoveringCuestionarios = true;
          _isHoveringExamenes = false;
          _isHoveringUsuarios = false;
          _isHoveringTemarios = false;
          _isHoveringTemas = false;
          _isHoveringCalificaciones = false;
        } else if (buttonText == 'Exámenes') {
          _isHoveringExamenes = true;
          _isHoveringCuestionarios = false;
          _isHoveringUsuarios = false;
          _isHoveringTemarios = false;
          _isHoveringTemas = false;
          _isHoveringCalificaciones = false;
        }
      } else {
        _isHoveringTemas = false;
        _isHoveringUsuarios = false;
        _isHoveringTemarios = false;
        _isHoveringCuestionarios = false;
        _isHoveringExamenes = false;
        _isHoveringCalificaciones = false;
      }
    });
  }

  void _handleGenericButtonPress(String buttonText) {
    print('Botón $buttonText seleccionado.');
    // Realizar acciones genéricas aquí según sea necesario
  }

  void _handleCardSelection(int index) {
    print('Tarjeta seleccionada: $index');
    // Realizar acciones específicas para la tarjeta seleccionada según sea necesario
  }
}

IconData getIconForIndex(int index) {
  switch (index) {
    case 0:
      return Icons.home;
    case 1:
      return Icons.person;
    case 2:
      return Icons.article;
    case 3:
      return Icons.assignment;
    case 4:
      return Icons.assignment_turned_in;
    case 5:
      return Icons.assignment_add;
    case 6:
      return Icons.grade;
    case 7:
      return Icons.person_pin_outlined;
    case 8:
      return Icons.exit_to_app;
    default:
      return Icons.error;
  }
}

void navigateToScreen(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
      break;
    case 1:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListarUsuario()));
      break;
    case 2:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListarTemario()));
      break;
    case 3:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListarTemas()));
      break;
    case 4:
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CuestionarioScreen()));
      break;
    case 5:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ExamenScreen()));
      break;
    case 6:
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SeleccionNotasScreen()));
      break;
    case 7:
      // Obtener el usuario actual
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Pasar el userId del usuario actual al EditarPerfil
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditarPerfil(userId: user.uid),
          ),
        );
      } else {
        // Manejar el caso en el que el usuario no está autenticado
        print('Usuario no autenticado');
        _showSnackBar('Debes iniciar sesión para editar tu perfil');
      }
      break;

    case 8:
      _confirmLogout(context);
      break;
  }
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

class DashboardItem extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final double fontSize;

  const DashboardItem({
    super.key,
    required this.icon,
    this.iconSize = 48,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: Colors.blue,
        ),
        const SizedBox(height: 8),
        Text(
          getLabelForIcon(icon),
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String getLabelForIcon(IconData icon) {
    switch (icon) {
      case Icons.home:
        return 'Inicio';
      case Icons.person:
        return 'Usuarios';
      case Icons.article:
        return 'Temarios';
      case Icons.assignment:
        return 'Temas';
      case Icons.assignment_turned_in:
        return 'Prácticas';
      case Icons.assignment_add:
        return 'Examenes';
      case Icons.grade:
        return 'Notas';
      case Icons.person_pin_outlined:
        return 'Perfil';
      case Icons.exit_to_app:
        return 'Salir';
      default:
        return 'Desconocido';
    }
  }
}
