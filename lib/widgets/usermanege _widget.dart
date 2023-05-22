import 'package:circle_book/screens/group/g_member_manage_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManegeWidget extends StatefulWidget {
  const UserManegeWidget(this.userID, this.groupID, {super.key});

  final String userID;
  final String groupID;

  @override
  State<UserManegeWidget> createState() => _UserManegeWidgetState();
}

class _UserManegeWidgetState extends State<UserManegeWidget> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _Groupleaderassignment(String userId) async{

  }
  

  @override
Widget build(BuildContext context) {
    return Container(
              padding: EdgeInsets.only(top:10),
              width: 150,
              height: 300,
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
      context: context,
      builder: (context){
      return AlertDialog(
      title: const Text(
          "정말로 이 그룹원을 강퇴하겠습니까?"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('다시한번 그룹원과 상의를 해보기 바랍니다.'),
            Text('독서중인 그룹에서 강퇴된 그룹원은 평판 점수가 자동으로 하락합니다.'),
            Text('정말로 강퇴를 원할시 확인 버튼 클릭하세요.'), 
          ],
        ),
        actions: [
          
        TextButton(
          child: const Text('확인'),
          onPressed: () async {
            DocumentSnapshot
                groupdata =
                await FirebaseFirestore
                    .instance
                    .collection(
                        'groups')
                    .doc(widget.groupID)
                    .get();
              int groupmemberscont =
                  groupdata[
                      'groupMembersCount'];
              List<String>
                  groupmemberlist =
                  groupdata[
                          'groupMembers']
                      .cast<
                          String>();
              groupmemberlist.remove(
                  widget.userID);
              groupmemberscont -=
                  1;
                  FirebaseFirestore
                  .instance
                  .collection(
                      'groups')
                  .doc(widget.groupID)
                  .update({
                "groupMembers":
                    groupmemberlist,
                "groupMembersCount":
                    groupmemberscont,
              });
              ScaffoldMessenger
                .of(context)
                .showSnackBar(
                const SnackBar(
                content: Text(
                '정상적으로 강퇴가 완료되었습니다.'),
                backgroundColor:
              Colors.blue,
                ),
              );
              Navigator.of(context)
                .pop();
              Navigator.of(context)
                .pop();
              Navigator.of(context)
                .pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupMemberManagePage(widget.groupID)));

                }
        ),
        TextButton(
          child: const Text('취소'),
          onPressed: () {
            Navigator.of(context)
                .pop();
          },
        )
        ]
      );
      }
        );
                    },
                    icon: const Icon(Icons.person_off),
                    label: const Text('그룹원 강퇴하기'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
      context: context,
      builder: (context){
      return AlertDialog(
      title: const Text(
          "정말로 이 그룹원을 그룹장으로 변경하시겠습니까?"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('다시한번 그룹원과 상의를 해보기 바랍니다.'),
            Text('그룹장이 변경될시 현 그룹장은 모든 권한이 박탈됩니다.'),
            Text('정말로 변경을 원할시 확인 버튼 클릭하세요.'), 
          ],
        ),
        actions: [
          
        TextButton(
          child: const Text('확인'),
          onPressed: () async {
                  FirebaseFirestore
                  .instance
                  .collection(
                      'groups')
                  .doc(widget.groupID)
                  .update({
                "groupLeader":
                    widget.userID,
              });
              ScaffoldMessenger
                .of(context)
                .showSnackBar(
                const SnackBar(
                content: Text(
                '정상적으로 그룹장변경이 완료되었습니다.'),
                backgroundColor:
              Colors.blue,
                ),
              );
              Navigator.of(context)
                .pop();
              Navigator.of(context)
                .pop();
              Navigator.of(context)
                .pop();
              Navigator.of(context)
                .pop();

                }
        ),
        TextButton(
          child: const Text('취소'),
          onPressed: () {
            Navigator.of(context)
                .pop();
          },
        )
        ]
      );
      }
        );
                    },
                    icon: const Icon(Icons.supervisor_account),
                    label: const Text('그룹장 변경하기'),
                  ),
                ],
              ),
            );
  }
}