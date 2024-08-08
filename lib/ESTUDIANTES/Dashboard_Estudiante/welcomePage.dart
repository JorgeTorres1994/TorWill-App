/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temas_Cuestionario.dart/lista_temas_cuestionario.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String displayName = 'Usuario';
  List<Map<String, dynamic>> temarios = [];
  List<Map<String, dynamic>> examenes = []; // Lista para almacenar los exámenes
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        QuerySnapshot temarioSnapshot = await FirebaseFirestore.instance
            .collection('temario')
            .orderBy('name')
            .get();
        QuerySnapshot examenSnapshot =
            await FirebaseFirestore.instance.collection('Examen').get();

        if (userDoc.exists) {
          displayName = userDoc.get('display_name') ?? 'Usuario';
        }

        temarios = temarioSnapshot.docs
            .map((doc) => {
                  'name': doc.get('name') ?? 'Nombre no disponible',
                  'description':
                      doc.get('description') ?? 'Descripción no disponible'
                })
            .toList();

        List<Map<String, dynamic>> tempExamenes = [];
        for (var doc in examenSnapshot.docs) {
          String temaId = doc.get('temaId');
          DocumentSnapshot temaDoc = await FirebaseFirestore.instance
              .collection('temas')
              .doc(temaId)
              .get();
          if (temaDoc.exists) {
            tempExamenes.add({
              'nombre': doc.get('nombre') ?? 'Nombre no disponible',
              'descripcion':
                  doc.get('descripcion') ?? 'Descripción no disponible',
              'tema': temaDoc.get('name') ?? 'Nombre de tema no disponible'
            });
          }
        }
        examenes = tempExamenes;
      }
    } catch (error) {
      print("Error fetching data: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://cdn.pixabay.com/photo/2017/08/30/07/59/books-2695078_960_720.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenido, $displayName',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Promedio General: 8.5',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  SectionTitle(title: 'Temarios Disponibles'),
                  SizedBox(height: 10),
                  Column(
                    children: temarios.map((temario) {
                      return TemarioCard(
                        temarioName: temario['name'] ?? 'Nombre no disponible',
                        description: temario['description'] ??
                            'Descripción no disponible',
                        onPressed: () =>
                            _navigateToTemarioDetail(context, temario['name']),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  SectionTitle(title: 'Progreso Académico'),
                  SizedBox(height: 10),
                  ProgressOverview(),
                  SizedBox(height: 30),
                  SectionTitle(title: 'Próximas Evaluaciones y Tareas'),
                  SizedBox(height: 10),
                  UpcomingTasks(examenes: examenes),
                  SizedBox(height: 30),
                  SectionTitle(title: 'Anuncios Recientes'),
                  SizedBox(height: 10),
                  RecentAnnouncements(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTemarioDetail(BuildContext context, String temarioName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaTemasCuestionario(temarioRef: temarioName),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class TemarioCard extends StatelessWidget {
  final String temarioName;
  final String description;
  final VoidCallback onPressed;

  const TemarioCard({
    required this.temarioName,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ), // Faltaba este paréntesis para cerrar RoundedRectangleBorder
      child: ListTile(
        leading: Image.network(
          'https://cdn-icons-png.flaticon.com/512/1247/1247391.png',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(temarioName),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }
}

class ProgressOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            'Progreso Actual',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.75,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            color: Colors.blueAccent,
          ),
          SizedBox(height: 10),
          Text(
            'Tareas completadas: 75%',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class UpcomingTasks extends StatelessWidget {
  final List<Map<String, dynamic>> examenes;

  const UpcomingTasks({Key? key, required this.examenes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: examenes.map((examen) {
        return TaskCard(
          taskName: examen['nombre'],
          dueDate:
              "Fecha de entrega: ${examen['tema']}", // Ajusta según tus campos
          description: examen['descripcion'],
          onPressed: () {},
        );
      }).toList(),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String taskName;
  final String dueDate;
  final String description;
  final VoidCallback onPressed;

  const TaskCard({
    required this.taskName,
    required this.dueDate,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(Icons.assignment, color: Colors.orangeAccent),
        title: Text(taskName),
        subtitle: Text('$dueDate\n$description'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }
}

class RecentAnnouncements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnnouncementCard(
          title: 'Nueva actualización en la plataforma',
          date: '2024-08-01',
          onPressed: () {},
        ),
        AnnouncementCard(
          title: 'Evento deportivo próximo',
          date: '2024-08-05',
          onPressed: () {},
        ),
        // Añade más AnnouncementCard aquí según sea necesario
      ],
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback onPressed;

  const AnnouncementCard({
    required this.title,
    required this.date,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(Icons.announcement, color: Colors.redAccent),
        title: Text(title),
        subtitle: Text(date),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temas_Cuestionario.dart/lista_temas_cuestionario.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String displayName = 'Usuario';
  List<Map<String, dynamic>> temarios = [];
  List<Map<String, dynamic>> examenes = []; // Lista para almacenar los exámenes
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        QuerySnapshot temarioSnapshot = await FirebaseFirestore.instance
            .collection('temario')
            .orderBy('name')
            .get();
        QuerySnapshot examenSnapshot =
            await FirebaseFirestore.instance.collection('Examen').get();

        if (userDoc.exists) {
          displayName = userDoc.get('display_name') ?? 'Usuario';
        }

        temarios = temarioSnapshot.docs
            .map((doc) => {
                  'name': doc.get('name') ?? 'Nombre no disponible',
                  'description':
                      doc.get('description') ?? 'Descripción no disponible'
                })
            .toList();

        List<Map<String, dynamic>> tempExamenes = [];
        for (var doc in examenSnapshot.docs) {
          String temaId = doc.get('temaId');
          DocumentSnapshot temaDoc = await FirebaseFirestore.instance
              .collection('temas')
              .doc(temaId)
              .get();
          if (temaDoc.exists) {
            tempExamenes.add({
              'nombre': doc.get('nombre') ?? 'Nombre no disponible',
              'descripcion':
                  doc.get('descripcion') ?? 'Descripción no disponible',
              'tema': temaDoc.get('name') ?? 'Nombre de tema no disponible'
            });
          }
        }
        examenes = tempExamenes;
      }
    } catch (error) {
      print("Error fetching data: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://cdn.pixabay.com/photo/2017/08/30/07/59/books-2695078_960_720.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenido, $displayName',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Promedio General: 8.5',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  SectionTitle(title: 'Temarios Disponibles'),
                  SizedBox(height: 10),
                  Column(
                    children: temarios.map((temario) {
                      return TemarioCard(
                        temarioName: temario['name'] ?? 'Nombre no disponible',
                        description: temario['description'] ??
                            'Descripción no disponible',
                        onPressed: () =>
                            _navigateToTemarioDetail(context, temario['name']),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  SectionTitle(title: 'Progreso Académico'),
                  SizedBox(height: 10),
                  ProgressOverview(),
                  SizedBox(height: 30),
                  SectionTitle(title: 'Próximas Evaluaciones y Tareas'),
                  SizedBox(height: 10),
                  UpcomingTasks(examenes: examenes),
                  SizedBox(height: 30),
                  SectionTitle(title: 'Anuncios Recientes'),
                  SizedBox(height: 10),
                  RecentAnnouncements(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTemarioDetail(BuildContext context, String temarioName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaTemasCuestionario(temarioRef: temarioName),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class TemarioCard extends StatelessWidget {
  final String temarioName;
  final String description;
  final VoidCallback onPressed;

  const TemarioCard({
    required this.temarioName,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ), // Faltaba este paréntesis para cerrar RoundedRectangleBorder
      child: ListTile(
        leading: Image.network(
          'https://cdn-icons-png.flaticon.com/512/1247/1247391.png',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(temarioName),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }
}

class ProgressOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            'Progreso Actual',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.75,
            minHeight: 10,
            backgroundColor: Colors.grey[300],
            color: Colors.blueAccent,
          ),
          SizedBox(height: 10),
          Text(
            'Tareas completadas: 75%',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class UpcomingTasks extends StatelessWidget {
  final List<Map<String, dynamic>> examenes;

  const UpcomingTasks({Key? key, required this.examenes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: examenes.map((examen) {
        return TaskCard(
          taskName: examen['nombre'],
          dueDate:
              "Tema: ${examen['tema']}", // Ajusta según tus campos
          description: examen['descripcion'],
          onPressed: () {},
        );
      }).toList(),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String taskName;
  final String dueDate;
  final String description;
  final VoidCallback onPressed;

  const TaskCard({
    required this.taskName,
    required this.dueDate,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(Icons.assignment, color: Colors.orangeAccent),
        title: Text(taskName),
        subtitle: Text('$dueDate\n$description'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }
}

class RecentAnnouncements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnnouncementCard(
          title: 'Nueva actualización en la plataforma',
          date: '2024-08-01',
          onPressed: () {},
        ),
        AnnouncementCard(
          title: 'Evento deportivo próximo',
          date: '2024-08-05',
          onPressed: () {},
        ),
        // Añade más AnnouncementCard aquí según sea necesario
      ],
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback onPressed;

  const AnnouncementCard({
    required this.title,
    required this.date,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(Icons.announcement, color: Colors.redAccent),
        title: Text(title),
        subtitle: Text(date),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }
}
