import 'package:circle_book/screens/main/main_books/mb_achievements_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainProfilePage extends StatefulWidget {
  const MainProfilePage({super.key});

  @override
  State<MainProfilePage> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  String Newname = '';
  String Newintroduce = '';
  @override
  Widget build(BuildContext context) {
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
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [
                            snapshot.data!['reputationscore'] > 90
                                ? Colors.purple
                                : snapshot.data!['reputationscore'] > 60
                                    ? Colors.blue
                                    : snapshot.data!['reputationscore'] > 30
                                        ? Colors.green
                                        : snapshot.data!['reputationscore'] > 10
                                            ? Colors.yellow
                                            : Colors.red,
                            snapshot.data!['reputationscore'] > 90
                                ? Colors.purple
                                : snapshot.data!['reputationscore'] > 60
                                    ? Colors.blue
                                    : snapshot.data!['reputationscore'] > 30
                                        ? Colors.green
                                        : snapshot.data!['reputationscore'] > 10
                                            ? Colors.yellow
                                            : Colors.red
                          ],
                        ),
                        borderRadius: BorderRadius.circular(500),
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage("assets/icons/usericon.png"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                          Newname = value;
                          },
                        ),
                          actions: [
                          TextButton(
                          child: const Text('확인'),
                          onPressed: () {
                          if (Newname == '') {
                          Navigator.pop(context);
                          } else {
                          FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth
                         .instance
                         .currentUser
                         ?.uid)
                        .update({
                        "userName": Newname,
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
                       },
                      child: RichText(
                        text: TextSpan(
                          text: snapshot.data!['userName'],
                          style: const TextStyle(
                          fontFamily: "Ssurround",
                          fontSize: 20,
                          color: Color(0xff6DC4DB),
                          ),
                          children: const <TextSpan>[
                            TextSpan(text: ' 님', style: TextStyle(fontFamily: "Ssurround",
                          fontSize: 20, color: Colors.black))
                          ],
                          ),
                      ),
                    ),
                    const Text(
                      "오늘도 좋은 하루가 되기를 바래요!",
                      style: TextStyle(
                        fontFamily: "Ssurround",
                        fontSize: 20,
                        color: Colors.black,
                        ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/아이콘_상태표시바용(512px).png',width: 35, height: 35),
                                const SizedBox(width: 5),
                                  const Text(
                                    '개인소개',
                                    style: TextStyle(
                                      fontFamily: "Ssurround",
                                      fontSize: 20,
                                      color: Color(0xff6DC4DB),
                                    ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('자기소개 글 변경'),
                                            content: TextField(
                                              decoration: const InputDecoration(
                                                  hintText:
                                                      "변경할 자기소개 글을 입력하세요."),
                                              onChanged: (value) {
                                                Newintroduce = value;
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text('확인'),
                                                onPressed: () {
                                                  if (Newintroduce == '') {
                                                    Navigator.pop(context);
                                                  } else {
                                                    FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .update({
                                                      "selfintroduction":
                                                          Newintroduce,
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
                              },
                              child: Text(
                                 snapshot.data!["selfintroduction"],
                                  style: const TextStyle(
                                        fontFamily: "Ssurround",
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/아이콘_상태표시바용(512px).png',width: 35, height: 35),
                                const SizedBox(width: 5),
                                  const Text(
                                    '완료한 독서 그룹',
                                    style: TextStyle(
                                      fontFamily: "Ssurround",
                                      fontSize: 20,
                                      color: Color(0xff6DC4DB),
                                    ),
                                ),
                                const SizedBox(
                                  width: 60,
                                ),
                                Text(
                                  "${"총 "+snapshot.data!["readingbookcount"].toString()}건 완료",
                                  style: const TextStyle(
                                      fontFamily: "Ssurround",
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  )
                              ]
                            ),
                            const SizedBox(
                              height: 5,
                            ),
    
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Image.asset('assets/icons/아이콘_상태표시바용(512px).png',width: 35, height: 35),
                                const SizedBox(width: 5),
                                  const Text(
                                    '업적',
                                    style: TextStyle(
                                      fontFamily: "Ssurround",
                                      fontSize: 20,
                                      color: Color(0xff6DC4DB),
                                    ),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.list),
                                    color: const Color(0xff6DC4DB),
                                    iconSize: 25.0,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    AchievementsScreen(
                                                                        snapshot
                                                                            .data!['userUID'])));
                                    }
                                ),
                                const SizedBox(
                                  width: 120,
                                ),
                                Text(
                                  "${"총 "+(snapshot.data!["complete_Achievements"].length).toString()}건 완료",
                                  style: const TextStyle(
                                      fontFamily: "Ssurround",
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  )
                              ],
                            ),
                              SizedBox(
                                height: 200,
                                child: GridView.count(
                                  crossAxisCount: 6,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 5,
                                  children: List.generate(
                                  snapshot.data!['mounted_Achievements'].length,
                                  (index){
                                      return Image.asset("${"assets/medal/"+snapshot.data!['mounted_Achievements'][index]}.png");
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
                                  }
                              )
                            ),
                          ),
                        ] // 이곳을 기점으로 위젯추가하면됩니다.
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
