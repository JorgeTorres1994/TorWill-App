/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MensajeriaInterna extends StatefulWidget {
  MensajeriaInterna({Key? key}) : super(key: key);

  @override
  _MensajeriaInternaState createState() => _MensajeriaInternaState();
}

class _MensajeriaInternaState extends State<MensajeriaInterna> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage(
      String messageText, String senderId, String displayName) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    bool isAdmin = userData['isAdmin'] ?? false;

    if (!isAdmin) {
      // Busca el profesor
      QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('isAdmin', isEqualTo: true)
          .get();

      if (adminSnapshot.docs.isEmpty) {
        print('No se encontró ningún profesor.');
        return;
      }

      var professorDoc = adminSnapshot.docs.first;
      Map<String, dynamic> professorData =
          professorDoc.data() as Map<String, dynamic>;
      FirebaseFirestore.instance.collection('messages').add({
        'text': messageText,
        'sender_id': senderId,
        'recipient_id': professorData['user_id'], // ID del profesor
        'timestamp': FieldValue.serverTimestamp(),
        'display_name': displayName,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("Mensajería Interna")),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('recipient_id', isEqualTo: currentUser?.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((document) {
                    Map<String, dynamic> messageData =
                        document.data() as Map<String, dynamic>;
                    bool isMe = messageData['sender_id'] == currentUser?.uid;
                    return ListTile(
                      title: Text(messageData['display_name']),
                      subtitle: Text(messageData['text']),
                      trailing: isMe ? Icon(Icons.check) : null,
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
                      sendMessage(_messageController.text, currentUser.uid,
                          currentUser.displayName ?? 'Unknown');
                      _messageController.clear();
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MensajeriaInterna extends StatefulWidget {
  @override
  _MensajeriaInternaState createState() => _MensajeriaInternaState();
}

class _MensajeriaInternaState extends State<MensajeriaInterna> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _firestore.collection('messages').add({
        'text': _controller.text,
        'date': DateTime.now().millisecondsSinceEpoch,
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Interno'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream:
                  _firestore.collection('messages').orderBy('date').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(snapshot.data!.docs[index]['text']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ),
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
        ],
      ),
    );
  }
}
