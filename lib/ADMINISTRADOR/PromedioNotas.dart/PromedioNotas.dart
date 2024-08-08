/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PromedioNotas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promedio de Notas'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('ResultadoCuestionarioEstudiante').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Mapa para agrupar los puntajes por estudiante
          Map<String, List<double>> estudianteNotas = {};

          snapshot.data!.docs.forEach((doc) {
            var idUsuario = doc['idUsuario'];
            var puntajeTotal = doc['puntajeTotal'] as double;

            if (!estudianteNotas.containsKey(idUsuario)) {
              estudianteNotas[idUsuario] = [];
            }

            estudianteNotas[idUsuario]!.add(puntajeTotal);
          });

          // Calcular el promedio de notas por estudiante
          List<Map<String, dynamic>> estudiantesConPromedio = estudianteNotas.entries.map((entry) {
            var idUsuario = entry.key;
            var notas = entry.value;
            var promedio = notas.reduce((a, b) => a + b) / notas.length;

            return {
              'idUsuario': idUsuario,
              'promedio': promedio,
            };
          }).toList();

          return ListView.builder(
            itemCount: estudiantesConPromedio.length,
            itemBuilder: (context, index) {
              var estudiante = estudiantesConPromedio[index];

              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('users').where('user_id', isEqualTo: estudiante['idUsuario']).get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      title: Text('Cargando...'),
                    );
                  }

                  if (userSnapshot.data!.docs.isEmpty) {
                    return ListTile(
                      title: Text('Usuario no encontrado'),
                    );
                  }

                  var userData = userSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                  var nombre = userData['display_name'];

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          nombre[0],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(nombre),
                      subtitle: Text('Promedio: ${estudiante['promedio'].toStringAsFixed(2)}'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PromedioNotas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promedio de Notas - Cuestionarios'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('ResultadoCuestionarioEstudiante').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Mapa para agrupar los puntajes por estudiante
          Map<String, List<double>> estudianteNotas = {};

          snapshot.data!.docs.forEach((doc) {
            var idUsuario = doc['idUsuario'];
            var puntajeTotal = doc['puntajeTotal'] as double;

            if (!estudianteNotas.containsKey(idUsuario)) {
              estudianteNotas[idUsuario] = [];
            }

            estudianteNotas[idUsuario]!.add(puntajeTotal);
          });

          // Calcular el promedio de notas por estudiante
          List<Map<String, dynamic>> estudiantesConPromedio = estudianteNotas.entries.map((entry) {
            var idUsuario = entry.key;
            var notas = entry.value;
            var promedio = notas.reduce((a, b) => a + b) / notas.length;

            return {
              'idUsuario': idUsuario,
              'promedio': promedio,
            };
          }).toList();

          return ListView.builder(
            itemCount: estudiantesConPromedio.length,
            itemBuilder: (context, index) {
              var estudiante = estudiantesConPromedio[index];

              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('users').where('user_id', isEqualTo: estudiante['idUsuario']).get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      title: Text('Cargando...'),
                    );
                  }

                  if (userSnapshot.data!.docs.isEmpty) {
                    return ListTile(
                      title: Text('Usuario no encontrado'),
                    );
                  }

                  var userData = userSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                  var nombre = userData['display_name'];

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          nombre[0],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(nombre),
                      subtitle: Text('Promedio: ${estudiante['promedio'].toStringAsFixed(2)}'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
