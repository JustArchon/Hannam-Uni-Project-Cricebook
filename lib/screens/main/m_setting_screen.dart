import 'package:circle_book/screens/login_page.dart';
import 'package:circle_book/screens/main/settings/s_myinformation_screen.dart';
import 'package:circle_book/screens/main/settings/s_report_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                              /*
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationScreen(),
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
                              */
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
                                                  /*await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid)
                                                      .delete();
                                                      */
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
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '공지사항',
                                              style: TextStyle(
                                                fontSize: 18,
                                                letterSpacing: 1.0,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '써킅톡이 런칭되었습니다.',
                                              style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.0,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '모두 매너있는 독서를 하시길 기원합니다.',
                                              style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.0,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                                },
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
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '이용약관 및 정책',
                                              style: TextStyle(
                                                fontSize: 18,
                                                letterSpacing: 1.0,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '여러분을 환영합니다. 써클톡 서비스 및 제품(이하 ‘서비스’)을 이용해 주셔서 감사합니다.',
                                              style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.0,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '본 약관은 다양한 써클톡 서비스의 이용과 관련하여 써클톡 서비스를 제공하는 써클톡 주식회사(이하 ‘써클톡’)와 이를 이용하는 써클톡 서비스 회원(이하 ‘회원’) 또는 비회원과의 관계를 설명하며,',
                                              style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.0,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '써클톡 서비스 및 제품(이하 ‘서비스’)을 이용해 주셔서 감사합니다.  아울러 여러분의 써클톡 서비스 이용에 도움이 될 수 있는 유익한 정보를 포함하고 있습니다.',
                                              style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.0,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '써클톡 서비스를 이용하시거나 써클톡 서비스 회원으로 가입하실 경우 여러분은 본 약관 및 관련 운영 정책을 확인하거나 동의하게 되므로, 잠시 시간을 내시어 주의 깊게 살펴봐 주시기 바랍니다.',
                                              style: TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.0,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                                },
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
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const LoginScreen()),
                                          (route) => false);
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
