import 'package:flutter/material.dart';
import 'package:circle_book/screens/main_books/mb_screen.dart';
import 'package:circle_book/screens/main_group_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:circle_book/Controller/CircleBookController.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen>{
  @override
  void initState() {
    super.initState();
    CircleBookController().authCatch();
  }
  @override
  Widget build(BuildContext context) {
    Get.put(CircleBookController());
    return MaterialApp(
      title: "MyApp",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // ��,�� ��� �巡�� �۵��ϰ��ϴ� �ڵ�
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  
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
  int _selectedIndex = 0; // ó���� ���� ȭ�� ����

  // �̵��� ������
  final List _pages = [
    MainBooksScreen(),
    const MainGroupScreen(),
    MainBooksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _pages[_selectedIndex], // �������� ����
        ),
        bottomNavigationBar: BottomNavigationBar(
          //type: BottomNavigationBarType.fixed, // bottomNavigationBar item�� 4�� �̻��� ���

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
    // state ����
    setState(() {
      _selectedIndex = index;
    });
  }
}