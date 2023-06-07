import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyinformationScreen extends StatelessWidget {
  const MyinformationScreen({super.key});

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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage("assets/icons/usericon.png"),
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
                              GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('비밀번호 변경'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text("최소 6자리 이상을 입력하십시오."),
                                            TextField(
                                              decoration: const InputDecoration(
                                                  hintText: "변경할 비밀번호를 입력하세요."),
                                              onChanged: (value) {
                                                newPassword = value;
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('확인'),
                                            onPressed: () async {
                                              if (newPassword == '') {
                                                Navigator.pop(context);
                                              } else {
                                                try {
                                                  await user!.updatePassword(
                                                      newPassword);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          '정상적으로 비밀번호가 변경되었습니다.'),
                                                      backgroundColor:
                                                          Colors.blue,
                                                    ),
                                                  );
                                                  Navigator.pop(context);
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          '비밀번호 변경 실패: $e'),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                  Navigator.pop(context);
                                                }
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('취소'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Row(
                                children: [
                                  Text("비밀번호 변경",
                                      style: TextStyle(
                                          fontFamily: "Ssurround",
                                          fontSize: 18,
                                          color: Colors.black)),
                                  SizedBox(
                                    width: 220,
                                  ),
                                  Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            ),
                            ]));
                  })));
  }
}