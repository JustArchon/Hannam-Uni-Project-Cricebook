import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.isMe, {Key? key}) : super(key: key);

    final String message;
    final bool isMe;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(), 
          );
        }else{
        return Stack(
          children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (isMe)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 45, 0),
                  child: ChatBubble(
                    clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 20),
                    backGroundColor: const Color(0xff6DC4DB),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!['userName'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            message,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.fromLTRB(45, 10, 0, 0),
                  child: ChatBubble(
                    clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
                    backGroundColor: Color(0xffE7E7ED),
                    margin: EdgeInsets.only(top: 20),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            isMe ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!['userName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            message,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
          Positioned(
            top : 0,
            right: isMe ? 5 : null,
            left: isMe ? null : 5,
            child: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data!['UserProfileImage']),
            ),
            )
          ]
        );
        }
      }
    );
  }
}