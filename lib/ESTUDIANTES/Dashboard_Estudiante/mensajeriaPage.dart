/*import 'package:flutter/material.dart';

class MensajeriaPage extends StatelessWidget {
  MensajeriaPage({super.key});

  final List<String> services = [
    "Mensajería interna",
    "Chat Grupal",
    "Reuniones"
  ];

  var imageUrls = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTG6sjn0Q684eP1equihVZVq466PQYQLJdLA&s",
    "https://cdn-icons-png.flaticon.com/128/6995/6995660.png",
    "https://cdn-icons-png.flaticon.com/128/3214/3214781.png",
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
import 'package:nueva_app_web_matematicas/ESTUDIANTES/ChatScreen/ChatGrupal.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/ChatScreen/MensajeriaInterna.dart';

class MensajeriaPage extends StatelessWidget {
  MensajeriaPage({super.key});

  final List<String> services = [
    "Mensajeria interna",
    "Chat Grupal",
    "Reuniones"
  ];

  final List<String> userIds = [
    "user_1",
    "user_2",  // Supongamos que este es el userId para "Chat Grupal"
    "user_3"
  ];

  final List<String> imageUrls = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTG6sjn0Q684eP1equihVZVq466PQYQLJdLA&s",
    "https://cdn-icons-png.flaticon.com/128/6995/6995660.png",
    "https://cdn-icons-png.flaticon.com/128/3214/3214781.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servicios de Mensajería'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2.6)),
          itemCount: services.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100), // Redondear las esquinas
              ),
              elevation: 5, // Añadir sombra
              child: InkWell(
                borderRadius: BorderRadius.circular(100), // Aplicar el radio de borde al InkWell
                onTap: () {
                  // Agregar la lógica de navegación según el servicio seleccionado
                  if (services[index] == "Chat Grupal") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatGrupal()),
                    );
                  } else if(services[index] == "Mensajeria interna"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MensajeriaInterna()),
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
                          fontFamily: "NotoSans", // Asegurándonos de usar la misma fuente que MaterialAcademico
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
      ),
    );
  }
}
