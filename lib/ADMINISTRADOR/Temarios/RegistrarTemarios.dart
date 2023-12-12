/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrarTemario extends StatefulWidget {
  @override
  _RegistrarTemarioState createState() => _RegistrarTemarioState();
}

class _RegistrarTemarioState extends State<RegistrarTemario> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _saveTemario() async {
    if (_formKey.currentState!.validate()) {
      try {
        var temarioRef =
            await FirebaseFirestore.instance.collection('temario').add({
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
        });

        var temarioId = temarioRef.id;

        // Registrar el temario_id junto con el temario
        await temarioRef.update({'temario_id': temarioId});

        print('Temario registrado correctamente. ID: $temarioId');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Temario registrado correctamente. ID: $temarioId')),
        );
      } catch (error) {
        _showErrorSnackBar('Error al registrar el temario: $error');
      }
    }
  }

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Temario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                controller: nameController,
                labelText: 'Nombre del Temario',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre del temario';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              _buildTextFormField(
                controller: descriptionController,
                labelText: 'Descripción',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la descripción del temario';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTemario,
                child: Text('Guardar Temario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrarTemario extends StatefulWidget {
  @override
  _RegistrarTemarioState createState() => _RegistrarTemarioState();
}

class _RegistrarTemarioState extends State<RegistrarTemario> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void _saveTemario() async {
    if (_formKey.currentState!.validate()) {
      try {
        var temarioRef =
            await FirebaseFirestore.instance.collection('temario').add({
          'name': nameController.text.trim(),
          'description': descriptionController.text.trim(),
        });

        var temarioId = temarioRef.id;

        // Registrar el temario_id junto con el temario
        await temarioRef.update({'temario_id': temarioId});

        print('Temario registrado correctamente. ID: $temarioId');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Temario registrado correctamente. ID: $temarioId')),
        );
      } catch (error) {
        _showErrorSnackBar('Error al registrar el temario: $error');
      }
    }
  }

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Temario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                controller: nameController,
                labelText: 'Nombre del Temario',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre del temario';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              _buildTextFormField(
                controller: descriptionController,
                labelText: 'Descripción',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la descripción del temario';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTemario,
                child: Text('Guardar Temario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
