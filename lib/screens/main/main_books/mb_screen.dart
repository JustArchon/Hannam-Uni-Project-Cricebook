import 'package:circle_book/models/book_model.dart';
import 'package:circle_book/services/api_services.dart';
import 'package:circle_book/widgets/books_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class MainBooksScreen extends StatelessWidget {
  MainBooksScreen({super.key});

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
              String collectionName = "CircleBookGroupList"; // 생성하고자 하는 컬렉션 이름

              FirebaseFirestore.instance
                  .collection(collectionName)
                  .get()
                  .then((snapshot) {
                if (snapshot.docs.isEmpty) {
                  // 컬렉션이 존재하지 않는 경우, 새로운 컬렉션 생성
                  List<String> ti = [];
                  for (int i = 0; i < 3; i++) {
                    ti.add(randomAlphaNumeric(28));
                    FirebaseFirestore.instance
                        .collection('CircleBookUserList')
                        .doc(ti[i])
                        .set({
                      "Username": "testUser$i",
                      "Useremail": "testUser$i@naver.com",
                      "UserUID": ti[i],
                    });
                  }
                  String? tm1, tm2, tm3;
                  String? isbn, bn, bt, bd;
                  for (int i = 0; i < 3; i++) {
                    switch (i) {
                      case 0:
                        tm1 = ti[i];
                        tm2 = ti[i + 1];
                        tm3 = ti[i + 2];
                        break;
                      case 1:
                        tm1 = ti[i];
                        tm2 = ti[i + 1];
                        tm3 = ti[i - 1];
                        break;
                      case 2:
                        tm1 = ti[i];
                        tm2 = ti[i - 2];
                        tm3 = ti[i - 1];
                        break;
                    }
                    for (int x = 0; x < 3; x++) {
                      switch (x) {
                        case 0:
                          isbn = "9791168473690";
                          bn = "세이노의 가르침";
                          bt =
                              "https://image.aladin.co.kr/product/30929/51/cover/s302832892_1.jpg";
                          bd =
                              "2000년부터 발표된 그의 주옥같은 글들. 독자들이 자발적으로 만든 제본서는 물론, 전자책과 앱까지 나왔던 《세이노의 가르침》이 드디어 전국 서점에서 독자들을 마주한다. 여러 판본을 모으고 저자의 확인을 거쳐 최근 생각을 추가로 수록하였다. 정식 출간본에만 추가로 수록된 글들은 목차와 본문에 별도 표시하였다.";
                          break;
                        case 1:
                          isbn = "9791190299770";
                          bn = "모든 삶은 흐른다";
                          bt =
                              "https://image.aladin.co.kr/product/31381/47/cover/k292832005_1.jpg";
                          bd =
                              "2022년 프랑스 최고의 철학과 교수로 꼽힌 로랑스 드빌레르의 인문에세이로 출간 후 프랑스 현지 언론의 극찬을 받으며 아마존 베스트셀러에 올랐다. 저자는 낯선 ‘인생’을 제대로 ‘항해’하려면 바다를 이해하라고 조언한다.";
                          break;
                        case 2:
                          isbn = "9791188331888";
                          bn = "사장학개론";
                          bt =
                              "https://image.aladin.co.kr/product/31325/1/cover/k832832683_3.jpg";
                          bd =
                              "한국과 미국, 전 세계를 오가며 ‘사장을 가르치는 사장’으로 알려진 『돈의 속성』의 저자 김승호 회장의 신간이다. 평생 사장으로 살아온 그의 경영철학 모두를 10여 년에 걸쳐 정리해 온 그는, 이번 『사장학개론』 책을 통해 120가지 주제로 그 내용을 모두 담아 완성했다.";
                          break;
                      }
                      String groupId = FirebaseFirestore.instance
                          .collection('CircleBookGroupList')
                          .doc()
                          .id;

                      FirebaseFirestore.instance
                          .collection('CircleBookGroupList')
                          .doc('$i의 그룹 $x')
                          .set({
                        'groupId': groupId, // 이 부분이 새롭게 추가된 부분입니다.
                        'BookData': [
                          isbn,
                          bn,
                          bt,
                          bd,
                        ],
                        'GroupName': '$i의 그룹 $x',
                        'GroupLeader': tm1,
                        'GroupMembers': [
                          tm1,
                          tm2,
                          tm3,
                        ],
                        'numMembers': x + 4,
                        'readingPeriod': x + 7,
                        'certificationPeriod': x + 1,
                        'passCount': x,
                        'discussionCount': x,
                        'notice': 'testUser$i의 $bn 그룹입니다.',
                        'Groupstate': 1,
                        'timestamp':
                            FieldValue.serverTimestamp(), // 타임스탬프 필드를 추가합니다.
                      });
                    }
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('테스트용 데이터가 생성되었습니다.')),
                  );
                } else {
                  // 컬렉션이 이미 존재하는 경우, 아무것도 하지 않음
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('이미 생성되었습니다.')),
                  );
                }
              }).catchError((error) {
                //print("Error checking if collection exists: $error");
              });
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
                  /*
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.green, // 배경색을 초록색으로 설정
                      ),
                      child: makeList(snapshot),
                    ),
                  ),
                  */
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
