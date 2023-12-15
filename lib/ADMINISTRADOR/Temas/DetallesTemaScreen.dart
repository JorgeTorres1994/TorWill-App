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
            autoPlay: false,
            looping: false,
            aspectRatio: 3 /
                2, // Establece un aspect ratio personalizado (400x600 pixels)
          );

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 600,
                      height: 400,
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
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

*/

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
            aspectRatio: 3 /
                2, // Establece un aspect ratio personalizado (400x600 pixels)
          );

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 600,
                      height: 400,
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
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
