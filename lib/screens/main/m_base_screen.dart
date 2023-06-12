import 'package:circle_book/screens/main/m_group_screen.dart';
import 'package:circle_book/screens/main/m_profile_screen.dart';
import 'package:circle_book/screens/main/m_setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:circle_book/screens/main/main_books/mb_screen.dart';

class MainBaseScreen extends StatefulWidget {
  const MainBaseScreen({super.key});

  @override
  State<MainBaseScreen> createState() => _MainBaseScreenState();
}

class _MainBaseScreenState extends State<MainBaseScreen> {
  int _selectedIndex = 0; // 처음에 나올 화면 지정
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      MainBooksScreen(),
      const MainGroupScreen(),
      MainProfilePage(
        uid: uid!,
        mainOrGroupProfile: false,
        groupId: '',
      ),
      const MainSettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // bottomNavigationBar item이 4개 이상일 경우

        onTap: _onItemTapped,

        currentIndex: _selectedIndex,

        selectedItemColor: const Color(0xff6DC4DB),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/book-bookmark.png',
              height: 20,
            ),
            activeIcon: Image.asset(
              'assets/icons/book-bookmark_selected.png',
              height: 20,
            ),
            label: "도서",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/people.png',
              height: 20,
            ),
            activeIcon: Image.asset(
              'assets/icons/people_selected.png',
              height: 20,
            ),
            label: "그룹",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/clipboard-user.png',
              height: 20,
            ),
            activeIcon: Image.asset(
              'assets/icons/clipboard-user_selected.png',
              height: 20,
            ),
            label: "프로필",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/gear.png',
              height: 20,
            ),
            activeIcon: Image.asset(
              'assets/icons/gear_selected.png',
              height: 20,
            ),
            label: "설정",
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    // state 갱신
    setState(() {
      _selectedIndex = index;
    });
  }
}
