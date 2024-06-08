/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/ExamenPreguntasPropuestas/ExamenPreguntas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamenScreen extends StatefulWidget {
  @override
  _ExamenScreenState createState() => _ExamenScreenState();
}

class _ExamenScreenState extends State<ExamenScreen> {
  String selectedThemeId = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> examenes = [];
  List<DropdownMenuItem<String>> items = [];
  bool _uploading = false;
  int selectedQuizIndex = -1;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadTemas();
    _loadExamenesFromFirestore();
  }

  Future<void> _loadExamenes() async {
    _prefs = await SharedPreferences.getInstance();
    String examenesString = _prefs?.getString('examenes') ?? '[]';
    List<Map<String, dynamic>> loadedExamenes = jsonDecode(examenesString);

    if (loadedExamenes.isNotEmpty) {
      setState(() {
        examenes = loadedExamenes;
      });
    }
  }

  Future<void> _loadExamenesFromFirestore() async {
    try {
      QuerySnapshot examenesSnapshot =
          await firestore.collection('Examen').get();

      setState(() {
        examenes = examenesSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id, // Agrega el ID del documento al mapa
            ...data, // Agrega el resto de los datos del documento al mapa
          };
        }).toList();
      });
    } catch (e) {
      print('Error al cargar examenes desde Firestore: $e');
    }
  }

  Future<void> _guardarExamenes() async {
    await _prefs?.setString('examenes', jsonEncode(examenes));
  }

  Future<void> _loadTemas() async {
    final temasSnapshot = await firestore.collection('temas').get();
    setState(() {
      items = buildDropdownItems(temasSnapshot);
    });

    _loadExamenes();
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmar eliminación'),
              content: Text('¿Seguro que quieres eliminar este examen?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Sí'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  List<DropdownMenuItem<String>> buildDropdownItems(QuerySnapshot snapshot) {
    return snapshot.docs.where((doc) => doc['name'] != null).map((doc) {
      String themeId = doc.id;
      String themeName = doc['name'] as String;

      if (selectedThemeId.isEmpty) {
        selectedThemeId = themeId;
      }

      return DropdownMenuItem<String>(
        value: themeId,
        child: Text(themeName),
      );
    }).toList();
  }

  void deleteQuizFromFirestore(int index) async {
    try {
      String quizId = examenes[index]['id'];
      await firestore.collection('Examen').doc(quizId).delete();

      setState(() {
        examenes.removeAt(index);
        _guardarExamenes(); // Guarda los cambios en SharedPreferences
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Examen eliminado con éxito.'),
        ),
      );
    } catch (e) {
      print('Error al eliminar el examen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el examen.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear/Editar Examen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nombre del Examen'),
              ),
              SizedBox(height: 16.0),
              if (items.isNotEmpty)
                DropdownButton<String>(
                  value: selectedThemeId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedThemeId = newValue!;
                    });
                  },
                  items: items,
                )
              else
                CircularProgressIndicator(),
              SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _uploading
                    ? null
                    : () {
                        if (selectedQuizIndex == -1) {
                          saveQuizToFirestore(); // Crear examen
                        } else {
                          editQuizInFirestore(
                              selectedQuizIndex); // Editar examen
                        }
                      },
                child: Text(
                    selectedQuizIndex == -1 ? 'Crear Examen' : 'Editar Examen'),
              ),
              SizedBox(height: 32.0),
              Text(
                'Examenes Creados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: examenes.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> examen = examenes[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(
                        'images/examen.png', // Ruta de la imagen por defecto
                        width: 48, // Ancho de la imagen
                        height: 48, // Altura de la imagen
                      ),
                      title: Text('Nombre: ${examen['nombre'] ?? ''}'),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<DocumentSnapshot>(
                                  future: firestore
                                      .collection('temas')
                                      .doc(examen['temaId'])
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text('Tema: Cargando...');
                                    }
                                    if (!snapshot.hasData) {
                                      return Text('Tema: Desconocido');
                                    }
                                    String themeName =
                                        snapshot.data!['name'] as String;
                                    return Text('Tema: $themeName');
                                  },
                                ),
                                Text(
                                    'Descripción: ${examen['descripcion'] ?? ''}'),
                              ],
                            ),
                          ),
                          if (examen['imageUrl'] != null)
                            Container(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                examen['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                selectedQuizIndex = index;
                                loadQuizData(index);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              bool confirmDelete =
                                  await _confirmDelete(context);
                              if (confirmDelete) {
                                // Eliminar cuestionario
                                deleteQuizFromFirestore(index);
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.question_answer),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExamenPreguntas(
                                    selectedExamen:
                                        examen, // Pasa el examen seleccionado
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadQuizData(int index) {
    if (index >= 0 && index < examenes.length) {
      Map<String, dynamic> quiz = examenes[index];
      nameController.text = quiz['nombre'] ?? '';
      selectedThemeId = quiz['temaId'] ?? '';
      descriptionController.text = quiz['descripcion'] ?? '';
    }
  }

  void saveQuizToFirestore() async {
    try {
      setState(() {
        _uploading = true;
      });

      await firestore.collection('Examen').add({
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      });

      setState(() {
        examenes.add({
          'nombre': nameController.text,
          'temaId': selectedThemeId,
          'descripcion': descriptionController.text,
        });

        _guardarExamenes();
        _uploading = false;
        selectedQuizIndex = -1; // Reinicia el índice seleccionado
      });

      nameController.clear();
      descriptionController.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Éxito'),
            content: Text('Examen creado y guardado en Firebase.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _uploading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al guardar el examen: $e'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void editQuizInFirestore(int index) async {
    try {
      setState(() {
        _uploading = true;
      });

      // Actualiza el examen en Firestore
      await firestore.collection('Examen').doc(examenes[index]['id']).update({
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      });

      setState(() {
        // Actualiza el examen en la lista
        examenes[index] = {
          'id': examenes[index]['id'],
          'nombre': nameController.text,
          'temaId': selectedThemeId,
          'descripcion': descriptionController.text,
        };

        _guardarExamenes();
        _uploading = false;
        selectedQuizIndex = -1; // Reinicia el índice seleccionado
      });

      nameController.clear();
      descriptionController.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Éxito'),
            content: Text('Examen editado y guardado en Firebase.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _uploading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al editar el examen: $e'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/ExamenPreguntasPropuestas/ExamenPreguntas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamenScreen extends StatefulWidget {
  @override
  _ExamenScreenState createState() => _ExamenScreenState();
}

class _ExamenScreenState extends State<ExamenScreen> {
  String selectedThemeId = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> examenes = [];
  List<DropdownMenuItem<String>> items = [];
  bool _uploading = false;
  bool _isLoading =
      true; // Nueva variable de estado para el círculo de carga global
  int selectedQuizIndex = -1;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadTemas();
    await _loadExamenesFromFirestore();
    setState(() {
      _isLoading = false; // Finalizar el estado de carga global
    });
  }

  Future<void> _loadExamenes() async {
    _prefs = await SharedPreferences.getInstance();
    String examenesString = _prefs?.getString('examenes') ?? '[]';
    List<Map<String, dynamic>> loadedExamenes = jsonDecode(examenesString);

    if (loadedExamenes.isNotEmpty) {
      setState(() {
        examenes = loadedExamenes;
      });
    }
  }

  Future<void> _loadExamenesFromFirestore() async {
    try {
      QuerySnapshot examenesSnapshot =
          await firestore.collection('Examen').get();

      setState(() {
        examenes = examenesSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id, // Agrega el ID del documento al mapa
            ...data, // Agrega el resto de los datos del documento al mapa
          };
        }).toList();
      });
    } catch (e) {
      print('Error al cargar examenes desde Firestore: $e');
    }
  }

  Future<void> _guardarExamenes() async {
    await _prefs?.setString('examenes', jsonEncode(examenes));
  }

  Future<void> _loadTemas() async {
    final temasSnapshot = await firestore.collection('temas').get();
    setState(() {
      items = buildDropdownItems(temasSnapshot);
    });

    _loadExamenes();
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmar eliminación'),
              content: Text('¿Seguro que quieres eliminar este examen?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Sí'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  List<DropdownMenuItem<String>> buildDropdownItems(QuerySnapshot snapshot) {
    return snapshot.docs.where((doc) => doc['name'] != null).map((doc) {
      String themeId = doc.id;
      String themeName = doc['name'] as String;

      if (selectedThemeId.isEmpty) {
        selectedThemeId = themeId;
      }

      return DropdownMenuItem<String>(
        value: themeId,
        child: Text(themeName),
      );
    }).toList();
  }

  void deleteQuizFromFirestore(int index) async {
    try {
      String quizId = examenes[index]['id'];
      await firestore.collection('Examen').doc(quizId).delete();

      setState(() {
        examenes.removeAt(index);
        _guardarExamenes(); // Guarda los cambios en SharedPreferences
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Examen eliminado con éxito.'),
        ),
      );
    } catch (e) {
      print('Error al eliminar el examen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el examen.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear/Editar Examen"),
      ),
      body: Stack(
        children: [
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
          else
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration:
                          InputDecoration(labelText: 'Nombre del Examen'),
                    ),
                    SizedBox(height: 16.0),
                    if (items.isNotEmpty)
                      DropdownButton<String>(
                        value: selectedThemeId,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedThemeId = newValue!;
                          });
                        },
                        items: items,
                      ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Descripción'),
                    ),
                    SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: _uploading
                          ? null
                          : () {
                              if (selectedQuizIndex == -1) {
                                saveQuizToFirestore(); // Crear examen
                              } else {
                                editQuizInFirestore(
                                    selectedQuizIndex); // Editar examen
                              }
                            },
                      child: Text(selectedQuizIndex == -1
                          ? 'Crear Examen'
                          : 'Editar Examen'),
                    ),
                    SizedBox(height: 32.0),
                    Text(
                      'Examenes Creados:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: examenes.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> examen = examenes[index];
                        return Card(
                          child: ListTile(
                            leading: Image.asset(
                              'images/examen.png', // Ruta de la imagen por defecto
                              width: 48, // Ancho de la imagen
                              height: 48, // Altura de la imagen
                            ),
                            title: Text('Nombre: ${examen['nombre'] ?? ''}'),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                        future: firestore
                                            .collection('temas')
                                            .doc(examen['temaId'])
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text('Tema: Cargando...');
                                          }
                                          if (!snapshot.hasData) {
                                            return Text('Tema: Desconocido');
                                          }
                                          String themeName =
                                              snapshot.data!['name'] as String;
                                          return Text('Tema: $themeName');
                                        },
                                      ),
                                      Text(
                                          'Descripción: ${examen['descripcion'] ?? ''}'),
                                    ],
                                  ),
                                ),
                                if (examen['imageUrl'] != null)
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                      examen['imageUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      selectedQuizIndex = index;
                                      loadQuizData(index);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    bool confirmDelete =
                                        await _confirmDelete(context);
                                    if (confirmDelete) {
                                      // Eliminar cuestionario
                                      deleteQuizFromFirestore(index);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.question_answer),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ExamenPreguntas(
                                          selectedExamen:
                                              examen, // Pasa el examen seleccionado
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void loadQuizData(int index) {
    if (index >= 0 && index < examenes.length) {
      Map<String, dynamic> quiz = examenes[index];
      nameController.text = quiz['nombre'] ?? '';
      selectedThemeId = quiz['temaId'] ?? '';
      descriptionController.text = quiz['descripcion'] ?? '';
    }
  }

  void saveQuizToFirestore() async {
    try {
      setState(() {
        _uploading = true;
      });

      await firestore.collection('Examen').add({
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      });

      setState(() {
        examenes.add({
          'nombre': nameController.text,
          'temaId': selectedThemeId,
          'descripcion': descriptionController.text,
        });

        _guardarExamenes();
        _uploading = false;
        selectedQuizIndex = -1; // Reinicia el índice seleccionado
      });

      nameController.clear();
      descriptionController.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Éxito'),
            content: Text('Examen creado y guardado en Firebase.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _uploading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al guardar el examen: $e'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  /*void editQuizInFirestore(int index) async {
    try {
      setState(() {
        _uploading = true;
      });

      // Actualiza el examen en Firestore
      await firestore.collection('Examen').doc(examenes[index]['id']).update({
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      });

      setState(() {
        // Actualiza el examen en la lista
        examenes[index] = {
          'id': examenes[index]['id'],
          'nombre': nameController.text,
          'temaId': selectedThemeId,
          'descripcion': descriptionController.text,
        };

        _guardarExamenes();
        _uploading = false;
        selectedQuizIndex = -1; // Reinicia el índice seleccionado
      });

      nameController.clear();
      descriptionController.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Éxito'),
            content: Text('Examen editado y guardado en Firebase.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _uploading = false;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al editar el examen: $e'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }*/
  void editQuizInFirestore(int index) async {
    try {
      setState(() {
        _uploading = true;
      });

      // Obtén el ID del examen
      String quizId = examenes[index]['id'];

      // Verifica que los datos del examen sean correctos
      print('Actualizando examen con ID: $quizId');
      print('Datos del examen: ${{
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      }}');

      // Actualiza el examen en Firestore
      await firestore.collection('Examen').doc(quizId).update({
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      });

      setState(() {
        // Actualiza el examen en la lista
        examenes[index] = {
          'id': quizId,
          'nombre': nameController.text,
          'temaId': selectedThemeId,
          'descripcion': descriptionController.text,
        };

        _guardarExamenes();
        _uploading = false;
        selectedQuizIndex = -1; // Reinicia el índice seleccionado
      });

      nameController.clear();
      descriptionController.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Éxito'),
            content: Text('Examen editado y guardado en Firebase.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      setState(() {
        _uploading = false;
      });

      print('Error al editar el examen: $e');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al editar el examen: $e'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
