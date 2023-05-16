//알라딘 API 메뉴얼 :
//https://docs.google.com/document/d/1mX-WxuoGs8Hy-QalhHcvuV17n50uGI2Sg_GHofgiePE/edit#heading=h.wzyr9o7mof2u

class BookModel {
  String title; //책제목
  String thumb; //책 커버 image
  String id; //isbn
  String description; //설명
  String categoryName; //카테고리
  String author; //지은이
  String publisher; //출판사
  String link;
  DateTime pubDate; //출판일

  BookModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        categoryName = json['categoryName'],
        author = json['author'],
        thumb = json['cover'],
        id = json['isbn13'],
        description = json['description'],
        publisher = json['publisher'],
        pubDate = DateTime.parse(json['pubDate']),
        link = json['link'];

  void replaceHTMLEntity() {
    description = description.replaceAll(
        RegExp(
          r'&lt',
        ),
        '<');
    description = description.replaceAll(
        RegExp(
          r'&gt',
        ),
        '>');
    description = description.replaceAll(
        RegExp(
          r'&nbsp',
        ),
        ' ');
    description = description.replaceAll(
        RegExp(
          r'&amp',
        ),
        '&');
    description = description.replaceAll(
        RegExp(
          r'&amp',
        ),
        '"');
    author = author.substring(0, author.indexOf('('));
    categoryName = categoryName.substring(
        categoryName.indexOf('>') + 1, categoryName.indexOf('>', 6));
  }
}
