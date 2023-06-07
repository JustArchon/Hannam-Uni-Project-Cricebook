import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circle_book/models/book_model.dart';
import 'package:circle_book/screens/main/main_books/mb_library_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class BooksDetailScreen extends StatefulWidget {
  final String id,
      title,
      thumb,
      description,
      categoryName,
      author,
      publisher,
      link;
  final DateTime pubDate;

  const BooksDetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
    required this.description,
    required this.categoryName,
    required this.author,
    required this.publisher,
    required this.pubDate,
    required this.link,
  });

  @override
  State<BooksDetailScreen> createState() => _BooksDetailScreenState();
}

class _BooksDetailScreenState extends State<BooksDetailScreen> {
  late Future<BookModel> book;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isChecked = false;

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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.28,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: widget.id,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.27,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 15,
                                      offset: const Offset(10, 10),
                                      color: Colors.black.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                child: Image.network(
                                  widget.thumb,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  height:
                                      MediaQuery.of(context).size.height * 0.27,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff6DC4DB)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: Text(
                                          widget.title,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 1.0,
                                            fontFamily: "Ssurround",
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 1.5, bottom: 1.5),
                                        height: 2,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.082,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "저자 : ${widget.author}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.0,
                                                fontFamily: "Ssurround",
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "카테고리 : ${widget.categoryName}",
                                              style: const TextStyle(
                                                fontSize: 15,
                                                letterSpacing: 1.0,
                                                fontFamily: "Ssurround",
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 1.5, bottom: 1.5),
                                        height: 2,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: Text(
                                                          widget.description,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            letterSpacing: 1.0,
                                                            fontFamily:
                                                                "SsurroundAir",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        actions: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.close),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 5,
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: const Text(
                                                  "책소개",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "Ssurround",
                                                    letterSpacing: 1.0,
                                                    color: Color(0xff6DC4DB),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LibraryScreen(
                                                        id: widget.id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 5,
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: const Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "소장",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: "Ssurround",
                                                        letterSpacing: 1.0,
                                                        color:
                                                            Color(0xff6DC4DB),
                                                      ),
                                                    ),
                                                    Text(
                                                      "도서관",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: "Ssurround",
                                                        letterSpacing: 1.0,
                                                        color:
                                                            Color(0xff6DC4DB),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  launchUrl(
                                                      Uri.parse(widget.link));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 5,
                                                  backgroundColor: Colors.white,
                                                ),
                                                child: const Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "링크로",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: "Ssurround",
                                                        letterSpacing: 1.0,
                                                        color:
                                                            Color(0xff6DC4DB),
                                                      ),
                                                    ),
                                                    Text(
                                                      "이동",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: "Ssurround",
                                                        letterSpacing: 1.0,
                                                        color:
                                                            Color(0xff6DC4DB),
                                                      ),
                                                    ),
                                                  ],
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff6DC4DB)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 160,
                                    height: 40,
                                    child: ElevatedButton(
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
                                                .doc(groupId)
                                                .set({
                                              'groupId': groupId,
                                              'bookData': [
                                                widget.id,
                                                widget.title,
                                                widget.thumb,
                                                widget.description,
                                                widget.author, //지은이
                                                widget.pubDate, //출판일
                                                widget.categoryName, //카테고리명
                                                widget.publisher, //출판사
                                                widget.link //책 URL 주소
                                              ],
                                              'groupName': result['groupName'],
                                              'groupLeader': FirebaseAuth
                                                  .instance.currentUser?.uid,
                                              'groupMembers': [
                                                FirebaseAuth
                                                    .instance.currentUser?.uid
                                              ],
                                              'groupMembersCount': 1,
                                              'maxMembers':
                                                  result['numMembers'],
                                              'readingPeriod':
                                                  result['readingPeriod'],
                                              'readingStatusVerificationPeriod':
                                                  result['certificationPeriod'],
                                              'verificationPassCount':
                                                  result['passCount'],
                                              'notice': result['notice'],
                                              'groupStatus': 1,
                                              'groupStartTime': DateTime.now(),
                                              'groupEndTime': DateTime.now(),
                                            });
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        backgroundColor:
                                            const Color(0xff6DC4DB),
                                      ),
                                      child: const Text(
                                        "그룹 생성",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Ssurround",
                                          letterSpacing: 1.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 2,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              showGroupListMethod()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> showGroupListMethod() {
    return StreamBuilder<QuerySnapshot>(
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
            return const Center(child: CircularProgressIndicator());
          default:
            final filteredDocs = snapshot.data!.docs
                .where((doc) => !doc['groupMembers']
                    .contains(FirebaseAuth.instance.currentUser!.uid))
                .toList();
            final nonFilteredDocs = snapshot.data!.docs
                .where((doc) => doc['groupMembers']
                    .contains(FirebaseAuth.instance.currentUser!.uid))
                .toList();
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...filteredDocs.map(
                      (doc) {
                        String gn = doc['groupName'];
                        int rp = doc['readingPeriod'];
                        int vp = doc['readingStatusVerificationPeriod'];
                        int pc = doc['verificationPassCount'];
                        String nt = doc['notice'];
                        int mc = doc['groupMembersCount'];
                        int mm = doc['maxMembers'];
                        String gl = doc['groupLeader'];

                        bool showApplyButton = (mc < mm);

                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              ExpansionTile(
                                title: Text(
                                  "그룹명 : $gn",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                    fontFamily: "Ssurround",
                                  ),
                                ),
                                subtitle: Text(
                                  "$rp일동안 / $vp일마다 / 패스권 $pc개",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: "SsurroundAir",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: const Color(0xff6DC4DB),
                                collapsedBackgroundColor:
                                    const Color(0xff6DC4DB),
                                iconColor: Colors.white,
                                collapsedIconColor: Colors.white,
                                collapsedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 165,
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                      left: 30,
                                      right: 30,
                                    ),
                                    color: Colors.white,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FutureBuilder<DocumentSnapshot>(
                                                  future: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(gl)
                                                      .get(),
                                                  builder:
                                                      (context, userSnapshot) {
                                                    if (userSnapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }

                                                    if (!userSnapshot.hasData) {
                                                      return const Text(
                                                          'Error');
                                                    }

                                                    String groupLeaderName =
                                                        userSnapshot.data![
                                                                'userName'] ??
                                                            '';
                                                    return Text(
                                                      "그룹장 : $groupLeaderName",
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "SsurroundAir",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Text(
                                                  "그룹원 : $mc / $mm\n목표 기간 : $rp일동안\n현황 인증 : $vp일마다\n인증 패스권 : $pc개",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "SsurroundAir",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "공지사항 : $nt",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "SsurroundAir",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (showApplyButton)
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xff6DC4DB),
                                              ),
                                              onPressed: () async {
                                                String currentUserUid =
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid;
                                                DocumentReference groupRef =
                                                    FirebaseFirestore.instance
                                                        .collection('groups')
                                                        .doc(doc.id);
                                                groupRef.update({
                                                  'groupMembers':
                                                      FieldValue.arrayUnion(
                                                          [currentUserUid]),
                                                  'groupMembersCount':
                                                      FieldValue.increment(1),
                                                });
                                                DocumentSnapshot
                                                    groupDocSnapshot =
                                                    await groupRef.get();
                                                int maxMembers =
                                                    groupDocSnapshot[
                                                        'maxMembers'];
                                                int groupMembersCount =
                                                    groupDocSnapshot[
                                                        'groupMembersCount'];

                                                Future.delayed(Duration.zero,
                                                    () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: const Text(
                                                          '가입이 완료되었습니다.',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            letterSpacing: 1.0,
                                                            fontFamily:
                                                                "SsurroundAir",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        actions: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.close),
                                                            onPressed: () {
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
                                              child: const Text(
                                                '가입',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "Ssurround",
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            )
                                          else if (!showApplyButton)
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey,
                                              ),
                                              onPressed: () {},
                                              child: const Text(
                                                '만석',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "Ssurround",
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
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
                    ),
                    ...nonFilteredDocs.map(
                      (doc) {
                        String gn = doc['groupName'];
                        int rp = doc['readingPeriod'];
                        int vp = doc['readingStatusVerificationPeriod'];
                        int pc = doc['verificationPassCount'];
                        String nt = doc['notice'];
                        int mc = doc['groupMembersCount'];
                        int mm = doc['maxMembers'];
                        String gl = doc['groupLeader'];

                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              ExpansionTile(
                                title: Text(
                                  "그룹명 : $gn",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                    fontFamily: "Ssurround",
                                  ),
                                ),
                                subtitle: Text(
                                  "$rp일동안 / $vp일마다 / 패스권 $pc개",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: "SsurroundAir",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: const Color(0xff6DC4DB),
                                collapsedBackgroundColor:
                                    const Color(0xff6DC4DB),
                                iconColor: Colors.white,
                                collapsedIconColor: Colors.white,
                                collapsedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 165,
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                      left: 30,
                                      right: 30,
                                    ),
                                    color: Colors.white,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FutureBuilder<DocumentSnapshot>(
                                                  future: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(gl)
                                                      .get(),
                                                  builder:
                                                      (context, userSnapshot) {
                                                    if (userSnapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }

                                                    if (!userSnapshot.hasData) {
                                                      return const Text(
                                                          'Error');
                                                    }

                                                    String groupLeaderName =
                                                        userSnapshot.data![
                                                                'userName'] ??
                                                            '';
                                                    return Text(
                                                      "그룹장 : $groupLeaderName",
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            "SsurroundAir",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.0,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Text(
                                                  "그룹원 : $mc / $mm\n목표 기간 : $rp일동안\n현황 인증 : $vp일마다\n인증 패스권 : $pc개",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "SsurroundAir",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "공지사항 : $nt",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "SsurroundAir",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () async {
                                              FirebaseFirestore.instance
                                                  .collection('groups')
                                                  .doc(doc.id)
                                                  .get()
                                                  .then(
                                                (DocumentSnapshot
                                                    groupSnapshot) {
                                                  if (groupSnapshot.exists) {
                                                    Map<String, dynamic>
                                                        groupData =
                                                        groupSnapshot.data()
                                                            as Map<String,
                                                                dynamic>;
                                                    List<String> groupMembers =
                                                        List<String>.from(
                                                            groupData[
                                                                'groupMembers']);
                                                    String groupLeader =
                                                        groupData[
                                                            'groupLeader'];
                                                    int groupMembersCount =
                                                        groupData[
                                                            'groupMembersCount'];

                                                    if (groupLeader ==
                                                        FirebaseAuth.instance
                                                            .currentUser?.uid) {
                                                      if (groupMembersCount !=
                                                          1) {
                                                        groupMembers.remove(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                ?.uid);
                                                        groupLeader =
                                                            groupMembers[0];
                                                        groupMembersCount -= 1;
                                                      } else {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'groups')
                                                            .doc(doc.id)
                                                            .delete();
                                                        return;
                                                      }
                                                    } else {
                                                      groupMembers.remove(
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              ?.uid);
                                                      groupMembersCount -= 1;
                                                    }

                                                    FirebaseFirestore.instance
                                                        .collection('groups')
                                                        .doc(doc.id)
                                                        .update({
                                                          'groupMembers':
                                                              groupMembers,
                                                          'groupLeader':
                                                              groupLeader,
                                                          'groupMembersCount':
                                                              groupMembersCount,
                                                        })
                                                        .then((_) {})
                                                        .catchError((error) {
                                                          print(
                                                              'Error updating group members: $error');
                                                        });
                                                  }
                                                },
                                              ).catchError((error) {
                                                print(
                                                    'Error getting group document: $error');
                                              });

                                              Future.delayed(Duration.zero, () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: const Text(
                                                        '탈퇴가 완료되었습니다.',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          letterSpacing: 1.0,
                                                          fontFamily:
                                                              "SsurroundAir",
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      actions: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.close),
                                                          onPressed: () {
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
                                            child: const Text(
                                              '탈퇴',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "Ssurround",
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                    ),
                  ].toList(),
                ),
              ),
            );
        }
      },
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
  late TextEditingController _noticeController;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController();
    _maxMembersController = TextEditingController();
    _readingPeriodController = TextEditingController();
    _readingStatusVerificationPeriodController = TextEditingController();
    _verificationPassCountController = TextEditingController();
    _noticeController = TextEditingController();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _maxMembersController.dispose();
    _readingPeriodController.dispose();
    _readingStatusVerificationPeriodController.dispose();
    _verificationPassCountController.dispose();
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
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'groupName': _groupNameController.text,
                      'numMembers': int.parse(_maxMembersController.text),
                      'readingPeriod': int.parse(_readingPeriodController.text),
                      'certificationPeriod': int.parse(
                          _readingStatusVerificationPeriodController.text),
                      'passCount':
                          int.parse(_verificationPassCountController.text),
                      'notice': _noticeController.text,
                    });
                  }
                },
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
