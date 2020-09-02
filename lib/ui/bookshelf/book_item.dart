import 'dart:convert' as convert;
class BookItem {

  BookItem(this.name, this.author, this.cover, this.readProgress, this.url, this.offset, this.chaptersIndex) {
    print("kkkk");
    this.bookId = BookItem.createBookId(name, author);
  }

  String bookId;
  String name;
  String author;
  String cover;
  String readProgress;
  String url;
  double offset;
  int chaptersIndex;

  BookItem.fromMap(Map<String, dynamic> map) {
    this.name = map["name"] as String;
    this.author = map["author"] as String;
    this.cover = map["cover"] as String;
    this.readProgress = map["readProgress"] as String;
    this.url = map["url"] as String;
    this.offset = map["offset"] as double;
    this.chaptersIndex = map["chaptersIndex"] as int;
    this.bookId = map["bookId"] == null || map["bookId"] == "" ?
      BookItem.createBookId(this.name, this.author) : map["bookId"] as String;

  }

  static String createBookId(String name, String author) {
    var content = convert.utf8.encode(name??"" + "@" + author??"");
    return convert.base64Encode(content);
  }

  Map<String, dynamic> toMap() {
    print(url);
    return <String, dynamic>{
      "name": name,
      "author": author,
      "cover": cover,
      "readProgress": readProgress,
      "url": url,
      "offset": offset,
      "chaptersIndex": chaptersIndex,
      "bookId": bookId,
    };
  }
}
