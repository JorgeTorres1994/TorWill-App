/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarPerfil extends StatefulWidget {
  final String userId;

  EditarPerfil({required this.userId});

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  late TextEditingController displayNameController;
  late TextEditingController emailController;
  //late String selectedGender;
  late String selectedGender = genderOptions.first;
  final List<String> genderOptions = ['Masculino', 'Femenino'];
  bool _userDataLoaded = false;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores y obtener datos del usuario
    displayNameController = TextEditingController();
    emailController = TextEditingController();
    //selectedGender = '';
    selectedGender = genderOptions.isNotEmpty ? genderOptions.first : '';

    // Cargar datos del usuario al iniciar la pantalla
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Obtener referencia del usuario actual
      var userRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);
      var userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        // Si el usuario existe, cargar los datos en los controladores
        var userData = userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          displayNameController.text = userData['display_name'] ?? '';
          emailController.text = userData['email'] ?? '';
          selectedGender = userData['gender'] ?? '';
          _userDataLoaded = true;
        });
      } else {
        // Manejar el caso en el que no se encuentra el usuario
        print('Usuario no encontrado.');
        _userDataLoaded = true; // Marcar como cargado para evitar errores
      }
    } catch (error) {
      print('Error al cargar datos del usuario: $error');
    }
  }

  Future<void> _guardarCambios() async {
    try {
      // Obtener referencia del usuario actual
      var userRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);
      await userRef.update({
        'display_name': displayNameController.text,
        'email': emailController.text,
        'gender': selectedGender,
      });

      // Muestra el SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Los datos del perfil se editaron correctamente'),
        ),
      );
      // Retrocede a la pantalla anterior
      //Navigator.pop(context);
    } catch (error) {
      print('Error al editar los datos del perfil: $error');
      // Muestra un mensaje de error en caso de falla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al editar los datos del perfil. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verificar si los datos del usuario se han cargado antes de mostrar la pantalla
    if (!_userDataLoaded) {
      // Puedes mostrar un indicador de carga o simplemente un contenedor vacío
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Definir la ruta de la imagen del avatar según el género
    var avatarImagePath = selectedGender == 'Masculino'
        ? 'images/chico.png'
        : 'images/leyendo.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(avatarImagePath),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: displayNameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),

            PopupMenuButton<String>(
              initialValue: selectedGender,
              itemBuilder: (BuildContext context) {
                return genderOptions.map((String option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
              onSelected: (String value) {
                setState(() {
                  selectedGender = value;
                });
              },
              child: ListTile(
                title: Text('Género'),
                subtitle: Text(selectedGender),
                trailing: Icon(Icons.arrow_drop_down),
              ),
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

class EditarPerfil extends StatefulWidget {
  final String userId;

  EditarPerfil({required this.userId});

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  late TextEditingController displayNameController;
  late TextEditingController emailController;
  //late String selectedGender;
  late String selectedGender = genderOptions.first;
  final List<String> genderOptions = ['Masculino', 'Femenino'];
  bool _userDataLoaded = false;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores y obtener datos del usuario
    displayNameController = TextEditingController();
    emailController = TextEditingController();
    //selectedGender = '';
    selectedGender = genderOptions.isNotEmpty ? genderOptions.first : '';

    // Cargar datos del usuario al iniciar la pantalla
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Obtener referencia del usuario actual
      var userRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);
      var userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        // Si el usuario existe, cargar los datos en los controladores
        var userData = userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          displayNameController.text = userData['display_name'] ?? '';
          emailController.text = userData['email'] ?? '';
          selectedGender = userData['gender'] ?? '';
          _userDataLoaded = true;
        });
      } else {
        // Manejar el caso en el que no se encuentra el usuario
        print('Usuario no encontrado.');
        _userDataLoaded = true; // Marcar como cargado para evitar errores
      }
    } catch (error) {
      print('Error al cargar datos del usuario: $error');
    }
  }

  Future<void> _guardarCambios() async {
    try {
      // Obtener referencia del usuario actual
      var userRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);
      await userRef.update({
        'display_name': displayNameController.text,
        'email': emailController.text,
        'gender': selectedGender,
      });

      // Muestra el SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Los datos del perfil se editaron correctamente'),
        ),
      );
      // Retrocede a la pantalla anterior
      //Navigator.pop(context);
    } catch (error) {
      print('Error al editar los datos del perfil: $error');
      // Muestra un mensaje de error en caso de falla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error al editar los datos del perfil. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verificar si los datos del usuario se han cargado antes de mostrar la pantalla
    if (!_userDataLoaded) {
      // Puedes mostrar un indicador de carga o simplemente un contenedor vacío
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Definir la ruta de la imagen del avatar según el género
    var avatarImagePath = selectedGender == 'Masculino'
        ? 'images/chico.png'
        : 'images/leyendo.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(avatarImagePath),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: displayNameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            PopupMenuButton<String>(
              initialValue: selectedGender,
              itemBuilder: (BuildContext context) {
                return genderOptions.map((String option) {
                  return PopupMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
              onSelected: (String value) {
                setState(() {
                  selectedGender = value;
                });
              },
              child: ListTile(
                title: Text('Género'),
                subtitle: Text(selectedGender),
                trailing: Icon(Icons.arrow_drop_down),
              ),
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
