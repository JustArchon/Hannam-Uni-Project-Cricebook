import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

 Future<DocumentSnapshot> _getUsername() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((querySnapshot) {
        return querySnapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    String newPassword = '';
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: Image.asset('assets/icons/아이콘_흰색(512px).png'),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: const Color(0xff6DC4DB),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: _getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
              return Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage("assets/icons/usericon.png"),
                      ),
                      const SizedBox(
                        width: 225,
                      ),
                      Image.asset('assets/icons/아이콘_배경x(512px).png',width: 80, height: 80),
                    ],
                    ),
                     RichText(
                        text: TextSpan(
                          text: snapshot.data!['userName'],
                          style: const TextStyle(
                          fontFamily: "Ssurround",
                          fontSize: 18,
                          color: Color(0xff6DC4DB),
                          ),
                          children: const <TextSpan>[
                            TextSpan(text: ' 님', style: TextStyle(fontFamily: "Ssurround",
                          fontSize: 18, color: Colors.black))
                          ],
                          ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "알람 설정",
                        style: TextStyle(fontFamily: "Ssurround",
                          fontSize: 18, color: Colors.black
                      )
                    ),
                    const SizedBox(
                        height: 30,
                      ),
                    GestureDetector(
                      onTap: () {
                      },
                      child: const Row(
                        children: [
                          Text(
                              "비밀번호 변경",
                              style: TextStyle(fontFamily: "Ssurround",
                                fontSize: 18, color: Colors.black
                            )
                          ),
                          SizedBox(
                            width: 220,
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 30,
                      ),
                    
                  ]
                )
              );
          }
        )
      )
    );
  }
}
