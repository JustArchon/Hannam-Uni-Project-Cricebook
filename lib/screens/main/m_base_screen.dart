import 'package:circle_book/screens/main/m_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:circle_book/screens/main/main_books/mb_screen.dart';

class MainBaseScreen extends StatelessWidget {
  const MainBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TabPage(),
      ),
    );
  }
}

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0; // 처음에 나올 화면 지정

  // 이동할 페이지
  final List _pages = [
    MainBooksScreen(),
    const MainGroupScreen(),
    MainBooksScreen(),
    MainBooksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _pages[_selectedIndex], // 페이지와 연결
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
        ));
  }

  void _onItemTapped(int index) {
    // state 갱신
    setState(() {
      _selectedIndex = index;
    });
  }
}
