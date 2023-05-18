import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:circle_book/models/library_model.dart';

class ApiLibrary {
  final String baseUrl = "https://nl.go.kr/kolisnet/openApi/open.php";

  Future<List<LibraryModel>> getLibraryList(String isbn, String city) async {
    List<LibraryModel> libraryInstances = [];
    String recKey = await getrecKey(isbn);
    Uri url = Uri.parse('$baseUrl?rec_key=$recKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var temp = Xml2Json()..parse(response.body);
      var responseBody = jsonDecode(temp.toParker());
      for (var temp in responseBody['METADATA']['HOLDINFO']) {
        var library = LibraryModel.fromJson(temp);
        library.localEdit();
        if (city == "전국") {
          libraryInstances.add(library);
        } else {
          if (library.local == city) {
            libraryInstances.add(library);
          }
        }
      }
    } else {
      throw Error();
    }
    return libraryInstances;
  }

  Future<String> getrecKey(String isbn) async {
    Uri url = Uri.parse('$baseUrl?per_page=1&gubun1=ISBN&code1=$isbn');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var temp = Xml2Json()..parse(response.body);
      var responseBody = jsonDecode(temp.toParker());
      String recKey = responseBody['METADATA']['RECORD']['REC_KEY'];
      return recKey;
    } else {
      throw Error();
    }
  }
}
