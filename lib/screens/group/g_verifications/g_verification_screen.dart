import 'package:circle_book/screens/group/g_verifications/gv_user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupVerificationScreen extends StatefulWidget {
  final String groupId, testDateString;

  const GroupVerificationScreen({
    super.key,
    required this.groupId,
    required this.testDateString,
  });

  @override
  State<GroupVerificationScreen> createState() =>
      _GroupVerificationScreenState();
}

class _GroupVerificationScreenState extends State<GroupVerificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<DocumentSnapshot> _getGroupData() async {
    return await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot;
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
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupId)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            Map<String, dynamic>? groupData = snapshot.data!.data();

            if (groupData != null) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Text(
                      "독서 현황 인증",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "SsurroundAir",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.7,
                        padding: const EdgeInsets.only(
                          top: 10,
                          right: 30,
                          left: 30,
                          bottom: 10,
                        ),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('groups')
                              .doc(widget.groupId)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            List<String> memberUIDs = List<String>.from(
                                snapshot.data!['groupMembers']);

                            memberUIDs.sort((a, b) => (a ==
                                    FirebaseAuth.instance.currentUser?.uid)
                                ? -1
                                : (b == FirebaseAuth.instance.currentUser?.uid)
                                    ? 1
                                    : 0);

                            return ListView.builder(
                              itemCount: memberUIDs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(memberUIDs[index])
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    }

                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }

                                    String userName =
                                        snapshot.data!['userName'];

                                    return StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('groups')
                                          .doc(widget.groupId)
                                          .collection(
                                              'readingStatusVerifications')
                                          .doc(memberUIDs[index])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container();
                                        }

                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }

                                        int rvRemainCount =
                                            snapshot.data!['rvRemainCount'];
                                        int rvSuccessCount =
                                            snapshot.data!['rvSuccessCount'];
                                        int rvUsedPassCount =
                                            snapshot.data!['rvUsedPassCount'];
                                        int rvFailCount =
                                            snapshot.data!['rvFailCount'];

                                        return Column(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        VerificationUserScreen(
                                                      groupId: widget.groupId,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 3,
                                                side: const BorderSide(
                                                  color: Color(0xff6DC4DB),
                                                  width: 2,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                backgroundColor: Colors.white,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          userName,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20,
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
                                                          width: 80,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '${rvSuccessCount + rvUsedPassCount} / $rvRemainCount',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "SsurroundAir",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors
                                                                .green[100],
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '$rvSuccessCount',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "SsurroundAir",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors
                                                                .blue[100],
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '$rvUsedPassCount',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "SsurroundAir",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                Colors.red[100],
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '$rvFailCount',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "SsurroundAir",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors
                                                                .grey[100],
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              '${rvRemainCount - rvSuccessCount - rvUsedPassCount - rvFailCount}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "SsurroundAir",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                            const SizedBox(
                                              height: 10,
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
              );
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
