import 'package:circle_book/widgets/chat_messagebox_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:circle_book/widgets/chat_message_widget.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  const ChatScreen({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  Future<DocumentSnapshot> _getGroupData() async {
    return await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot;
      } else {
        throw Exception('그룹을 찾을 수 없습니다.');
      }
    });
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        //print(loggedUser!.email);
      }
    } catch (e) {
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: _getGroupData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('...');
            }
            if (snapshot.hasData) {
              return RichText(
                text: TextSpan(
                    text: snapshot.data!['groupName'],
                    style: const TextStyle(
                        fontFamily: "Ssurround",
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: 1.0),
                    children: const [
                      TextSpan(
                        text: ' 그룹 채팅방',
                        style: TextStyle(
                            fontFamily: "Ssurround",
                            fontSize: 24,
                            color: Colors.white,
                            letterSpacing: 1.0),
                      )
                    ]),
              );
            }
            return const Text('데이터를 불러오지 못했습니다.');
          },
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: const Color(0xff6DC4DB),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(
              groupId: widget.groupId,
            ),
          ),
          NewMessage(
            groupId: widget.groupId,
          ),
        ],
      ),
    );
  }
}
