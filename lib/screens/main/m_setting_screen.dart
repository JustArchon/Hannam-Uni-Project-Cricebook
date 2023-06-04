import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({super.key});

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
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
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
                        "서비스 설정",
                        style: TextStyle(fontFamily: "Ssurround",
                          fontSize: 18, color: Colors.black
                      )
                    ),
                    const SizedBox(
                        height: 30,
                      ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                              "내 정보 관리",
                              style: TextStyle(fontFamily: "Ssurround",
                                fontSize: 18, color: Colors.black
                            )
                          ),
                          SizedBox(
                            width: 250,
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 30,
                      ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                              "알림 설정",
                              style: TextStyle(fontFamily: "Ssurround",
                                fontSize: 18, color: Colors.black
                            )
                          ),
                          SizedBox(
                            width: 271,
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 30,
                      ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                              "회원탈퇴",
                              style: TextStyle(fontFamily: "Ssurround",
                                fontSize: 18, color: Colors.black
                            )
                          ),
                          SizedBox(
                            width: 275,
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 40,
                      ),
                    const Text(
                        "서비스 안내",
                        style: TextStyle(fontFamily: "Ssurround",
                          fontSize: 18, color: Colors.black
                      )
                    ),
                    const SizedBox(
                        height: 40,
                      ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                              "공지사항",
                              style: TextStyle(fontFamily: "Ssurround",
                                fontSize: 18, color: Colors.black
                            )
                          ),
                          SizedBox(
                            width: 275,
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 30,
                      ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                              "서비스 문의",
                              style: TextStyle(fontFamily: "Ssurround",
                                fontSize: 18, color: Colors.black
                            )
                          ),
                          SizedBox(
                            width: 250,
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 30,
                      ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                              "버전 정보",
                              style: TextStyle(fontFamily: "Ssurround",
                                fontSize: 18, color: Colors.black
                            )
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              "1.0.0",
                              style: TextStyle(fontFamily: "Ssurround",
                                fontSize: 18, color: Colors.grey
                            )
                          ),
                          SizedBox(
                            width: 88,
                          ),
                          Text(
                              "최신버전입니다.",
                              style: TextStyle(fontFamily: "Ssurround",
                                fontSize: 18, color: Colors.grey
                            )
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 30,
                      ),
                    GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Text(
                              "이용약관 및 정책",
                              style: TextStyle(fontFamily: "Ssurround",
                                fontSize: 18, color: Colors.black
                            )
                          ),
                          SizedBox(
                            width: 210,
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 10,
                      ),
                    ElevatedButton(
                      style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 156, vertical: 12),
                      ),
                    ),
                      onPressed: () async{
                         {
                      try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('로그아웃 실패: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
                      },
                      child: const Text('로그아웃')
                    )
                  ]
                )
              );
            }
          }
        )
      )
    );
  }
}
