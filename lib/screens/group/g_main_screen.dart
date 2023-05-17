import 'package:circle_book/widgets/drawer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMainScreen extends StatefulWidget {
  final String id,
      title,
      thumb,
      groupId,
      author,
      pubDate,
      categoryName,
      publisher;

  const GroupMainScreen({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
    required this.groupId,
    required this.author,
    required this.pubDate,
    required this.categoryName,
    required this.publisher,
  });

  @override
  State<GroupMainScreen> createState() => _GroupMainScreenState();
}

class _GroupMainScreenState extends State<GroupMainScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this, //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
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
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  snapshot.data!['groupName'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: "Ssurround",
                    letterSpacing: 1.0,
                  ),
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
            onPressed: () {},
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
              //int vp = groupData['readingStatusVerificationPeriod'];
              int rp = groupData['readingPeriod'];
              String nt = groupData['notice'];
              int mm = groupData['maxMembers'];
              int mc = groupData['groupMembersCount'];
              List<dynamic>? gm = groupData['groupMembers'];
              String gl = groupData['groupLeader'];

              return Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.only(top: 30, right: 30, left: 30),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Hero(
                                tag: widget.id,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 15,
                                        offset: const Offset(10, 10),
                                        color: Colors.black.withOpacity(0.2),
                                      )
                                    ],
                                  ),
                                  child: Image.network(
                                    widget.thumb,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height: 50,
                                        child: Text(
                                          widget.title,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Ssurround",
                                              letterSpacing: 1.0,
                                              color: Color(0xff6DC4DB)),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget.author,
                                        style: const TextStyle(
                                            fontSize: 20,
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
                                          const Text(
                                            "ISBN ",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Ssurround",
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            widget.id,
                                            style: const TextStyle(
                                              fontSize: 15,
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
                                          const Text(
                                            "출판사 ",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Ssurround",
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            widget.publisher,
                                            style: const TextStyle(
                                              fontSize: 15,
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
                                          const Text(
                                            "출판일자 ",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Ssurround",
                                              letterSpacing: 1.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            widget.pubDate,
                                            style: const TextStyle(
                                              fontSize: 15,
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
                                      const Text(
                                        "카테고리",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Ssurround",
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        widget.categoryName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "기간 ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Ssurround",
                                        letterSpacing: 1.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "2023. 05. 14 ~ 2023. 05. ${14 + rp}",
                                      style: const TextStyle(
                                        fontSize: 15,
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
                                            const Text(
                                              "그룹장 ",
                                              style: TextStyle(
                                                fontSize: 20,
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

                                                String groupLeaderName =
                                                    userSnapshot.data![
                                                            'userName'] ??
                                                        '';
                                                return Text(
                                                  groupLeaderName,
                                                  style: const TextStyle(
                                                    fontSize: 15,
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
                                            const Text(
                                              "그룹 인원 ",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "Ssurround",
                                                letterSpacing: 1.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "$mc / $mm",
                                              style: const TextStyle(
                                                fontSize: 15,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: const EdgeInsets.only(
                      top: 10,
                      right: 30,
                      left: 30,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: TabBar(
                            tabs: [
                              Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  '공지사항',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Ssurround",
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  '독서현황',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Ssurround",
                                  ),
                                ),
                              ),
                            ],
                            indicator: const BoxDecoration(
                              color: Color(0xff6DC4DB),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            controller: _tabController,
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      nt,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: "SsurroundAir",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    const Text(
                                      "그룹원 닉네임",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "SsurroundAir",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40,
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        children: gm?.map((memberUid) {
                                              return FutureBuilder(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(memberUid)
                                                    .get(),
                                                builder:
                                                    (context, userSnapshot) {
                                                  if (userSnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  }
                                                  if (userSnapshot.hasData) {
                                                    Map<String, dynamic>?
                                                        userData = userSnapshot
                                                            .data!
                                                            .data();
                                                    String? userName =
                                                        userData?['userName'];
                                                    return Text(
                                                      '$userName / ',
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "SsurroundAir",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    );
                                                  }

                                                  return const Text('Error');
                                                },
                                              );
                                            }).toList() ??
                                            [],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  '독서현황인증',
                                  style: TextStyle(
                                    fontSize: 30,
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
