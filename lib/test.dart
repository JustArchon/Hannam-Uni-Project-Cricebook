import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:circle_book/models/book_model.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late Future<BookModel> book;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          "그룹 리스트",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  height: 200,
                  color: Colors.blue,
                ),
                Container(
                  height: 200,
                  color: Colors.red,
                ),
              ],
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      height: 300,
                      color: Colors.green,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 300,
                      color: Colors.yellow,
                      child: Wrap(
                        children: List.generate(
                          20,
                          (index) => Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey,
                            child: Center(
                              child: Text(
                                'Item $index',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
