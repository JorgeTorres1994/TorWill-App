/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/CuestionarioPreguntasPropuestas/CuestionarioPreguntas.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/CuestionarioPreguntasResueltas/CuestionarioResueltos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CuestionarioScreen extends StatefulWidget {
  @override
  _CuestionarioScreenState createState() => _CuestionarioScreenState();
}

class _CuestionarioScreenState extends State<CuestionarioScreen> {
  late TextEditingController searchController;
  String selectedThemeId = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> cuestionarios = [];
  List<DropdownMenuItem<String>> items = [];
  bool _uploading = false;
  int selectedQuizIndex = -1;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _loadTemas();
    _loadCuestionariosFromFirestore();
  }

  Future<void> _loadCuestionarios() async {
    _prefs = await SharedPreferences.getInstance();
    String cuestionariosString = _prefs?.getString('cuestionarios') ?? '[]';
    List<Map<String, dynamic>> loadedCuestionarios =
        jsonDecode(cuestionariosString);

    if (loadedCuestionarios.isNotEmpty) {
      setState(() {
        cuestionarios = loadedCuestionarios;
      });
    }
  }

  Future<void> _loadCuestionariosFromFirestore() async {
    try {
      QuerySnapshot cuestionariosSnapshot =
          await firestore.collection('Cuestionario').get();

      setState(() {
        cuestionarios = cuestionariosSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            ...data,
          };
        }).toList();
      });
    } catch (e) {
      print('Error al cargar cuestionarios desde Firestore: $e');
    }
  }

  Future<void> _saveCuestionarios() async {
    await _prefs?.setString('cuestionarios', jsonEncode(cuestionarios));
  }

  Future<void> _loadTemas() async {
    final temasSnapshot = await firestore.collection('temas').get();
    setState(() {
      items = buildDropdownItems(temasSnapshot);
    });

    // Llamamos a _loadCuestionarios al final de _loadTemas
    _loadCuestionarios();
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmar eliminación'),
              content: Text('¿Seguro que quieres eliminar este cuestionario?'),
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
      String quizId = cuestionarios[index]['id'];
      await firestore.collection('Cuestionario').doc(quizId).delete();

      setState(() {
        cuestionarios.removeAt(index);
        _saveCuestionarios(); // Guarda los cambios en SharedPreferences
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cuestionario eliminado con éxito.'),
        ),
      );
    } catch (e) {
      print('Error al eliminar el cuestionario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el cuestionario.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear/Editar Cuestionario"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration:
                    InputDecoration(labelText: 'Nombre del Cuestionario'),
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
                          saveQuizToFirestore(); // Crear Cuestionario
                        } else {
                          editQuizInFirestore(
                              selectedQuizIndex); // Editar Cuestionario
                        }
                      },
                child: Text(selectedQuizIndex == -1
                    ? 'Crear Cuestionario'
                    : 'Editar Cuestionario'),
              ),
              SizedBox(height: 32.0),
              Text(
                'Cuestionarios Creados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar cuestionario',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    // Filtrar la lista de cuestionarios por nombre
                    cuestionarios = cuestionarios
                        .where((cuestionario) => cuestionario['nombre']
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
              FutureBuilder<QuerySnapshot>(
                future:
                    FirebaseFirestore.instance.collection('Cuestionario').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No se encontraron cuestionarios.');
                  }
                  cuestionarios = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: cuestionarios.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> cuestionario = cuestionarios[index];
                      return Card(
                        child: ListTile(
                          leading: Image.asset(
                            'images/practicas.png', // Ruta de la imagen por defecto
                            width: 48, // Ancho de la imagen
                            height: 48, // Altura de la imagen
                          ),
                          title:
                              Text('Nombre: ${cuestionario['nombre'] ?? ''}'),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('temas')
                                          .doc(cuestionario['temaId'])
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
                                      'Descripción: ${cuestionario['descripcion'] ?? ''}',
                                    ),
                                  ],
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
                                icon: Icon(Icons.book_online),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CuestionarioResueltos(
                                        selectedCuestionarioResuelto:
                                            cuestionario, // Pasa el cuestionario seleccionado
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.question_answer),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CuestionarioPreguntas(
                                        selectedCuestionario:
                                            cuestionario, // Pasa el cuestionario seleccionado
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
    if (index >= 0 && index < cuestionarios.length) {
      Map<String, dynamic> quiz = cuestionarios[index];
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

      await firestore.collection('Cuestionario').add({
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      });

      setState(() {
        cuestionarios.add({
          'nombre': nameController.text,
          'temaId': selectedThemeId,
          'descripcion': descriptionController.text,
        });

        _saveCuestionarios();
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
            content: Text('Cuestionario creado y guardado en Firebase.'),
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
            content: Text('Error al guardar el cuestionario: $e'),
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

      // Actualiza el cuestionario en Firestore
      await firestore
          .collection('Cuestionario')
          .doc(cuestionarios[index]['id'])
          .update({
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      });

      setState(() {
        // Actualiza el cuestionario en la lista
        cuestionarios[index] = {
          'id': cuestionarios[index]['id'],
          'nombre': nameController.text,
          'temaId': selectedThemeId,
          'descripcion': descriptionController.text,
        };

        _saveCuestionarios();
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
            content: Text('Cuestionario editado y guardado en Firebase.'),
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
            content: Text('Error al editar el cuestionario: $e'),
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
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/CuestionarioPreguntasPropuestas/CuestionarioPreguntas.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/CuestionarioPreguntasResueltas/CuestionarioResueltos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CuestionarioScreen extends StatefulWidget {
  @override
  _CuestionarioScreenState createState() => _CuestionarioScreenState();
}

class _CuestionarioScreenState extends State<CuestionarioScreen> {
  late TextEditingController searchController;
  String selectedThemeId = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> cuestionarios = [];
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
    searchController = TextEditingController();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadTemas();
    await _loadCuestionariosFromFirestore();
    setState(() {
      _isLoading = false; // Finalizar el estado de carga global
    });
  }

  Future<void> _loadCuestionarios() async {
    _prefs = await SharedPreferences.getInstance();
    String cuestionariosString = _prefs?.getString('cuestionarios') ?? '[]';
    List<Map<String, dynamic>> loadedCuestionarios =
        jsonDecode(cuestionariosString);

    if (loadedCuestionarios.isNotEmpty) {
      setState(() {
        cuestionarios = loadedCuestionarios;
      });
    }
  }

  Future<void> _loadCuestionariosFromFirestore() async {
    try {
      QuerySnapshot cuestionariosSnapshot =
          await firestore.collection('Cuestionario').get();

      setState(() {
        cuestionarios = cuestionariosSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            ...data,
          };
        }).toList();
      });
    } catch (e) {
      print('Error al cargar cuestionarios desde Firestore: $e');
    }
  }

  Future<void> _saveCuestionarios() async {
    await _prefs?.setString('cuestionarios', jsonEncode(cuestionarios));
  }

  Future<void> _loadTemas() async {
    final temasSnapshot = await firestore.collection('temas').get();
    setState(() {
      items = buildDropdownItems(temasSnapshot);
    });

    _loadCuestionarios();
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmar eliminación'),
              content: Text('¿Seguro que quieres eliminar este cuestionario?'),
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
      String quizId = cuestionarios[index]['id'];
      await firestore.collection('Cuestionario').doc(quizId).delete();

      setState(() {
        cuestionarios.removeAt(index);
        _saveCuestionarios(); // Guarda los cambios en SharedPreferences
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cuestionario eliminado con éxito.'),
        ),
      );
    } catch (e) {
      print('Error al eliminar el cuestionario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el cuestionario.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear/Editar Cuestionario"),
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
                          InputDecoration(labelText: 'Nombre del Cuestionario'),
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
                                saveQuizToFirestore(); // Crear Cuestionario
                              } else {
                                editQuizInFirestore(
                                    selectedQuizIndex); // Editar Cuestionario
                              }
                            },
                      child: Text(selectedQuizIndex == -1
                          ? 'Crear Cuestionario'
                          : 'Editar Cuestionario'),
                    ),
                    SizedBox(height: 32.0),
                    Text(
                      'Cuestionarios Creados:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar cuestionario',
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // Filtrar la lista de cuestionarios por nombre
                          cuestionarios = cuestionarios
                              .where((cuestionario) => cuestionario['nombre']
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cuestionarios.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> cuestionario =
                            cuestionarios[index];
                        return Card(
                          child: ListTile(
                            leading: Image.asset(
                              'images/practicas.png', // Ruta de la imagen por defecto
                              width: 48, // Ancho de la imagen
                              height: 48, // Altura de la imagen
                            ),
                            title:
                                Text('Nombre: ${cuestionario['nombre'] ?? ''}'),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('temas')
                                            .doc(cuestionario['temaId'])
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
                                        'Descripción: ${cuestionario['descripcion'] ?? ''}',
                                      ),
                                    ],
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
                                  icon: Icon(Icons.book_online),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CuestionarioResueltos(
                                          selectedCuestionarioResuelto:
                                              cuestionario,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.question_answer),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CuestionarioPreguntas(
                                          selectedCuestionario: cuestionario,
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
    if (index >= 0 && index < cuestionarios.length) {
      Map<String, dynamic> quiz = cuestionarios[index];
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

      await firestore.collection('Cuestionario').add({
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      });

      setState(() {
        cuestionarios.add({
          'nombre': nameController.text,
          'temaId': selectedThemeId,
          'descripcion': descriptionController.text,
        });

        _saveCuestionarios();
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
            content: Text('Cuestionario creado y guardado en Firebase.'),
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
            content: Text('Error al guardar el cuestionario: $e'),
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

      // Actualiza el cuestionario en Firestore
      await firestore
          .collection('Cuestionario')
          .doc(cuestionarios[index]['id'])
          .update({
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      });

      setState(() {
        // Actualiza el cuestionario en la lista
        cuestionarios[index] = {
          'id': cuestionarios[index]['id'],
          'nombre': nameController.text,
          'temaId': selectedThemeId,
          'descripcion': descriptionController.text,
        };

        _saveCuestionarios();
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
            content: Text('Cuestionario editado y guardado en Firebase.'),
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
            content: Text('Error al editar el cuestionario: $e'),
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

      // Obtén el ID del cuestionario
      String quizId = cuestionarios[index]['id'];

      // Verifica que los datos del cuestionario sean correctos
      print('Actualizando cuestionario con ID: $quizId');
      print('Datos del cuestionario: ${{
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      }}');

      // Actualiza el cuestionario en Firestore
      await firestore.collection('Cuestionario').doc(quizId).update({
        'nombre': nameController.text,
        'temaId': selectedThemeId,
        'descripcion': descriptionController.text,
      });

      setState(() {
        // Actualiza el cuestionario en la lista
        cuestionarios[index] = {
          'id': quizId,
          'nombre': nameController.text,
          'temaId': selectedThemeId,
          'descripcion': descriptionController.text,
        };

        _saveCuestionarios();
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
            content: Text('Cuestionario editado y guardado en Firebase.'),
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

      print('Error al editar el cuestionario: $e');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al editar el cuestionario: $e'),
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
