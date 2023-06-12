import 'package:circle_book/screens/group/g_report_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupProfilePage extends StatefulWidget {
  const GroupProfilePage(this.userId, this.groupId, {super.key});
  final String userId;
  final String groupId;

  @override
  State<GroupProfilePage> createState() => _GroupProfilePageState();
}

class _GroupProfilePageState extends State<GroupProfilePage> {
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
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              String profileIcon = snapshot.data!['profileIcon'];

              return SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 5,
                            color: snapshot.data!['reputationscore'] > 900
                                ? Colors.purple
                                : snapshot.data!['reputationscore'] > 600
                                    ? Colors.blue
                                    : snapshot.data!['reputationscore'] > 300
                                        ? Colors.green
                                        : snapshot.data!['reputationscore'] >
                                                100
                                            ? Colors.yellow
                                            : Colors.red,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/$profileIcon.png',
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: RichText(
                          text: TextSpan(
                            text: snapshot.data!['userName'],
                            style: const TextStyle(
                              fontFamily: "Ssurround",
                              fontSize: 20,
                              color: Color(0xff6DC4DB),
                            ),
                            children: const <TextSpan>[
                              TextSpan(
                                  text: ' 님',
                                  style: TextStyle(
                                      fontFamily: "Ssurround",
                                      fontSize: 20,
                                      color: Colors.black))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                      'assets/icons/아이콘_상태표시바용(512px).png',
                                      width: 35,
                                      height: 35),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {},
                                    child: const Text(
                                      '개인소개',
                                      style: TextStyle(
                                        fontFamily: "Ssurround",
                                        fontSize: 20,
                                        color: Color(0xff6DC4DB),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Text(
                                snapshot.data!["selfintroduction"],
                                style: const TextStyle(
                                  fontFamily: "Ssurround",
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                          'assets/icons/아이콘_상태표시바용(512px).png',
                                          width: 35,
                                          height: 35),
                                      const SizedBox(width: 5),
                                      const Expanded(
                                        child: Text(
                                          '완료한 독서 그룹',
                                          style: TextStyle(
                                            fontFamily: "Ssurround",
                                            fontSize: 20,
                                            color: Color(0xff6DC4DB),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${"총 ${snapshot.data!["readingbookcount"]}"}건 완료",
                                        style: const TextStyle(
                                          fontFamily: "Ssurround",
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      )
                                    ]),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                        'assets/icons/아이콘_상태표시바용(512px).png',
                                        width: 35,
                                        height: 35),
                                    const SizedBox(width: 5),
                                    const Text(
                                      '업적',
                                      style: TextStyle(
                                        fontFamily: "Ssurround",
                                        fontSize: 20,
                                        color: Color(0xff6DC4DB),
                                      ),
                                    ),
                                    const Expanded(child: SizedBox(width: 1)),
                                    Text(
                                      "${"총 ${snapshot.data!["complete_Achievements"].length}"}건 완료",
                                      style: const TextStyle(
                                        fontFamily: "Ssurround",
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: GridView.count(
                                    crossAxisCount: 6,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 5,
                                    children: List.generate(
                                        snapshot.data!['mounted_Achievements']
                                            .length, (index) {
                                      return Image.asset(
                                          "${"assets/medals/" + snapshot.data!['mounted_Achievements'][index]}.png");
                                      /*Ink(
                                          decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: const BorderSide(
                                          color: const Color(0xff6DC4DB),
                                          width: 2,
                                        )),
                                        ),
                                          child: 
                                          );
                                          */
                                    })),
                              ),
                            ] // 이곳을 기점으로 위젯추가하면됩니다.
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
        floatingActionButton:
            FirebaseAuth.instance.currentUser?.uid != widget.userId
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MemberReportScreen(
                                userId: widget.userId,
                                groupId: widget.groupId,
                              )));
                    },
                    backgroundColor: const Color(0xff6DC4DB),
                    child: const Icon(Icons.report))
                : null);
  }
}
