import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupBoardScreen extends StatefulWidget {
  final String title, groupId;

  const GroupBoardScreen({
    super.key,
    required this.title,
    required this.groupId,
  });

  @override
  State<GroupBoardScreen> createState() => _GroupBoardScreenState();
}

class _GroupBoardScreenState extends State<GroupBoardScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<DocumentSnapshot> _getGroupData() async {
    return await FirebaseFirestore.instance
        .collection('groups')
        .where('groupId', isEqualTo: widget.groupId)
        .limit(1)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size > 0) {
        return querySnapshot.docs[0];
      } else {
        throw Exception('그룹을 찾을 수 없습니다.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: FutureBuilder(
          future: _getGroupData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('...');
            }
            if (snapshot.hasData) {
              //String groupName = snapshot.data!['groupName'];
              return Text(
                snapshot.data!['groupName'],
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: "Ssurround",
                  letterSpacing: 1.0,
                ),
              );
            }
            return const Text('데이터를 불러오지 못했습니다.');
          },
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: const Color(0xff6DC4DB),
        foregroundColor: Colors.white,
        actions: <Widget>[
          // 그룹 방 내 상단 메뉴 버튼 예정
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              //print('Group menu button is clicked');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getGroupData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            Map<String, dynamic>? groupData =
                snapshot.data!.data() as Map<String, dynamic>?;

            if (groupData != null) {
              // groupData에서 필요한 정보를 추출하여 사용

              int vp = groupData['readingStatusVerificationPeriod'];
              int dc = groupData['discussionCount'];
              int rp = groupData['readingPeriod'];
              int mm = groupData['maxMembers'];
              int mc = groupData['groupMembersCount'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                          top: 10,
                          bottom: 10,
                        ),
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          color: Colors.lightGreen,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "도서명 : ${widget.title}",
                              style: const TextStyle(fontSize: 20),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            // 그룹 내 데이터 가져올 예정
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "그룹 인원 ($mc / $mm)",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 80,
                                ),
                                Text(
                                  "토론 횟수 (0 / $dc)",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "독서 기간 (0 / $rp)",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 80,
                                ),
                                Text(
                                  "인증 기간 (0 / $vp)",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                          top: 50,
                          bottom: 50,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: Colors.blue[100],
                                padding: const EdgeInsets.only(
                                  left: 50,
                                  right: 50,
                                  top: 30,
                                  bottom: 30,
                                ),
                              ),
                              child: const Text(
                                "[ 그룹 채팅방 ]",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: Colors.purple[100],
                                padding: const EdgeInsets.only(
                                  left: 50,
                                  right: 50,
                                  top: 30,
                                  bottom: 30,
                                ),
                              ),
                              child: const Text(
                                "[ 토론 채팅방 ]",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: Colors.orange[100],
                                padding: const EdgeInsets.only(
                                  left: 50,
                                  right: 50,
                                  top: 30,
                                  bottom: 30,
                                ),
                              ),
                              child: const Text(
                                "[ 인증 게시판 ]",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: Colors.yellow[100],
                                padding: const EdgeInsets.only(
                                  left: 50,
                                  right: 50,
                                  top: 30,
                                  bottom: 30,
                                ),
                              ),
                              child: const Text(
                                "[ 독후감 게시판 ]",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
              // ...
            }
          }

          return const Center(
            child: Text('데이터를 불러올 수 없습니다.'),
          );
        },
      ),
    );
  }
}
