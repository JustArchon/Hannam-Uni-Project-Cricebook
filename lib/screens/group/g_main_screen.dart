import 'package:circle_book/functions/size_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:circle_book/widgets/drawer_widget.dart';

class GroupMainScreen extends StatefulWidget {
  final String id, title, thumb;
  final String groupId;

  const GroupMainScreen({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
    required this.groupId, required String author, required String pubDate, required String categoryName, required String publisher,
  });

  @override
  State<GroupMainScreen> createState() => _GroupMainScreenState();
}

class _GroupMainScreenState extends State<GroupMainScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool isNoticeScreen = true;

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
                style: TextStyle(
                  fontSize: widthSizeMax(24, screenWidth),
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

              //int vp = groupData['readingStatusVerificationPeriod'];
              //int dc = groupData['discussionCount'];
              //int rp = groupData['readingPeriod'];
              String nt = groupData['notice'];
              int mm = groupData['maxMembers'];
              int mc = groupData['groupMembersCount'];
              List<dynamic>? gm = groupData['groupMembers'];
              String gl = groupData['groupLeader'];

              return Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                  ),
                  Container(
                    width: widthSizeMax(500, screenWidth),
                    padding:
                        const EdgeInsets.only(top: 30, right: 30, left: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: widget.id,
                              child: Container(
                                width: widthSizeMax(160, screenWidth),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 15,
                                      offset: const Offset(10, 10),
                                      color: Colors.black.withOpacity(0.1),
                                    )
                                  ],
                                ),
                                child: Image.network(
                                  widget.thumb,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: widthSizeMax(20, screenWidth),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: widthSizeMax(220, screenWidth),
                                  height: heightSizeMax(50, screenHeight),
                                  child: Text(
                                    widget.title,
                                    style: TextStyle(
                                        fontSize: widthSizeMax(20, screenWidth),
                                        fontFamily: "Ssurround",
                                        letterSpacing: 1.0,
                                        color: const Color(0xff6DC4DB)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "세이노",
                                  style: TextStyle(
                                      fontSize: widthSizeMax(20, screenWidth),
                                      fontFamily: "Ssurround",
                                      letterSpacing: 1.0,
                                      color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "ISBN ",
                                      style: TextStyle(
                                        fontSize: widthSizeMax(20, screenWidth),
                                        fontFamily: "Ssurround",
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      widget.id,
                                      style: TextStyle(
                                        fontSize: widthSizeMax(15, screenWidth),
                                        fontFamily: "SsurroundAir",
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "출판사 ",
                                      style: TextStyle(
                                        fontSize: widthSizeMax(20, screenWidth),
                                        fontFamily: "Ssurround",
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "데이원",
                                      style: TextStyle(
                                        fontSize: widthSizeMax(15, screenWidth),
                                        fontFamily: "SsurroundAir",
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "출판일자 ",
                                      style: TextStyle(
                                        fontSize: widthSizeMax(20, screenWidth),
                                        fontFamily: "Ssurround",
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "2023. 03. 02",
                                      style: TextStyle(
                                        fontSize: widthSizeMax(15, screenWidth),
                                        fontFamily: "SsurroundAir",
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "카테고리",
                                  style: TextStyle(
                                    fontSize: widthSizeMax(20, screenWidth),
                                    fontFamily: "Ssurround",
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "자기계발",
                                  style: TextStyle(
                                    fontSize: widthSizeMax(15, screenWidth),
                                    fontFamily: "SsurroundAir",
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "기간 ",
                                      style: TextStyle(
                                        fontSize: widthSizeMax(20, screenWidth),
                                        fontFamily: "Ssurround",
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "2023. 05. 07. (일) ~ 2023. 05. 22. (월)",
                                      style: TextStyle(
                                        fontSize: widthSizeMax(15, screenWidth),
                                        fontFamily: "SsurroundAir",
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "그룹장 ",
                                              style: TextStyle(
                                                fontSize: widthSizeMax(
                                                    20, screenWidth),
                                                fontFamily: "Ssurround",
                                                letterSpacing: 1.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            FutureBuilder<DocumentSnapshot>(
                                              future: FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(gl)
                                                  .get(),
                                              builder: (context, userSnapshot) {
                                                if (userSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }

                                                if (!userSnapshot.hasData) {
                                                  return const Text('Error');
                                                }

                                                // 그룹장의 닉네임 출력
                                                String groupLeaderName =
                                                    userSnapshot.data![
                                                            'userName'] ??
                                                        '';
                                                return Text(
                                                  groupLeaderName,
                                                  style: TextStyle(
                                                    fontSize: widthSizeMax(
                                                        15, screenWidth),
                                                    fontFamily: "SsurroundAir",
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1.0,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "그룹 인원 ",
                                              style: TextStyle(
                                                fontSize: widthSizeMax(
                                                    20, screenWidth),
                                                fontFamily: "Ssurround",
                                                letterSpacing: 1.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "$mc / $mm",
                                              style: TextStyle(
                                                fontSize: widthSizeMax(
                                                    15, screenWidth),
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: widthSizeMax(500, screenWidth),
                    padding:
                        const EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 2,
                          width: widthSizeMax(400, screenWidth),
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isNoticeScreen = true;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        '공지사항',
                                        style: TextStyle(
                                            fontSize:
                                                widthSizeMax(25, screenWidth),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Ssurround",
                                            color: isNoticeScreen
                                                ? const Color(0xff6DC4DB)
                                                : Colors.black),
                                      ),
                                      if (isNoticeScreen)
                                        Container(
                                          height: 2,
                                          width: widthSizeMax(100, screenWidth),
                                          color: const Color(0xff6DC4DB),
                                        )
                                      else
                                        Container(
                                          height: 2,
                                          width: widthSizeMax(100, screenWidth),
                                          color: Colors.black,
                                        ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isNoticeScreen = false;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        '토론',
                                        style: TextStyle(
                                            fontSize:
                                                widthSizeMax(25, screenWidth),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Ssurround",
                                            color: !isNoticeScreen
                                                ? const Color(0xff6DC4DB)
                                                : Colors.black),
                                      ),
                                      if (!isNoticeScreen)
                                        Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          height: 2,
                                          width: widthSizeMax(100, screenWidth),
                                          color: const Color(0xff6DC4DB),
                                        )
                                      else
                                        Container(
                                          height: 2,
                                          width: widthSizeMax(100, screenWidth),
                                          color: Colors.black,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          nt,
                          style: TextStyle(
                            fontSize: widthSizeMax(20, screenWidth),
                            fontFamily: "SsurroundAir",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          "그룹원 닉네임",
                          style: TextStyle(
                            fontSize: widthSizeMax(20, screenWidth),
                            fontFamily: "SsurroundAir",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // 그룹 내 공지사항 데이터 가져올 예정
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: gm?.map((memberUid) {
                                return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(memberUid)
                                      .get(),
                                  builder: (context, userSnapshot) {
                                    if (userSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (userSnapshot.hasData) {
                                      Map<String, dynamic>? userData =
                                          userSnapshot.data!.data();
                                      String? userName = userData?['userName'];
                                      return Text(
                                        '$userName / ',
                                        style: TextStyle(
                                          fontSize:
                                              widthSizeMax(15, screenWidth),
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }

                                    return const Text('Error');
                                  },
                                );
                              }).toList() ??
                              [],
                        ),
                      ],
                    ),
                  )
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
      drawer: Drawerwidget(widget.groupId)
    );
  }
}
