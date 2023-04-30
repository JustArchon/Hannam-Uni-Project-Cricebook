import 'package:flutter/material.dart';
import 'package:circle_book/screens/group_main_screen.dart';

class MainGroupScreen extends StatelessWidget {
  const MainGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MyApp",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CircleBook",
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,

        //toolbarHeight: 50,

        // 좌측 아이콘 버튼
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_outlined),
        ),

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_outlined), // 그룹 검색 아이콘 생성
            onPressed: () {
              // 아이콘 버튼 실행
              //print('Group search button is clicked');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings), // 그룹 설정 아이콘 생성
            onPressed: () {
              // 아이콘 버튼 실행
              //print('Group settings button is clicked');
            },
          ),
        ],
      ),

      // 참여중인 그룹들 리스트 출력
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupMainScreen(),
                fullscreenDialog: true,
              ),
            );
            */
          },
          child: const Text("Go to Group Main Page"),
        ),
      ),
    );
  }
}
