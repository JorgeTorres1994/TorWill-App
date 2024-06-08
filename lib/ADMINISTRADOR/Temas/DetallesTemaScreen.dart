/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:just_audio/just_audio.dart';

class DetallesTemaScreen extends StatefulWidget {
  final String temaId;

  DetallesTemaScreen({required this.temaId});

  @override
  _DetallesTemaScreenState createState() => _DetallesTemaScreenState();
}

class _DetallesTemaScreenState extends State<DetallesTemaScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late AudioPlayer _audioPlayer;
  late Future<void> _initializeAudioPlayer;
  ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudioPlayer = _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    // Inicializar el audio player, pero no configurar una URL hasta que se tenga un tema con audio
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleAudioPlayback() {
    if (_isPlaying.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    _isPlaying.value = !_isPlaying.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Tema'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('temas').doc(widget.temaId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var tema = snapshot.data!.data() as Map<String, dynamic>;

          _videoPlayerController = VideoPlayerController.network(tema['video']);
          _videoPlayerController.initialize();

          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: false,
            looping: false,
            aspectRatio: 3 / 2,
          );

          // Comprobar si el tema tiene un campo de audio
          bool hasAudio = tema.containsKey('audio') && tema['audio'].isNotEmpty;
          if (hasAudio) {
            _audioPlayer.setUrl(tema['audio']);
          }

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
                    SizedBox(height: 16),
                    if (hasAudio)
                      FutureBuilder<void>(
                        future: _initializeAudioPlayer,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return Column(
                              children: [
                                ValueListenableBuilder<bool>(
                                  valueListenable: _isPlaying,
                                  builder: (context, isPlaying, child) {
                                    return ElevatedButton(
                                      onPressed: _toggleAudioPlayback,
                                      child: Icon(
                                        isPlaying ? Icons.pause : Icons.play_arrow,
                                      ),
                                    );
                                  },
                                ),
                                StreamBuilder<Duration?>(
                                  stream: _audioPlayer.durationStream,
                                  builder: (context, snapshot) {
                                    final duration = snapshot.data ?? Duration.zero;
                                    return StreamBuilder<Duration>(
                                      stream: _audioPlayer.positionStream,
                                      builder: (context, snapshot) {
                                        var position = snapshot.data ?? Duration.zero;
                                        if (position > duration) {
                                          position = duration;
                                        }
                                        return Slider(
                                          min: 0.0,
                                          max: duration.inMilliseconds.toDouble(),
                                          value: position.inMilliseconds.toDouble(),
                                          onChanged: (value) {
                                            _audioPlayer.seek(Duration(milliseconds: value.round()));
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
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
import 'package:just_audio/just_audio.dart';

class DetallesTemaScreen extends StatefulWidget {
  final String temaId;

  DetallesTemaScreen({required this.temaId});

  @override
  _DetallesTemaScreenState createState() => _DetallesTemaScreenState();
}

class _DetallesTemaScreenState extends State<DetallesTemaScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late AudioPlayer _audioPlayer;
  late Future<void> _initializeAudioPlayer;
  ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudioPlayer = _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    // Inicializar el audio player, pero no configurar una URL hasta que se tenga un tema con audio
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleAudioPlayback() {
    if (_isPlaying.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    _isPlaying.value = !_isPlaying.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Tema'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('temas').doc(widget.temaId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var tema = snapshot.data!.data() as Map<String, dynamic>;

          _videoPlayerController = VideoPlayerController.network(tema['video']);
          _videoPlayerController.initialize();

          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: false,
            looping: false,
            aspectRatio: 3 / 2,
          );

          // Comprobar si el tema tiene un campo de audio
          bool hasAudio = tema.containsKey('audio') && tema['audio'].isNotEmpty;
          if (hasAudio) {
            _audioPlayer.setUrl(tema['audio']);
          }

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
                    SizedBox(height: 16),
                    if (hasAudio)
                      FutureBuilder<void>(
                        future: _initializeAudioPlayer,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return Column(
                              children: [
                                ValueListenableBuilder<bool>(
                                  valueListenable: _isPlaying,
                                  builder: (context, isPlaying, child) {
                                    return ElevatedButton(
                                      onPressed: _toggleAudioPlayback,
                                      child: Icon(
                                        isPlaying ? Icons.pause : Icons.play_arrow,
                                      ),
                                    );
                                  },
                                ),
                                StreamBuilder<Duration?>(
                                  stream: _audioPlayer.durationStream,
                                  builder: (context, snapshot) {
                                    final duration = snapshot.data ?? Duration.zero;
                                    return StreamBuilder<Duration>(
                                      stream: _audioPlayer.positionStream,
                                      builder: (context, snapshot) {
                                        var position = snapshot.data ?? Duration.zero;
                                        if (position > duration) {
                                          position = duration;
                                        }
                                        return Slider(
                                          min: 0.0,
                                          max: duration.inMilliseconds.toDouble(),
                                          value: position.inMilliseconds.toDouble(),
                                          onChanged: (value) {
                                            _audioPlayer.seek(Duration(milliseconds: value.round()));
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
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
