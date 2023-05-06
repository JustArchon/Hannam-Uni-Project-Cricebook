import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMainScreen extends StatefulWidget {
  final String id, title, thumb;
  final String groupId;
  //final String gn, nt;
  //final int nm, gmc, dc, rp, cp;
  //final List<String> gmn;

  const GroupMainScreen({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
    required this.groupId,
    /*
    required this.gn,
    required this.nt,
    required this.nm,
    required this.gmc,
    required this.dc,
    required this.rp,
    required this.cp,
    required this.gmn,
    */
  });

  @override
  State<GroupMainScreen> createState() => _GroupMainScreenState();
}

class _GroupMainScreenState extends State<GroupMainScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<DocumentSnapshot> _getGroupData() async {
    return await FirebaseFirestore.instance
        .collection('CircleBookGroupList')
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
              return const Text('로딩중...');
            }
            if (snapshot.hasData) {
              String groupName = snapshot.data!['GroupName'];
              return Text(
                groupName,
                style: const TextStyle(
                  fontSize: 24,
                ),
              );
            }
            return const Text('데이터를 불러오지 못했습니다.');
          },
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
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

              int cp = groupData['certificationPeriod'];
              int dc = groupData['discussionCount'];
              int rp = groupData['readingPeriod'];
              String nt = groupData['notice'];
              int nm = groupData['numMembers'];
              int mc = groupData['GroupMembers'].length;
              return Column(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
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
                                  "그룹 인원 ($mc / $nm)",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 80,
                                ),
                                Text(
                                  "토론 횟수 (01 / $dc)",
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
                                  "독서 기간 (11 / $rp)",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 80,
                                ),
                                Text(
                                  "인증 기간 (02 / $cp)",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Hero(
                    tag: widget.id,
                    child: Container(
                      height: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            offset: const Offset(10, 10),
                            color: Colors.black.withOpacity(0.3),
                          )
                        ],
                      ),
                      child: Image.network(
                        widget.thumb,
                        height: 250,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "독서 목표 기간",
                    style: TextStyle(fontSize: 30),
                  ),
                  // 그룹 내 독서 목표 기간 데이터 가져올 예정
                  Text(
                    "2023-05-08 ~ 2023-05-${rp + 8}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "공지사항",
                    style: TextStyle(fontSize: 30),
                  ),
                  // 그룹 내 공지사항 데이터 가져올 예정
                  Text(
                    nt,
                    style: const TextStyle(fontSize: 20),
                  ),
                  // ... 다른 위젯들
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
