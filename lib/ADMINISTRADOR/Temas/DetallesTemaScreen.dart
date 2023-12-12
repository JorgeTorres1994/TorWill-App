/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class DetallesTemaScreen extends StatelessWidget {
  final String temaId;

  DetallesTemaScreen({required this.temaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Tema'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('temas').doc(temaId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var tema = snapshot.data!.data() as Map<String, dynamic>;

          // Configurar el controlador de video
          VideoPlayerController _videoPlayerController =
              VideoPlayerController.network(tema['video']);
          _videoPlayerController.initialize();

          // Configurar el controlador de Chewie
          ChewieController _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay:
                false, // Puedes configurar esto como true si quieres que el video se reproduzca automáticamente
            looping: false,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height:
                    200, // Establece la altura deseada para el área de visualización del video
                child: Chewie(controller: _chewieController),
              ),
              Text('Nombre: ${tema['name']}'),
              Text('Temario: ${tema['temarioRef']}'),
              ElevatedButton(
                onPressed: () {
                  // Puedes agregar lógica adicional para controlar la reproducción del video aquí
                  _videoPlayerController.play();
                },
                child: Text('Reproducir Video'),
              ),
            ],
          );
        },
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class DetallesTemaScreen extends StatelessWidget {
  final String temaId;

  DetallesTemaScreen({required this.temaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Tema'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('temas').doc(temaId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var tema = snapshot.data!.data() as Map<String, dynamic>;

          // Configurar el controlador de video
          VideoPlayerController _videoPlayerController =
              VideoPlayerController.network(tema['video']);
          _videoPlayerController.initialize();

          // Configurar el controlador de Chewie
          ChewieController _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: false,
            looping: false,
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: Chewie(controller: _chewieController),
                ),
                SizedBox(height: 16),
                Text(
                  'Nombre: ${tema['name']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Temario: ${tema['temarioRef']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
