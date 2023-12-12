/*import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/dashboard_estudiante.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/NotasCuestionarioEstudiante/NotasCuestionarioEstudiante.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/NotasExamenEstudiante/NotasExamenEstudiante.dart';

class NotasEstudiantesScreen extends StatefulWidget {
  final String userId;

  NotasEstudiantesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _NotasEstudiantesScreenState createState() => _NotasEstudiantesScreenState();
}

class _NotasEstudiantesScreenState extends State<NotasEstudiantesScreen> {
  bool _isHoveringCuestionarios = false;
  bool _isHoveringExamenes = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selecciona una opción',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DashboardEstudiante()), // Reemplaza 'PantallaAnterior' con el nombre correcto de tu pantalla anterior
            );
          },
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.blue[100], // Puedes cambiar el color aquí
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildOptionButton(
                'Cuestionarios',
                'images/boleta-de-calificaciones.png',
                NotasCuestionarioEstudiante(idUsuario: widget.userId),
              ),
              SizedBox(width: 20),
              _buildOptionButton(
                'Exámenes',
                'images/certificado.png',
                NotasExamenEstudiante(idUsuario: widget.userId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    String buttonText,
    String imagePath,
    Widget destinationScreen,
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
                  _isHoveringCuestionarios && buttonText == 'Cuestionarios' ||
                          _isHoveringExamenes && buttonText == 'Exámenes'
                      ? Colors.blue.shade200
                      : Colors.blue,
              width: 2,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => destinationScreen,
              ),
            );
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
                  color: _isHoveringCuestionarios &&
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
        if (buttonText == 'Cuestionarios') {
          _isHoveringCuestionarios = true;
          _isHoveringExamenes = false;
        } else if (buttonText == 'Exámenes') {
          _isHoveringCuestionarios = false;
          _isHoveringExamenes = true;
        }
      } else {
        _isHoveringCuestionarios = false;
        _isHoveringExamenes = false;
      }
    });
  }
}

*/

import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/dashboard_estudiante.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/NotasCuestionarioEstudiante/NotasCuestionarioEstudiante.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/NotasExamenEstudiante/NotasExamenEstudiante.dart';

class NotasEstudiantesScreen extends StatefulWidget {
  final String userId;

  NotasEstudiantesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _NotasEstudiantesScreenState createState() => _NotasEstudiantesScreenState();
}

class _NotasEstudiantesScreenState extends State<NotasEstudiantesScreen> {
  bool _isHoveringCuestionarios = false;
  bool _isHoveringExamenes = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selecciona una opción',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DashboardEstudiante()), // Reemplaza 'PantallaAnterior' con el nombre correcto de tu pantalla anterior
            );
          },
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.blue[100], // Puedes cambiar el color aquí
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildOptionButton(
                'Cuestionarios',
                'images/boleta-de-calificaciones.png',
                NotasCuestionarioEstudiante(idUsuario: widget.userId),
              ),
              SizedBox(width: 20),
              _buildOptionButton(
                'Exámenes',
                'images/certificado.png',
                NotasExamenEstudiante(idUsuario: widget.userId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    String buttonText,
    String imagePath,
    Widget destinationScreen,
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
                  _isHoveringCuestionarios && buttonText == 'Cuestionarios' ||
                          _isHoveringExamenes && buttonText == 'Exámenes'
                      ? Colors.blue.shade200
                      : Colors.blue,
              width: 2,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => destinationScreen,
              ),
            );
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
                  color: _isHoveringCuestionarios &&
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
        if (buttonText == 'Cuestionarios') {
          _isHoveringCuestionarios = true;
          _isHoveringExamenes = false;
        } else if (buttonText == 'Exámenes') {
          _isHoveringCuestionarios = false;
          _isHoveringExamenes = true;
        }
      } else {
        _isHoveringCuestionarios = false;
        _isHoveringExamenes = false;
      }
    });
  }
}
