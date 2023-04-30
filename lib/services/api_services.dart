import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:circle_book/models/book_model.dart';

//카테고리 필터링
var filter = ['만화', '수험서', '대학교재', '참고서', '달력', '화집', '잡지', '게임'];

//maxResults 말고는 수정하지 마세요.
class ApiService {
  final String baseUrl =
      "https://www.aladin.co.kr/ttb/api/ItemList.aspx?ttbkey";
  final String ttbkey = "ttbkimgi06281904001";
  final String searchOption =
      "Cover=big&start=1&SearchTarget=Book&output=js&Version=20131101";
  String maxResults = "30"; //앱 설정 기본 검색값 값 변경시 함수내에서 바꿀것!!
  //이번주 베스트셀러 리스트 반환
  Future<List<BookModel>> getBestSeller() async {
    List<BookModel> bookInstances = [];
    String queryType = "Bestseller";
    final url = Uri.parse(
        '$baseUrl=$ttbkey&QueryType=$queryType&$searchOption&maxResults=$maxResults');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final books = jsonDecode(response.body);
      for (var book in books['item']) {
        bool isDetected = false;
        final temp = BookModel.fromJson(book);
        //필터링 부분
        for (String category in filter) {
          if (temp.categoryName.contains(category)) {
            isDetected = true;
            break;
          }
        }
        if (!isDetected) {
          bookInstances.add(temp);
        }
      }
      return bookInstances;
    }
    throw Error();
  }

  //주목할만한 신간 리스트 반환
  Future<List<BookModel>> getNewSpecial() async {
    List<BookModel> bookInstances = [];
    String queryType = "ItemNewSpecial";
    final url = Uri.parse(
        '$baseUrl=$ttbkey&QueryType=$queryType&$searchOption&maxResults=$maxResults');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final books = jsonDecode(response.body);
      for (var book in books['item']) {
        bool isDetected = false;
        final temp = BookModel.fromJson(book);
        //필터링 부분
        for (String category in filter) {
          if (temp.categoryName.contains(category)) {
            isDetected = true;
            break;
          }
        }
        if (!isDetected) {
          bookInstances.add(temp);
        }
      }
      return bookInstances;
    }
    throw Error();
  }

  //설정한 날(년 / 월 / 주) 베스트셀러 리스트 반환 사용예시: getBestSellerByWeek(2022, 5, 3) 2022년 5월 3주차 베스트셀러 리스트 반환
  Future<List<BookModel>> getBestSellerByWeek(
      String year, String month, String week) async {
    List<BookModel> bookInstances = [];
    String queryType = "QueryType=Bestseller";
    final url = Uri.parse(
        '$baseUrl=$ttbkey&$queryType&$searchOption&maxResults=$maxResults&Year=$year&Month=$month&Week=$week');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final books = jsonDecode(response.body);
      for (var book in books['item']) {
        bool isDetected = false;
        final temp = BookModel.fromJson(book);
        //필터링 부분
        for (String category in filter) {
          if (temp.categoryName.contains(category)) {
            isDetected = true;
            break;
          }
        }
        if (!isDetected) {
          bookInstances.add(temp);
        }
      }
      return bookInstances;
    }
    throw Error();
  }
}
