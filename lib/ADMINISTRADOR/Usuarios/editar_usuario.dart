/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarUsuario extends StatefulWidget {
  final Map<String, dynamic> user;
  final String userId;

  EditarUsuario({required this.user, required this.userId});

  @override
  _EditarUsuarioState createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends State<EditarUsuario> {
  late TextEditingController displayNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late Map<String, dynamic> userData;

  @override

  void initState() {
    super.initState();
    displayNameController =
        TextEditingController(text: widget.user['display_name'] ?? '');
    emailController = TextEditingController(text: widget.user['email'] ?? '');
    passwordController =
        TextEditingController(text: widget.user['password'] ?? '');
  }

  Future<void> _loadUserData() async {
    try {
      var userRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);
      var userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        setState(() {
          userData = userSnapshot.data() as Map<String, dynamic>;
          displayNameController.text = userData['display_name'] ?? '';
          emailController.text = userData['email'] ?? '';
          passwordController.text = userData['password'] ?? '';
        });
      } else {
        // Manejar el caso en el que no se encuentra el usuario
        print('Usuario no encontrado.');
      }
    } catch (error) {
      print('Error al cargar datos del usuario: $error');
    }
  }

  Future<void> _guardarCambios() async {
    try {
      var userRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);
      await userRef.update({
        'display_name': displayNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      });

      // Muestra el SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Los datos del usuario se editaron correctamente'),
        ),
      );

      // Retrocede a la pantalla de Registro de Usuario
      Navigator.pop(context);
    } catch (error) {
      print('Error al editar los datos del usuario: $error');
      // Muestra un mensaje de error en caso de falla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al editar los datos del usuario. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            TextFormField(
              controller: displayNameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: Text('Guardar'),
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

class EditarUsuario extends StatefulWidget {
  final Map<String, dynamic> user;
  final String userId;

  EditarUsuario({required this.user, required this.userId});

  @override
  _EditarUsuarioState createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends State<EditarUsuario> {
  late TextEditingController displayNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late String selectedGender;
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    displayNameController =
        TextEditingController(text: widget.user['display_name'] ?? '');
    emailController = TextEditingController(text: widget.user['email'] ?? '');
    passwordController =
        TextEditingController(text: widget.user['password'] ?? '');
    selectedGender = widget.user['gender'] ?? 'Masculino';
  }

  Future<void> _loadUserData() async {
    try {
      var userRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);
      var userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        setState(() {
          userData = userSnapshot.data() as Map<String, dynamic>;
          displayNameController.text = userData['display_name'] ?? '';
          emailController.text = userData['email'] ?? '';
          passwordController.text = userData['password'] ?? '';
          selectedGender = userData['gender'] ?? 'Masculino';
        });
      } else {
        // Manejar el caso en el que no se encuentra el usuario
        print('Estudiante no encontrado.');
      }
    } catch (error) {
      print('Error al cargar datos del estudiante: $error');
    }
  }

  Future<void> _guardarCambios() async {
    try {
      var userRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);
      await userRef.update({
        'display_name': displayNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'gender': selectedGender,
      });

      // Muestra el SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Los datos del estudiante se editaron correctamente'),
        ),
      );

      // Retrocede a la pantalla de Registro de Usuario
      Navigator.pop(context);
    } catch (error) {
      print('Error al editar los datos del estudiante: $error');
      // Muestra un mensaje de error en caso de falla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al editar los datos del estudiante. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Estudiante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            TextFormField(
              controller: displayNameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            DropdownButtonFormField<String>(
              value: selectedGender,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
              items: ['Masculino', 'Femenino']
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Género'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
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
