import 'package:circle_book/screens/main/profiles/p_achievements_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../group/g_report_screen.dart';

class MainProfilePage extends StatefulWidget {
  final String uid, groupId;
  final bool mainOrGroupProfile;

  const MainProfilePage(
      {super.key,
      required this.uid,
      required this.mainOrGroupProfile,
      required this.groupId});

  @override
  State<MainProfilePage> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  String newIntroduce = '';

  @override
  Widget build(BuildContext context) {
    bool myProfile = true;
    if (widget.uid != FirebaseAuth.instance.currentUser?.uid) {
      myProfile = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 50,
            child: Image.asset('assets/icons/아이콘_흰색(512px).png'),
          ),
          centerTitle: true,
          elevation: 2,
          backgroundColor: const Color(0xff6DC4DB),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: widget.mainOrGroupProfile,
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                String profileIcon = snapshot.data!['profileIcon'];

                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 5,
                            color: snapshot.data!['reputationscore'] > 900
                                ? Colors.purple
                                : snapshot.data!['reputationscore'] > 600
                                    ? Colors.blue
                                    : snapshot.data!['reputationscore'] > 300
                                        ? Colors.green
                                        : snapshot.data!['reputationscore'] >
                                                100
                                            ? Colors.yellow
                                            : Colors.red,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/$profileIcon.png',
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
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
                            fontSize: 20,
                            color: Color(0xff6DC4DB),
                          ),
                          children: const <TextSpan>[
                            TextSpan(
                                text: ' 님',
                                style: TextStyle(
                                    fontFamily: "Ssurround",
                                    fontSize: 20,
                                    color: Colors.black))
                          ],
                        ),
                      ),
                      if (myProfile)
                        const Text(
                          "오늘도 좋은 하루가 되기를 바래요!",
                          style: TextStyle(
                            fontFamily: "Ssurround",
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                    'assets/icons/아이콘_상태표시바용(512px).png',
                                    width: 35,
                                    height: 35),
                                const SizedBox(width: 10),
                                const Text(
                                  '개인소개',
                                  style: TextStyle(
                                    fontFamily: "Ssurround",
                                    fontSize: 20,
                                    color: Color(0xff6DC4DB),
                                  ),
                                ),
                                if (myProfile)
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: const Color(0xff6DC4DB),
                                      iconSize: 20.0,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('개인소개 수정'),
                                                content: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "수정할 개인소개를 입력하세요."),
                                                  onChanged: (value) {
                                                    newIntroduce = value;
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('확인'),
                                                    onPressed: () {
                                                      if (newIntroduce == '') {
                                                        Navigator.pop(context);
                                                      } else {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                ?.uid)
                                                            .update({
                                                          "selfintroduction":
                                                              newIntroduce,
                                                        });
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
                                      }),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                        snapshot.data!["selfintroduction"],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                        ),
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
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 70,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff6DC4DB)),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  snapshot.data!["selfintroduction"],
                                  style: const TextStyle(
                                    fontFamily: "Ssurround",
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/icons/아이콘_상태표시바용(512px).png',
                                  width: 35,
                                  height: 35,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  '그룹 독서 정보',
                                  style: TextStyle(
                                    fontFamily: "Ssurround",
                                    fontSize: 20,
                                    color: Color(0xff6DC4DB),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.22,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xff6DC4DB)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '그룹 독서 완료',
                                            style: TextStyle(
                                              fontFamily: "Ssurround",
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "${snapshot.data!["readingbookcount"]}회",
                                            style: const TextStyle(
                                              fontFamily: "Ssurround",
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            '그룹장',
                                            style: TextStyle(
                                              fontFamily: "Ssurround",
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "${snapshot.data!["groupleadercount"]}회",
                                            style: const TextStyle(
                                              fontFamily: "Ssurround",
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        '업적',
                                        style: TextStyle(
                                          fontFamily: "Ssurround",
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "${snapshot.data!["complete_Achievements"].length}개",
                                        style: const TextStyle(
                                          fontFamily: "Ssurround",
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      if (myProfile)
                                        IconButton(
                                          icon: const Icon(Icons.list),
                                          color: const Color(0xff6DC4DB),
                                          iconSize: 25.0,
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AchievementsScreen(
                                                  snapshot.data!['userUID'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                  Expanded(
                                    child: GridView.count(
                                      crossAxisCount: 6,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 5,
                                      children: List.generate(
                                        snapshot.data!['mounted_Achievements']
                                            .length,
                                        (index) {
                                          return Image.asset(
                                              "${"assets/medals/" + snapshot.data!['mounted_Achievements'][index]}.png");
                                          /*Ink(
                                        decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                        color: const Color(0xff6DC4DB),
                                        width: 2,
                                      )),
                                      ),
                                        child: 
                                        );
                                        */
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        floatingActionButton: widget.mainOrGroupProfile
            ? !myProfile
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MemberReportScreen(
                                userId: widget.uid,
                                groupId: widget.groupId,
                              )));
                    },
                    backgroundColor: const Color(0xff6DC4DB),
                    child: const Icon(Icons.report))
                : null
            : null);
  }
}
