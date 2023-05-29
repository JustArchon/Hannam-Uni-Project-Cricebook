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

        // 좌측 아이콘 버튼
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_outlined),
        ),
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
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
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
                        snapshot.data!['reputationscore'] > 90 ? Colors.purple : snapshot.data!['reputationscore'] > 60 ? Colors.blue : snapshot.data!['reputationscore'] > 30 ? Colors.green : snapshot.data!['reputationscore'] > 10 ? Colors.yellow : Colors.red,
                        snapshot.data!['reputationscore'] > 90 ? Colors.purple : snapshot.data!['reputationscore'] > 60 ? Colors.blue : snapshot.data!['reputationscore'] > 30 ? Colors.green : snapshot.data!['reputationscore'] > 10 ? Colors.yellow : Colors.red
                          ],
                        ),
                        borderRadius: BorderRadius.circular(500),
                        ),
                        child:
                        CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("assets/icons/usericon.png"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        '${snapshot.data!['reputationscore']}점',
                        style: const TextStyle(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  '닉네임 : ',
                                  style: TextStyle(
                                    fontFamily: "Ssurround",
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  snapshot.data!['userName'],
                                  style: const TextStyle(
                                    fontFamily: "Ssurround",
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),

                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: const Color(0xff6DC4DB),
                                  iconSize: 25.0,
                                  onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                         return AlertDialog(
                                          title: const Text('닉네임 변경'),
                                          content: TextField(
                                          decoration: const InputDecoration(hintText: "변경할 닉네임을 입력하세요."),
                                          onChanged: (value) {
                                            Newname = value;
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('확인'),
                                            onPressed: () {
                                              if(Newname == ''){
                                                Navigator.pop(context);
                                              }else{
                                                FirebaseFirestore
                                                .instance
                                                .collection(
                                                    'users')
                                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                                .update({
                                                "userName":
                                                    Newname,
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
                                    }
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '완주 횟수 : ${snapshot.data!["readingbookcount"].toString()}회',
                                  style: const TextStyle(
                                    fontFamily: "Ssurround",
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  ' | 그룹장 역임횟수 : ${snapshot.data!["groupleadercount"].toString()}회',
                                  style: const TextStyle(
                                    fontFamily: "Ssurround",
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                child: Text(
                                  '개인소개 : ${snapshot.data!["selfintroduction"]}',
                                  style: const TextStyle(
                                    fontFamily: "Ssurround",
                                    fontSize: 20,
                                    color: Colors.black,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: const Color(0xff6DC4DB),
                                  iconSize: 25.0,
                                  onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                         return AlertDialog(
                                          title: const Text('자기소개 글 변경'),
                                          content: TextField(
                                          decoration: const InputDecoration(hintText: "변경할 자기소개 글을 입력하세요."),
                                          onChanged: (value) {
                                            Newintroduce = value;
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('확인'),
                                            onPressed: () {
                                              if(Newintroduce == ''){
                                                Navigator.pop(context);
                                              }else{
                                                FirebaseFirestore
                                                .instance
                                                .collection(
                                                    'users')
                                                .doc(FirebaseAuth.instance.currentUser?.uid)
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
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                                  '독서 완료 책',
                                  style: TextStyle(
                                    fontFamily: "Ssurround",
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                      '업적 리스트',
                                      style: TextStyle(
                                        fontFamily: "Ssurround",
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                  icon: const Icon(Icons.sync),
                                  color: const Color(0xff6DC4DB),
                                  iconSize: 25.0,
                                  onPressed: () {}
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
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
