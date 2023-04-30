import 'package:circle_book/models/book_model.dart';
import 'package:circle_book/services/api_services.dart';
import 'package:circle_book/widgets/books_widget.dart';
import 'package:flutter/material.dart';
//import 'package:circle_book/ex_webtoon/models/webtoon_model.dart';
//import 'package:circle_book/ex_webtoon/services/api_service.dart';
//import 'package:circle_book/ex_webtoon/widgets/webtoon_widget.dart';

class MainBooksScreen extends StatelessWidget {
  MainBooksScreen({super.key});

  //final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();
  final Future<List<BookModel>> bestSeller = ApiService().getBestSeller();

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
        future: bestSeller,
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
                    '주간 베스트셀러',
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

  Widget makeList(AsyncSnapshot<List<BookModel>> snapshot) {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 0.6,
      children: List.generate(
        snapshot.data!.length,
        (index) {
          var book = snapshot.data![index];
          return Book(
            id: book.id,
            title: book.title,
            thumb: book.thumb,
            description: book.description,
          );
        },
      ),
    );
  }
}
