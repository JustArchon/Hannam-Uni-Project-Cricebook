class LibraryModel {
  String name; //도서관 이름
  String local; //도서관 소재 위치
  String id;

  LibraryModel.fromJson(Map<String, dynamic> json)
      : name = json['LIB_NAME'],
        local = json['LOCAL'],
        id = json['LIB_CODE'];

  void localEdit() {
    local = local.substring(0, 2);
  }
}

class LibraryInfoModel {
  String name;
  String tel;
  String address;
  String id;

  LibraryInfoModel.fromJson(Map<String, dynamic> json)
      : name = json['LIB_NAME'],
        tel = json['TEL'],
        address = json['ADDRESS'],
        id = json['LIB_CODE'];
}
