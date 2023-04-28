class BookModel {
  final String title; //책제목
  final String thumb; //책 커버 image
  final String id; //isbn
  final String description; //설명
  final String categoryName; //카테고리
  final String author; //지은이
  
  BookModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        categoryName = json['categoryName'],
        author = json['author'],
        thumb = json['cover'],
        id = json['isbn13'],
        description = json['description'];
}
