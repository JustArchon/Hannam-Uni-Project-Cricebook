import 'package:circle_book/screens/group/g_chat_screen.dart';
import 'package:circle_book/screens/group/g_calendar_screen.dart';
import 'package:circle_book/screens/group/g_board_screen.dart';
import 'package:circle_book/screens/group/g_main_screen.dart';

import 'package:flutter/material.dart';

class GroupBaseScreen extends StatefulWidget {
  final String id, title, thumb, groupId;

  const GroupBaseScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.thumb,
    required this.groupId,
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
      ),
      GroupChatScreen(title: widget.title, groupId: widget.groupId),
      GroupCalendarScreen(title: widget.title, groupId: widget.groupId),
      GroupBoardScreen(title: widget.title, groupId: widget.groupId),
      // 다른 페이지 추가
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

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_rounded), label: "Main"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded), label: "Calendar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.note_alt_outlined), label: "Board"),
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
