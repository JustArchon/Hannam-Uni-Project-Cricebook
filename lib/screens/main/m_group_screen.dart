import 'package:circle_book/screens/group/g_base_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainGroupScreen extends StatelessWidget {
  const MainGroupScreen({super.key});

  Future<Map<String, dynamic>> getVerificationData(
      String uid, String gi) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(gi)
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

  Future<int> countLikesMembers(String uid, String gi) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(gi)
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
      String uid, int readingPeriod, String groupLeader, String gi) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        int readingBookCount = userSnapshot['readingbookcount'];
        int groupLeaderCount = userSnapshot['groupleadercount'];
        int certificount = userSnapshot['certificount'];
        int reputationScore = userSnapshot['reputationscore'];
        Map<String, dynamic> verificationData =
            await getVerificationData(uid, gi);
        int rvSuccessCount = verificationData['rvSuccessCount'];
        int rvUsedPassCount = verificationData['rvUsedPassCount'];
        int rvRemainCount = verificationData['rvRemainCount'];
        int totalSuccessCount = rvSuccessCount + rvUsedPassCount;
        int likesMembersCount = await countLikesMembers(uid, gi);
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

  void updateGroupMembers(String gi) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(gi)
        .get()
        .then((groupSnapshot) {
      if (groupSnapshot.exists) {
        List<String> groupMembers =
            List<String>.from(groupSnapshot['groupMembers']);
        int readingPeriod = groupSnapshot['readingPeriod'];
        String groupLeader = groupSnapshot['groupLeader'];

        for (String memberUID in groupMembers) {
          updateUserDocument(memberUID, readingPeriod, groupLeader, gi);
        }
      }
    }).catchError((error) {
      print('그룹 문서 가져오기 에러: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false); //뒤로가기 막음
      },
      child: Scaffold(
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

            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 10,
                    ),
                    const Text(
                      '나의 그룹',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff6DC4DB),
                        letterSpacing: 1.0,
                        fontFamily: "Ssurround",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    groupListShow(2, testDateString),
                    const SizedBox(
                      height: 10,
                    ),
                    groupListShow(1, testDateString),
                    const SizedBox(
                      height: 10,
                    ),
                    groupListShow(3, testDateString),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> groupListShow(
      int gsn, String testDateString) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .where('groupMembers',
              arrayContains: FirebaseAuth.instance.currentUser?.uid)
          .where('groupStatus', isEqualTo: gsn)
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
                  int gs = doc['groupStatus'];
                  String bi = doc['bookData'][0];
                  String gi = doc['groupId'];
                  String author = doc['bookData'][4];
                  DateTime pubDate = doc['bookData'][5].toDate() as DateTime;
                  String formattedPubDate =
                      DateFormat('yyyy. MM. dd').format(pubDate);
                  String categoryName = doc['bookData'][6];
                  String publisher = doc['bookData'][7];

                  bool showReadingPeriodByIndicatorBar = (gs != 1);
                  bool showDoVerificationDateIcon = false;

                  Timestamp groupStartTimestamp = doc['groupStartTime'];
                  DateTime groupStartTime = groupStartTimestamp != null
                      ? groupStartTimestamp.toDate()
                      : DateTime.now();

                  String formattedgroupStartTime =
                      DateFormat('yyyy. MM. dd').format(groupStartTime);

                  Timestamp? groupEndTimestamp = doc['groupEndTime'];
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

                  if ((duration.inDays > 0) && (gs == 2)) {
                    FirebaseFirestore.instance
                        .collection('groups')
                        .doc(doc.id)
                        .update({
                      'groupStatus': 3,
                    });
                    updateGroupMembers(gi);
                  }

                  // 독서인증날인지 체크
                  int readingStatusVerificationPeriod =
                      doc['readingStatusVerificationPeriod'];
                  DateTime verificationDate = groupStartTime;
                  if (groupStartTime != testDate) {
                    while (verificationDate.isBefore(testDate)) {
                      verificationDate = verificationDate
                          .add(Duration(days: readingStatusVerificationPeriod));
                    }
                    if (verificationDate.isAtSameMomentAs(testDate)) {
                      showDoVerificationDateIcon = true;
                    } else {
                      showDoVerificationDateIcon = false;
                    }
                  }

                  Color? buttonColor;
                  String? gst;
                  switch (gs) {
                    case 1:
                      buttonColor = Colors.grey[400];
                      gst = '준비 중';
                      break;
                    case 2:
                      buttonColor = const Color(0xff6DC4DB);
                      gst = '독서 중';
                      break;
                    case 3:
                      buttonColor = Colors.black;
                      gst = '완료';
                      break;
                    default:
                      buttonColor = Colors.grey;
                      break;
                  }
                  return FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GroupBaseScreen(
                                    id: bi,
                                    title: bn,
                                    thumb: bt,
                                    groupId: gi,
                                    author: author,
                                    pubDate: formattedPubDate,
                                    categoryName: categoryName,
                                    publisher: publisher,
                                    groupStatus: gs,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white,
                            ),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                    ),
                                    child: Image.network(
                                      bt,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.18,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              gn,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Color(0xff6DC4DB),
                                                letterSpacing: 1.0,
                                                fontFamily: "Ssurround",
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                if (gs == 2)
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.timelapse,
                                                        size: 30,
                                                        color:
                                                            showDoVerificationDateIcon
                                                                ? Colors.red
                                                                : Colors.grey,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: buttonColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "$gst",
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        letterSpacing: 1.0,
                                                        fontFamily:
                                                            "SsurroundAir",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: Image.asset(
                                                  'assets/icons/book-bookmark.png'),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Text(
                                                bn,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  letterSpacing: 1.0,
                                                  fontFamily: "SsurroundAir",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: Image.asset(
                                                  'assets/icons/people.png'),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "$mc/$mm",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                letterSpacing: 1.0,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  showReadingPeriodByIndicatorBar,
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                    child: Image.asset(
                                                        'assets/icons/calendar-days.png'),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "$formattedgroupStartTime ~ ",
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          letterSpacing: 1.0,
                                                          fontFamily:
                                                              "SsurroundAir",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        formattedgroupEndTime,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          letterSpacing: 1.0,
                                                          fontFamily:
                                                              "SsurroundAir",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        /*
                                        const SizedBox(
                                          height: 10,
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
                                            minHeight: 10,
                                          ),
                                        ),
                                        */
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
