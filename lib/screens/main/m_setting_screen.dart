import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String newPassword = '';
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('알림'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.notifications),
                title: const Text('알림 설정'),
                onPressed: ((context) async
                {}),
              ),

            ]
          ),
          SettingsSection(
            title: const Text('계정'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.password),
                title: const Text('비밀번호 변경'),
                onPressed: ((context) async
                {
                  showDialog(
                    context: context,
                    builder: (context) {
                     return AlertDialog(
                      title: const Text('비밀번호 변경'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "최소 6자리 이상을 입력하십시오."
                          ),
                          TextField(
                          decoration: const InputDecoration(hintText: "변경할 비밀번호를 입력하세요."),
                          onChanged: (value) {
                            newPassword = value;
                          },
                    ),
                        ],
                      ),
                    actions: [
                      TextButton(
                        child: const Text('확인'),
                        onPressed: () async{
                          if(newPassword == ''){
                            Navigator.pop(context);
                          }else{
                            try {
                            await user!.updatePassword(newPassword);
                            ScaffoldMessenger
                           .of(context)
                           .showSnackBar(
                           const SnackBar(
                           content: Text(
                           '정상적으로 비밀번호가 변경되었습니다.'),
                           backgroundColor:
                           Colors.blue,
                           ),
                           );
                            Navigator.pop(context);
                            } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                              content: Text('비밀번호 변경 실패: $e'),
                              backgroundColor: Colors.red,
                              ),
                            );
                            Navigator.pop(context);
                            }
                          }
                        },
                        ),
                      TextButton(
                        child: const Text('취소'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        ),
                    ],
                  );
                }
                );
                }),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.logout),
                title: const Text('로그아웃'),
                onPressed: ((context) async
                {
                  try {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('로그아웃 실패: $e'),
                  backgroundColor: Colors.red,
                ),
                    );
                  }
                }
              ),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('회원탈퇴[불안정한기능, 그룹내 회원정보가 삭제되지않음]'),
                onPressed: ((context) async
                {
                  showDialog(
                    context: context,
                    builder: (context) {
                     return AlertDialog(
                      title: const Text('회원 탈퇴'),
                      content:
                          const Text(
                            "정말로 서클북 회원을 탈퇴하시겠습니까? 탈퇴시 모든 정보가 사라집니다."
                          ),
                    actions: [
                      TextButton(
                        child: const Text('확인'),
                        onPressed: () async{
                            try {
                            await FirebaseFirestore
                            .instance
                            .collection(
                             'users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .delete();
                            await user!.delete();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger
                           .of(context)
                           .showSnackBar(
                           const SnackBar(
                           content: Text(
                           '정상적으로 회원탈퇴가 완료되었습니다.'),
                           backgroundColor:
                           Colors.blue,
                           ),
                           );
                            
                            } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                              content: Text('회원탈퇴 실패: $e'),
                              backgroundColor: Colors.red,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        ),
                      TextButton(
                        child: const Text('취소'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        ),
                    ],
                  );
                }
                );
                }),
              ),

            ],
          ),
          SettingsSection(
            title: const Text('개발자 연락처'),
            tiles: <SettingsTile>[]
          ),
          
        ],
      ),
    );
  }
}
