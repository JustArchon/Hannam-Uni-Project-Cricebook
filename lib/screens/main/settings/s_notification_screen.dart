import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<DocumentSnapshot> _getUsername() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((querySnapshot) {
      return querySnapshot;
    });
  }
    bool certalarm = true;
    bool bookreadstartendalarm = true;
    bool sharebookreportalarm = true;
  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
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
                                Image.asset('assets/icons/아이콘_배경x(512px).png',
                                    width: 80, height: 80),
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
                                  TextSpan(
                                      text: ' 님',
                                      style: TextStyle(
                                          fontFamily: "Ssurround",
                                          fontSize: 18,
                                          color: Colors.black))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text("알람 설정",
                                style: TextStyle(
                                    fontFamily: "Ssurround",
                                    fontSize: 18,
                                    color: Colors.black)),
                            const SizedBox(
                              height: 30,
                            ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("독서현황 인증 알림",
                                      style: TextStyle(
                                          fontFamily: "Ssurround",
                                          fontSize: 18,
                                          color: Colors.black)),
                                  Switch(
                                    value: certalarm,
                                    onChanged: (value) {
                                      setState(() {
                                        certalarm = value;
                                      });
                                    },
                                    activeColor: const Color(0xff6DC4DB),
                                  ),
                                ],
                              ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("그룹독서 시작 및 종료 알림",
                                      style: TextStyle(
                                          fontFamily: "Ssurround",
                                          fontSize: 18,
                                          color: Colors.black)),
                                  Switch(
                                    value: bookreadstartendalarm,
                                    onChanged: (value) {
                                      setState(() {
                                        bookreadstartendalarm = value;
                                      });
                                    },
                                    activeColor: const Color(0xff6DC4DB),
                                  ),
                                ],
                              ),
                          Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("독후감 공유 알림",
                                      style: TextStyle(
                                          fontFamily: "Ssurround",
                                          fontSize: 18,
                                          color: Colors.black)),
                                  Switch(
                                    value: sharebookreportalarm,
                                    onChanged: (value) {
                                      setState(() {
                                        sharebookreportalarm = value;
                                      });
                                    },
                                    activeColor: const Color(0xff6DC4DB),
                                  ),
                                ],
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                          ]));
                })));
  }
}
