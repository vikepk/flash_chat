import 'package:flutter/material.dart';
import 'package:flash/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<MsgBubble> MsgBubbles = [];
final _firestore = FirebaseFirestore.instance;

final _auth = FirebaseAuth.instance;
late User loggedIn;

class ChatScreen extends StatefulWidget {
  static const String id = "/chat";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgcl = TextEditingController();

  late String msg;

  @override
  void initState() {
    super.initState();

    get();
  }

  Future<void> get() async {
    loggedIn = await _auth.currentUser!;
  }

  void getdocuments() async {
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("images/logo.png"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();

                Navigator.pop(context);
              }),
        ],
        title: Text(
          'Chat',
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamMsg(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgcl,
                      onChanged: (value) {
                        //Do something with the user input.
                        msg = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      msgcl.clear();
                      _firestore.collection('messages').add({
                        "Message": msg,
                        "sender": loggedIn.email,
                        "time": Timestamp.now()
                      });

                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MsgBubble extends StatelessWidget {
  late final text;
  late final user;
  bool isMe;
  MsgBubble({required this.text, required this.user, required this.isMe}) {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))
                : BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.zero,
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
            color: isMe ? Colors.lightBlue : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15, color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
          Text(user),
        ],
      ),
    );
  }
}

class StreamMsg extends StatelessWidget {
  final msgdocs =
      _firestore.collection("messages").orderBy('time', descending: false);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        //Stream gets the data from database continously as a stream as snapshots
        stream: msgdocs.snapshots(),
        //snapshot from the collection messages
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //condition when snapshot has data
            return Center(
              child: CircularProgressIndicator(backgroundColor: Colors.white),
            );
          }
          //Intially tries with for loop
          final currentuser = loggedIn.email;

          return Expanded(
            child: ListView(
              reverse: true,
              children: snapshot.data!.docs.reversed
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return MsgBubble(
                        text: data['Message'],
                        user: data['sender'],
                        isMe: currentuser == data['sender']);
                  })
                  .toList()
                  .cast(),
            ),
          );
        });
  }
}
