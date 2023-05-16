import 'package:circle_book/models/book_model.dart';
import 'package:circle_book/screens/main/main_books/mb_search_screen.dart';
import 'package:circle_book/services/api_services.dart';
import 'package:circle_book/widgets/books_widget.dart';
import 'package:flutter/material.dart';

class MainBooksScreen extends StatelessWidget {
  MainBooksScreen({super.key});

  final Future<List<BookModel>> bestSeller = ApiService().getBestSeller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: Image.asset('assets/icons/아이콘_흰색(512px).png'),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: const Color(0xff6DC4DB),
        foregroundColor: Colors.white,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: bestSeller,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '주간 베스트셀러',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Ssurround",
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.8,
                        children: List.generate(
                          snapshot.data!.length,
                          (index) {
                            var book = snapshot.data![index];
                            return Book(
                              id: book.id,
                              title: book.title,
                              thumb: book.thumb,
                              description: book.description,
                              categoryName: book.categoryName,
                              author: book.author,
                              publisher: book.publisher,
                              pubDate: book.pubDate,
                              link: book.link,
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
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
}
