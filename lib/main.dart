/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/Bienvenida/bienvenida.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Dashboard_Profesor/dashboard_profesor.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/dashboard_estudiante.dart';
import 'package:nueva_app_web_matematicas/providers/dark_theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC2IMLFFFEk5T0bmUzaGs5HkqhuAxLc7V8",
      authDomain: "sistemawebmatematicas.firebaseapp.com",
      projectId: "sistemawebmatematicas",
      storageBucket: "sistemawebmatematicas.appspot.com",
      messagingSenderId: "480008247108",
      appId: "1:480008247108:web:6e3e07d337c648f2b8a911",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkThemeProvider>(
          create: (_) => DarkThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme:
              themeProvider.getDarkTheme ? ThemeData.dark() : ThemeData.light(),
          debugShowCheckedModeBanner: false,
          title: 'TORWIL APP - APRENDIENDO MATEMÁTICAS',
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final isUserSignedIn = snapshot.hasData;

                if (isUserSignedIn) {
                  final User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.done) {
                          if (userSnapshot.hasError) {
                            return Center(
                              child:
                                  Text('Error al cargar los datos del usuario'),
                            );
                          }

                          var isAdmin = userSnapshot.data?['isAdmin'] ?? false;

                          if (isAdmin) {
                            return const Dashboard();
                          } else {
                            return DashboardEstudiante();
                          }
                        }

                        return Center(child: CircularProgressIndicator());
                      },
                    );
                  }
                }

                return const Bienvenida();
              }
            },
          ),
        );
      },
    );
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/Bienvenida/bienvenida.dart';
import 'package:nueva_app_web_matematicas/ADMINISTRADOR/Dashboard_Profesor/dashboard_profesor.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Dashboard_Estudiante/dashboard_estudiante.dart';
import 'package:nueva_app_web_matematicas/providers/dark_theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC2IMLFFFEk5T0bmUzaGs5HkqhuAxLc7V8",
      authDomain: "sistemawebmatematicas.firebaseapp.com",
      projectId: "sistemawebmatematicas",
      storageBucket: "sistemawebmatematicas.appspot.com",
      messagingSenderId: "480008247108",
      appId: "1:480008247108:web:6e3e07d337c648f2b8a911",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkThemeProvider>(
          create: (_) => DarkThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue, // Swatch de color para el tema claro
            fontFamily: 'NotoSans', // Familia de fuente
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.indigo, // Color primario para el tema oscuro
            fontFamily: 'NotoSans', // Familia de fuente
          ),
          themeMode:
              themeProvider.getDarkTheme ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          title: 'TORWIL APP - APRENDIENDO MATEMÁTICAS',
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final isUserSignedIn = snapshot.hasData;

                if (isUserSignedIn) {
                  final User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.done) {
                          if (userSnapshot.hasError) {
                            return Center(
                              child:
                                  Text('Error al cargar los datos del usuario'),
                            );
                          }

                          var isAdmin = userSnapshot.data?['isAdmin'] ?? false;

                          if (isAdmin) {
                            return const Dashboard();
                          } else {
                            return DashboardEstudiante();
                          }
                        }

                        return Center(child: CircularProgressIndicator());
                      },
                    );
                  }
                }

                return const Bienvenida();
              }
            },
          ),
        );
      },
    );
  }
}
