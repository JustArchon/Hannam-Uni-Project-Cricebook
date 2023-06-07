import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VerificationUserScreen extends StatefulWidget {
  final String groupId;

  const VerificationUserScreen({
    super.key,
    required this.groupId,
  });

  @override
  State<VerificationUserScreen> createState() => _VerificationUserScreenState();
}

class _VerificationUserScreenState extends State<VerificationUserScreen> {
  final TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, DocumentSnapshot> cachedData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xff6DC4DB),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "독서 현황 인증",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Ssurround",
            letterSpacing: 1.0,
          ),
        ),
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

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .doc(widget.groupId)
                .collection('readingStatusVerifications')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              int remainedPassCount = snapshot.data!['rvRemainedPassCount'];
              int rvReadingPage = snapshot.data!['rvReadingPage'];
              int rvSuccessCount = snapshot.data!['rvSuccessCount'];
              int usedPassCount = snapshot.data!['rvUsedPassCount'];

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        String userName = snapshot.data!['userName'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: "Ssurround",
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '남은 패스권 : $remainedPassCount 개',
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: "Ssurround",
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('groups')
                          .doc(widget.groupId)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasData) {
                          Map<String, dynamic>? groupData =
                              snapshot.data!.data() as Map<String, dynamic>?;

                          if (groupData != null) {
                            int rp = groupData['readingPeriod'];
                            int rvp =
                                groupData['readingStatusVerificationPeriod'];
                            int remainedVerification =
                                (rp / rvp).toDouble().truncate();

                            Timestamp? groupStartTimestamp =
                                groupData['groupStartTime'];
                            DateTime groupStartTime =
                                groupStartTimestamp != null
                                    ? groupStartTimestamp.toDate()
                                    : DateTime.now();

                            Duration vd = Duration(days: rvp);

                            return Expanded(
                              child: GridView.builder(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.6,
                                ),
                                itemCount: remainedVerification,
                                itemBuilder: (BuildContext context, int index) {
                                  DateTime verificationDate =
                                      groupStartTime.add(vd * (index + 1));

                                  String formattedVerificationDate =
                                      DateFormat('yyyy. MM. dd')
                                          .format(verificationDate);
                                  final formattedDateYear =
                                      '${verificationDate.year}';
                                  final formattedDate =
                                      '${verificationDate.month}. ${verificationDate.day}';

                                  return FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('groups')
                                        .doc(widget.groupId)
                                        .collection(
                                            'readingStatusVerifications')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .collection('userVerifications')
                                        .doc(formattedVerificationDate)
                                        .get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }

                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }

                                      String vContent = '-';
                                      int verificationStatus = 0;

                                      ValueNotifier<String> vStateString =
                                          ValueNotifier<String>('인증예정');
                                      ValueNotifier<Color?> vColor =
                                          ValueNotifier<Color?>(
                                              Colors.grey[400]);

                                      if (snapshot.hasData &&
                                          snapshot.data!.exists) {
                                        final verificationContent = snapshot
                                            .data!['verificationContent'];
                                        if (verificationContent != 0) {
                                          vContent = '$verificationContent';
                                          vStateString.value = '인증완료';
                                          vColor.value = Colors.green[400];
                                        } else if (verificationContent == 0) {
                                          vStateString.value = 'PASS';
                                          vColor.value = Colors.blue[400];
                                        }
                                      } else {
                                        if (verificationDate
                                                .compareTo(testDate) ==
                                            0) {
                                          vStateString.value = '인증하기';
                                          vColor.value = Colors.yellow[400];
                                          verificationStatus = 1;
                                        } else if (verificationDate
                                                .compareTo(testDate) <
                                            0) {
                                          vStateString.value = '미인증';
                                          vColor.value = Colors.red[400];
                                        }
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          if (verificationDate
                                                      .compareTo(testDate) ==
                                                  0 &&
                                              verificationStatus == 1) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Row(
                                                    children: [
                                                      const Text(
                                                          '독서 현황 인증\n(다 읽었으면 0 입력)'),
                                                      const Spacer(),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.close),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          _contentController
                                                              .clear();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  content: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
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
                                                          child: Form(
                                                            key: _formKey,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  _contentController,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                focusedBorder:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    '페이지 번호를 입력하시오.',
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return '페이지 번호를 입력해주세요.';
                                                                }
                                                                if (int.parse(
                                                                        value) <=
                                                                    rvReadingPage) {
                                                                  return '이전에 인증한 페이지보다 높아야 합니다.';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    if (remainedPassCount != 0)
                                                      TextButton(
                                                        child: const Text('패스'),
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'groups')
                                                              .doc(widget
                                                                  .groupId)
                                                              .collection(
                                                                  'readingStatusVerifications')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid)
                                                              .collection(
                                                                  'userVerifications')
                                                              .doc(
                                                                  formattedVerificationDate)
                                                              .set({
                                                            'verificationContent':
                                                                0,
                                                          });

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'groups')
                                                              .doc(widget
                                                                  .groupId)
                                                              .collection(
                                                                  'readingStatusVerifications')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid)
                                                              .update({
                                                            'rvRemainedPassCount':
                                                                remainedPassCount -
                                                                    1,
                                                            'rvUsedPassCount':
                                                                usedPassCount +
                                                                    1,
                                                          });

                                                          Navigator.of(context)
                                                              .pop();
                                                          _contentController
                                                              .clear();
                                                        },
                                                      ),
                                                    TextButton(
                                                      child: const Text('인증'),
                                                      onPressed: () async {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          int pageNumber =
                                                              int.parse(
                                                                  _contentController
                                                                      .text);
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'groups')
                                                              .doc(widget
                                                                  .groupId)
                                                              .collection(
                                                                  'readingStatusVerifications')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid)
                                                              .collection(
                                                                  'userVerifications')
                                                              .doc(
                                                                  formattedVerificationDate)
                                                              .set({
                                                            'verificationContent':
                                                                pageNumber,
                                                          });

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'groups')
                                                              .doc(widget
                                                                  .groupId)
                                                              .collection(
                                                                  'readingStatusVerifications')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid)
                                                              .update({
                                                            'rvReadingPage':
                                                                pageNumber,
                                                            'rvSuccessCount':
                                                                rvSuccessCount +
                                                                    1,
                                                          });

                                                          Navigator.of(context)
                                                              .pop();
                                                          _contentController
                                                              .clear();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            color: vColor.value,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.7),
                                                spreadRadius: 0,
                                                blurRadius: 5.0,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                formattedDateYear,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: "SsurroundAir",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                formattedDate,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "SsurroundAir",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Container(
                                                height: 2,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                vStateString.value,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: "SsurroundAir",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                vContent,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "SsurroundAir",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          }
                        }

                        return const Center(
                          child: Text('데이터를 불러올 수 없습니다.'),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
