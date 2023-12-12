/*import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegistrarTemas extends StatefulWidget {
  @override
  _RegistrarTemasState createState() => _RegistrarTemasState();
}

class _RegistrarTemasState extends State<RegistrarTemas> {
  final TextEditingController _nombreController = TextEditingController();
  String? _temarioSeleccionado;
  List<String> _temarios = [];
  String? _imagenUrl;
  String? _videoUrl;

  @override
  void initState() {
    super.initState();
    _cargarTemarios();
  }

  Future<void> _cargarTemarios() async {
    try {
      final temariosSnapshot =
          await FirebaseFirestore.instance.collection('temario').get();
      setState(() {
        _temarios =
            temariosSnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (error) {
      print('Error al cargar los temarios: $error');
    }
  }

  Future<String?> _subirArchivo(String fileType) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [fileType],
      );

      if (result != null && result.files.isNotEmpty) {
        final blob = html.Blob([result.files.first.bytes], fileType);
        final nombreArchivo = result.files.first.name;

        final storageRef =
            FirebaseStorage.instance.ref('$fileType/$nombreArchivo');
        await storageRef.putBlob(blob);

        final url = await storageRef.getDownloadURL();
        print('URL del $fileType: $url');

        return url;
      }
    } catch (error) {
      print('Error al subir el $fileType: $error');
      return null;
    }

    return null;
  }

  Future<void> _subirImagen() async {
    final imageUrl = await _subirArchivo('image');
    if (imageUrl != null) {
      setState(() {
        _imagenUrl = imageUrl;
      });

      // Mostrar Snackbar cuando la imagen se ha subido correctamente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imagen subida con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _subirVideo() async {
    final videoUrl = await _subirArchivo('mp4');
    if (videoUrl != null) {
      setState(() {
        _videoUrl = videoUrl;
      });

      // Mostrar Snackbar cuando el video se ha subido correctamente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video subido con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _registrarTema() async {
    if (_nombreController.text.isEmpty || _temarioSeleccionado == null) {
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('temas').add({
          'name': _nombreController.text,
          'temarioRef': _temarioSeleccionado!,
          'userId': user.uid,
          'imagen': _imagenUrl,
          'video': _videoUrl,
        });

        _nombreController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tema registrado con éxito'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Error al registrar el tema: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al registrar el tema. Por favor, inténtalo de nuevo.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Tema'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Tema'),
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _temarioSeleccionado,
              onChanged: (String? newValue) {
                setState(() {
                  _temarioSeleccionado = newValue;
                });
              },
              items: [
                for (String temario in _temarios)
                  DropdownMenuItem<String>(
                    value: temario,
                    child: Text(temario),
                  ),
              ],
              hint: Text('Seleccione un Temario'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _subirImagen,
              child: Text('Subir Imagen'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _subirVideo,
              child: Text('Subir Video'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: (_imagenUrl != null || _videoUrl != null)
                  ? _registrarTema
                  : null,
              child: Text('Registrar Tema'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegistrarTemas extends StatefulWidget {
  @override
  _RegistrarTemasState createState() => _RegistrarTemasState();
}

class _RegistrarTemasState extends State<RegistrarTemas> {
  final TextEditingController _nombreController = TextEditingController();
  String? _temarioSeleccionado;
  List<String> _temarios = [];
  String? _imagenUrl;
  String? _videoUrl;

  @override
  void initState() {
    super.initState();
    _cargarTemarios();
  }

  Future<void> _cargarTemarios() async {
    try {
      final temariosSnapshot =
          await FirebaseFirestore.instance.collection('temario').get();
      setState(() {
        _temarios =
            temariosSnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (error) {
      print('Error al cargar los temarios: $error');
    }
  }

  Future<String?> _subirArchivo(String fileType) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [fileType],
      );

      if (result != null && result.files.isNotEmpty) {
        final blob = html.Blob([result.files.first.bytes], fileType);
        final nombreArchivo = result.files.first.name;

        final storageRef =
            FirebaseStorage.instance.ref('$fileType/$nombreArchivo');
        await storageRef.putBlob(blob);

        final url = await storageRef.getDownloadURL();
        print('URL del $fileType: $url');

        return url;
      }
    } catch (error) {
      print('Error al subir el $fileType: $error');
      return null;
    }

    return null;
  }

  Future<void> _subirImagen() async {
    final imageUrl = await _subirArchivo('image');
    if (imageUrl != null) {
      setState(() {
        _imagenUrl = imageUrl;
      });

      // Mostrar Snackbar cuando la imagen se ha subido correctamente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imagen subida con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _subirVideo() async {
    final videoUrl = await _subirArchivo('mp4');
    if (videoUrl != null) {
      setState(() {
        _videoUrl = videoUrl;
      });

      // Mostrar Snackbar cuando el video se ha subido correctamente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video subido con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _registrarTema() async {
    if (_nombreController.text.isEmpty || _temarioSeleccionado == null) {
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('temas').add({
          'name': _nombreController.text,
          'temarioRef': _temarioSeleccionado!,
          'userId': user.uid,
          'imagen': _imagenUrl,
          'video': _videoUrl,
        });

        _nombreController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tema registrado con éxito'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Error al registrar el tema: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al registrar el tema. Por favor, inténtalo de nuevo.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Tema'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del Tema'),
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _temarioSeleccionado,
              onChanged: (String? newValue) {
                setState(() {
                  _temarioSeleccionado = newValue;
                });
              },
              items: [
                for (String temario in _temarios)
                  DropdownMenuItem<String>(
                    value: temario,
                    child: Text(temario),
                  ),
              ],
              hint: Text('Seleccione un Temario'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _subirImagen,
              child: Text('Subir Imagen'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _subirVideo,
              child: Text('Subir Video'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: (_imagenUrl != null || _videoUrl != null)
                  ? _registrarTema
                  : null,
              child: Text('Registrar Tema'),
            ),
          ],
        ),
      ),
    );
  }
}
