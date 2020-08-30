import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:zyuedu/data/net/dio_utils.dart';
import 'package:zyuedu/data/sources/stuct.dart';
import 'package:zyuedu/util/d_query.dart';
import 'package:zyuedu/util/utils.dart';

import 'detail_source.dart';

class SearchSource {
  String html;
  String searchKey;
  bool exactQuery = false;
  List<SearchItem> searchList = [];
  SearchSource.fromKey(this.searchKey);

  SearchSource.fromHtml(String html) {
    this.html = Utils.cleanLineBreak(html);
    this.genContent();
  }

  SearchSource setExactQuery(bool exactQuery) {
    this.exactQuery = exactQuery;
    return this;
  }

  Future<SearchSource> getAsyncInfo() async {
    var a = "剑来";

    FormData data = new FormData.fromMap({
      "searchkey": this.searchKey
    });
    Map<String, dynamic> query = {};
    String url = "http://www.xbiquge.la/modules/article/waps.php";
    return await Sources()
        .search(url, queryParameters: query, data: data, method: Method.post)
        .then((json) {
          this.html = Utils.cleanLineBreak(json["data"]);
          this.genContent();
          return this;
    });
  }

  void genContent() {
    Document document = Document.html(this.html);
    String nameRuleString = "@grid.tr.@even[0].a:text";
    var name = DQuery(document).find(nameRuleString).doc as List;
    String urlRuleString = "@grid.tr.@even[0].a(href)";
    var url = DQuery(document).find(urlRuleString).doc as List;
    String authorRuleString = "@grid.tr.@even[1]:text";
    var author = DQuery(document).find(authorRuleString).doc as List;
    int resultLen = name.length;
    for (int i = 0; i < resultLen; i++) {
      if (this.exactQuery == null || (this.exactQuery && name[i] == this.searchKey) || !this.exactQuery) {
        this.searchList.add(SearchItem(name[i], url[i], author: author[i]));
      }
    }
  }
}

const DefaultCover = "http://www.xbiquge.la/files/article/image/15/15021/15021s.jpg";

class SearchItem {
  String name;
  String url;
  String author;
  String cover;
  String introduce;
  SearchItem(this.name, this.url, {this.author, this.cover, this.introduce}) {
    if (this.cover != null) {
      this.cover = Utils.convertImageUrl(this.cover);
    } else {
      this.cover = DefaultCover;
    }
    this.getInfo();
  }

  void getInfo() async {
    await DetailSource.fromUrl(this.url)
        .getAsyncInfo()
        .then((item) {
        this.cover = item.cover;
        this.introduce = item.introduce;
        this.author = item.author;
    });
  }

}