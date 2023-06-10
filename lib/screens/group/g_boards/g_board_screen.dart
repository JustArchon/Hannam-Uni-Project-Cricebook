import 'package:circle_book/screens/group/g_boards/gb_book_report_screen.dart';
import 'package:circle_book/screens/group/g_boards/gb_discussion_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupBoardScreen extends StatefulWidget {
  final String groupId;

  const GroupBoardScreen({
    super.key,
    required this.groupId,
  });

  @override
  State<GroupBoardScreen> createState() => _GroupBoardScreenState();
}

class _GroupBoardScreenState extends State<GroupBoardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
    _loadSavedText().then((bookReportContent) {
      setState(() {
        _reportController.text = bookReportContent ?? '';
      });
    });
    _focusNode.requestFocus();
  }

  bool isNoticeScreen = true;
  String discussionTopic = '';
  int discussionTopicPage = 0;
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _topicPageController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();
  String bookReport = '';
  bool _isFirstPage = true;

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

  Future<void> _addDiscussions(BuildContext context, String discussionTopic,
      int discussionTopicPage) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('discussions')
          .add({
        'discussionTopic': discussionTopic,
        'discussionTopicPage': discussionTopicPage,
        'discussionWriter': FirebaseAuth.instance.currentUser?.uid,
        'discussionTime': FieldValue.serverTimestamp(),
      });

      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text(
                '새로운 토론 주제가 생성되었습니다.',
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addBookReports(String bookReport) async {
    try {
      final bookReportRef = FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('bookReports')
          .where('bookReportWriter',
              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .limit(1);
      final querySnapshot = await bookReportRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final documentSnapshot = querySnapshot.docs.first;
        await documentSnapshot.reference.set({
          'bookReportWriter': FirebaseAuth.instance.currentUser?.uid,
          'bookReportContent': bookReport,
          'bookReportSharedStatus': false,
          'bookReportLikesMembers':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid]),
        });
      } else {
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupId)
            .collection('bookReports')
            .add({
          'bookReportWriter': FirebaseAuth.instance.currentUser?.uid,
          'bookReportContent': bookReport,
          'bookReportSharedStatus': false,
          'bookReportLikesMembers':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid]),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _loadSavedText() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('bookReports')
          .where('bookReportWriter',
              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      final List<DocumentSnapshot> documents = querySnapshot.docs;
      if (documents.isEmpty) {
        return '';
      }
      String bookReportContent =
          documents.first.get('bookReportContent') as String? ?? '';
      bookReportContent = bookReportContent.replaceAll('<br>', '\n');

      return bookReportContent;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('오류: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  void checkEvent(DateTime testDate) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        DateTime groupEndTime = documentSnapshot['groupEndTime'].toDate();
        DateTime twoDaysBefore = groupEndTime.subtract(const Duration(days: 3));

        //DateTime currentDate = DateTime.now();

        if (testDate.isBefore(groupEndTime) &&
            testDate.isAfter(twoDaysBefore)) {
          // 현재 날짜가 groupEndTime의 2일 전보다 이전인 경우
          Future.delayed(Duration.zero, () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Text(
                    '독후감을 공유하시겠습니까?\n(공유후 독후감 수정이 불가합니다.)',
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 1.0,
                      fontFamily: "SsurroundAir",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('공유'),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('groups')
                            .doc(widget.groupId)
                            .collection('bookReports')
                            .where('bookReportWriter',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser?.uid)
                            .limit(1)
                            .get()
                            .then((querySnapshot) {
                          if (querySnapshot.size > 0) {
                            DocumentSnapshot documentSnapshot =
                                querySnapshot.docs[0];
                            String documentId = documentSnapshot.id;

                            FirebaseFirestore.instance
                                .collection('groups')
                                .doc(widget.groupId)
                                .collection('bookReports')
                                .doc(documentId)
                                .update({
                              'bookReportSharedStatus': true,
                            });
                          } else {
                            if (bookReport == '') {
                              bookReport = '내용없음';
                            }
                            FirebaseFirestore.instance
                                .collection('groups')
                                .doc(widget.groupId)
                                .collection('bookReports')
                                .add({
                              'bookReportWriter':
                                  FirebaseAuth.instance.currentUser?.uid,
                              'bookReportContent': bookReport,
                              'bookReportSharedStatus': true,
                              'bookReportLikesMembers': FieldValue.arrayUnion(
                                  [FirebaseAuth.instance.currentUser?.uid]),
                            });
                          }
                        });
                        setState(() {
                          _isFirstPage = false;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
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
          Future.delayed(Duration.zero, () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const Text(
                    '공유는 그룹독서 종료 2일전부터\n가능합니다.',
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
        print('Group document does not exist');
      }
    }).catchError((error) {
      print('Error: $error');
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.only(
                top: 30,
                right: 10,
                left: 10,
                bottom: 10,
              ),
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '독서토론',
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
                          '독후감',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Ssurround",
                          ),
                        ),
                      ),
                    ],
                    indicatorColor: const Color(0xff6DC4DB),
                    indicatorWeight: 5,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: const Color(0xff6DC4DB),
                    unselectedLabelColor: Colors.black,
                    controller: _tabController,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Row(
                                          children: [
                                            const Text('토론 주제 생성'),
                                            const Spacer(),
                                            IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                _topicController.clear();
                                              },
                                            ),
                                          ],
                                        ),
                                        content: Form(
                                          key: _formKey,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xff6DC4DB),
                                                          width: 1)),
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: TextFormField(
                                                          maxLines: null,
                                                          controller:
                                                              _topicPageController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            hintText:
                                                                '몇 페이지까지의 내용인지 입력하세요.',
                                                          ),
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return '페이지 번호를 입력해주세요.';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xff6DC4DB),
                                                          width: 1)),
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: TextFormField(
                                                          maxLines: null,
                                                          controller:
                                                              _topicController,
                                                          onChanged: (value) {
                                                            discussionTopic =
                                                                value;
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            hintText:
                                                                '토론 주제를 입력하세요',
                                                          ),
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return '토론 주제를 입력하세요.';
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('생성'),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                discussionTopicPage = int.parse(
                                                    _topicPageController.text);
                                                discussionTopic =
                                                    _topicController
                                                        .text
                                                        .replaceAll(
                                                            '\n', '<br>');

                                                await _addDiscussions(
                                                    context,
                                                    discussionTopic,
                                                    discussionTopicPage);
                                                _topicController.clear();
                                                _topicPageController.clear();
                                                discussionTopic = '';
                                                discussionTopicPage = 0;
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: const Color(0xff6DC4DB),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      height: 30,
                                      child:
                                          Image.asset('assets/icons/Write.png'),
                                    ),
                                    const Text(
                                      '토론 주제 생성',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "SsurroundAir",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        discussionListShow(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('groups')
                              .doc(widget.groupId)
                              .collection('bookReports')
                              .where('bookReportWriter',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser?.uid)
                              .limit(1)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                if (snapshot.data!.size > 0) {
                                  DocumentSnapshot documentSnapshot =
                                      snapshot.data!.docs[0];
                                  bool bookReportSharedStatus =
                                      documentSnapshot[
                                          'bookReportSharedStatus'];
                                  if (bookReportSharedStatus == true) {
                                    _isFirstPage = false;
                                  }
                                }
                                return _isFirstPage
                                    ? StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('testData')
                                            .doc('F3Oj2KpFKo5T73ZRE23p')
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

                                          String testDateString =
                                              snapshot.data!['testDateString'];
                                          DateTime testDate =
                                              DateFormat('yyyy. MM. dd')
                                                  .parse(testDateString);

                                          return Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    margin:
                                                      const EdgeInsets.all(10),
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      height: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.57,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffB98764),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 5,
                                                              spreadRadius: 5)
                                                        ],
                                                        border: Border.all(
                                                            color: const Color(
                                                                0xffB98764))),
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(10),
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      height: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.57,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(30),
                                                          border: Border.all(color: const Color(
                                                                0xffF9F871))),
                                                      alignment: Alignment.center,
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10.0),
                                                                child: TextField(
                                                                  focusNode:
                                                                      _focusNode,
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .newline,
                                                                  maxLines: null,
                                                                  controller:
                                                                      _reportController,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        '독후감을 작성하세요.',
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Column(
                                                  children: [
                                                    FittedBox(
                                                            fit: BoxFit.fitWidth,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10.0),
                                                              child: const Text(
                                                                '공유는 그룹독서 종료 2일전부터 가능합니다.',
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                  color: Colors.red,
                                                                  fontFamily:
                                                                      "Ssurround",
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            bookReport =
                                                                _reportController
                                                                    .text
                                                                    .replaceAll(
                                                                        '\n',
                                                                        '<br>');
                                                            _addBookReports(
                                                                bookReport);

                                                            Future.delayed(
                                                                Duration.zero, () {
                                                              showDialog(
                                                                context: context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    content:
                                                                        const Text(
                                                                      '독후감이 저장되었습니다.',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        letterSpacing:
                                                                            1.0,
                                                                        fontFamily:
                                                                            "SsurroundAir",
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                      ),
                                                                    ),
                                                                    actions: [
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
                                                                  );
                                                                },
                                                              );
                                                            });
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            elevation: 5,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            backgroundColor:
                                                                const Color(
                                                                    0xff6DC4DB),
                                                          ),
                                                          child: const Text(
                                                            '저장',
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
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            checkEvent(testDate);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            elevation: 5,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            backgroundColor:
                                                                const Color(
                                                                    0xff6DC4DB),
                                                          ),
                                                          child: const Text(
                                                            '공유',
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
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Column(
                                          children: [
                                            /*
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isFirstPage = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text(
                                        '돌아가기',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "SsurroundAir",
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff6DC4DB),
                                        ),
                                      ),
                                    ),
                                    */
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      bookReportListShow(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> discussionListShow() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('discussions')
          .orderBy('discussionTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/icons/face-disappointed.png',
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: const TextSpan(
                  text: '진행중인 ',
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: "SsurroundAir",
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '독서토론',
                      style: TextStyle(
                        color: Color(0xff6DC4DB),
                      ),
                    ),
                    TextSpan(
                      text: '이 없어요!',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "토론하고픈 주제를 생성하여 그룹원들과 토론해봐요!",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: "SsurroundAir",
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          );
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
            return Wrap(
              spacing: 0.0,
              runSpacing: 5.0,
              children: documents.map(
                (doc) {
                  String discussionTopic =
                      doc['discussionTopic'].replaceAll('<br>', ' ');
                  String discussionWriterUID = doc['discussionWriter'];
                  int discussionTopicPage = doc['discussionTopicPage'];
                  String discussionId = doc.id;
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(discussionWriterUID)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.hasError) {
                        return Text('Error: ${userSnapshot.error}');
                      }
                      if (!userSnapshot.hasData) {
                        return const SizedBox();
                      }
                      final userDoc = userSnapshot.data!;
                      String discussionWriter = userDoc['userName'];

                      return FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    ExpansionTile(
                                      title: Text(
                                        '작성자 : $discussionWriter',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          letterSpacing: 1.0,
                                          fontFamily: "Ssurround",
                                        ),
                                      ),
                                      subtitle: Text(
                                        "$discussionTopicPage 페이지 까지의 내용",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: "SsurroundAir",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: const Color(0xff6DC4DB),
                                      collapsedBackgroundColor:
                                          const Color(0xff6DC4DB),
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      collapsedShape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 135,
                                          margin: const EdgeInsets.all(5),
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 30,
                                            right: 30,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 55,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      discussionTopic,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        letterSpacing: 1.0,
                                                        fontFamily: "Ssurround",
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xff6DC4DB),
                                                ),
                                                onPressed: () async {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DiscussionScreen(
                                                              groupId: widget
                                                                  .groupId,
                                                              discussionId:
                                                                  discussionId),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  '입장',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "Ssurround",
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            );
        }
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> bookReportListShow() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('bookReports')
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
              runSpacing: 10.0,
              children: documents.map(
                (doc) {
                  String bookReportContent =
                      doc['bookReportContent'].replaceAll('<br>', ' ');
                  String bookReportId = doc.id;
                  String bookReportWriter = doc['bookReportWriter'];
                  bool bookReportSharedStatus = doc['bookReportSharedStatus'];
                  if (bookReportSharedStatus == false) {
                    return const SizedBox.shrink();
                  }
                  return FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookReportScreen(
                                      groupId: widget.groupId,
                                      bookReportId: bookReportId),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              padding: const EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: const Color(0xff6DC4DB),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        padding: const EdgeInsets.all(7.5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: const Color(0xff6DC4DB)),
                                        ),
                                        child: Image.asset(
                                          'assets/icons/아이콘_상태표시바용(512px).png',
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(bookReportWriter)
                                            .get(),
                                        builder: (context, userSnapshot) {
                                          if (userSnapshot.hasError) {
                                            return Text(
                                                'Error: ${userSnapshot.error}');
                                          }
                                          if (!userSnapshot.hasData) {
                                            return const SizedBox();
                                          }
                                          final userDoc = userSnapshot.data!;
                                          String userName = userDoc['userName'];

                                          return Text(
                                            userName,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Ssurround",
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      bookReportContent,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "SsurroundAir",
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
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
