/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({required this.studentUserId, required this.professorUserId});

  final String professorUserId;
  final String studentUserId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    var messageText = _messageController.text.trim();

    if (messageText.isNotEmpty) {
      var currentUser = await _getCurrentUser();

      _firestore
          .collection('mensajes')
          .doc(_generateChatId())
          .collection('chats')
          .add({
        'text': messageText,
        'sender': widget.studentUserId,
        'timestamp': FieldValue.serverTimestamp(),
        'user_info': {
          'displayName': currentUser.displayName,
          'gender': currentUser.gender,
        },
      });

      _messageController.clear();
    }
  }

  Future<UserInfo> _getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var userData = await _firestore.collection('users').doc(user.uid).get();
      return UserInfo(
        displayName: userData['display_name'],
        gender: userData['gender'],
      );
    } else {
      return UserInfo(displayName: '', gender: '');
    }
  }

  String _generateChatId() {
    var userIds = [widget.studentUserId, widget.professorUserId];
    userIds.sort();
    return userIds.join('_');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MENSAJERIA ACADEMICA'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('mensajes')
                  .doc(_generateChatId())
                  .collection('chats')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var messages = snapshot.data!.docs;

                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  var messageText = message['text'];
                  var messageSender = message['sender'];

                  var messageWidget = MessageWidget(
                    sender: messageSender,
                    text: messageText,
                    timestamp: message[
                        'timestamp'], // Asegúrate de que este campo exista en tu documento de mensaje
                  );

                  messageWidgets.add(messageWidget);
                }

                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;
  final Timestamp? timestamp; // Marcar como opcional

  MessageWidget({
    required this.sender,
    required this.text,
    this.timestamp, // Marcar como opcional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<UserInfo?>(
        future: _getUserInfo(sender),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error al cargar la información del usuario');
          } else if (snapshot.data == null || snapshot.data == false) {
            return Text('Usuario no encontrado');
          } else {
            var userInfo = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${userInfo.displayName}: $text'),
                SizedBox(height: 4),
                Image.asset(
                  userInfo.gender == 'Masculino'
                      ? 'images/chico.png'
                      : 'images/leyendo.png',
                  width: 60,
                  height: 60,
                ),
                if (timestamp != null) SizedBox(height: 4),
                Text(
                  _formatDateTime(timestamp!.toDate()),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<UserInfo?> _getUserInfo(String userId) async {
    var userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userData.exists) {
      return UserInfo(
        displayName: userData['display_name'],
        gender: userData['gender'],
      );
    } else {
      return null; // Manejar caso de usuario no existente
    }
  }

  String _formatDateTime(DateTime dateTime) {
    var formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }
}

class UserInfo {
  final String displayName;
  final String gender;

  UserInfo({required this.displayName, required this.gender});
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({required this.studentUserId, required this.professorUserId});

  final String professorUserId;
  final String studentUserId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    var messageText = _messageController.text.trim();

    if (messageText.isNotEmpty) {
      var currentUser = await _getCurrentUser();

      _firestore
          .collection('mensajes')
          .doc(_generateChatId())
          .collection('chats')
          .add({
        'text': messageText,
        'sender': widget.studentUserId,
        'timestamp': FieldValue.serverTimestamp(),
        'user_info': {
          'displayName': currentUser.displayName,
          'gender': currentUser.gender,
        },
      });

      _messageController.clear();
    }
  }

  Future<UserInfo> _getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var userData = await _firestore.collection('users').doc(user.uid).get();
      return UserInfo(
        displayName: userData['display_name'],
        gender: userData['gender'],
      );
    } else {
      return UserInfo(displayName: '', gender: '');
    }
  }

  String _generateChatId() {
    var userIds = [widget.studentUserId, widget.professorUserId];
    userIds.sort();
    return userIds.join('_');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MENSAJERIA ACADEMICA'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('mensajes')
                  .doc(_generateChatId())
                  .collection('chats')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var messages = snapshot.data!.docs;

                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  var messageText = message['text'];
                  var messageSender = message['sender'];

                  var messageWidget = MessageWidget(
                    sender: messageSender,
                    text: messageText,
                    timestamp: message[
                        'timestamp'], // Asegúrate de que este campo exista en tu documento de mensaje
                  );

                  messageWidgets.add(messageWidget);
                }

                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;
  final Timestamp? timestamp; // Marcar como opcional

  MessageWidget({
    required this.sender,
    required this.text,
    this.timestamp, // Marcar como opcional
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<UserInfo?>(
        future: _getUserInfo(sender),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error al cargar la información del usuario');
          } else if (snapshot.data == null || snapshot.data == false) {
            return Text('Usuario no encontrado');
          } else {
            var userInfo = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${userInfo.displayName}: $text'),
                SizedBox(height: 4),
                Image.asset(
                  userInfo.gender == 'Masculino'
                      ? 'images/chico.png'
                      : 'images/leyendo.png',
                  width: 60,
                  height: 60,
                ),
                if (timestamp != null) SizedBox(height: 4),
                Text(
                  _formatDateTime(timestamp!.toDate()),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<UserInfo?> _getUserInfo(String userId) async {
    var userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userData.exists) {
      return UserInfo(
        displayName: userData['display_name'],
        gender: userData['gender'],
      );
    } else {
      return null; // Manejar caso de usuario no existente
    }
  }

  String _formatDateTime(DateTime dateTime) {
    var formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }
}

class UserInfo {
  final String displayName;
  final String gender;

  UserInfo({required this.displayName, required this.gender});
}
