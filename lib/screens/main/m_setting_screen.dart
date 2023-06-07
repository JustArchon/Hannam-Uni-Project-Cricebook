import 'package:circle_book/screens/main/settings/s_myinformation_screen.dart';
import 'package:circle_book/screens/main/settings/s_notification_screen.dart';
import 'package:circle_book/screens/main/settings/s_report_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// I"m trash.. of course JustArchon you fucking
class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({super.key});

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
                              const Text("서비스 설정",
                                  style: TextStyle(
                                      fontFamily: "Ssurround",
                                      fontSize: 18,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const MyinformationScreen()));
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("내 정보 관리",
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
                                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotificationScreen(),
                                ),
                              );
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("알림 설정",
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
                                          title: const Text('회원 탈퇴'),
                                          content: const Text(
                                              "정말로 서클북 회원을 탈퇴하시겠습니까? 탈퇴시 모든 정보가 사라집니다."),
                                          actions: [
                                            TextButton(
                                              child: const Text('확인'),
                                              onPressed: () async {
                                                try {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid)
                                                      .delete();
                                                  await user!.delete();
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          '정상적으로 회원탈퇴가 완료되었습니다.'),
                                                      backgroundColor:
                                                          Colors.blue,
                                                    ),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content:
                                                          Text('회원탈퇴 실패: $e'),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                  Navigator.pop(context);
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
                                    Text("회원탈퇴",
                                        style: TextStyle(
                                            fontFamily: "Ssurround",
                                            fontSize: 18,
                                            color: Colors.black)),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              const Text("서비스 안내",
                                  style: TextStyle(
                                      fontFamily: "Ssurround",
                                      fontSize: 18,
                                      color: Colors.black)),
                              const SizedBox(
                                height: 40,
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
                              GestureDetector(
                                onTap: () {},
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("버전 정보",
                                            style: TextStyle(
                                                fontFamily: "Ssurround",
                                                fontSize: 18,
                                                color: Colors.black)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("1.0.0",
                                            style: TextStyle(
                                                fontFamily: "Ssurround",
                                                fontSize: 18,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("최신버전입니다.",
                                            style: TextStyle(
                                                fontFamily: "Ssurround",
                                                fontSize: 18,
                                                color: Colors.grey)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
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
                                    Text("이용약관 및 정책",
                                        style: TextStyle(
                                            fontFamily: "Ssurround",
                                            fontSize: 18,
                                            color: Colors.black)),
                                    Icon(Icons.arrow_forward_ios)
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
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
                            ]
                      )
                  );
            }
          )
        )
      ),
    );
  }
}