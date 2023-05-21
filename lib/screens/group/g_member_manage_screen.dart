import 'package:circle_book/widgets/usermanege%20_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMemberManagePage extends StatefulWidget {
  const GroupMemberManagePage(this.groupid, {super.key});
  final String groupid;
  

  @override
  State<GroupMemberManagePage> createState() => _GroupMemberManagePageState();
  
  

}


class _GroupMemberManagePageState extends State<GroupMemberManagePage> {


    void showAlert(BuildContext context, String userUID, String groupID){
      showDialog(
        context: context,
        builder: (context){
          return Dialog(
            backgroundColor: Colors.white,
            child: UserManegeWidget(userUID,groupID),
          );
        },
      );
    }
  Future<DocumentSnapshot> _getGroupData() async {
    return await FirebaseFirestore.instance
        .collection('groups')
        .where('groupId', isEqualTo: widget.groupid)
        .limit(1)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size > 0) {
        return querySnapshot.docs[0];
      } else {
        throw Exception('그룹을 찾을 수 없습니다.');
      }
    });
  }
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
      body: FutureBuilder(
          future: _getGroupData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              Map<String, dynamic>? groupData =
                  snapshot.data!.data() as Map<String, dynamic>?;

              if (groupData != null) {
                List<dynamic>? gm = groupData['groupMembers'];
                String gl = groupData['groupLeader'];
                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                            const Text("그룹원 관리",
                            style: TextStyle(
                              fontFamily: "Ssurround",
                              fontSize: 20,
                              color: Colors.black,)),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                                  child: Column(
                                    children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: gm?.length,
                                          itemBuilder: (context, index) {
                                            return StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(gm?[index])
                                                    .snapshots(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else {
                                                    return ListTile(
                                                      leading: const CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/icons/usericon.png')),
                                                      title: Text(snapshot
                                                          .data!['userName']),
                                                      subtitle: Text(snapshot
                                                          .data!['userEmail']),
                                                      trailing: gl ==
                                                              snapshot.data![
                                                                  'userUID']
                                                          ? const Text('그룹장')
                                                          : const Text('그룹원'),
                                                      onTap: () {
                                                        if(snapshot.data!['userUID'] == FirebaseAuth.instance.currentUser?.uid){

                                                        }else{
                                                          showAlert(context, snapshot.data!['userUID'], widget.groupid);

                                                        }
                                                      },
                                                    );
                                                  }
                                                });
                                          },
                                        ),
                                    ]
                              ),
                          ),
                        ],
                      );
                    }
                  },
                );
              }
            }
                        return const Center(
              child: Text('데이터를 불러올 수 없습니다.'),
            );
          }
      )
      
    );
  }
}
