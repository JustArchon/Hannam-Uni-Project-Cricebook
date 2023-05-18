import 'package:circle_book/screens/group/g_boards/gb_book_report_screen.dart';
import 'package:circle_book/screens/group/g_boards/gb_discussion_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this, //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();
    _loadSavedText().then((bookReportContent) {
      setState(() {
        _reportController.text = bookReportContent ?? '';
      });
    });
  }

  bool isNoticeScreen = true;
  String discussionTopic = '';
  final TextEditingController _topicController = TextEditingController();
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

  Future<void> _addDiscussions(
      BuildContext context, String discussionTopic) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('discussions')
          .add({
        'discussionTopic': discussionTopic,
        'discussionWriter': FirebaseAuth.instance.currentUser?.uid,
        'discussionTime': FieldValue.serverTimestamp(),
      });

      // 성공 메시지 표시
      Future.delayed(Duration.zero, () {
        final scaffoldContext = ScaffoldMessenger.of(context);
        scaffoldContext.showSnackBar(
          const SnackBar(
            content: Text('새로운 토론 주제가 생성되었습니다.'),
            backgroundColor: Color(0xff6DC4DB),
          ),
        );
      });
    } catch (e) {
      // 오류 메시지 표시
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
        actions: <Widget>[
          // 그룹 방 내 상단 메뉴 버튼 예정
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.only(
                top: 10,
                right: 30,
                left: 30,
                bottom: 10,
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: TabBar(
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
                      indicator: const BoxDecoration(
                        color: Color(0xff6DC4DB),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      controller: _tabController,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
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
                                        content: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xff6DC4DB),
                                                  width: 3)),
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  maxLines: null,
                                                  controller: _topicController,
                                                  onChanged: (value) {
                                                    discussionTopic = value;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    hintText: '토론 주제를 입력하세요',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('생성'),
                                            onPressed: () async {
                                              if (discussionTopic.isEmpty) {
                                                Future.delayed(Duration.zero,
                                                    () {
                                                  final scaffoldContext =
                                                      ScaffoldMessenger.of(
                                                          context);
                                                  scaffoldContext.showSnackBar(
                                                    const SnackBar(
                                                      content:
                                                          Text('토론 주제를 입력하세요.'),
                                                      backgroundColor:
                                                          Color(0xff6DC4DB),
                                                    ),
                                                  );
                                                });
                                              } else {
                                                await _addDiscussions(
                                                    context, discussionTopic);
                                                Navigator.of(context).pop();
                                                _topicController.clear();
                                                discussionTopic = '';
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
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text(
                                  '토론 주제 생성',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "SsurroundAir",
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff6DC4DB),
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
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
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _isFirstPage
                              ? Column(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextField(
                                            textInputAction:
                                                TextInputAction.newline,
                                            maxLines: null,
                                            controller: _reportController,
                                            decoration: const InputDecoration(
                                              hintText: '독후감을 작성하세요.',
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: const Text(
                                          '공유는 그룹독서 종료 2일전부터 가능합니다.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontFamily: "Ssurround",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: Colors.black,
                                      )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              bookReport = _reportController
                                                  .text
                                                  .replaceAll('\n', '<br>');
                                              _addBookReports(bookReport);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              backgroundColor: Colors.white,
                                            ),
                                            child: const Text(
                                              '저장',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff6DC4DB),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isFirstPage = false;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              backgroundColor: Colors.white,
                                            ),
                                            child: const Text(
                                              '공유',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "SsurroundAir",
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff6DC4DB),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Column(
                                    children: [
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
                                      SingleChildScrollView(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              bookReportListShow(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                  String discussionTopic = doc['discussionTopic'];
                  String discussionId = doc.id;
                  return FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DiscussionScreen(
                                      groupId: widget.groupId,
                                      discussionId: discussionId),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              padding: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: const Color(0xff6DC4DB),
                            ),
                            child: Text(
                              discussionTopic,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Ssurround",
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
              spacing: 10.0,
              runSpacing: 10.0,
              children: documents.map(
                (doc) {
                  String bookReportContent =
                      doc['bookReportContent'].replaceAll('<br>', ' ');
                  String bookReportId = doc.id;
                  String bookReportWriter = doc['bookReportWriter'];
                  return FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
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
                              padding: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: const Color(0xff6DC4DB),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      color: Colors.grey,
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
                                Text(
                                  bookReportContent,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Ssurround",
                                  ),
                                ),
                              ],
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
