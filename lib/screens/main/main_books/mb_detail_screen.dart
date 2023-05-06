import 'package:circle_book/screens/group/g_base_screen.dart';
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "그룹 리스트",
          style: TextStyle(
            fontSize: 24,
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
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.description,
                              style: const TextStyle(fontSize: 12),
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
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.blue,
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
                                  style: TextStyle(fontSize: 22),
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
                                          .collection('CircleBookGroupList')
                                          .doc()
                                          .id;

                                      FirebaseFirestore.instance
                                          .collection('CircleBookGroupList')
                                          .doc(result['groupName'])
                                          .set({
                                        'groupId':
                                            groupId, // 이 부분이 새롭게 추가된 부분입니다.
                                        'BookData': [
                                          widget.id,
                                          widget.title,
                                          widget.thumb,
                                          widget.description
                                        ],
                                        'GroupName': result['groupName'],
                                        'GroupLeader': FirebaseAuth
                                            .instance.currentUser?.uid,
                                        'GroupMembers': [
                                          FirebaseAuth.instance.currentUser?.uid
                                        ],
                                        'numMembers': result['numMembers'],
                                        'readingPeriod':
                                            result['readingPeriod'],
                                        'certificationPeriod':
                                            result['certificationPeriod'],
                                        'passCount': result['passCount'],
                                        'discussionCount':
                                            result['discussionCount'],
                                        'notice': result['notice'],
                                        'Groupstate': 1,
                                        'timestamp': FieldValue
                                            .serverTimestamp(), // 타임스탬프 필드를 추가합니다.
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
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('CircleBookGroupList')
                                .where('BookData', arrayContains: widget.id)
                                .where('Groupstate',
                                    isEqualTo: 1) // Groupstate가 1인 것만 검색
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
                                  List<QueryDocumentSnapshot> documents =
                                      snapshot.data!.docs;
                                  return Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: documents.map(
                                          (doc) {
                                            String gn = doc['GroupName'];
                                            int rp = doc['readingPeriod'];
                                            int cp = doc['certificationPeriod'];
                                            int pc = doc['passCount'];
                                            int dc = doc['discussionCount'];
                                            String nt = doc['notice'];
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
                                                          color: Colors.black),
                                                    ),
                                                    subtitle: Text(
                                                      "$rp일동안 / $cp일마다 / 패스권 $pc개 / 토론 $dc회",
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                    backgroundColor:
                                                        Colors.grey[400],
                                                    collapsedBackgroundColor:
                                                        Colors.grey[400],
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
                                                            "그룹원 : 3 / 4\n독서 목표 기간 : $rp일동안\n독서 현황 인증 간격 : $cp일마다\n인증 패수권 : $pc개 // 토론 : $dc회\n공지사항 : $nt",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      ElevatedButton(
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
                                                                      'CircleBookGroupList')
                                                                  .doc(doc.id);

                                                          // 해당 그룹의 GroupMembers 배열에 현재 사용자의 UID 추가
                                                          groupRef.update({
                                                            'GroupMembers':
                                                                FieldValue
                                                                    .arrayUnion([
                                                              currentUserUid
                                                            ])
                                                          });

                                                          // 신청 완료 메시지 출력
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    '신청이 완료되었습니다.')),
                                                          );
                                                        },
                                                        child: const Text('신청'),
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
                ],
              ),
              const SizedBox(
                height: 25,
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
  late TextEditingController _numMembersController;
  late TextEditingController _readingPeriodController;
  late TextEditingController _certificationPeriodController;
  late TextEditingController _passCountController;
  late TextEditingController _discussionCountController;
  late TextEditingController _noticeController;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController();
    _numMembersController = TextEditingController();
    _readingPeriodController = TextEditingController();
    _certificationPeriodController = TextEditingController();
    _passCountController = TextEditingController();
    _discussionCountController = TextEditingController();
    _noticeController = TextEditingController();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _numMembersController.dispose();
    _readingPeriodController.dispose();
    _certificationPeriodController.dispose();
    _passCountController.dispose();
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
                controller: _numMembersController,
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
                controller: _certificationPeriodController,
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
                controller: _passCountController,
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
                'numMembers': int.parse(_numMembersController.text),
                'readingPeriod': int.parse(_readingPeriodController.text),
                'certificationPeriod':
                    int.parse(_certificationPeriodController.text),
                'passCount': int.parse(_passCountController.text),
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
