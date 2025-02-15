import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/userProvider.dart';
import 'package:provider/provider.dart';

class ChatroomScreen extends StatefulWidget {
  String chatroomName;

  String chatroomId;

  ChatroomScreen(
      {super.key, required this.chatroomName, required this.chatroomId});

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  var db = FirebaseFirestore.instance;

  TextEditingController messageText = TextEditingController();
  Future<void> sendMessage() async {
    if (messageText.text.isEmpty) {
      return;
    }

    Map<String, dynamic> messageToSend = {
      "text": messageText.text,
      "sender_name": Provider.of<UserProvider>(context, listen: false).userName,
      "chatroom_id": widget.chatroomId,
      "timestamp": FieldValue.serverTimestamp()
    };

    await db.collection("messages").add(messageToSend);
    messageText.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatroomName),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: db
                .collection("messages")
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              var allMessages = snapshot.data?.docs ?? [];
              return ListView.builder(
                  reverse: true,
                  itemCount: allMessages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allMessages[index]["sender_name"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(allMessages[index]["text"]),
                          SizedBox(height: 8)
                        ],
                      ),
                    );
                  });
            },
          )),
          Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageText,
                    decoration: InputDecoration(
                        hintText: 'Write message here...',
                        border: InputBorder.none),
                  )),
                  InkWell(onTap: sendMessage, child: Icon(Icons.send))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
