import 'package:flutter/material.dart';
import 'package:circle_book/ex_webtoon/models/webtoon_model.dart';
import 'package:circle_book/ex_webtoon/services/api_service.dart';
import 'package:circle_book/ex_webtoon/widgets/webtoon_widget.dart';

class MainBooksScreen extends StatelessWidget {
  MainBooksScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          "CircleBook",
          style: TextStyle(
            fontSize: 24,
          ),
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

        // 우측 아이콘 버튼들
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_outlined), // 책 검색 아이콘 생성
            onPressed: () {
              // 아이콘 버튼 실행
              //print('Book search button is clicked');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings), // 책 설정 아이콘 생성
            onPressed: () {
              // 아이콘 버튼 실행
              //print('Book settings button is clicked');
            },
          ),
        ],
      ),

      // 책 리스트 뷰 써서 보이게 하기
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    '@@월 베스트셀러',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(child: makeList(snapshot)),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    '@@@@년 베스트셀러',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(child: makeList(snapshot)),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    '@@장르 추천 도서',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(child: makeList(snapshot)),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        //print(index);
        var webtoon = snapshot.data![index];
        return Webtoon(
          id: webtoon.id,
          title: webtoon.title,
          thumb: webtoon.thumb,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 20),
    );
  }
}
