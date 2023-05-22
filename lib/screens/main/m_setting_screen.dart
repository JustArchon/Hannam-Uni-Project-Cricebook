import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            title: const Text('계정'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.logout),
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
                }),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.logout),
                title: const Text('비밀번호 변경'),
                onPressed: ((context) async
                {}),
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}
