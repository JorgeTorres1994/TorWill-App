/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/ListaNotasEstudiante/ListaNotasExamenesEstudiante.dart';

class ListaTemariosExamenes extends StatefulWidget {
  @override
  _ListaTemariosExamenesState createState() => _ListaTemariosExamenesState();
}

class _ListaTemariosExamenesState extends State<ListaTemariosExamenes> {
  Map<String, bool> _expandedRows = {};
  Map<String, bool> _expandedTopics = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GESTION DE NOTAS DE LOS EXAMENES'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('temario').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Algo salió mal'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay temarios disponibles'));
          }

          return ListView(
            padding: EdgeInsets.all(8.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              String id = document.id;
              bool isExpanded = _expandedRows[id] ?? false;

              return Card(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Image.asset('images/temario.png',
                          width: 50, height: 50),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(data['name'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Text("Ver temas"),
                        ],
                      ),
                      trailing: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more),
                      onTap: () {
                        setState(() {
                          _expandedRows[id] = !isExpanded;
                        });
                      },
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('temas')
                              .where('temarioRef', isEqualTo: data['name'])
                              .get(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> temasSnapshot) {
                            if (temasSnapshot.hasError) {
                              return Center(
                                  child: Text('Error al cargar los temas'));
                            }
                            if (!temasSnapshot.hasData ||
                                temasSnapshot.data!.docs.isEmpty) {
                              return Center(
                                  child: Text('No hay temas disponibles'));
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: temasSnapshot.data!.docs
                                  .map((DocumentSnapshot temaDoc) {
                                Map<String, dynamic> temaData =
                                    temaDoc.data()! as Map<String, dynamic>;
                                String topicId = temaDoc.id;
                                bool isTopicExpanded =
                                    _expandedTopics[topicId] ?? false;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*ListTile(
                                      leading: Image.asset('images/temas.png', width: 100, height: 100),
                                      title: Text(temaData['name']),
                                      trailing: Icon(isTopicExpanded ? Icons.expand_less : Icons.expand_more),
                                      onTap: () {
                                        setState(() {
                                          _expandedTopics[topicId] = !isTopicExpanded;
                                        });
                                      },
                                    ),*/
                                    ListTile(
                                      leading: Image.asset('images/temas.png',
                                          width: 100, height: 100),
                                      title: Text(temaData['name']),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Ver exámenes',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black
                                            ),
                                          ),
                                          Icon(isTopicExpanded
                                              ? Icons.expand_less
                                              : Icons.expand_more),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _expandedTopics[topicId] =
                                              !isTopicExpanded;
                                        });
                                      },
                                    ),
                                    if (isTopicExpanded)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection('Examen')
                                              .where('temaId',
                                                  isEqualTo: topicId)
                                              .get(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  examenesSnapshot) {
                                            if (examenesSnapshot.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error al cargar los exámenes'));
                                            }
                                            if (!examenesSnapshot.hasData ||
                                                examenesSnapshot
                                                    .data!.docs.isEmpty) {
                                              return Center(
                                                  child: Text(
                                                      'No hay exámenes disponibles'));
                                            }

                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: examenesSnapshot
                                                  .data!.docs
                                                  .map((DocumentSnapshot
                                                      examenDoc) {
                                                Map<String, dynamic>
                                                    examenData =
                                                    examenDoc.data()!
                                                        as Map<String, dynamic>;

                                                return ListTile(
                                                  leading: Image.asset(
                                                      'images/certificado.png',
                                                      width: 100,
                                                      height: 100),
                                                  title: Text(
                                                      examenData['nombre']),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ListaNotasExamenEstudiante(
                                                          idExamen:
                                                              examenDoc.id,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/ListaNotasEstudiante/ListaNotasExamenesEstudiante.dart';

class ListaTemariosExamenes extends StatefulWidget {
  @override
  _ListaTemariosExamenesState createState() => _ListaTemariosExamenesState();
}

class _ListaTemariosExamenesState extends State<ListaTemariosExamenes> {
  Map<String, bool> _expandedRows = {};
  Map<String, bool> _expandedTopics = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GESTION DE NOTAS DE LOS EXAMENES'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('temario').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Algo salió mal'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay temarios disponibles'));
          }

          return ListView(
            padding: EdgeInsets.all(8.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              String id = document.id;
              bool isExpanded = _expandedRows[id] ?? false;

              return Column(
                children: [
                  Card(
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Image.asset('images/temario.png', width: 50, height: 50),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(data['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Text("Ver temas"),
                            ],
                          ),
                          trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                          onTap: () {
                            setState(() {
                              _expandedRows[id] = !isExpanded;
                            });
                          },
                        ),
                        if (isExpanded) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: FutureBuilder(
                              future: FirebaseFirestore.instance.collection('temas')
                                  .where('temarioRef', isEqualTo: data['name']).get(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> temasSnapshot) {
                                if (temasSnapshot.hasError) {
                                  return Center(child: Text('Error al cargar los temas'));
                                }
                                if (!temasSnapshot.hasData || temasSnapshot.data!.docs.isEmpty) {
                                  return Center(child: Text('No hay temas disponibles'));
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: temasSnapshot.data!.docs.map((DocumentSnapshot temaDoc) {
                                    Map<String, dynamic> temaData = temaDoc.data()! as Map<String, dynamic>;
                                    String topicId = temaDoc.id;
                                    bool isTopicExpanded = _expandedTopics[topicId] ?? false;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8.0),
                                        ListTile(
                                          leading: Image.asset('images/temas.png', width: 100, height: 100),
                                          title: Text(temaData['name']),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Ver exámenes', style: TextStyle(fontSize: 16.0, color: Colors.black)),
                                              Icon(isTopicExpanded ? Icons.expand_less : Icons.expand_more),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _expandedTopics[topicId] = !isTopicExpanded;
                                            });
                                          },
                                        ),
                                        if (isTopicExpanded) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20.0),
                                            child: FutureBuilder(
                                              future: FirebaseFirestore.instance.collection('Examen')
                                                  .where('temaId', isEqualTo: topicId).get(),
                                              builder: (context, AsyncSnapshot<QuerySnapshot> examenesSnapshot) {
                                                if (examenesSnapshot.hasError) {
                                                  return Center(child: Text('Error al cargar los exámenes'));
                                                }
                                                if (!examenesSnapshot.hasData || examenesSnapshot.data!.docs.isEmpty) {
                                                  return Center(child: Text('No hay exámenes disponibles'));
                                                }

                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: examenesSnapshot.data!.docs.map((DocumentSnapshot examenDoc) {
                                                    Map<String, dynamic> examenData = examenDoc.data()! as Map<String, dynamic>;

                                                    return Column(
                                                      children: [
                                                        SizedBox(height: 8.0),
                                                        ListTile(
                                                          leading: Image.asset('images/certificado.png', width: 100, height: 100),
                                                          title: Text(examenData['nombre']),
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ListaNotasExamenEstudiante(
                                                                  idExamen: examenDoc.id,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                        ],
                                      ],
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 8.0),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}