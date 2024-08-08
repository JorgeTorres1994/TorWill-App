/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/materialAcademico.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/mensajeriaPage.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/welcomePage.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/PerfilEstudiante/PerfilEstudiante.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/PerfilProfesor/PerfilProfesor.dart';

class DashboardEstudiante extends StatefulWidget {
  const DashboardEstudiante({Key? key}) : super(key: key);

  @override
  State<DashboardEstudiante> createState() => _DashboardEstudianteState();
}

class _DashboardEstudianteState extends State<DashboardEstudiante> {
  var _currentIndex = 0;
  // Estado para almacenar el ID del profesor y la carga
  String? _profesorUserId;
  bool _isLoadingProfesor = false;

  @override
  void initState() {
    super.initState();
    // Si el índice inicial es 2, carga los datos del profesor
    if (_currentIndex == 2) {
      _loadProfesorData();
    }
  }

  Future<void> _loadProfesorData() async {
    setState(() {
      _isLoadingProfesor = true;
    });

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('isAdmin', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userId = querySnapshot.docs.first.id;

        setState(() {
          _profesorUserId = userId; // Guardar el ID del profesor
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se encontró un usuario con isAdmin = true'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar los datos del profesor: $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoadingProfesor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TorWill App'),
      ),
      backgroundColor: Color(0xFFF0F0F0),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Material"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_3_outlined), label: "Profesor"),
          BottomNavigationBarItem(
              icon: Icon(Icons.message), label: "Mensajería"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Config"),
        ],
      ),
      body: getBodyWidget(),
    );
  }

  Widget getBodyWidget() {
    switch (_currentIndex) {
      case 0:
        return WelcomePage(); // Página de bienvenida
      case 1:
        return MaterialAcademico(); // Página de material académico
      case 2:
        if (_isLoadingProfesor) {
          return Center(child: CircularProgressIndicator());
        } else if (_profesorUserId != null) {
          return PerfilProfesor(
              userId: _profesorUserId!); // Página del perfil del profesor
        } else {
          return Center(child: Text('No se encontró el perfil del profesor.'));
        }
      case 3:
        return MensajeriaPage(); // Página de mensajería
      case 4:
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          return PerfilEstudiante(
              userId: user.uid); // Página del perfil del estudiante
        } else {
          return Center(child: Text('Usuario no autenticado.'));
        }
      default:
        return WelcomePage(); // Valor por defecto
    }
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      _loadProfesorData(); // Cargar datos del profesor si se selecciona la pestaña
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/materialAcademico.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/mensajeriaPage.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/welcomePage.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/PerfilEstudiante/PerfilEstudiante.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/PerfilProfesor/PerfilProfesor.dart';

class DashboardEstudiante extends StatefulWidget {
  const DashboardEstudiante({Key? key}) : super(key: key);

  @override
  State<DashboardEstudiante> createState() => _DashboardEstudianteState();
}

class _DashboardEstudianteState extends State<DashboardEstudiante> {
  var _currentIndex = 0;
  // Estado para almacenar el ID del profesor y la carga
  String? _profesorUserId;
  bool _isLoadingProfesor = false;

  @override
  void initState() {
    super.initState();
    // Si el índice inicial es 2, carga los datos del profesor
    if (_currentIndex == 2) {
      _loadProfesorData();
    }
  }

  Future<void> _loadProfesorData() async {
    setState(() {
      _isLoadingProfesor = true;
    });

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('isAdmin', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userId = querySnapshot.docs.first.id;

        setState(() {
          _profesorUserId = userId; // Guardar el ID del profesor
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se encontró un usuario con isAdmin = true'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar los datos del profesor: $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoadingProfesor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TorWill App'),
      ),
      backgroundColor: Color(0xFFF0F0F0),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Material"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_3_outlined), label: "Profesor"),
          BottomNavigationBarItem(
              icon: Icon(Icons.message), label: "Mensajería"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Config"),
        ],
      ),
      body: getBodyWidget(),
    );
  }

  Widget getBodyWidget() {
    switch (_currentIndex) {
      case 0:
        return WelcomePage(); // Página de bienvenida
      case 1:
        return MaterialAcademico(); // Página de material académico
      case 2:
        if (_isLoadingProfesor) {
          return Center(child: CircularProgressIndicator());
        } else if (_profesorUserId != null) {
          return PerfilProfesor(
              userId: _profesorUserId!); // Página del perfil del profesor
        } else {
          return Center(child: Text('No se encontró el perfil del profesor.'));
        }
      case 3:
        return MensajeriaPage(); // Página de mensajería
      case 4:
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          return PerfilEstudiante(
              userId: user.uid); // Página del perfil del estudiante
        } else {
          return Center(child: Text('Usuario no autenticado.'));
        }
      default:
        return WelcomePage(); // Valor por defecto
    }
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      _loadProfesorData(); // Cargar datos del profesor si se selecciona la pestaña
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
