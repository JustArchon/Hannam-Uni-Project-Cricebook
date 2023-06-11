import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen(this.userID, {super.key});
  final String userID;

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 2,
          backgroundColor: const Color(0xff6DC4DB),
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "업적 리스트",
            style: TextStyle(
              fontSize: 24,
              fontFamily: "Ssurround",
              letterSpacing: 1.0,
            ),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            //future: _getGroupData(),
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userID)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  //List<dynamic>? ca = snapshot.data!['mounted_Achievements'];
                  int Bookcount = snapshot.data!['readingbookcount'];
                  int GroupLeaderCount = snapshot.data!['groupleadercount'];
                  int CertifiCount = snapshot.data!['certificount'];
                  return SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(height: 10),
                      Column(children: [
                        const Text("독서 횟수 업적"),
                        ListTile(
                          leading: snapshot.data!['complete_Achievements']
                                  .contains('readcount1')
                              ? Image.asset('assets/medals/readcount1medal.png')
                              : const Icon(Icons.lock,
                                  size: 55, color: Color(0xff6DC4DB)),
                          title: const Text('그룹 독서 1회 완료'),
                          subtitle: const Text('그룹 독서 1회를 완료하세요!'),
                          trailing: FittedBox(
                            child: CircularPercentIndicator(
                              radius: 28.0,
                              lineWidth: 7.0,
                              animation: true,
                              percent: Bookcount > 1 ? 1 : Bookcount / 1,
                              center: Text(
                                Bookcount > 1
                                    ? '100%'
                                    : '${(Bookcount / 1) * 100}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: const Color(0xff6DC4DB),
                            ),
                          ),
                          onTap: () {
                            if (Bookcount >= 1) {
                              var newlist =
                                  snapshot.data!['mounted_Achievements'];
                              if (snapshot.data!['complete_Achievements']
                                      .contains('readcount1') ==
                                  false) {
                                var comlist =
                                    snapshot.data!['complete_Achievements'];
                                comlist.add('readcount1');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "complete_Achievements": comlist,
                                });
                              }
                              if (snapshot.data!['mounted_Achievements']
                                  .contains('readcount1medal')) {
                                newlist.remove('readcount1medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 제거가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              } else {
                                newlist.add('readcount1medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 추가가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            } else {
                              Future.delayed(Duration.zero, () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                        '아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!',
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            }
                          },
                        ),
                        ListTile(
                          leading: snapshot.data!['complete_Achievements']
                                  .contains('readcount5')
                              ? Image.asset('assets/medals/readcount5medal.png')
                              : const Icon(Icons.lock,
                                  size: 55, color: Color(0xff6DC4DB)),
                          title: const Text('그룹 독서 5회 완료'),
                          subtitle: const Text('그룹 독서 5회를 완료하세요!'),
                          trailing: FittedBox(
                            child: CircularPercentIndicator(
                              radius: 28.0,
                              lineWidth: 7.0,
                              animation: true,
                              percent: Bookcount > 5 ? 1 : Bookcount / 5,
                              center: Text(
                                Bookcount > 5
                                    ? '100%'
                                    : '${(Bookcount / 5) * 100}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: const Color(0xff6DC4DB),
                            ),
                          ),
                          onTap: () {
                            if (Bookcount >= 5) {
                              var newlist =
                                  snapshot.data!['mounted_Achievements'];
                              if (snapshot.data!['complete_Achievements']
                                      .contains('readcount5') ==
                                  false) {
                                var comlist =
                                    snapshot.data!['complete_Achievements'];
                                comlist.add('readcount5');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "complete_Achievements": comlist,
                                });
                              }
                              if (snapshot.data!['mounted_Achievements']
                                  .contains('readcount5medal')) {
                                newlist.remove('readcount5medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 제거가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              } else {
                                newlist.add('readcount5medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 추가가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            } else {
                              Future.delayed(Duration.zero, () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                        '아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!',
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            }
                          },
                        ),
                        ListTile(
                          leading: snapshot.data!['complete_Achievements']
                                  .contains('readcount10')
                              ? Image.asset(
                                  'assets/medals/readcount10medal.png')
                              : const Icon(Icons.lock,
                                  size: 55, color: Color(0xff6DC4DB)),
                          title: const Text('그룹 독서 10회 완료'),
                          subtitle: const Text('그룹 독서 10회를 완료하세요!'),
                          trailing: FittedBox(
                            child: CircularPercentIndicator(
                              radius: 28.0,
                              lineWidth: 7.0,
                              animation: true,
                              percent: Bookcount > 10 ? 1 : Bookcount / 10,
                              center: Text(
                                Bookcount > 10
                                    ? '100%'
                                    : '${(Bookcount / 10) * 100}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: const Color(0xff6DC4DB),
                            ),
                          ),
                          onTap: () {
                            if (Bookcount >= 10) {
                              var newlist =
                                  snapshot.data!['mounted_Achievements'];
                              if (snapshot.data!['complete_Achievements']
                                      .contains('readcount10') ==
                                  false) {
                                var comlist =
                                    snapshot.data!['complete_Achievements'];
                                comlist.add('readcount10');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "complete_Achievements": comlist,
                                });
                              }
                              if (snapshot.data!['mounted_Achievements']
                                  .contains('readcount10medal')) {
                                newlist.remove('readcount10medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 제거가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              } else {
                                newlist.add('readcount10medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 추가가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            } else {
                              Future.delayed(Duration.zero, () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                        '아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!',
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            }
                          },
                        ),
                        Container(
                          height: 1.0,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                        const Text("그룹장 횟수 업적"),
                        ListTile(
                          leading: snapshot.data!['complete_Achievements']
                                  .contains('groupleadercount1')
                              ? Image.asset(
                                  'assets/medals/groupleadercount1medal.png')
                              : const Icon(Icons.lock,
                                  size: 55, color: Color(0xff6DC4DB)),
                          title: const Text('그룹 독서장 1회 완료'),
                          subtitle: const Text('그룹장을 맡아 그룹 독서 1회를 완료하세요!'),
                          trailing: FittedBox(
                            child: CircularPercentIndicator(
                              radius: 28.0,
                              lineWidth: 7.0,
                              animation: true,
                              percent:
                                  GroupLeaderCount > 1 ? 1 : GroupLeaderCount / 1,
                              center: Text(
                                GroupLeaderCount > 1
                                    ? '100%'
                                    : '${(GroupLeaderCount / 1) * 100}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: const Color(0xff6DC4DB),
                            ),
                          ),
                          onTap: () {
                            if (GroupLeaderCount >= 1) {
                              var newlist =
                                  snapshot.data!['mounted_Achievements'];
                              if (snapshot.data!['complete_Achievements']
                                      .contains('groupleadercount1') ==
                                  false) {
                                var comlist =
                                    snapshot.data!['complete_Achievements'];
                                comlist.add('groupleadercount1');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "complete_Achievements": comlist,
                                });
                              }
                              if (snapshot.data!['mounted_Achievements']
                                  .contains('groupleadercount1medal')) {
                                newlist.remove('groupleadercount1medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 제거가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              } else {
                                newlist.add('groupleadercount1medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 추가가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            } else {
                              Future.delayed(Duration.zero, () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                        '아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!',
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            }
                          },
                        ),
                        ListTile(
                          leading: snapshot.data!['complete_Achievements']
                                  .contains('groupleadercount5')
                              ? Image.asset(
                                  'assets/medals/groupleadercount5medal.png')
                              : const Icon(Icons.lock,
                                  size: 55, color: Color(0xff6DC4DB)),
                          title: const Text('그룹 독서장 5회 완료'),
                          subtitle: const Text('그룹장을 맡아 그룹 독서 5회를 완료하세요!'),
                          trailing: FittedBox(
                            child: CircularPercentIndicator(
                              radius: 28.0,
                              lineWidth: 7.0,
                              animation: true,
                              percent:
                                  GroupLeaderCount > 5 ? 1 : GroupLeaderCount / 5,
                              center: Text(
                                GroupLeaderCount > 5
                                    ? '100%'
                                    : '${(GroupLeaderCount / 5) * 100}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: const Color(0xff6DC4DB),
                            ),
                          ),
                          onTap: () {
                            if (GroupLeaderCount >= 5) {
                              var newlist =
                                  snapshot.data!['mounted_Achievements'];
                              if (snapshot.data!['complete_Achievements']
                                      .contains('groupleadercount5') ==
                                  false) {
                                var comlist =
                                    snapshot.data!['complete_Achievements'];
                                comlist.add('groupleadercount5');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "complete_Achievements": comlist,
                                });
                              }
                              if (snapshot.data!['mounted_Achievements']
                                  .contains('groupleadercount5medal')) {
                                newlist.remove('groupleadercount5medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 제거가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              } else {
                                newlist.add('groupleadercount5medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 추가가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            } else {
                              Future.delayed(Duration.zero, () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                        '아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!',
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            }
                          },
                        ),
                        ListTile(
                          leading: snapshot.data!['complete_Achievements']
                                  .contains('groupleadercount10')
                              ? Image.asset(
                                  'assets/medals/groupleadercount10medal.png')
                              : const Icon(Icons.lock,
                                  size: 55, color: Color(0xff6DC4DB)),
                          title: const Text('그룹 독서장 10회 완료'),
                          subtitle: const Text('그룹장을 맡아 그룹 독서 10회를 완료하세요!'),
                          trailing: FittedBox(
                            child: CircularPercentIndicator(
                              radius: 28.0,
                              lineWidth: 7.0,
                              animation: true,
                              percent: GroupLeaderCount > 10
                                  ? 1
                                  : GroupLeaderCount / 10,
                              center: Text(
                                GroupLeaderCount > 10
                                    ? '100%'
                                    : '${(GroupLeaderCount / 10) * 100}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: const Color(0xff6DC4DB),
                            ),
                          ),
                          onTap: () {
                            if (GroupLeaderCount >= 10) {
                              var newlist =
                                  snapshot.data!['mounted_Achievements'];
                              if (snapshot.data!['complete_Achievements']
                                      .contains('groupleadercount10') ==
                                  false) {
                                var comlist =
                                    snapshot.data!['complete_Achievements'];
                                comlist.add('groupleadercount10');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "complete_Achievements": comlist,
                                });
                              }
                              if (snapshot.data!['mounted_Achievements']
                                  .contains('groupleadercount10medal')) {
                                newlist.remove('groupleadercount10medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 제거가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              } else {
                                newlist.add('groupleadercount10medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 추가가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            } else {
                              Future.delayed(Duration.zero, () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                        '아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!',
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            }
                          },
                        ),
                        Container(
                          height: 1.0,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                        const Text("독서인증 횟수 업적"),
                        ListTile(
                          leading: snapshot.data!['complete_Achievements']
                                  .contains('certificount10')
                              ? Image.asset(
                                  'assets/medals/certificount10medal.png')
                              : const Icon(Icons.lock,
                                  size: 55, color: Color(0xff6DC4DB)),
                          title: const Text('그룹 독서 인증 10회 완료'),
                          subtitle: const Text('그룹 독서 인증을 10회를 완료하세요!'),
                          trailing: FittedBox(
                            child: CircularPercentIndicator(
                              radius: 28.0,
                              lineWidth: 7.0,
                              animation: true,
                              percent: CertifiCount > 10 ? 1 : CertifiCount / 10,
                              center: Text(
                                CertifiCount > 10
                                    ? '100%'
                                    : '${(CertifiCount / 10) * 100}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: const Color(0xff6DC4DB),
                            ),
                          ),
                          onTap: () {
                            if (CertifiCount >= 10) {
                              var newlist =
                                  snapshot.data!['mounted_Achievements'];
                              if (snapshot.data!['complete_Achievements']
                                      .contains('certificount10') ==
                                  false) {
                                var comlist =
                                    snapshot.data!['complete_Achievements'];
                                comlist.add('certificount10');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "complete_Achievements": comlist,
                                });
                              }
                              if (snapshot.data!['mounted_Achievements']
                                  .contains('certificount10medal')) {
                                newlist.remove('certificount10medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 제거가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              } else {
                                newlist.add('certificount10medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 추가가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            } else {
                              Future.delayed(Duration.zero, () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                        '아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!',
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            }
                          },
                        ),
                        ListTile(
                          leading: snapshot.data!['complete_Achievements']
                                  .contains('certificount50')
                              ? Image.asset(
                                  'assets/medals/certificount50medal.png')
                              : const Icon(Icons.lock,
                                  size: 55, color: Color(0xff6DC4DB)),
                          title: const Text('그룹 독서 인증 50회 완료'),
                          subtitle: const Text('그룹 독서 인증을 50회를 완료하세요!'),
                          trailing: FittedBox(
                            child: CircularPercentIndicator(
                              radius: 28.0,
                              lineWidth: 7.0,
                              animation: true,
                              percent: CertifiCount > 50 ? 1 : CertifiCount / 50,
                              center: Text(
                                CertifiCount > 50
                                    ? '100%'
                                    : '${(CertifiCount / 50) * 100}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: const Color(0xff6DC4DB),
                            ),
                          ),
                          onTap: () {
                            if (CertifiCount >= 50) {
                              var newlist =
                                  snapshot.data!['mounted_Achievements'];
                              if (snapshot.data!['complete_Achievements']
                                      .contains('certificount50') ==
                                  false) {
                                var comlist =
                                    snapshot.data!['complete_Achievements'];
                                comlist.add('certificount50');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "complete_Achievements": comlist,
                                });
                              }
                              if (snapshot.data!['mounted_Achievements']
                                  .contains('certificount50medal')) {
                                newlist.remove('certificount50medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 제거가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              } else {
                                newlist.add('certificount50medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 추가가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            } else {
                              Future.delayed(Duration.zero, () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                        '아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!',
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            }
                          },
                        ),
                        ListTile(
                          leading: snapshot.data!['complete_Achievements']
                                  .contains('certificount100')
                              ? Image.asset(
                                  'assets/medals/certificount100medal.png')
                              : const Icon(Icons.lock,
                                  size: 55, color: Color(0xff6DC4DB)),
                          title: const Text('그룹 독서 인증 100회 완료'),
                          subtitle: const Text('그룹 독서 인증을 100회를 완료하세요!'),
                          trailing: FittedBox(
                            child: CircularPercentIndicator(
                              radius: 28.0,
                              lineWidth: 7.0,
                              animation: true,
                              percent: CertifiCount > 100 ? 1 : CertifiCount / 100,
                              center: Text(
                                CertifiCount > 100
                                    ? '100%'
                                    : '${(CertifiCount / 100) * 100}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: const Color(0xff6DC4DB),
                            ),
                          ),
                          onTap: () {
                            if (CertifiCount >= 100) {
                              var newlist =
                                  snapshot.data!['mounted_Achievements'];
                              if (snapshot.data!['complete_Achievements']
                                      .contains('certificount100') ==
                                  false) {
                                var comlist =
                                    snapshot.data!['complete_Achievements'];
                                comlist.add('certificount100');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "complete_Achievements": comlist,
                                });
                              }
                              if (snapshot.data!['mounted_Achievements']
                                  .contains('certificount100medal')) {
                                newlist.remove('certificount100medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 제거가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              } else {
                                newlist.add('certificount100medal');
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid)
                                    .update({
                                  "mounted_Achievements": newlist,
                                });
                                Future.delayed(Duration.zero, () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text(
                                          '정상적으로 업적 뱃지 추가가 완료되었습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            } else {
                              Future.delayed(Duration.zero, () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                        '아직 획득하지 못한 뱃지입니다. 목표를 달성후 장착해보세요!',
                                        style: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 1.0,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: [
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              });
                            }
                          },
                        ),
                      ])
                    ]),
                  );
                }
              }
              return const Center(
                child: Text('데이터를 불러올 수 없습니다.'),
              );
            }));
  }
}
