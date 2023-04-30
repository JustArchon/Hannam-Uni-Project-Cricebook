import 'package:flutter/material.dart';

class GroupMainScreen extends StatefulWidget {
  final String id, title, thumb;

  const GroupMainScreen({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
  });

  @override
  State<GroupMainScreen> createState() => _GroupMainScreenState();
}

class _GroupMainScreenState extends State<GroupMainScreen> {
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
          const SizedBox(
            height: 40,
          ),
          Hero(
              tag: widget.id,
              child: Container(
                width: 200,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      offset: const Offset(10, 10),
                      color: Colors.black.withOpacity(0.3),
                    )
                  ],
                ),
                child: Image.network(widget.thumb),
              )),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "독서 목표 기간",
            style: TextStyle(fontSize: 30),
          ),
          // 그룹 내 독서 목표 기간 데이터 가져올 예정
          const Text(
            "2023-04-01 ~ 2023-04-14",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "공지사항",
            style: TextStyle(fontSize: 30),
          ),
          // 그룹 내 공지사항 데이터 가져올 예정
          const Text(
            "토론 7일, 13일 오후 8시에\n진행 예정입니다.",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
