import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Drawerwidget extends StatelessWidget {
  Drawerwidget(this.groupid, {super.key,});

  final String groupid;

  Future<DocumentSnapshot> _getGroupData() async {
    return await FirebaseFirestore.instance
        .collection('groups')
        .where('groupId', isEqualTo: groupid)
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
    return Drawer(
      child: FutureBuilder(
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
                  Expanded(
                    child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          // 프로젝트에 assets 폴더 생성 후 이미지 2개 넣기
                          // pubspec.yaml 파일에 assets 주석에 이미지 추가하기
                          UserAccountsDrawerHeader(
                            currentAccountPicture: CircleAvatar(
                              // 현재 계정 이미지 set
                              backgroundImage: AssetImage('assets/icons/usericon.png'),
                              backgroundColor: Colors.white,
                            ),
                            otherAccountsPictures: <Widget>[
                              // CircleAvatar(
                              //   backgroundColor: Colors.white,
                              //   backgroundImage: AssetImage('assets/profile2.png'),
                              // )
                            ],
                            accountName: Text(snapshot.data!['userName']),
                            accountEmail: Text(snapshot.data!['userEmail']),
                            /*
                            onDetailsPressed: () {
                              print('arrow is clicked');
                            },
                            */
                            decoration: const BoxDecoration(
                                color: Color(0xff6DC4DB),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(40.0),
                                    bottomRight: Radius.circular(40.0))),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Text("그룹 멤버"),
                                SizedBox(
                                  height: 340,
                                  child: ListView.builder(
                                        itemCount: gm?.length,
                                        itemBuilder: (context, index){
                                              return StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(gm?[index])
                                                        .snapshots(),
                                                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return const Center(
                                                          child: CircularProgressIndicator(),
                                                          );
                                                  } else {
                                                    return ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundImage: AssetImage('assets/icons/usericon.png')
                                                      ),
                                                      title: Text(snapshot.data!['userName']),
                                                      subtitle: Text(snapshot.data!['userEmail']),
                                                      trailing: gl == snapshot.data!['userUID'] ? Text('그룹장') : Text('그룹원'),
                                                    );
                                                  }
                                                }
                                              );
                                        },
                                        ),
                                ),
                                    ],
                                  ),
                          ),
                              Container(
                                child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                child: Container(
                                  child: const Column(
                                    children: <Widget>[
                                      Divider(),
                                      ListTile(
                                        leading: Icon(Icons.exit_to_app_sharp),
                                        title: Text("그룹 나가기"),
                                      )
                                      ],
                                    ),
                                )
                              ),
                            ),
                            ],
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
          ),
        );
      }
    }