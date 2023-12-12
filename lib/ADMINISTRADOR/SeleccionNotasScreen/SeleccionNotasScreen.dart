import 'package:flutter/material.dart';
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
