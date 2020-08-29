
import 'package:html/dom.dart';
import 'package:zyuedu/util/d_query.dart';

class SearchSource {
  String html;
  List<SearchItem> searchList = [];
  SearchSource(String html) {
    this.html = this.cleanLineBreak(html);
    this.genStruct();
  }

  void genStruct() {
    Document document = Document.html(this.html);
    String nameRuleString = "@grid.tr.@even[0].a:text";
    var name = DQuery(document).find(nameRuleString).doc as List;
    String urlRuleString = "@grid.tr.@even[0].a(href)";
    var url = DQuery(document).find(urlRuleString).doc as List;
    String authorRuleString = "@grid.tr.@even[1]:text";
    var author = DQuery(document).find(authorRuleString).doc as List;
    int resultLen = name.length;
    for (int i = 0; i < resultLen; i++) {
      this.searchList.add(SearchItem(name[i], url[i], author[i]));
    }
    var a = "剑来";
  }

  String cleanLineBreak(String str) {
    return str.replaceAll(new RegExp(r"[\r\n]"), "");
  }
}

class SearchItem {
  String name;
  String url;
  String author;
  SearchItem(this.name, this.url, this.author);
}