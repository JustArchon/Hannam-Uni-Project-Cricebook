import 'package:circle_book/screens/group/g_base_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_outlined), // 그룹 검색 아이콘 생성
            onPressed: () {
              // 아이콘 버튼 실행
            },
          ),
        ],
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
                children: [
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
                  }

                  Color? buttonColor;
                  String? gst;
                  switch (gs) {
                    case 1:
                      buttonColor = Colors.yellow[200];
                      gst = '준비 중';
                      break;
                    case 2:
                      buttonColor = Colors.green[200];
                      gst = '독서 중';
                      break;
                    case 3:
                      buttonColor = Colors.red[200];
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
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Image.network(
                                      bt,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: 50,
                                          child: Text(
                                            "도서 : $bn",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              letterSpacing: 1.0,
                                              fontFamily: "SsurroundAir",
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "참여 그룹원 : $mc/$mm",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: buttonColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "$gst",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
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
