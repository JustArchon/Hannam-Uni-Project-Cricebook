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
  @override
  void initState() {
    super.initState();
  }

  bool isNoticeScreen = true;
  String updatedNotice = '';
  bool isDeleting = false;
  bool isButtonLoading = false;
  bool isLoading = false;

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

  Future<void> createReadingCheckDocuments(
    String groupId,
    List<String> groupMembers,
    int remainedVerification,
    int verificationPassCount,
    DateTime startDate,
    int verificationDurationInt,
  ) async {
    final CollectionReference groupCollection =
        FirebaseFirestore.instance.collection('groups');

    Duration verificationDuration = Duration(days: verificationDurationInt);

    final snapshot = await groupCollection
        .doc(groupId)
        .collection('readingStatusVerifications')
        .get();

    if (snapshot.docs.isEmpty) {
      final tasks = <Future>[];

      for (String memberUid in groupMembers) {
        tasks.add(
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
          }),
        );
      }

      await Future.wait(tasks);
    }
  }

  Future<void> updateVerificationStatus(DateTime testDate) async {
    final lockRef = FirebaseFirestore.instance
        .collection('locks')
        .doc('verificationStatusLock');
    final lockDoc = await lockRef.get();

    if (lockDoc.exists && lockDoc.data()?['locked'] == true) {
      // 다른 프로세스가 작업 중이므로 대기
      await lockRef
          .snapshots()
          .firstWhere((doc) => !(doc.data()?['locked'] == true));
    }

    // Lock 획득
    await lockRef.set({'locked': true});

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        QuerySnapshot<Map<String, dynamic>> groupDocsSnapshot =
            await FirebaseFirestore.instance
                .collection('groups')
                .doc(widget.groupId)
                .collection('readingStatusVerifications')
                .get();

        final tasks = <Future<void>>[];

        for (QueryDocumentSnapshot<Map<String, dynamic>> groupDoc
            in groupDocsSnapshot.docs) {
          tasks.add(() async {
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

            for (QueryDocumentSnapshot<Map<String, dynamic>> doc
                in filteredDocs) {
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
            return;
          }());
        }

        await Future.wait(tasks);
      });
    } finally {
      // Lock 해제
      await lockRef.set({'locked': false});
    }
  }

  Future<bool> checkDocumentExists(
      String collectionName, String documentId) async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .get();

    return snapshot.exists;
  }

  Future<Map<String, dynamic>> getVerificationData(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('readingStatusVerifications')
          .doc(uid)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        return {
          'rvSuccessCount': data['rvSuccessCount'],
          'rvUsedPassCount': data['rvUsedPassCount'],
          'rvRemainCount': data['rvRemainCount'],
        };
      } else {
        return {
          'rvSuccessCount': 0,
          'rvUsedPassCount': 0,
          'rvRemainCount': 0,
        };
      }
    } catch (e) {
      print('데이터 가져오기 에러: $e');
      return {
        'rvSuccessCount': 0,
        'rvUsedPassCount': 0,
        'rvRemainCount': 0,
      };
    }
  }

  Future<int> countLikesMembers(String uid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('bookReports')
          .where('bookReportWriter', isEqualTo: uid)
          .get();

      int totalLikesMembers = 0;

      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        List<String> likesMembers =
            List<String>.from(documentSnapshot['bookReportLikesMembers']);
        totalLikesMembers += likesMembers.length;
      }

      return totalLikesMembers;
    } catch (e) {
      print('인덱스 수 세기 에러: $e');
      return 0;
    }
  }

  Future<void> updateUserDocument(
      String uid, int readingPeriod, String groupLeader) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        int readingBookCount = userSnapshot['readingbookcount'];
        int groupLeaderCount = userSnapshot['groupleadercount'];
        int certificount = userSnapshot['certificount'];
        int reputationScore = userSnapshot['reputationscore'];
        Map<String, dynamic> verificationData = await getVerificationData(uid);
        int rvSuccessCount = verificationData['rvSuccessCount'];
        int rvUsedPassCount = verificationData['rvUsedPassCount'];
        int rvRemainCount = verificationData['rvRemainCount'];
        int totalSuccessCount = rvSuccessCount + rvUsedPassCount;
        int likesMembersCount = await countLikesMembers(uid);
        certificount = certificount + totalSuccessCount;
        reputationScore = reputationScore +
            totalSuccessCount +
            (readingPeriod * 3) +
            ((likesMembersCount - 1) * 5) -
            (rvRemainCount - totalSuccessCount);
        readingBookCount++;
        if (groupLeader == uid) {
          groupLeaderCount++;
        }
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'readingbookcount': readingBookCount,
          'groupleadercount': groupLeaderCount,
          'certificount': certificount,
          'reputationscore': reputationScore,
        });
      }
    } catch (e) {
      print('유저 문서 업데이트 에러: $e');
    }
  }

  void updateGroupMembers() {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((groupSnapshot) {
      if (groupSnapshot.exists) {
        List<String> groupMembers =
            List<String>.from(groupSnapshot['groupMembers']);
        int readingPeriod = groupSnapshot['readingPeriod'];
        String groupLeader = groupSnapshot['groupLeader'];

        for (String memberUID in groupMembers) {
          updateUserDocument(memberUID, readingPeriod, groupLeader);
        }
      }
    }).catchError((error) {
      print('그룹 문서 가져오기 에러: $error');
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
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('testData')
            .doc('F3Oj2KpFKo5T73ZRE23p')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Text('No data available');
          }

          String testDateString = snapshot.data!['testDateString'];
          DateTime testDate = DateFormat('yyyy. MM. dd').parse(testDateString);

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
                  String nt = groupData['notice'].replaceAll('<br>', '\n');
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

                  DateTime currentDate = DateTime.now();
                  DateTime endDate =
                      DateFormat('yyyy. MM. dd').parse(formattedgroupEndTime);
                  Duration duration = testDate.difference(endDate);

                  if ((duration.inDays > 0) && (gs == 2)) {
                    FirebaseFirestore.instance
                        .collection('groups')
                        .doc(widget.groupId)
                        .update({
                      'groupStatus': 3,
                    });
                    updateGroupMembers();
                  }

                  bool showStartButton =
                      ((FirebaseAuth.instance.currentUser?.uid == gl) &&
                          (gs == 1));
                  bool showNoticeEditButton =
                      (FirebaseAuth.instance.currentUser?.uid == gl &&
                          (gs != 3));
                  bool showReadingPeriod = (gs != 1);

                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            const EdgeInsets.only(top: 20, right: 30, left: 30),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 250,
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 10,
                                                        bottom: 10,
                                                        left: 20,
                                                        right: 20,
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            widget.title,
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    "Ssurround",
                                                                letterSpacing:
                                                                    1.0,
                                                                color: Color(
                                                                    0xff6DC4DB)),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            widget.author,
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    "Ssurround",
                                                                letterSpacing:
                                                                    1.0,
                                                                color: Colors
                                                                    .grey),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                "ISBN ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      "Ssurround",
                                                                  letterSpacing:
                                                                      1.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Text(
                                                                widget.id,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "SsurroundAir",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.0,
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      "Ssurround",
                                                                  letterSpacing:
                                                                      1.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Text(
                                                                widget
                                                                    .publisher,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "SsurroundAir",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.0,
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      "Ssurround",
                                                                  letterSpacing:
                                                                      1.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Text(
                                                                widget.pubDate,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "SsurroundAir",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.0,
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                "카테고리 ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      "Ssurround",
                                                                  letterSpacing:
                                                                      1.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Text(
                                                                widget
                                                                    .categoryName,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "SsurroundAir",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.close),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 5,
                                              backgroundColor: Colors.white,
                                              padding: const EdgeInsets.all(10),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 70,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(),
                                                  ),
                                                  child: Image.network(
                                                    widget.thumb,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text(
                                                  "책 정보",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontFamily: "Ssurround",
                                                      letterSpacing: 1.0,
                                                      color: Color(0xff6DC4DB)),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          top: 15,
                                          bottom: 15,
                                          left: 10,
                                          right: 10,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xff6DC4DB)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                  StreamBuilder<
                                                      DocumentSnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(gl)
                                                        .snapshots(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                DocumentSnapshot>
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
                                                          userSnapshot.data!.get(
                                                                  'userName') ??
                                                              '';
                                                      return SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.32,
                                                        child: Text(
                                                          groupLeaderName,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "SsurroundAir",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
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
                                              const SizedBox(
                                                height: 10,
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  if (showReadingPeriod)
                                                    SizedBox(
                                                      height: 40,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "$formattedgroupStartTime ~",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  "SsurroundAir",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            formattedgroupEndTime,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  "SsurroundAir",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  if (!showReadingPeriod)
                                                    SizedBox(
                                                      height: 40,
                                                      child: Center(
                                                        child: Text(
                                                          " ($rp일동안)",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "SsurroundAir",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.0,
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
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "공지사항",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: "Ssurround",
                                                      letterSpacing: 1.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  if (showNoticeEditButton)
                                                    IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Row(
                                                                children: [
                                                                  const Text(
                                                                      '공지사항 수정'),
                                                                  const Spacer(),
                                                                  IconButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .close),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              content:
                                                                  Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    border: Border.all(
                                                                        color: const Color(
                                                                            0xff6DC4DB),
                                                                        width:
                                                                            3)),
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
                                                                            TextEditingController(text: nt),
                                                                        onChanged:
                                                                            (value) {
                                                                          updatedNotice = value.replaceAll(
                                                                              '\n',
                                                                              '<br>');
                                                                        },
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          border:
                                                                              InputBorder.none,
                                                                          focusedBorder:
                                                                              InputBorder.none,
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
                                                                  child:
                                                                      const Text(
                                                                          '수정'),
                                                                  onPressed:
                                                                      () async {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
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
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color:
                                                            Color(0xff6DC4DB),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              if (showStartButton)
                                                ElevatedButton(
                                                  onPressed: () {
                                                    DateTime currentDateTime =
                                                        testDate;
                                                    //DateTime.now();

                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        bool isStarting = false;

                                                        return StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  setState) {
                                                            return AlertDialog(
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const Text(
                                                                    "그룹 독서를 시작하시겠습니까?",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontFamily:
                                                                          "SsurroundAir",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      letterSpacing:
                                                                          1.0,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  isStarting
                                                                      ? const CircularProgressIndicator()
                                                                      : const SizedBox(),
                                                                ],
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          '시작'),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      isStarting =
                                                                          true;
                                                                    });

                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'groups')
                                                                        .doc(widget
                                                                            .groupId)
                                                                        .update({
                                                                      'groupStartTime':
                                                                          currentDateTime,
                                                                      'groupEndTime':
                                                                          currentDateTime
                                                                              .add(Duration(days: rp)),
                                                                    }).then((_) {
                                                                      return createReadingCheckDocuments(
                                                                        widget
                                                                            .groupId,
                                                                        memberUIDs,
                                                                        remainedVerification,
                                                                        vp,
                                                                        testDate,
                                                                        rvp,
                                                                      );
                                                                    }).then((_) {
                                                                      return FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'groups')
                                                                          .doc(widget
                                                                              .groupId)
                                                                          .update({
                                                                        'groupStatus':
                                                                            2
                                                                      });
                                                                    }).then((_) {
                                                                      setState(
                                                                          () {
                                                                        isStarting =
                                                                            false;
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    });
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          '취소'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 5,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    backgroundColor:
                                                        const Color(0xff6DC4DB),
                                                  ),
                                                  child: const Text(
                                                    '그룹 독서 시작',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily:
                                                          "SsurroundAir",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                    nt,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontFamily:
                                                          "SsurroundAir",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                                  actions: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.close),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 70,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xff6DC4DB),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              nt,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
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
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                            right: 30,
                            left: 30,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    color: Colors.black,
                                  ),
                                  const Text(
                                    '독서현황',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Ssurround",
                                    ),
                                  ),
                                  Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              if (gs != 1)
                                Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffcee7ef),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
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

                                        if (!snapshot.hasData ||
                                            snapshot.data == null) {
                                          return const Text(
                                              'No data available');
                                        }

                                        List<String> memberUIDs =
                                            List<String>.from(
                                                snapshot.data!['groupMembers']);
                                        memberUIDs.sort((a, b) => (a ==
                                                FirebaseAuth
                                                    .instance.currentUser?.uid)
                                            ? -1
                                            : (b ==
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid)
                                                ? 1
                                                : 0);

                                        return SingleChildScrollView(
                                          child: Wrap(
                                            children: List.generate(
                                                memberUIDs.length, (index) {
                                              return StreamBuilder<
                                                  DocumentSnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(memberUIDs[index])
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
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

                                                      int rvRemainCount =
                                                          snapshot.data![
                                                              'rvRemainCount'];

                                                      ValueNotifier<int>
                                                          rvSuccessCountNotifier =
                                                          ValueNotifier<int>(0);
                                                      ValueNotifier<int>
                                                          rvUsedPassCountNotifier =
                                                          ValueNotifier<int>(0);
                                                      ValueNotifier<int>
                                                          rvFailCountNotifier =
                                                          ValueNotifier<int>(0);
                                                      ValueNotifier<int>
                                                          rvCombinedCountNotifier =
                                                          ValueNotifier<int>(0);
                                                      ValueNotifier<int>
                                                          rvRemainingCountNotifier =
                                                          ValueNotifier<int>(
                                                              rvRemainCount);

                                                      Duration vd =
                                                          Duration(days: rvp);
                                                      for (int i = 0;
                                                          i < remainedVerification;
                                                          i++) {
                                                        DateTime
                                                            verificationDate =
                                                            groupStartTime.add(
                                                                vd * (i + 1));

                                                        if (verificationDate
                                                                .compareTo(
                                                                    testDate) <=
                                                            0) {
                                                          String
                                                              formattedStartDate =
                                                              DateFormat(
                                                                      'yyyy. MM. dd')
                                                                  .format(
                                                                      verificationDate);

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'groups')
                                                              .doc(widget
                                                                  .groupId)
                                                              .collection(
                                                                  'readingStatusVerifications')
                                                              .doc(memberUIDs[
                                                                  index])
                                                              .collection(
                                                                  'userVerifications')
                                                              .doc(
                                                                  formattedStartDate)
                                                              .get()
                                                              .then(
                                                                  (DocumentSnapshot
                                                                      snapshot) {
                                                            if (snapshot
                                                                .exists) {
                                                              final data = snapshot
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>;
                                                              final verificationContent =
                                                                  data[
                                                                      'verificationContent'];
                                                              if (verificationContent !=
                                                                  0) {
                                                                rvSuccessCountNotifier
                                                                    .value++;
                                                              } else if (verificationContent ==
                                                                  0) {
                                                                rvUsedPassCountNotifier
                                                                    .value++;
                                                              }
                                                            } else {
                                                              if (verificationDate
                                                                      .compareTo(
                                                                          testDate) <
                                                                  0) {
                                                                rvFailCountNotifier
                                                                    .value++;
                                                              }
                                                            }

                                                            rvCombinedCountNotifier
                                                                    .value =
                                                                rvSuccessCountNotifier
                                                                        .value +
                                                                    rvUsedPassCountNotifier
                                                                        .value;
                                                            rvRemainingCountNotifier.value =
                                                                rvRemainCount -
                                                                    rvSuccessCountNotifier
                                                                        .value -
                                                                    rvUsedPassCountNotifier
                                                                        .value -
                                                                    rvFailCountNotifier
                                                                        .value;
                                                          }).catchError(
                                                                  (error) {
                                                            print(
                                                                'Error: $error');
                                                          });
                                                        } else {
                                                          break;
                                                        }
                                                      }

                                                      return Column(
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              const Color(0xff6DC4DB),
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                FittedBox(
                                                                              fit: BoxFit.fitWidth,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Container(
                                                                                        width: MediaQuery.of(context).size.width * 0.08,
                                                                                        padding: const EdgeInsets.all(7.5),
                                                                                        decoration: BoxDecoration(
                                                                                          shape: BoxShape.circle,
                                                                                          border: Border.all(color: const Color(0xff6DC4DB)),
                                                                                        ),
                                                                                        child: Image.asset(
                                                                                          'assets/icons/아이콘_상태표시바용(512px).png',
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 10,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: MediaQuery.of(context).size.width * 0.33,
                                                                                        child: Text(
                                                                                          userName,
                                                                                          style: const TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 15,
                                                                                            fontFamily: "SsurroundAir",
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          maxLines: 1,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: MediaQuery.of(context).size.width * 0.28,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        const Text(
                                                                                          '성공',
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 15,
                                                                                            fontFamily: "SsurroundAir",
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(
                                                                                          width: 3,
                                                                                        ),
                                                                                        Container(
                                                                                          width: 80,
                                                                                          padding: const EdgeInsets.all(3),
                                                                                          decoration: BoxDecoration(
                                                                                            border: Border.all(
                                                                                              color: Colors.black,
                                                                                            ),
                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: ValueListenableBuilder<int>(
                                                                                              valueListenable: rvCombinedCountNotifier,
                                                                                              builder: (context, value, _) {
                                                                                                return Text(
                                                                                                  '$value / $rvRemainCount',
                                                                                                  style: const TextStyle(
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 15,
                                                                                                    fontFamily: "SsurroundAir",
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
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
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            child:
                                                                                FittedBox(
                                                                              fit: BoxFit.fitWidth,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: MediaQuery.of(context).size.width * 0.2,
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        const Text(
                                                                                          '인증완료',
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 15,
                                                                                            fontFamily: "SsurroundAir",
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          width: 30,
                                                                                          height: 30,
                                                                                          decoration: BoxDecoration(
                                                                                            border: Border.all(
                                                                                              color: Colors.black,
                                                                                            ),
                                                                                            shape: BoxShape.circle,
                                                                                            color: Colors.green[100],
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: ValueListenableBuilder<int>(
                                                                                              valueListenable: rvSuccessCountNotifier,
                                                                                              builder: (context, value, _) {
                                                                                                return Text(
                                                                                                  '$value',
                                                                                                  style: const TextStyle(
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 15,
                                                                                                    fontFamily: "SsurroundAir",
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: MediaQuery.of(context).size.width * 0.2,
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        const Text(
                                                                                          '패스권사용',
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 15,
                                                                                            fontFamily: "SsurroundAir",
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          width: 30,
                                                                                          height: 30,
                                                                                          decoration: BoxDecoration(
                                                                                            border: Border.all(
                                                                                              color: Colors.black,
                                                                                            ),
                                                                                            shape: BoxShape.circle,
                                                                                            color: Colors.blue[100],
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: ValueListenableBuilder<int>(
                                                                                              valueListenable: rvUsedPassCountNotifier,
                                                                                              builder: (context, value, _) {
                                                                                                return Text(
                                                                                                  '$value',
                                                                                                  style: const TextStyle(
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 15,
                                                                                                    fontFamily: "SsurroundAir",
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: MediaQuery.of(context).size.width * 0.2,
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        const Text(
                                                                                          '미인증',
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 15,
                                                                                            fontFamily: "SsurroundAir",
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          width: 30,
                                                                                          height: 30,
                                                                                          decoration: BoxDecoration(
                                                                                            border: Border.all(
                                                                                              color: Colors.black,
                                                                                            ),
                                                                                            shape: BoxShape.circle,
                                                                                            color: Colors.red[100],
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: ValueListenableBuilder<int>(
                                                                                              valueListenable: rvFailCountNotifier,
                                                                                              builder: (context, value, _) {
                                                                                                return Text(
                                                                                                  '$value',
                                                                                                  style: const TextStyle(
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 15,
                                                                                                    fontFamily: "SsurroundAir",
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: MediaQuery.of(context).size.width * 0.2,
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        const Text(
                                                                                          '인증예정',
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 15,
                                                                                            fontFamily: "SsurroundAir",
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          width: 30,
                                                                                          height: 30,
                                                                                          decoration: BoxDecoration(
                                                                                            border: Border.all(
                                                                                              color: Colors.black,
                                                                                            ),
                                                                                            shape: BoxShape.circle,
                                                                                            color: Colors.grey[100],
                                                                                          ),
                                                                                          child: Center(
                                                                                            child: ValueListenableBuilder<int>(
                                                                                              valueListenable: rvRemainingCountNotifier,
                                                                                              builder: (context, value, _) {
                                                                                                return Text(
                                                                                                  '$value',
                                                                                                  style: const TextStyle(
                                                                                                    color: Colors.black,
                                                                                                    fontSize: 15,
                                                                                                    fontFamily: "SsurroundAir",
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
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
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              elevation: 3,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              backgroundColor:
                                                                  Colors.white,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(7),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .fitWidth,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width * 0.08,
                                                                                padding: const EdgeInsets.all(7.5),
                                                                                decoration: BoxDecoration(
                                                                                  shape: BoxShape.circle,
                                                                                  border: Border.all(
                                                                                    color: const Color(0xff6DC4DB),
                                                                                    width: 2,
                                                                                  ),
                                                                                ),
                                                                                child: Image.asset(
                                                                                  'assets/icons/아이콘_상태표시바용(512px).png',
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.33,
                                                                                child: Text(
                                                                                  userName,
                                                                                  style: const TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 15,
                                                                                    fontFamily: "Ssurround",
                                                                                  ),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.28,
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                const Text(
                                                                                  '성공',
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 15,
                                                                                    fontFamily: "Ssurround",
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 3,
                                                                                ),
                                                                                Container(
                                                                                  width: 80,
                                                                                  padding: const EdgeInsets.all(3),
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: ValueListenableBuilder<int>(
                                                                                      valueListenable: rvCombinedCountNotifier,
                                                                                      builder: (context, value, _) {
                                                                                        return Text(
                                                                                          '$value / $rvRemainCount',
                                                                                          style: const TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontSize: 15,
                                                                                            fontFamily: "SsurroundAir",
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
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
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            }),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
