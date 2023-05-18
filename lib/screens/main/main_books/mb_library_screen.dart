import 'package:circle_book/models/library_model.dart';
import 'package:flutter/material.dart';
import 'package:circle_book/services/api_library.dart';

class LibraryScreen extends StatefulWidget {
  final String id;
  const LibraryScreen({
    super.key,
    required this.id,
  });
  @override
  State<LibraryScreen> createState() => _LibraryScreen();
}

class _LibraryScreen extends State<LibraryScreen> {
  final cities = [
    '전국',
    '서울',
    '부산',
    '대구',
    '인천',
    '광주',
    '대전',
    '울산',
    '경기',
    '강원',
    '충북',
    '충남',
    '경북',
    '경남',
    '전북',
    '전남',
    '제주',
  ];
  String selectCity = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      selectCity = cities[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xff6DC4DB),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "소장 도서관 리스트",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Ssurround",
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          DropdownButton(
              style: const TextStyle(
                fontSize: 15,
                fontFamily: "Ssurround",
                letterSpacing: 1.0,
              ),
              value: selectCity,
              items: cities
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectCity = value!;
                });
              }),
          Expanded(
            child: resultScreen(),
          )
        ],
      ),
    );
  }

  Widget libraryList(LibraryModel library) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff6DC4DB)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Text(
                '${library.name}<${library.local}>',
                style: const TextStyle(
                  fontSize: 20,
                  letterSpacing: 1.0,
                  fontFamily: "SsurroundAir",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget resultScreen() {
    Future<List<LibraryModel>> result =
        ApiLibrary().getLibraryList(widget.id, selectCity);
    return FutureBuilder(
      future: result,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text("소장하고있는 도서관이 없습니다.",
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 1.0,
                  fontFamily: "SsurroundAir",
                  fontWeight: FontWeight.bold,
                )),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(5),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return libraryList(snapshot.data![index]);
          },
        );
      },
    );
  }
}
