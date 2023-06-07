import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MemberReportScreen extends StatefulWidget {
  const MemberReportScreen(
      {super.key, required this.userId, required this.groupId});
  final String userId;
  final String groupId;

  @override
  State<MemberReportScreen> createState() => _MemberReportScreenState();
}

class _MemberReportScreenState extends State<MemberReportScreen> {
  //final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  var _ReportReason = '';
  //var _ReportType = '';

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
                return SingleChildScrollView(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      child: Column(children: [
                        const Text(
                          "신고하기",
                          style: TextStyle(
                            fontFamily: "Ssurround",
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "신고 대상: " + snapshot.data!['userName'],
                          style: const TextStyle(
                            fontFamily: "Ssurround",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        /*TextField(
                  maxLines: 1,
                  controller: _controller,
                  decoration: const InputDecoration(labelText: '신고 유형'),
                  onChanged: (value) {
                      _ReportType = value;
                  },
                ),
                */
                        TextField(
                          maxLines: 15,
                          controller: _controller2,
                          decoration: const InputDecoration(labelText: '신고 사유'),
                          onChanged: (value) {
                            _ReportReason = value;
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title:
                                          const Text("정말로 이 그룹원을 신고 하시겠습니까?"),
                                      content: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text('정확하게 신고 유형과 사유를 적었는지 확인바랍니다.'),
                                          Text(
                                              '신고 제출시 관리팀에서 확인후, 신고 사유가 확인된 후, 해당 회원에 대한 제제가 진행됩니다.'),
                                          Text('정말로 신고를 원할시 확인 버튼 클릭하세요.'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            child: const Text('확인'),
                                            onPressed: () async {
                                              FirebaseFirestore.instance
                                                  .collection('reports')
                                                  .add({
                                                "reporterType": 'UserReport',
                                                "reportGroupID": widget.groupId,
                                                "reporterUID": FirebaseAuth
                                                    .instance.currentUser?.uid,
                                                "reportedmemberUID":
                                                    widget.userId,
                                                //"reporttype": _ReportType,
                                                "reportreason": _ReportReason,
                                              });
                                              Future.delayed(Duration.zero, () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: const Text(
                                                        '정상적으로 신고가 완료되었습니다.',
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
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            }),
                                        TextButton(
                                          child: const Text('취소'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ]);
                                });
                          },
                          child: const Text('제출하기'),
                        ),
                      ])),
                );
              }
            }));
  }
}
