import 'package:circle_book/screens/group/g_base_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainGroupScreen extends StatelessWidget {
  const MainGroupScreen({super.key});

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

        //toolbarHeight: 50,

        // 좌측 아이콘 버튼
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_outlined),
        ),

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_outlined), // 그룹 검색 아이콘 생성
            onPressed: () {
              // 아이콘 버튼 실행
              //print('Group search button is clicked');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings), // 그룹 설정 아이콘 생성
            onPressed: () {
              // 아이콘 버튼 실행
              //print('Group settings button is clicked');
            },
          ),
        ],
      ),

      // 참여중인 그룹들 리스트 출력
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10,
            ),
            groupListShow(2),
            const SizedBox(
              height: 10,
            ),
            groupListShow(1),
            const SizedBox(
              height: 10,
            ),
            groupListShow(3),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> groupListShow(int gsn) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .where('groupMembers',
              arrayContains: FirebaseAuth.instance.currentUser?.uid)
          .where('groupStatus', isEqualTo: gsn) // Groupstate가 1인 것만 검색
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            return Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: documents.map(
                (doc) {
                  String bt = doc['bookData'][2];
                  String gn = doc['groupName'];
                  String bn = doc['bookData'][1];
                  int mm = doc['maxMembers'];
                  int mc = doc['groupMembersCount'];
                  int rp = doc['readingPeriod'];
                  int vp = doc['readingStatusVerificationPeriod'];
                  int dc = doc['discussionCount'];
                  int gs = doc['groupStatus'];
                  String bi = doc['bookData'][0];
                  String gi = doc['groupId'];
                  Color? buttonColor;
                  String? gst;
                  switch (gs) {
                    case 1:
                      buttonColor = Colors.yellow[100];
                      gst = '준비 중';
                      break;
                    case 2:
                      buttonColor = Colors.green[100];
                      gst = '독서 중';
                      break;
                    case 3:
                      buttonColor = Colors.red[100];
                      gst = '완료';
                      break;
                    default:
                      buttonColor = Colors.grey;
                      break;
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupBaseScreen(
                              id: bi,
                              title: bn,
                              thumb: bt,
                              groupId: gi,
                            ),
                            fullscreenDialog: true, // 화면 생성 방식
                          ),
                        );
                        //print(gi);
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: buttonColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "[$gst]",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 80,
                                height: 80,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color(0xff6DC4DB),
                                ),
                                child: Image.network(
                                  bt,
                                  width: 20,
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 350,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 230,
                                      child: Text(
                                        "[$gn]",
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                    ),
                                    Text(
                                      "인원 ($mc/$mm)",
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 230,
                                        child: Text(
                                          "[$bn]",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Text(
                                        "토론 (0/$dc)",
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 170,
                                      child: Text(
                                        "[독서 기간] (0/$rp)",
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                    ),
                                    Text(
                                      "[인증 간격] (0/$vp)",
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            );
        }
      },
    );
  }
}
