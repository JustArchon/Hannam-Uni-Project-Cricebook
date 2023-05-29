import 'package:circle_book/screens/group/g_verifications/gv_user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circle_book/widgets/drawer_widget.dart';
import 'package:intl/intl.dart';

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
      vsync: this,
    );
    super.initState();
  }

  bool isNoticeScreen = true;
  String updatedNotice = '';

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

  void createReadingCheckDocuments(
      String groupId,
      List<String> groupMembers,
      int remainedVerification,
      int verificationPassCount,
      DateTime startDate,
      int verificationDurationInt) {
    final CollectionReference groupCollection =
        FirebaseFirestore.instance.collection('groups');

    Duration verificationDuration = Duration(days: verificationDurationInt);

    groupCollection
        .doc(groupId)
        .collection('readingStatusVerifications')
        .get()
        .then((snapshot) {
      if (snapshot.docs.isEmpty) {
        for (String memberUid in groupMembers) {
          groupCollection
              .doc(groupId)
              .collection('readingStatusVerifications')
              .doc(memberUid)
              .set({
            'userUID': memberUid,
            'rvStatus': 1,
            'rvSuccessCount': 0,
            'rvUsedPassCount': 0,
            'rvRemainedPassCount': verificationPassCount,
            'rvFailCount': 0,
            'rvRemainCount': remainedVerification,
            'rvReadingPage': 0,
          });
          for (int i = 0; i < remainedVerification; i++) {
            DateTime verificationDate =
                startDate.add(verificationDuration * (i + 1));
            String formattedStartDate =
                DateFormat('yyyy. MM. dd').format(verificationDate);
            groupCollection
                .doc(groupId)
                .collection('readingStatusVerifications')
                .doc(memberUid)
                .collection('userVerifications')
                .doc(formattedStartDate)
                .set({
              'verificationDate': verificationDate,
              'verificationContent': 0,
              'verificationStatus': 0,
            });
          }
        }
      }
    });
  }

  Future<void> updateVerificationStatus(DateTime testDate) async {
    QuerySnapshot<Map<String, dynamic>> groupDocsSnapshot =
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupId)
            .collection('readingStatusVerifications')
            .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> groupDoc
        in groupDocsSnapshot.docs) {
      QuerySnapshot<Map<String, dynamic>> userVerificationDocsSnapshot =
          await groupDoc.reference.collection('userVerifications').get();

      DateTime currentDate = DateTime.now();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredDocs =
          userVerificationDocsSnapshot.docs.where((doc) {
        DateTime docDate = DateTime.parse(doc.id.replaceAll('. ', '-'));
        return docDate.isBefore(testDate);
      }).toList();

      WriteBatch batch = FirebaseFirestore.instance.batch();
      int rvRemainedPassCount = groupDoc.data()['rvRemainedPassCount'];
      int rvUsedPassCount = groupDoc.data()['rvUsedPassCount'];
      int rvFailCount = groupDoc.data()['rvFailCount'];

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in filteredDocs) {
        int verificationStatus = doc.data()['verificationStatus'];

        if (verificationStatus == 0) {
          if (rvRemainedPassCount > 0) {
            batch.update(doc.reference, {
              'verificationStatus': 2,
            });
            rvRemainedPassCount--;
            rvUsedPassCount++;
          } else {
            batch.update(doc.reference, {
              'verificationStatus': 3,
            });
            rvFailCount++;
          }
        }
      }

      batch.update(groupDoc.reference, {
        'rvRemainedPassCount': rvRemainedPassCount,
        'rvUsedPassCount': rvUsedPassCount,
        'rvFailCount': rvFailCount,
      });

      await batch.commit();
    }
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
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('testData')
            .doc('F3Oj2KpFKo5T73ZRE23p')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          String testDateString = snapshot.data!['testDateString'];

          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .doc(widget.groupId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                Map<String, dynamic>? groupData = snapshot.data!.data();

                if (groupData != null) {
                  int rp = groupData['readingPeriod'];
                  String nt = groupData['notice'];
                  int mm = groupData['maxMembers'];
                  int mc = groupData['groupMembersCount'];
                  String gl = groupData['groupLeader'];
                  int gs = groupData['groupStatus'];
                  int vp = groupData['verificationPassCount'];
                  int rvp = groupData['readingStatusVerificationPeriod'];
                  int remainedVerification = (rp / rvp).toDouble().truncate();

                  List<String> memberUIDs =
                      List<String>.from(groupData['groupMembers']);

                  Timestamp? groupStartTimestamp = groupData['groupStartTime'];
                  DateTime groupStartTime = groupStartTimestamp != null
                      ? groupStartTimestamp.toDate()
                      : DateTime.now();
                  String formattedgroupStartTime =
                      DateFormat('yyyy. MM. dd').format(groupStartTime);

                  Timestamp? groupEndTimestamp = groupData['groupEndTime'];
                  DateTime groupEndTime = groupEndTimestamp != null
                      ? groupEndTimestamp.toDate()
                      : DateTime.now();
                  String formattedgroupEndTime =
                      DateFormat('yyyy. MM. dd').format(groupEndTime);

                  DateTime testDate =
                      DateFormat('yyyy. MM. dd').parse(testDateString);
                  DateTime currentDate = DateTime.now();
                  DateTime endDate =
                      DateFormat('yyyy. MM. dd').parse(formattedgroupEndTime);
                  Duration duration = testDate.difference(endDate);

                  Duration currentDuration =
                      testDate.difference(groupStartTime);
                  Duration totalDuration = endDate.difference(groupStartTime);
                  double currentRatio = currentDuration.inMilliseconds /
                      totalDuration.inMilliseconds;
                  print(duration.inDays);
                  if ((duration.inDays > 0) && (gs == 2)) {
                    FirebaseFirestore.instance
                        .collection('groups')
                        .doc(widget.groupId)
                        .update({
                      'groupStatus': 3,
                    });
                  }

                  bool showStartButton =
                      ((FirebaseAuth.instance.currentUser?.uid == gl) &&
                          (gs == 1));
                  bool showNoticeEditButton =
                      (FirebaseAuth.instance.currentUser?.uid == gl &&
                          (gs != 3));
                  bool showReadingPeriod = (gs != 1);
                  bool showReadingPeriodByIndicatorBar = (gs != 1);

                  updateVerificationStatus(testDate);

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              top: 30, right: 30, left: 30),
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
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 15,
                                              offset: const Offset(10, 10),
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            )
                                          ],
                                        ),
                                        child: Image.network(
                                          widget.thumb,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                          Visibility(
                                              visible: showReadingPeriod,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "$formattedgroupStartTime ~ $formattedgroupEndTime",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          "SsurroundAir",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Text(
                                            "($rp일)",
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
                                      Visibility(
                                        visible:
                                            showReadingPeriodByIndicatorBar,
                                        child: LinearProgressIndicator(
                                          value: currentRatio,
                                          backgroundColor: Colors.grey,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(Color(0xff6DC4DB)),
                                        ),
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  FutureBuilder<
                                                      DocumentSnapshot>(
                                                    future: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(gl)
                                                        .get(),
                                                    builder: (context,
                                                        userSnapshot) {
                                                      if (userSnapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }

                                                      if (!userSnapshot
                                                          .hasData) {
                                                        return const Text(
                                                            'Error');
                                                      }

                                                      String groupLeaderName =
                                                          userSnapshot.data![
                                                                  'userName'] ??
                                                              '';
                                                      return Text(
                                                        groupLeaderName,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "SsurroundAir",
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    "$mc / $mm",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          "SsurroundAir",
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              TabBar(
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
                                  )
                                ],
                                indicatorColor: const Color(0xff6DC4DB),
                                indicatorWeight: 5,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelColor: const Color(0xff6DC4DB),
                                unselectedLabelColor: Colors.black,
                                controller: _tabController,
                                onTap: (index) {
                                  if (gs == 1) {
                                    _tabController
                                        .animateTo(_tabController.index - 1);
                                    Future.delayed(Duration.zero, () {
                                      final scaffoldContext =
                                          ScaffoldMessenger.of(context);
                                      scaffoldContext.showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('그룹 독서가 시작되어야 열람 가능합니다.'),
                                          backgroundColor: Color(0xff6DC4DB),
                                        ),
                                      );
                                    });
                                  } else {
                                    _tabController
                                        .animateTo(_tabController.index);
                                  }
                                },
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              nt,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Visibility(
                                              visible: showNoticeEditButton,
                                              child: IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Row(
                                                          children: [
                                                            const Text(
                                                                '공지사항 수정'),
                                                            const Spacer(),
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.close),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        content: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              border: Border.all(
                                                                  color: const Color(
                                                                      0xff6DC4DB),
                                                                  width: 3)),
                                                          child: Row(
                                                            children: [
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    TextFormField(
                                                                  maxLines:
                                                                      null,
                                                                  controller:
                                                                      TextEditingController(
                                                                          text:
                                                                              nt),
                                                                  onChanged:
                                                                      (value) {
                                                                    updatedNotice =
                                                                        value;
                                                                  },
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    focusedBorder:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        '공지사항을 입력하세요',
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                '수정'),
                                                            onPressed:
                                                                () async {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'groups')
                                                                  .doc(widget
                                                                      .groupId)
                                                                  .update({
                                                                'notice':
                                                                    updatedNotice
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              setState(
                                                                () {},
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Color(0xff6DC4DB),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: showStartButton,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('groups')
                                                      .doc(widget.groupId)
                                                      .update(
                                                          {'groupStatus': 2});
                                                  DateTime currentDateTime =
                                                      DateTime.now();

                                                  setState(
                                                    () {
                                                      FirebaseFirestore.instance
                                                          .collection('groups')
                                                          .doc(widget.groupId)
                                                          .update({
                                                        'groupStartTime':
                                                            currentDateTime,
                                                        'groupEndTime':
                                                            currentDateTime.add(
                                                                Duration(
                                                                    days: rp)),
                                                      });
                                                      createReadingCheckDocuments(
                                                        widget.groupId,
                                                        memberUIDs,
                                                        remainedVerification,
                                                        vp,
                                                        groupStartTime,
                                                        rvp,
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: const Text(
                                                  '그룹 독서 시작',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "SsurroundAir",
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff6DC4DB),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        child: StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('groups')
                                              .doc(widget.groupId)
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            }

                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            }

                                            List<String> memberUIDs =
                                                List<String>.from(snapshot
                                                    .data!['groupMembers']);

                                            memberUIDs.sort((a, b) => (a ==
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid)
                                                ? -1
                                                : (b ==
                                                        FirebaseAuth.instance
                                                            .currentUser?.uid)
                                                    ? 1
                                                    : 0);

                                            return ListView.builder(
                                              itemCount: memberUIDs.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return StreamBuilder<
                                                    DocumentSnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(memberUIDs[index])
                                                      .snapshots(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              DocumentSnapshot>
                                                          snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Container();
                                                    }

                                                    if (snapshot.hasError) {
                                                      return Text(
                                                          'Error: ${snapshot.error}');
                                                    }

                                                    String userName = snapshot
                                                        .data!['userName'];

                                                    return StreamBuilder<
                                                        DocumentSnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('groups')
                                                          .doc(widget.groupId)
                                                          .collection(
                                                              'readingStatusVerifications')
                                                          .doc(
                                                              memberUIDs[index])
                                                          .snapshots(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  DocumentSnapshot>
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Container();
                                                        }

                                                        if (snapshot.hasError) {
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        }

                                                        int rvRemainCount =
                                                            snapshot.data![
                                                                'rvRemainCount'];
                                                        int rvSuccessCount =
                                                            snapshot.data![
                                                                'rvSuccessCount'];
                                                        int rvUsedPassCount =
                                                            snapshot.data![
                                                                'rvUsedPassCount'];
                                                        int rvFailCount =
                                                            snapshot.data![
                                                                'rvFailCount'];

                                                        return Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            VerificationUserScreen(
                                                                      groupId:
                                                                          widget
                                                                              .groupId,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                elevation: 3,
                                                                side:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xff6DC4DB),
                                                                  width: 2,
                                                                ),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          userName,
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                20,
                                                                            fontFamily:
                                                                                "SsurroundAir",
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              80,
                                                                          padding:
                                                                              const EdgeInsets.all(3),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              '${rvSuccessCount + rvUsedPassCount} / $rvRemainCount',
                                                                              style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                                fontFamily: "SsurroundAir",
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.black,
                                                                            ),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                Colors.green[100],
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              '$rvSuccessCount',
                                                                              style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                                fontFamily: "SsurroundAir",
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.black,
                                                                            ),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                Colors.blue[100],
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              '$rvUsedPassCount',
                                                                              style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                                fontFamily: "SsurroundAir",
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.black,
                                                                            ),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                Colors.red[100],
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              '$rvFailCount',
                                                                              style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                                fontFamily: "SsurroundAir",
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.black,
                                                                            ),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                Colors.grey[100],
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              '${rvRemainCount - rvSuccessCount - rvUsedPassCount - rvFailCount}',
                                                                              style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                                fontFamily: "SsurroundAir",
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            );
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
              }

              return const Center(
                child: Text('데이터를 불러올 수 없습니다.'),
              );
            },
          );
        },
      ),
      endDrawer: Drawerwidget(widget.groupId),
    );
  }
}
