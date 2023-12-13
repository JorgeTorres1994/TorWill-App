/*import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Cuestionario_Estudiante_Screen/CuestionarioEstudianteScreen.dart';
import 'package:video_player/video_player.dart';

class MaterialEscolarPage extends StatefulWidget {
  final String temaId;
  final String urlDelVideo;
  final String urlDeRecording;

  MaterialEscolarPage({
    required this.temaId,
    required this.urlDelVideo,
    required this.urlDeRecording,
  });

  @override
  _MaterialEscolarPageState createState() => _MaterialEscolarPageState();
}

class _MaterialEscolarPageState extends State<MaterialEscolarPage> {
  late VideoPlayerController _videoController;
  late AssetsAudioPlayer _audioPlayer;
  double videoHeight = 300.0;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.urlDelVideo)
      ..initialize().then((_) {
        setState(() {});
      });
    _audioPlayer = AssetsAudioPlayer();
    _audioPlayer.open(Audio.network(widget.urlDeRecording), autoStart: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Escolar'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _videoController.setVolume(0);
            _videoController.pause();
            _audioPlayer.stop();
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    CuestionarioEstudianteScreen(temaId: widget.temaId),
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: videoHeight,
              child: _videoController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _playPauseAudio,
              child: Text(_audioPlayer.isPlaying.value
                  ? 'Pausar Grabación'
                  : 'Reproducir Grabación'),
            ),
            // ... cualquier otro contenido de tu página
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.zoom_out),
              onPressed: () {
                setState(() {
                  videoHeight =
                      videoHeight > 100.0 ? videoHeight - 20.0 : 100.0;
                });
              },
            ),
            IconButton(
              icon: Icon(
                _videoController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
              onPressed: _playPauseVideo,
            ),
            IconButton(
              icon: Icon(Icons.zoom_in),
              onPressed: () {
                setState(() {
                  videoHeight += 20.0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _playPauseVideo() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        // Ensure the video is played immediately when the widget is built.
        if (!_videoController.value.isInitialized) {
          _videoController.initialize().then((_) {
            _videoController.play();
          });
        } else {
          _videoController.play();
        }
      }
    });
  }

  void _playPauseAudio() {
    if (_audioPlayer.isPlaying.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {}); // Update the UI based on audio player state.
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
*/

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:nueva_app_web_matematicas/ESTUDIANTES/Cuestionario_Estudiante_Screen/CuestionarioEstudianteScreen.dart';
import 'package:video_player/video_player.dart';

class MaterialEscolarPage extends StatefulWidget {
  final String temaId;
  final String urlDelVideo;
  final String urlDeRecording;

  MaterialEscolarPage({
    required this.temaId,
    required this.urlDelVideo,
    required this.urlDeRecording,
  });

  @override
  _MaterialEscolarPageState createState() => _MaterialEscolarPageState();
}

class _MaterialEscolarPageState extends State<MaterialEscolarPage> {
  late VideoPlayerController _videoController;
  late AssetsAudioPlayer _audioPlayer;
  double videoHeight = 300.0;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.urlDelVideo)
      ..initialize().then((_) {
        setState(() {});
      });
    _audioPlayer = AssetsAudioPlayer();
    _audioPlayer.open(Audio.network(widget.urlDeRecording), autoStart: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Escolar'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _videoController.setVolume(0);
            _videoController.pause();
            _audioPlayer.stop();
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    CuestionarioEstudianteScreen(temaId: widget.temaId),
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: videoHeight,
              child: _videoController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _playPauseAudio,
              child: Text(_audioPlayer.isPlaying.value
                  ? 'Pausar Grabación'
                  : 'Reproducir Grabación'),
            ),
            // ... cualquier otro contenido de tu página
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.zoom_out),
              onPressed: () {
                setState(() {
                  videoHeight =
                      videoHeight > 100.0 ? videoHeight - 20.0 : 100.0;
                });
              },
            ),
            IconButton(
              icon: Icon(
                _videoController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
              onPressed: _playPauseVideo,
            ),
            IconButton(
              icon: Icon(Icons.zoom_in),
              onPressed: () {
                setState(() {
                  videoHeight += 20.0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _playPauseVideo() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        // Ensure the video is played immediately when the widget is built.
        if (!_videoController.value.isInitialized) {
          _videoController.initialize().then((_) {
            _videoController.play();
          });
        } else {
          _videoController.play();
        }
      }
    });
  }

  void _playPauseAudio() {
    if (_audioPlayer.isPlaying.value) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {}); // Update the UI based on audio player state.
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
