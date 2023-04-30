import 'package:flutter/material.dart';

class GroupBoardScreen extends StatefulWidget {
  final String id, title, thumb;

  const GroupBoardScreen({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
  });

  @override
  State<GroupBoardScreen> createState() => _GroupBoardScreenState();
}

class _GroupBoardScreenState extends State<GroupBoardScreen> {
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
                    Row(
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
                    Row(
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
            children: [
              // 채팅방들 기능 구현 예정
              Container(
                padding: const EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 50,
                  bottom: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.blue[200],
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                          top: 30,
                          bottom: 30,
                        ),
                      ),
                      child: const Text(
                        "[ 인증 게시판 ]",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.yellow[200],
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                          top: 30,
                          bottom: 30,
                        ),
                      ),
                      child: const Text(
                        "[ 독후감 게시판 ]",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.green[200],
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                          top: 30,
                          bottom: 30,
                        ),
                      ),
                      child: const Text(
                        "[ 자유 게시판 ]",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                          top: 30,
                          bottom: 30,
                        ),
                      ),
                      child: const Text(
                        "[ 익명 질문 게시판 ]",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
