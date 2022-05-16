import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser!;

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final chatDocs = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (context, index) => MessageBubble(
            message: (chatDocs[index].data() as dynamic)['text'],
            userName: (chatDocs[index].data() as dynamic)['username'],
            isMe: (chatDocs[index].data() as dynamic)['userId'] == user.uid,
          ),
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
