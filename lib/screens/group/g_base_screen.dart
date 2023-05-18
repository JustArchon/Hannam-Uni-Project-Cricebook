import 'package:circle_book/screens/group/g_boards/g_board_screen.dart';
import 'package:circle_book/screens/group/g_chat_screen.dart';
import 'package:circle_book/screens/group/g_main_screen.dart';

import 'package:flutter/material.dart';

class GroupBaseScreen extends StatefulWidget {
  final String id,
      title,
      thumb,
      groupId,
      author,
      pubDate,
      categoryName,
      publisher;

  const GroupBaseScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.thumb,
    required this.groupId,
    required this.author,
    required this.pubDate,
    required this.categoryName,
    required this.publisher,
  }) : super(key: key);

  @override
  State<GroupBaseScreen> createState() => _GroupBaseScreenState();
}

class _GroupBaseScreenState extends State<GroupBaseScreen> {
  int _selectedIndex = 0; // 처음에 나올 화면 지정

  late final List<Widget> _pages; // late 키워드로 나중에 초기화

  @override
  void initState() {
    super.initState();

    // initState에서 _pages 리스트 초기화
    _pages = [
      GroupMainScreen(
        id: widget.id,
        title: widget.title,
        thumb: widget.thumb,
        groupId: widget.groupId,
        author: widget.author,
        pubDate: widget.pubDate,
        categoryName: widget.categoryName,
        publisher: widget.publisher,
      ),
      ChatScreen(
        groupId: widget.groupId,
      ),
      GroupMainScreen(
        id: widget.id,
        title: widget.title,
        thumb: widget.thumb,
        groupId: widget.groupId,
        author: widget.author,
        pubDate: widget.pubDate,
        categoryName: widget.categoryName,
        publisher: widget.publisher,
      ),
      GroupBoardScreen(
        groupId: widget.groupId,
      ),
    ];
  }

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
                'assets/icons/house-blank.png',
                height: 20,
              ),
              activeIcon: Image.asset(
                'assets/icons/house-blank_selected.png',
                height: 20,
              ),
              label: "그룹홈"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/messages.png',
                height: 20,
              ),
              activeIcon: Image.asset(
                'assets/icons/messages_selected.png',
                height: 20,
              ),
              label: "써클톡"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/calendar-days.png',
                height: 20,
              ),
              activeIcon: Image.asset(
                'assets/icons/calendar-days_selected.png',
                height: 20,
              ),
              label: "캘린더"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/chalkboard-user.png',
                height: 20,
              ),
              activeIcon: Image.asset(
                'assets/icons/chalkboard-user_selected.png',
                height: 20,
              ),
              label: "커뮤니티"),
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
