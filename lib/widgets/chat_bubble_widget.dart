import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChatBubbles extends StatelessWidget {
  final String userId;
  final String message;
  final bool isMe;
  final String image;
  const ChatBubbles({
    Key? key,
    required this.userId,
    required this.message,
    required this.isMe,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Stack(children: [
              Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (isMe)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 45, 0),
                      child: ChatBubble(
                        clipper:
                            ChatBubbleClipper8(type: BubbleType.sendBubble),
                        alignment: Alignment.topRight,
                        margin: const EdgeInsets.only(top: 20),
                        backGroundColor: const Color(0xff6DC4DB),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!['userName'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              if(image != "noImage")  
                              Image.network(image, fit: BoxFit.contain),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                message,
                                style: const TextStyle(color: Colors.white),
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
                        clipper:
                            ChatBubbleClipper8(type: BubbleType.receiverBubble),
                        backGroundColor: const Color(0xffE7E7ED),
                        margin: const EdgeInsets.only(top: 20),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!['userName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                message,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
              Positioned(
                top: 0,
                right: isMe ? 5 : null,
                left: isMe ? null : 5,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset('assets/icons/usericon.png'),
                ),
              )
            ]);
          }
        });
  }
}
