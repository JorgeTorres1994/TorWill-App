import 'package:flutter/material.dart';

class PremiosEstudiantes extends StatelessWidget {
  PremiosEstudiantes({super.key});

  final List<String> premios = [
    "Medalla de Oro",
    "Trofeo de Campeón",
    "Estrella de Excelencia",
    "Certificado de Honor",
  ];

  final List<String> descripciones = [
    "Premio por obtener la mayor calificación.",
    "Reconocimiento al mejor rendimiento académico.",
    "Por destacar en todas las materias.",
    "Por completar todas las tareas con excelencia.",
  ];

  final List<String> imageUrls = [
    "https://cdn-icons-png.flaticon.com/128/2583/2583364.png",
    "https://cdn-icons-png.flaticon.com/128/2422/2422377.png",
    "https://cdn-icons-png.flaticon.com/128/3010/3010993.png",
    "https://cdn-icons-png.flaticon.com/128/2748/2748471.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Premios Ganados'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1,
          ),
          itemCount: premios.length,
          itemBuilder: (context, index) {
            return ClipOval(
              child: Material(
                color: Colors.white, // Color de fondo del Card
                child: InkWell(
                  splashColor: Colors.teal
                      .withAlpha(30), // Color de la animación al tocar
                  onTap: () {
                    // Acciones al presionar cada Card
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network(
                        imageUrls[index],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text(
                        premios[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          descripciones[index],
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
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
