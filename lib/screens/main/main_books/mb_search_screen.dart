import 'package:flutter/material.dart';
import 'package:circle_book/models/book_model.dart';
import 'package:circle_book/services/api_services.dart';
import 'package:circle_book/widgets/books_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textController = TextEditingController();
  String searchData = "";

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void onSearch(String text) {
    setState(() {
      searchData = text;
    });
  }

  Widget resultScreen() {
    Future<List<BookModel>> result = ApiService().searchByName(searchData);
    return FutureBuilder(
      future: result,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text("검색결과가 없습니다."),
          );
        }
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
              Expanded(child: makeList(snapshot)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xff6DC4DB),
          foregroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      hintText: '검색 할 책 이름을 입력해주세요',
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      onSearch(textController.text);
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              IconButton(
                icon: const Icon(Icons.search_outlined),
                onPressed: () {
                  onSearch(textController.text);
                },
              ),
            ],
          ),
        ),
        body: resultScreen());
  }
}

Widget makeList(AsyncSnapshot<List<BookModel>> snapshot) {
  return GridView.count(
    crossAxisCount: 3,
    //padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    //mainAxisSpacing: 20,
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
  );
}
