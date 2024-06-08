/*import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class EditarTemas extends StatefulWidget {
  final String temaId;

  EditarTemas({required this.temaId});

  @override
  _EditarTemasState createState() => _EditarTemasState();
}

class _EditarTemasState extends State<EditarTemas> {
  final TextEditingController _nombreController = TextEditingController();
  String? _temarioSeleccionado;
  List<String> _temarios = [];
  String? _imagenUrl;
  String? _videoUrl;
  String? _audioUrl;

  @override
  void initState() {
    super.initState();
    _cargarTemarios();
    _cargarDatosTema();
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

  Future<void> _cargarDatosTema() async {
    try {
      final temaSnapshot = await FirebaseFirestore.instance
          .collection('temas')
          .doc(widget.temaId)
          .get();
      var tema = temaSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _nombreController.text = tema['name'];
        _temarioSeleccionado = tema['temarioRef'];
        _imagenUrl = tema['imagen'];
        _videoUrl = tema['video'];
        _audioUrl = tema['audio'];
      });
    } catch (error) {
      print('Error al cargar los datos del tema: $error');
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

  Future<void> _subirVideo() async {
    final videoUrl = await _subirArchivo('mp4');
    if (videoUrl != null) {
      setState(() {
        _videoUrl = videoUrl;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video subido con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _subirAudio() async {
    final audioUrl = await _subirArchivo('mp3');
    if (audioUrl != null) {
      setState(() {
        _audioUrl = audioUrl;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Audio subido con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _editarTema() async {
    if (_nombreController.text.isEmpty || _temarioSeleccionado == null) {
      return;
    }

    try {
      Map<String, dynamic> updatedFields = {
        'name': _nombreController.text,
        'temarioRef': _temarioSeleccionado!,
        'imagen': _imagenUrl,
        'video': _videoUrl ?? '',
        'audio': _audioUrl ?? '',
      };

      await FirebaseFirestore.instance
          .collection('temas')
          .doc(widget.temaId)
          .update(updatedFields);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tema editado con éxito'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context); // Volver a la pantalla anterior
    } catch (error) {
      print('Error al editar el tema: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error al editar el tema. Por favor, inténtalo de nuevo.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tema'),
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
              onPressed: _subirVideo,
              child: Text('Subir Nuevo Video'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _subirAudio,
              child: Text('Subir Nuevo Audio'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _editarTema,
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class EditarTemas extends StatefulWidget {
  final String temaId;

  EditarTemas({required this.temaId});

  @override
  _EditarTemasState createState() => _EditarTemasState();
}

class _EditarTemasState extends State<EditarTemas> {
  final TextEditingController _nombreController = TextEditingController();
  String? _temarioSeleccionado;
  List<String> _temarios = [];
  String? _imagenUrl;
  String? _videoUrl;
  String? _audioUrl;

  @override
  void initState() {
    super.initState();
    _cargarTemarios();
    _cargarDatosTema();
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

  Future<void> _cargarDatosTema() async {
    try {
      final temaSnapshot = await FirebaseFirestore.instance
          .collection('temas')
          .doc(widget.temaId)
          .get();
      var tema = temaSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _nombreController.text = tema['name'];
        _temarioSeleccionado = tema['temarioRef'];
        _imagenUrl = tema['imagen'];
        _videoUrl = tema['video'];
        _audioUrl = tema['audio'];
      });
    } catch (error) {
      print('Error al cargar los datos del tema: $error');
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

  Future<void> _subirVideo() async {
    final videoUrl = await _subirArchivo('mp4');
    if (videoUrl != null) {
      setState(() {
        _videoUrl = videoUrl;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Video subido con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _subirAudio() async {
    final audioUrl = await _subirArchivo('mp3');
    if (audioUrl != null) {
      setState(() {
        _audioUrl = audioUrl;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Audio subido con éxito'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _editarTema() async {
    if (_nombreController.text.isEmpty || _temarioSeleccionado == null) {
      return;
    }

    try {
      Map<String, dynamic> updatedFields = {
        'name': _nombreController.text,
        'temarioRef': _temarioSeleccionado!,
        'imagen': _imagenUrl,
        'video': _videoUrl ?? '',
        'audio': _audioUrl ?? '',
      };

      await FirebaseFirestore.instance
          .collection('temas')
          .doc(widget.temaId)
          .update(updatedFields);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tema editado con éxito'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context); // Volver a la pantalla anterior
    } catch (error) {
      print('Error al editar el tema: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error al editar el tema. Por favor, inténtalo de nuevo.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tema'),
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
              onPressed: _subirVideo,
              child: Text('Subir Nuevo Video'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _subirAudio,
              child: Text('Subir Nuevo Audio'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _editarTema,
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}

