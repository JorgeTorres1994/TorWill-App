/*import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/ListaNotasEstudiante/ListaNotasCuestionarioEstudiante.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/ListaNotasEstudiante/ListaNotasExamenesEstudiante.dart';

class SeleccionNotasScreen extends StatelessWidget {
  SeleccionNotasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una opción'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ListaNotasCuestionarioEstudiante(),
                  ),
                );
              },
              child: Text('Ver notas de cuestionarios'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ListaNotasExamenEstudiante(),
                  ),
                );
              },
              child: Text('Ver notas de exámenes'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/ListaNotasEstudiante/ListaNotasCuestionarioEstudiante.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/ListaNotasEstudiante/ListaNotasExamenesEstudiante.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/dashboard_estudiante.dart';

class SeleccionNotasScreen extends StatefulWidget {
  SeleccionNotasScreen({Key? key}) : super(key: key);

  @override
  _SeleccionNotasScreenState createState() => _SeleccionNotasScreenState();
}

class _SeleccionNotasScreenState extends State<SeleccionNotasScreen> {
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
                builder: (context) => DashboardEstudiante(),
              ),
            );
          },
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.blue[100],
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildOptionButton(
                'Cuestionarios',
                'images/boleta-de-calificaciones.png',
                ListaNotasCuestionarioEstudiante(),
              ),
              SizedBox(width: 20),
              _buildOptionButton(
                'Exámenes',
                'images/certificado.png',
                ListaNotasExamenEstudiante(),
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
              color: _isHoveringCuestionarios &&
                          buttonText == 'Notas Cuestionarios' ||
                      _isHoveringExamenes && buttonText == 'Notas Exámenes'
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
                              buttonText == 'Notas Cuestionarios' ||
                          _isHoveringExamenes && buttonText == 'Notas Exámenes'
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
