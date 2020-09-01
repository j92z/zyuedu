import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zyuedu/ui/bookshelf/book_item.dart';

///@author longshaohua

class DbHelper {
  final String _tableName = "Bookshelf";

  Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await _initDb();
    return _db;
  }

  //初始化数据库
  _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "books.db");
    print(path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // When creating the db, create the table
  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $_tableName("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "cover TEXT,"
        "readProgress TEXT,"
        "url TEXT,"
        "bookId TEXT,"
        "offset DOUBLE,"
        "chaptersIndex INTEGER)");
    print("Created tables");
  }

  /// 添加书籍到书架
  Future<int> addBookshelfItem(BookItem item) async {
    print("addBookshelfItem = ${item.bookId}");
    var dbClient = await db;
    int res = await dbClient.insert("$_tableName", item.toMap());
    return res;
  }

  /// 根据 id 查询判断书籍是否存在书架
  Future<BookItem> queryBooks(String bookId) async {
    var dbClient = await db;
    var result = await dbClient
        .query(_tableName, where: "bookId = ?", whereArgs: [bookId]);
    if (result != null && result.length > 0) {
     return BookItem.fromMap(result[0]);
    }
    return null;
  }

  /// 书架根据 id 移除书籍
  Future<int> deleteBooks(String id) async {
    var dbClient = await db;
    int res =
        await dbClient.delete(_tableName, where: "bookId = ?", whereArgs: [id]);
    print("deleteItem = $res");
    return res;
  }

  /// 查询加入书架的所有书籍
  Future<List> getTotalList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $_tableName");
    return result.toList();
  }

  /// 更新书籍进度
  Future<int> updateBooks(BookItem user) async {
    var dbClient = await db;
    return await dbClient.update(_tableName, user.toMap(),
        where: "bookId = ?", whereArgs: [user.bookId]);
  }


  /// 关闭
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}