/*import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temarios_Estudiantes/Lista_temarios_estudiantes.dart';

class MaterialAcademico extends StatelessWidget {
  MaterialAcademico({super.key});

  final List<String> services = [
    "Temarios",
    "Exámenes",
    "Notas",
  ];

  var imageUrls = [
    "https://cdn-icons-png.flaticon.com/128/3313/3313498.png",
    "https://cdn-icons-png.flaticon.com/128/6779/6779711.png",
    "https://cdn-icons-png.flaticon.com/128/13868/13868555.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2.6),
        ),
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(100), // Redondear las esquinas
            ),
            elevation: 5, // Añadir sombra
            child: InkWell(
              borderRadius: BorderRadius.circular(
                  100), // Aplicar el radio de borde al InkWell
              onTap: () {
                if (services[index] == "Temarios") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListaTemariosEstudiantes()),
                  );
                } else {
                  print('Tapped on ${services[index]}');
                }
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Image.network(
                        imageUrls[index],
                        height: 120, // Ajuste de tamaño
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      services[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "NotoSans",
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temarios_Estudiantes/Lista_temarios_estudiantes.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temarios_Examen/Lista_Temarios_Examen.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/PremiosEstudiante/premiosEstudiante.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Seleccion_Notas_Estudiantes/SeleccionNotasEstudiantes.dart';

class MaterialAcademico extends StatelessWidget {
  MaterialAcademico({super.key});

  final List<String> services = ["Temarios", "Exámenes", "Notas", "Premios"];

  var imageUrls = [
    "https://cdn-icons-png.flaticon.com/128/3313/3313498.png",
    "https://cdn-icons-png.flaticon.com/128/6779/6779711.png",
    "https://cdn-icons-png.flaticon.com/128/13868/13868555.png",
    "https://cdn-icons-png.flaticon.com/128/10473/10473579.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2.6),
        ),
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(100), // Redondear las esquinas
            ),
            elevation: 5, // Añadir sombra
            child: InkWell(
              borderRadius: BorderRadius.circular(
                  100), // Aplicar el radio de borde al InkWell
              onTap: () {
                if (services[index] == "Temarios") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListaTemariosEstudiantes()),
                  );
                } else if (services[index] == "Exámenes") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListaTemariosExamen()),
                  );
                } else if (services[index] == "Notas") {
                  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SeleccionNotasEstudiantes(userId: userId)));
                } else if (services[index] == "Premios") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PremiosEstudiantes()),
                  );
                } else {
                  print('Tapped on ${services[index]}');
                }
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Image.network(
                        imageUrls[index],
                        height: 120, // Ajuste de tamaño
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      services[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "NotoSans",
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
