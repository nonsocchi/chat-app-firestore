import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(8.0),
          child: const Text('This works'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('chats/JZoNtTa3RaP2Qxqtd7Cj/messages')
                .snapshots()
                .listen((event) {
              event.docs.forEach((doc) {
                print(doc['text']);
              });
            });
          }),
    );
  }
}
