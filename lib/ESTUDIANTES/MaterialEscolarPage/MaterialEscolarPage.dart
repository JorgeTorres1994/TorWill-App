/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MaterialEscolarPage extends StatefulWidget {
  final String temaId;

  MaterialEscolarPage({
    required this.temaId,
  });

  @override
  _MaterialEscolarPageState createState() => _MaterialEscolarPageState();
}

class _MaterialEscolarPageState extends State<MaterialEscolarPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late AudioPlayer _audioPlayer;
  late Future<void> _initializeAudioPlayer;
  ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);
  bool _isLoading = true;
  bool _hasVideo = false;
  bool _hasAudio = false;
  bool _isSeen = false; // Variable para controlar si el tema ha sido visto

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _fetchData();
    _checkIfSeen(); // Verifica si el tema ya ha sido visto
  }

  Future<void> _fetchData() async {
    try {
      DocumentSnapshot temaSnapshot = await FirebaseFirestore.instance
          .collection('temas')
          .doc(widget.temaId)
          .get();

      Map<String, dynamic> data = temaSnapshot.data() as Map<String, dynamic>;
      String? urlDelVideo = data['video'];
      String? urlDeRecording = data['audio'];

      if (urlDelVideo != null && urlDelVideo.isNotEmpty) {
        _initializeVideo(urlDelVideo);
        _hasVideo = true;
      } else {
        setState(() {
          _isLoading = false;
        });
      }

      if (urlDeRecording != null && urlDeRecording.isNotEmpty) {
        _initializeAudio(urlDeRecording);
        _hasAudio = true;
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: false,
          looping: false,
          aspectRatio: _videoPlayerController.value.aspectRatio,
        );
        setState(() {
          _isLoading = false;
        });
      });
  }

  void _initializeAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  Future<void> _markAsSeen() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text('¿Ya viste todo el material propuesto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
        await FirebaseFirestore.instance.collection('MaterialVisto').add({
          'temaId': widget.temaId,
          'userId': userId,
          'esVisto': true,
        });
        setState(() {
          _isSeen = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Material marcado como visto.'),
        ));
      } catch (e) {
        print("Error marcando como visto: $e");
      }
    }
  }

  Future<void> _checkIfSeen() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('MaterialVisto')
          .where('temaId', isEqualTo: widget.temaId)
          .where('userId', isEqualTo: userId)
          .where('esVisto', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _isSeen = true;
        });
      }
    } catch (e) {
      print("Error checking if seen: $e");
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
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
        title: Text('Material Escolar'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_hasVideo && _chewieController != null)
                          SizedBox(
                            height: 300,
                            child: Chewie(controller: _chewieController!),
                          )
                        else if (!_hasVideo)
                          Center(
                              child:
                                  Text('No hay material de video disponible.')),
                        SizedBox(
                            height:
                                32), // Espacio adicional entre video y audio
                        if (_hasAudio)
                          Column(
                            children: [
                              ValueListenableBuilder<bool>(
                                valueListenable: _isPlaying,
                                builder: (context, isPlaying, child) {
                                  return ElevatedButton(
                                    onPressed: _toggleAudioPlayback,
                                    child: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 16),
                              StreamBuilder<Duration?>(
                                stream: _audioPlayer.durationStream,
                                builder: (context, snapshot) {
                                  final duration =
                                      snapshot.data ?? Duration.zero;
                                  return StreamBuilder<Duration>(
                                    stream: _audioPlayer.positionStream,
                                    builder: (context, snapshot) {
                                      var position =
                                          snapshot.data ?? Duration.zero;
                                      if (position > duration) {
                                        position = duration;
                                      }
                                      return Column(
                                        children: [
                                          Slider(
                                            min: 0.0,
                                            max: duration.inMilliseconds
                                                .toDouble(),
                                            value: position.inMilliseconds
                                                .toDouble(),
                                            onChanged: (value) {
                                              _audioPlayer.seek(Duration(
                                                  milliseconds: value.round()));
                                            },
                                          ),
                                          Text(
                                            '${positionToString(position)} / ${positionToString(duration)}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          )
                        else
                          Center(
                              child:
                                  Text('No hay material de audio disponible.')),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isSeen)
                          Text(
                            'VISTO',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        SizedBox(width: 8),
                        FloatingActionButton(
                          onPressed: _isSeen ? null : _markAsSeen,
                          child: Icon(Icons.check),
                          backgroundColor: _isSeen ? Colors.grey : Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String positionToString(Duration position) {
    final minutes = position.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = position.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MaterialEscolarPage extends StatefulWidget {
  final String temaId;

  MaterialEscolarPage({
    required this.temaId,
  });

  @override
  _MaterialEscolarPageState createState() => _MaterialEscolarPageState();
}

class _MaterialEscolarPageState extends State<MaterialEscolarPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late AudioPlayer _audioPlayer;
  late Future<void> _initializeAudioPlayer;
  ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);
  bool _isLoading = true;
  bool _hasVideo = false;
  bool _hasAudio = false;
  bool _isSeen = false; // Variable para controlar si el tema ha sido visto

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _fetchData();
    _checkIfSeen(); // Verifica si el tema ya ha sido visto
  }

  Future<void> _fetchData() async {
    try {
      DocumentSnapshot temaSnapshot = await FirebaseFirestore.instance
          .collection('temas')
          .doc(widget.temaId)
          .get();

      Map<String, dynamic> data = temaSnapshot.data() as Map<String, dynamic>;
      String? urlDelVideo = data['video'];
      String? urlDeRecording = data['audio'];

      if (urlDelVideo != null && urlDelVideo.isNotEmpty) {
        _initializeVideo(urlDelVideo);
        _hasVideo = true;
      } else {
        setState(() {
          _isLoading = false;
        });
      }

      if (urlDeRecording != null && urlDeRecording.isNotEmpty) {
        _initializeAudio(urlDeRecording);
        _hasAudio = true;
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: false,
          looping: false,
          aspectRatio: _videoPlayerController.value.aspectRatio,
        );
        setState(() {
          _isLoading = false;
        });
      });
  }

  void _initializeAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  Future<void> _markAsSeen() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text('¿Ya viste todo el material propuesto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
        await FirebaseFirestore.instance.collection('MaterialVisto').add({
          'temaId': widget.temaId,
          'userId': userId,
          'esVisto': true,
        });
        setState(() {
          _isSeen = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Material marcado como visto.'),
        ));
      } catch (e) {
        print("Error marcando como visto: $e");
      }
    }
  }

  Future<void> _checkIfSeen() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('MaterialVisto')
          .where('temaId', isEqualTo: widget.temaId)
          .where('userId', isEqualTo: userId)
          .where('esVisto', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _isSeen = true;
        });
      }
    } catch (e) {
      print("Error checking if seen: $e");
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
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
        title: Text('Material Escolar'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_hasVideo && _chewieController != null)
                          SizedBox(
                            height: 300,
                            child: Chewie(controller: _chewieController!),
                          )
                        else if (!_hasVideo)
                          Center(
                              child:
                                  Text('No hay material de video disponible.')),
                        SizedBox(
                            height:
                                32), // Espacio adicional entre video y audio
                        if (_hasAudio)
                          Column(
                            children: [
                              ValueListenableBuilder<bool>(
                                valueListenable: _isPlaying,
                                builder: (context, isPlaying, child) {
                                  return ElevatedButton(
                                    onPressed: _toggleAudioPlayback,
                                    child: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 16),
                              StreamBuilder<Duration?>(
                                stream: _audioPlayer.durationStream,
                                builder: (context, snapshot) {
                                  final duration =
                                      snapshot.data ?? Duration.zero;
                                  return StreamBuilder<Duration>(
                                    stream: _audioPlayer.positionStream,
                                    builder: (context, snapshot) {
                                      var position =
                                          snapshot.data ?? Duration.zero;
                                      if (position > duration) {
                                        position = duration;
                                      }
                                      return Column(
                                        children: [
                                          Slider(
                                            min: 0.0,
                                            max: duration.inMilliseconds
                                                .toDouble(),
                                            value: position.inMilliseconds
                                                .toDouble(),
                                            onChanged: (value) {
                                              _audioPlayer.seek(Duration(
                                                  milliseconds: value.round()));
                                            },
                                          ),
                                          Text(
                                            '${positionToString(position)} / ${positionToString(duration)}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          )
                        else
                          Center(
                              child:
                                  Text('No hay material de audio disponible.')),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isSeen)
                          Text(
                            'VISTO',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        SizedBox(width: 8),
                        FloatingActionButton(
                          onPressed: _isSeen ? null : _markAsSeen,
                          child: Icon(Icons.check),
                          backgroundColor: _isSeen ? Colors.grey : Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String positionToString(Duration position) {
    final minutes = position.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = position.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
