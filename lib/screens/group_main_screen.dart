import 'package:flutter/material.dart';

class GroupMainScreen extends StatelessWidget {
  const GroupMainScreen({super.key});

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

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              print('Group menu button is clicked');
            },
          ),
        ],
      ),

      // body: // 참여중인 그룹들 리스트 출력
    );
  }
}
