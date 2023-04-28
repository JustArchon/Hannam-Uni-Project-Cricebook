//책 커버 이미지와 책 이름 출력하는 위젯
import 'package:flutter/material.dart';

class Book extends StatelessWidget {
  final String title, thumb, id;

  const Book({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            width: 160,
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
              width: 160,
              height: 200,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 160,
            child: Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
