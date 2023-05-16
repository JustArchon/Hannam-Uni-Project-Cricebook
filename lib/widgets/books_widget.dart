import 'package:flutter/material.dart';
import 'package:circle_book/screens/main/main_books/mb_detail_screen.dart';

class Book extends StatelessWidget {
  final String id,
      title,
      thumb,
      description,
      categoryName,
      author,
      publisher,
      link;
  final DateTime pubDate;

  const Book({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
    required this.description,
    required this.categoryName,
    required this.author,
    required this.publisher,
    required this.pubDate,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BooksDetailScreen(
              id: id,
              title: title,
              thumb: thumb,
              description: description,
              categoryName: categoryName,
              author: author,
              publisher: publisher,
              pubDate: pubDate,
              link: link,
            ),
            fullscreenDialog: true, // 화면 생성 방식
          ),
        );
      },
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Column(
          children: [
            Hero(
              tag: id,
              child: Container(
                height: 140,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: const Offset(13, 7),
                        color: Colors.black.withOpacity(0.2),
                      )
                    ]),
                child: Image.network(
                  thumb,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 160,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "SsurroundAir",
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
