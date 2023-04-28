import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtoon/models/book_model.dart';

//maxResults 말고는 수정하지 마세요.
//
class ApiService {
  final String baseUrl = "https://www.aladin.co.kr/ttb/api/ItemList.aspx?ttbkey";
  final String ttbkey = "ttbkimgi06281904001";
  final String maxResults = "20"; //최대 검색값
  final String searchOption = "QueryType=Bestseller&Cover=big&start=1&SearchTarget=Book&output=js&Version=20131101";

  Future<List<BookModel>> getTodaysToons() async {
    List<BookModel> bookInstances = [];
    final url = Uri.parse('$baseUrl=$ttbkey&$searchOption&maxResults=$maxResults');
    final response = await http.get(url);

    if (response.statusCode == 200) { 
      final books = jsonDecode(response.body);
      for (var book in books['item']) {
        bookInstances.add(BookModel.fromJson(book));
      }
      return bookInstances;
    }
    throw Error();
  }
}
