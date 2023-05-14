import 'package:circle_book/widgets/chat_bubble.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget{
  const Messages({Key? key, required this.id, required this.title, required this.thumb, required this.groupId, required this.groupname}) : super(key: key);
  final String id, title, thumb;
  final String groupId;
  final String groupname;

  @override
  Widget build(BuildContext context){
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('groups').doc(groupname).collection('GroupChats')
      .orderBy('time', descending: true)
      .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(), 
          );
        }
        final chatDocs = snapshot.data!.docs;
        
        return ListView.builder(
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
            return ChatBubbles(
              chatDocs[index]['text'],
              chatDocs[index]['userID'].toString() == user!.uid,
              chatDocs[index]['userID'],
            );
          },
        );
      },
    );
  }
}