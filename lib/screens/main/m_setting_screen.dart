import 'package:circle_book/screens/main/settings/s_report_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainSettingsScreen extends StatefulWidget {
  const MainSettingsScreen({super.key});

  @override
  State<MainSettingsScreen> createState() => _MainSettingsScreenState();
}

class _MainSettingsScreenState extends State<MainSettingsScreen> {
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
    String newName = '';
    String newPassword = '';
    User? user = FirebaseAuth.instance.currentUser;
    return WillPopScope(
      onWillPop: () {
        return Future(() => false); //뒤로가기 막음
      },
      child: Scaffold(
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
                    String profileIcon = snapshot.data!['profileIcon'];
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
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.17,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.17,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: const Color(0xff6DC4DB),
                                              width: 3),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/$profileIcon.png',
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
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
                                    ],
                                  ),
                                  Image.asset('assets/icons/아이콘_배경x(512px).png',
                                      width: 80, height: 80),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('닉네임 변경'),
                                          content: TextField(
                                            decoration: const InputDecoration(
                                                hintText: "변경할 닉네임을 입력하세요."),
                                            onChanged: (value) {
                                              newName = value;
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text('확인'),
                                              onPressed: () {
                                                if (newName == '') {
                                                  Navigator.pop(context);
                                                } else {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid)
                                                      .update({
                                                    "userName": newName,
                                                  });
                                                  Navigator.pop(context);
                                                  setState(() {});
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("닉네임 변경",
                                        style: TextStyle(
                                            fontFamily: "Ssurround",
                                            fontSize: 18,
                                            color: Colors.black)),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
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
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            "변경할 비밀번호를 입력하세요."),
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
                                                    ScaffoldMessenger.of(
                                                            context)
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
                                                    ScaffoldMessenger.of(
                                                            context)
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("비밀번호 변경",
                                        style: TextStyle(
                                            fontFamily: "Ssurround",
                                            fontSize: 18,
                                            color: Colors.black)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("공지사항",
                                        style: TextStyle(
                                            fontFamily: "Ssurround",
                                            fontSize: 18,
                                            color: Colors.black)),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const AppReportScreen()));
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("서비스 문의",
                                        style: TextStyle(
                                            fontFamily: "Ssurround",
                                            fontSize: 18,
                                            color: Colors.black)),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  {
                                    try {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('로그아웃 실패: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: const Color(0xff6DC4DB),
                                ),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: const Center(
                                    child: Text(
                                      "로그아웃",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "SsurroundAir",
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]));
                  }))),
    );
  }
}
