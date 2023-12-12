/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarTemario extends StatefulWidget {
  final Map<String, dynamic> temario;
  final String temarioId;

  EditarTemario({required this.temario, required this.temarioId});

  @override
  _EditarTemarioState createState() => _EditarTemarioState();
}

class _EditarTemarioState extends State<EditarTemario> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late Map<String, dynamic> temarioData;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.temario['name'] ?? '');
    descriptionController =
        TextEditingController(text: widget.temario['description'] ?? '');
  }

  Future<void> _loadTemarioData() async {
    try {
      var temarioRef = FirebaseFirestore.instance
          .collection('temario')
          .doc(widget.temarioId);
      var temarioSnapshot = await temarioRef.get();

      if (temarioSnapshot.exists) {
        setState(() {
          temarioData = temarioSnapshot.data() as Map<String, dynamic>;
          nameController.text = temarioData['name'] ?? '';
          descriptionController.text = temarioData['description'] ?? '';
        });
      } else {
        // Manejar el caso en el que no se encuentra el temario
        print('Temario no encontrado.');
      }
    } catch (error) {
      print('Error al cargar datos del temario: $error');
    }
  }

  Future<void> _guardarCambios() async {
    try {
      var temarioRef = FirebaseFirestore.instance
          .collection('temario')
          .doc(widget.temarioId);
      await temarioRef.update({
        'name': nameController.text,
        'description': descriptionController.text,
      });

      // Muestra el SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Los datos del temario se editaron correctamente'),
        ),
      );

      // Retrocede a la pantalla de Lista de Temarios
      Navigator.pop(context);
    } catch (error) {
      print('Error al editar los datos del temario: $error');
      // Muestra un mensaje de error en caso de falla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al editar los datos del temario. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Temario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre del Temario'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarTemario extends StatefulWidget {
  final Map<String, dynamic> temario;
  final String temarioId;

  EditarTemario({required this.temario, required this.temarioId});

  @override
  _EditarTemarioState createState() => _EditarTemarioState();
}

class _EditarTemarioState extends State<EditarTemario> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late Map<String, dynamic> temarioData;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.temario['name'] ?? '');
    descriptionController =
        TextEditingController(text: widget.temario['description'] ?? '');
  }

  Future<void> _loadTemarioData() async {
    try {
      var temarioRef = FirebaseFirestore.instance
          .collection('temario')
          .doc(widget.temarioId);
      var temarioSnapshot = await temarioRef.get();

      if (temarioSnapshot.exists) {
        setState(() {
          temarioData = temarioSnapshot.data() as Map<String, dynamic>;
          nameController.text = temarioData['name'] ?? '';
          descriptionController.text = temarioData['description'] ?? '';
        });
      } else {
        // Manejar el caso en el que no se encuentra el temario
        print('Temario no encontrado.');
      }
    } catch (error) {
      print('Error al cargar datos del temario: $error');
    }
  }

  Future<void> _guardarCambios() async {
    try {
      var temarioRef = FirebaseFirestore.instance
          .collection('temario')
          .doc(widget.temarioId);
      await temarioRef.update({
        'name': nameController.text,
        'description': descriptionController.text,
      });

      // Muestra el SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Los datos del temario se editaron correctamente'),
        ),
      );

      // Retrocede a la pantalla de Lista de Temarios
      Navigator.pop(context);
    } catch (error) {
      print('Error al editar los datos del temario: $error');
      // Muestra un mensaje de error en caso de falla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al editar los datos del temario. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Temario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre del Temario'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
