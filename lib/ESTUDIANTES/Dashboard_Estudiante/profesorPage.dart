/*import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<String> services = [
    "Material Académico",
    "Exámenes",
    "Notas",
    "Mensajería"
  ];

  var imageUrls = [
    "https://cdn-icons-png.flaticon.com/128/3313/3313498.png",
    "https://cdn-icons-png.flaticon.com/128/6779/6779711.png",
    "https://cdn-icons-png.flaticon.com/128/13868/13868555.png",
    "https://cdn-icons-png.flaticon.com/128/6995/6995660.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            //childAspectRatio: 1, // Relación de aspecto para hacer los elementos cuadrados
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 2.6)),
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Acción al tocar el botón
              print('Tapped on ${services[index]}');
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(100), // Redondear las esquinas
              ),
              elevation: 5, // Añadir sombra
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
                      style:
                          TextStyle(fontSize: 16, fontFamily: "NotoSans", color: Colors.black ,fontWeight: FontWeight.w600),
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

import 'package:flutter/material.dart';

class ProfesorPage extends StatelessWidget {
  ProfesorPage({super.key});

  final List<String> services = [
    "Datos del Profesor"
  ];

  var imageUrls = [
    "https://cdn-icons-png.flaticon.com/128/3313/3313498.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            //childAspectRatio: 1, // Relación de aspecto para hacer los elementos cuadrados
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 2.6)),
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Acción al tocar el botón
              print('Tapped on ${services[index]}');
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(100), // Redondear las esquinas
              ),
              elevation: 5, // Añadir sombra
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
                      style:
                          TextStyle(fontSize: 16, fontFamily: "NotoSans", color: Colors.black ,fontWeight: FontWeight.w600),
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
