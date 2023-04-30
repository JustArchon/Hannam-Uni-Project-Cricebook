import 'package:flutter/material.dart';

class GroupChatScreen extends StatefulWidget {
  final String id, title, thumb;

  const GroupChatScreen({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "그룹명",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: <Widget>[
          // 그룹 방 내 상단 메뉴 버튼 예정
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              //print('Group menu button is clicked');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 10,
                  bottom: 10,
                ),
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  color: Colors.lightGreen,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "도서명 : ${widget.title}",
                      style: const TextStyle(fontSize: 20),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // 그룹 내 데이터 가져올 예정
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "그룹 인원 (04 / 04)",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "토론 횟수 (01 / 02)",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "독서 기간 (11 / 14)",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "인증 기간 (02 / 03)",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 기본 생성 채팅방 버튼
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: const BeveledRectangleBorder(),
                  backgroundColor: Colors.blue[400],
                  padding: const EdgeInsets.only(
                    left: 50,
                    right: 50,
                    top: 30,
                    bottom: 30,
                  ),
                ),
                child: const Text(
                  "[ 그룹 채팅방 ]",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: const BeveledRectangleBorder(),
                  backgroundColor: Colors.blue[400],
                  padding: const EdgeInsets.only(
                    left: 50,
                    right: 50,
                    top: 30,
                    bottom: 30,
                  ),
                ),
                child: const Text(
                  "[ 독서 토론 채팅방 ]",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              // 추가 생성 채팅방 버튼
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: const BeveledRectangleBorder(),
                  backgroundColor: Colors.red[300],
                  padding: const EdgeInsets.only(
                    left: 50,
                    right: 50,
                    top: 30,
                    bottom: 30,
                  ),
                ),
                child: const Text(
                  "[ 그룹원1 과의 채팅 ]",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ],
          ),
          // 채팅방 추가 생성 버튼
          Center(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 50,
            ),
          ),
        ],
      ),
    );
  }
}
