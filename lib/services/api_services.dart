import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:circle_book/models/book_model.dart';

//카테고리 필터링
var filter = ['만화', '수험서', '대학교재', '참고서', '달력', '화집', '잡지', '게임', '어린이', '여행', '외국어', '유아', '전집', '컴퓨터', 'Gift'];
var category = ['2105', '74', '1', '656', '987'];
//고전, 역사, 소설/시/희곡, 인문학, 과학

//maxResults 말고는 수정하지 마세요.
class ApiService {
  final String ttbkey = "ttbkimgi06281904001";
  final String searchOption =
      "Cover=big&start=1&SearchTarget=Book&output=js&Version=20131101";
  String maxResults = "30"; //앱 설정 기본 검색값 값 변경시 함수내에서 바꿀것!

  //이번주 베스트셀러 리스트 반환
  Future<List<BookModel>> getBestSeller() async {
    List<BookModel> bookInstances = [];
    Uri url = Uri.parse(
        'https://www.aladin.co.kr/ttb/api/ItemList.aspx?ttbkey=$ttbkey&QueryType=Bestseller&$searchOption&maxResults=$maxResults');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final books = jsonDecode(response.body);
      for (var book in books['item']) {
        bool isDetected = false;
        var temp = BookModel.fromJson(book);
        //필터링 부분
        for (String category in filter) {
          if (temp.categoryName.contains(category)) {
            isDetected = true;
            break;
          }
        }
        if (!isDetected) {
          temp.replaceHTMLEntity();
          bookInstances.add(temp);
        }
      }
      return bookInstances;
    }
    throw Error();
  }

  //원하는 카테고리만 가져와서 베스트셀러 구성
  Future<List<BookModel>> makeBestSellerList() async {
    List<BookModel> bookInstances = [];
    maxResults = "6";

    for(String categoryNumber in category) {
      Uri url = Uri.parse(
      'https://www.aladin.co.kr/ttb/api/ItemList.aspx?ttbkey=$ttbkey&QueryType=Bestseller&$searchOption&CategoryId=$categoryNumber&maxResults=$maxResults');
      final response = await http.get(url);

      if(response.statusCode == 200) {
        var books = json.decode(response.body);
        for(var book in books['item']) {
          var temp = BookModel.fromJson(book);
          temp.replaceHTMLEntity();
          bookInstances.add(temp);
        }
      }
      else
      {
        throw Error();
      }
    }
    return bookInstances;
  }
  
  //isbn으로 검색해서 이미지 가져오는 기능
  Future<String> getThumb(String bookISBN) async {
    Uri url = 
      Uri.parse('http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=$ttbkey&itemIdType=ISBN&ItemId=$bookISBN&Cover=Big&output=js&Version=20131101');

    final response = await http.get(url);

    if(response.statusCode == 200) {
      final book = BookModel.fromJson(jsonDecode(response.body));
      return book.thumb;
    }
    throw Error();
  }

  Future<List<BookModel>> searchByName(String name) async {
    List<BookModel> bookInstances = [];
    Uri url = Uri.parse(
      'https://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=$ttbkey&Query=$name&QueryType=Title&MaxResults=$maxResults&Cover=Big&output=js&version=20131101');
    
    final response = await http.get(url);

    if(response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      for(var temp in responseBody['item']) {
        var book = BookModel.fromJson(temp);
        book.replaceHTMLEntity();
        bookInstances.add(book);
      }
      return bookInstances;
    }
    throw Error();
  }
}
