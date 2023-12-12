/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temas_Examen/lista_temas_examen.dart';

class ListaTemariosCuestionario extends StatefulWidget {
  @override
  _ListaTemariosCuestionarioState createState() =>
      _ListaTemariosCuestionarioState();
}

class _ListaTemariosCuestionarioState extends State<ListaTemariosCuestionario> {
  List<Map<String, dynamic>> temarios = [];

  Future<List<Map<String, dynamic>>> getTemarios() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('temario').get();

    return querySnapshot.docs
        .map((DocumentSnapshot document) =>
            document.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Cargar los temarios al inicio
    getTemarios().then((temariosList) {
      setState(() {
        temarios = temariosList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona el temario de tu cuestionario'),
      ),
      body: temarios.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: temarios.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    temarios[index]['name'],
                    style: TextStyle(fontSize: 20.0),
                  ),
                  leading: Image.asset(
                    'images/temariosExamen.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                  onTap: () {
                    _onTemarioSelected(temarios[index]);
                  },
                  selected: temarios[index]['selected'] ?? false,
                  tileColor: temarios[index]['selected'] ?? false
                      ? Colors.blue.withOpacity(0.3)
                      : null,
                );
              },
            ),
    );
  }

  void _onTemarioSelected(Map<String, dynamic> temario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaTemasExamen(temario: temario),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Lista_Temas_Examen/lista_temas_examen.dart';
import 'package:provider/provider.dart';

class TemariosProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _temarios = [];

  List<Map<String, dynamic>> get temarios => _temarios;

  Future<void> loadTemarios() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('temario').get();
    _temarios = querySnapshot.docs
        .map((DocumentSnapshot document) =>
            document.data() as Map<String, dynamic>)
        .toList();
    notifyListeners();
  }
}

class ListaTemariosCuestionario extends StatefulWidget {
  @override
  _ListaTemariosCuestionarioState createState() =>
      _ListaTemariosCuestionarioState();
}

class _ListaTemariosCuestionarioState extends State<ListaTemariosCuestionario> {
  late TemariosProvider _temariosProvider;

  @override
  void initState() {
    super.initState();
    _temariosProvider = Provider.of<TemariosProvider>(context, listen: false);
    _temariosProvider.loadTemarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona el temario de tu cuestionario'),
      ),
      body: Consumer<TemariosProvider>(
        builder: (context, temariosProvider, child) {
          return temariosProvider.temarios.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: temariosProvider.temarios.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        temariosProvider.temarios[index]['name'],
                        style: TextStyle(fontSize: 20.0),
                      ),
                      leading: Image.asset(
                        'images/temariosExamen.png',
                        width: 100.0,
                        height: 100.0,
                      ),
                      onTap: () {
                        _onTemarioSelected(temariosProvider.temarios[index]);
                      },
                      selected:
                          temariosProvider.temarios[index]['selected'] ?? false,
                      tileColor:
                          temariosProvider.temarios[index]['selected'] ?? false
                              ? Colors.blue.withOpacity(0.3)
                              : null,
                    );
                  },
                );
        },
      ),
    );
  }

  void _onTemarioSelected(Map<String, dynamic> temario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaTemasExamen(temario: temario),
      ),
    );
  }
}
