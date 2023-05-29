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
            return Container();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          String testDateString = snapshot.data!['testDateString'];

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

              DateTime testDate =
                  DateFormat('yyyy. MM. dd').parse(testDateString);

              updateVerificationStatus(testDate);

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
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('groups')
                          .doc(widget.groupId)
                          .collection('readingStatusVerifications')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection('userVerifications')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final documentsData = snapshot.data!.docs.map((doc) {
                            final verificationDate =
                                (doc['verificationDate'] as Timestamp).toDate();
                            final formattedDate =
                                '${verificationDate.month}/${verificationDate.day}';
                            final formattedDateFull = DateFormat('yyyy. MM. dd')
                                .format(verificationDate);
                            DateTime currentDate = DateTime.now();
                            Duration duration =
                                testDate.difference(verificationDate);

                            return {
                              'verificationDate': formattedDate,
                              'verificationContent': doc['verificationContent'],
                              'verificationStatus': doc['verificationStatus'],
                              'verificationDuration': duration,
                              'formattedDateFull': formattedDateFull,
                            };
                          }).toList();

                          return Expanded(
                            child: GridView.builder(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemCount: documentsData.length,
                              itemBuilder: (BuildContext context, int index) {
                                final documentData = documentsData[index];

                                final verificationDate =
                                    documentData['verificationDate'];
                                final verificationContent =
                                    documentData['verificationContent'];
                                final verificationStatus =
                                    documentData['verificationStatus'];
                                final verificationDuration =
                                    documentData['verificationDuration'];
                                final formattedDateFull =
                                    documentData['formattedDateFull'];

                                String vContent = '';
                                Color? vColor, vBorderColor;
                                double vBorderWidth = 0.0;

                                if (verificationStatus == 0) {
                                  if (verificationDuration.inDays == 0) {
                                    vContent = '인증하기';
                                    vColor = Colors.yellow[400];
                                  } else {
                                    vContent = '인증예정';
                                    vColor = Colors.grey[400];
                                  }
                                } else if (verificationStatus == 1) {
                                  vContent = '$verificationContent';
                                  vColor = Colors.green[400];
                                } else if (verificationStatus == 2) {
                                  vContent = 'PASS';
                                  vColor = Colors.blue[400];
                                } else if (verificationStatus == 3) {
                                  vContent = '미인증';
                                  vColor = Colors.red[400];
                                }

                                if (verificationDuration.inDays == 0) {
                                  vBorderColor = Colors.amber;
                                  vBorderWidth = 3;
                                } else {
                                  vBorderColor = Colors.grey;
                                  vBorderWidth = 1;
                                }

                                return GestureDetector(
                                  onTap: () {
                                    if (verificationDuration.inDays == 0 &&
                                        verificationStatus == 0) {
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
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    _contentController.clear();
                                                  },
                                                ),
                                              ],
                                            ),
                                            content: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
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
                                                      child: TextFormField(
                                                        controller:
                                                            _contentController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          hintText:
                                                              '페이지 번호를 입력하시오.',
                                                        ),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
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
                                              TextButton(
                                                child: const Text('인증'),
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    int pageNumber = int.parse(
                                                        _contentController
                                                            .text);
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('groups')
                                                        .doc(widget.groupId)
                                                        .collection(
                                                            'readingStatusVerifications')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .collection(
                                                            'userVerifications')
                                                        .doc(formattedDateFull)
                                                        .update({
                                                      'verificationContent':
                                                          pageNumber,
                                                      'verificationStatus': 1,
                                                    });

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('groups')
                                                        .doc(widget.groupId)
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
                                                          rvSuccessCount + 1,
                                                    });

                                                    Navigator.of(context).pop();
                                                    _contentController.clear();
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
                                    padding: const EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                      color: vColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.7),
                                          spreadRadius: 0,
                                          blurRadius: 5.0,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          verificationDate,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Ssurround",
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 2,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          vContent,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Ssurround",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
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
