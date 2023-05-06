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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _pages[_selectedIndex], // 페이지와 연결
        ),
        bottomNavigationBar: BottomNavigationBar(
          //type: BottomNavigationBarType.fixed, // bottomNavigationBar item이 4개 이상일 경우

          onTap: _onItemTapped,

          currentIndex: _selectedIndex,

          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_rounded), label: "Books"),
            BottomNavigationBarItem(
                icon: Icon(Icons.groups_rounded), label: "Group"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: "Profile"),
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
