//import 'package:circle_book/screens/group/g_base_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circle_book/models/book_model.dart';

class BooksDetailScreen extends StatefulWidget {
  final String id, title, thumb, description;

  const BooksDetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
    required this.description,
  });

  @override
  State<BooksDetailScreen> createState() => _BooksDetailScreenState();
}

class _BooksDetailScreenState extends State<BooksDetailScreen> {
  late Future<BookModel> book;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
          "그룹 리스트",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Ssurround",
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: widget.id,
                        child: Container(
                          width: 120,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15,
                                offset: const Offset(10, 10),
                                color: Colors.black.withOpacity(0.3),
                              )
                            ],
                          ),
                          child: Image.network(widget.thumb),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: 270,
                        decoration: BoxDecoration(
                          color: const Color(0xff6DC4DB),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 20,
                                letterSpacing: 1.0,
                                fontFamily: "Ssurround",
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.description,
                              style: const TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.0,
                                fontFamily: "SsurroundAir",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 해당 책으로 만들어진 그룹 리스트 출력 예정
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 400,
                    decoration: BoxDecoration(
                      color: const Color(0xff6DC4DB),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 그룹 검색 버튼 기능 구현 예정
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  fixedSize: const Size(170, 40),
                                ),
                                child: const Text(
                                  "그룹 검색",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: "Ssurround",
                                    letterSpacing: 1.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              // 그룹 생성 후 데이터 백엔드로 넘겨줄 예정
                              OutlinedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const GroupCreationPopup();
                                    },
                                  ).then((result) {
                                    if (result != null) {
                                      String groupId = FirebaseFirestore
                                          .instance
                                          .collection('groups')
                                          .doc()
                                          .id;

                                      FirebaseFirestore.instance
                                          .collection('groups')
                                          .doc(result['groupName'])
                                          .set({
                                        'groupId':
                                            groupId, // 이 부분이 새롭게 추가된 부분입니다.
                                        'bookData': [
                                          widget.id,
                                          widget.title,
                                          widget.thumb,
                                          widget.description
                                        ],
                                        'groupName': result['groupName'],
                                        'groupLeader': FirebaseAuth
                                            .instance.currentUser?.uid,
                                        'groupMembers': [
                                          FirebaseAuth.instance.currentUser?.uid
                                        ],
                                        'groupMembersCount': 1,
                                        'maxMembers': result['numMembers'],
                                        'readingPeriod':
                                            result['readingPeriod'],
                                        'readingStatusVerificationPeriod':
                                            result['certificationPeriod'],
                                        'verificationPassCount':
                                            result['passCount'],
                                        'discussionCount':
                                            result['discussionCount'],
                                        'notice': result['notice'],
                                        'groupStatus': 1, // 타임스탬프 필드를 추가합니다.
                                      });
                                    }
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  fixedSize: const Size(170, 40),
                                ),
                                child: const Text(
                                  "그룹 생성",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: "Ssurround",
                                    letterSpacing: 1.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('groups')
                                .where('bookData', arrayContains: widget.id)
                                .where('groupStatus', isEqualTo: 1)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return const Center(
                                      child: CircularProgressIndicator());
                                default:
                                  final filteredDocs = snapshot.data!.docs
                                      .where((doc) => !doc['groupMembers']
                                          .contains(FirebaseAuth
                                              .instance.currentUser!.uid))
                                      .toList(); // 필터링된 문서를 가져옵니다.
                                  return Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: filteredDocs.map(
                                          (doc) {
                                            String gn = doc['groupName'];
                                            int rp = doc['readingPeriod'];
                                            int vp = doc[
                                                'readingStatusVerificationPeriod'];
                                            int pc =
                                                doc['verificationPassCount'];
                                            int dc = doc['discussionCount'];
                                            String nt = doc['notice'];
                                            int mc = doc['groupMembersCount'];
                                            int mm = doc['maxMembers'];
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                children: [
                                                  ExpansionTile(
                                                    title: Text(
                                                      "그룹명 : $gn",
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        letterSpacing: 1.0,
                                                        fontFamily: "Ssurround",
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      "$rp일동안 / $vp일마다 / 패스권 $pc개 / 토론 $dc회",
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontFamily:
                                                              "SsurroundAir",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    backgroundColor:
                                                        const Color(0xfff5b7b1),
                                                    collapsedBackgroundColor:
                                                        const Color(0xfff5b7b1),
                                                    collapsedShape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          Text(
                                                            "그룹원 : $mc / $mm\n독서 목표 기간 : $rp일동안\n독서 현황 인증 간격 : $vp일마다\n인증 패수권 : $pc개 // 토론 : $dc회\n공지사항 : $nt",
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    "SsurroundAir",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xff6DC4DB),
                                                        ),
                                                        onPressed: () async {
                                                          // 현재 로그인된 사용자의 UID 가져오기
                                                          String
                                                              currentUserUid =
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid;

                                                          // 해당 그룹의 DocumentReference 가져오기
                                                          DocumentReference
                                                              groupRef =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'groups')
                                                                  .doc(doc.id);

                                                          // 해당 그룹의 GroupMembers 배열에 현재 사용자의 UID 추가
                                                          groupRef.update({
                                                            'groupMembers':
                                                                FieldValue
                                                                    .arrayUnion([
                                                              currentUserUid
                                                            ]),
                                                            'groupMembersCount':
                                                                FieldValue
                                                                    .increment(
                                                                        1),
                                                          });

                                                          // 그룹 문서 가져오기
                                                          DocumentSnapshot
                                                              groupDocSnapshot =
                                                              await groupRef
                                                                  .get();

                                                          // 그룹의 maxMembers와 groupMembersCount 비교 후, groupStatus 필드 업데이트
                                                          int maxMembers =
                                                              groupDocSnapshot[
                                                                  'maxMembers'];
                                                          int groupMembersCount =
                                                              groupDocSnapshot[
                                                                  'groupMembersCount'];

                                                          if (groupMembersCount >=
                                                              maxMembers) {
                                                            groupRef.update({
                                                              'groupStatus': 2
                                                            });
                                                          }

                                                          // 신청 완료 메시지 출력
                                                          Future.delayed(
                                                              Duration.zero,
                                                              () {
                                                            final scaffoldContext =
                                                                ScaffoldMessenger
                                                                    .of(context);
                                                            scaffoldContext
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    '신청이 완료되었습니다.'),
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff6DC4DB),
                                                              ),
                                                            );
                                                          });

                                                          setState(() {});
                                                        },
                                                        child: const Text(
                                                          '신청',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Ssurround",
                                                            letterSpacing: 1.0,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  /*
                  // 그룹 방 내로 들어가기 위한 테스트 버튼
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupBaseScreen(
                            id: widget.id,
                            title: widget.title,
                            thumb: widget.thumb,
                            groupId: '',
                          ),
                          fullscreenDialog: true, // 화면 생성 방식
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(300, 40),
                    ),
                    child: const Text(
                      "그룹 메인 페이지로 가기",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  */
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupCreationPopup extends StatefulWidget {
  const GroupCreationPopup({Key? key}) : super(key: key);

  @override
  _GroupCreationPopupState createState() => _GroupCreationPopupState();
}

class _GroupCreationPopupState extends State<GroupCreationPopup> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _groupNameController;
  late TextEditingController _maxMembersController;
  late TextEditingController _readingPeriodController;
  late TextEditingController _readingStatusVerificationPeriodController;
  late TextEditingController _verificationPassCountController;
  late TextEditingController _discussionCountController;
  late TextEditingController _noticeController;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController();
    _maxMembersController = TextEditingController();
    _readingPeriodController = TextEditingController();
    _readingStatusVerificationPeriodController = TextEditingController();
    _verificationPassCountController = TextEditingController();
    _discussionCountController = TextEditingController();
    _noticeController = TextEditingController();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _maxMembersController.dispose();
    _readingPeriodController.dispose();
    _readingStatusVerificationPeriodController.dispose();
    _verificationPassCountController.dispose();
    _discussionCountController.dispose();
    _noticeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('그룹 생성'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                  labelText: '그룹명',
                  hintText: '10자 내로 입력해주세요.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '그룹명을 입력하세요.';
                  } else if (value.length > 10) {
                    return '그룹명은 10자 까지 가능합니다.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maxMembersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '그룹원 최대 인원',
                  hintText: '2 이상 입력해주세요.',
                ),
                validator: (value) {
                  final intValue = int.tryParse(value!);
                  if (intValue == null || intValue < 2) {
                    return '최대 인원은 2 이상의 정수여야 합니다.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _readingPeriodController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '독서 목표 기간',
                  hintText: '2 이상 입력해주세요.',
                ),
                validator: (value) {
                  final intValue = int.tryParse(value!);
                  if (intValue == null || intValue < 2) {
                    return '목표 기간은 2 이상의 정수여야 합니다.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _readingStatusVerificationPeriodController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '독서 현황 인증 간격',
                  hintText: '0 이상 입력해주세요.',
                ),
                validator: (value) {
                  final intValue = int.tryParse(value!);
                  if (intValue == null || intValue < 0) {
                    return '현황 인증 간격은 0 이상의 정수여야 합니다.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _verificationPassCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '인증 패스권 개수',
                  hintText: '0 이상 입력해주세요.',
                ),
                validator: (value) {
                  final intValue = int.tryParse(value!);
                  if (intValue == null || intValue < 0) {
                    return '인증 패스권 개수는 0 이상의 정수여야 합니다.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _discussionCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '토론 횟수',
                  hintText: '0 이상 입력해주세요.',
                ),
                validator: (value) {
                  final intValue = int.tryParse(value!);
                  if (intValue == null || intValue < 0) {
                    return '토론 횟수는 0 이상의 정수여야 합니다.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noticeController,
                decoration: const InputDecoration(
                  labelText: '공지사항',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'groupName': _groupNameController.text,
                'numMembers': int.parse(_maxMembersController.text),
                'readingPeriod': int.parse(_readingPeriodController.text),
                'certificationPeriod':
                    int.parse(_readingStatusVerificationPeriodController.text),
                'passCount': int.parse(_verificationPassCountController.text),
                'discussionCount': int.parse(_discussionCountController.text),
                'notice': _noticeController.text,
              });
            }
          },
          child: const Text('생성'),
        ),
      ],
    );
  }
}
