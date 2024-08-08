/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage(String messageText, String senderId, String displayName) {
    FirebaseFirestore.instance.collection('messages').add({
      'text': messageText,
      'sender_id': senderId,
      'timestamp': FieldValue.serverTimestamp(),
      'display_name': displayName,
    });
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("Chat Grupal")),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((document) {
                    return ListTile(
                      title: Text(document['display_name']),
                      subtitle: Text(document['text']),
                      trailing: document['sender_id'] == currentUser?.uid ? Icon(Icons.check) : null,
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Escribe un mensaje...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty && currentUser != null) {
                      // Obtener display name desde la colección users
                      FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get().then((userDoc) {
                        if (userDoc.exists) {
                          sendMessage(_messageController.text, currentUser.uid, userDoc.data()?['display_name'] ?? 'Unknown');
                          _messageController.clear();
                        }
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatGrupal extends StatefulWidget {
  ChatGrupal({Key? key}) : super(key: key);

  @override
  _ChatGrupalState createState() => _ChatGrupalState();
}

class _ChatGrupalState extends State<ChatGrupal> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage(String messageText, String senderId, String displayName) {
    FirebaseFirestore.instance.collection('chatGrupal').add({
      'text': messageText,
      'sender_id': senderId,
      'timestamp': FieldValue.serverTimestamp(),
      'display_name': displayName,
    });
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("Chat Grupal")),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatGrupal')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((document) {
                    bool isMe = document['sender_id'] == currentUser?.uid;
                    return Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: <Widget>[
                        if (!isMe)
                          CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/128/2995/2995657.png")),
                        Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                Text(document['display_name'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                document['text'],
                                style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Escribe un mensaje...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty &&
                        currentUser != null) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .get()
                          .then((userDoc) {
                        if (userDoc.exists) {
                          sendMessage(_messageController.text, currentUser.uid,
                              userDoc.data()?['display_name'] ?? 'Unknown');
                          _messageController.clear();
                        }
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
