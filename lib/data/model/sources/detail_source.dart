// import 'dart:html';

import 'package:html/dom.dart';
import 'package:zyuedu/data/sources/stuct.dart';
import 'package:zyuedu/util/d_query.dart';
import 'package:zyuedu/util/utils.dart';

class DetailSource {
  String html;
  String url;
  String name;
  String author;
  String cover;
  String introduce;
  String category;
  List<ChapterItem> chapter = [];

  DetailSource.fromUrl(this.url);

  DetailSource.fromHtml(this.html) {
    this.html = Utils.cleanLineBreak(this.html);
    this.genContent();
  }

  Future<DetailSource> getAsyncInfo() async {
    return await Sources()
        .detail(this.url)
        .then((json) {
      this.html = Utils.cleanLineBreak(json['data']);
      this.genContent();
      return this;
    });
  }

  void genContent() {
    Document document = Document.html(this.html);
    String nameRuleString = "#info.h1:text";
    this.name = DQuery(document).find(nameRuleString).doc;
    String authorRuleString = "meta[property=\"og:novel:author\"](content)";
    this.author = DQuery(document).find(authorRuleString).doc;
    String coverRuleString = "meta[property=\"og:image\"](content)";
    this.cover = DQuery(document).find(coverRuleString).doc;
    String introRuleString = "meta[property=\"og:description\"](content)";
    this.introduce = DQuery(document).find(introRuleString).doc;
    String cateRuleString = "meta[property=\"og:novel:category\"](content)";
    this.category = DQuery(document).find(cateRuleString).doc;
    String chapterNameRuleString = "#list.a:text";
    var chapterName = DQuery(document).find(chapterNameRuleString).doc as List;
    String chapterUrlRuleString = "#list.a(href)";
    var chapterUrl = DQuery(document).find(chapterUrlRuleString).doc as List;
    int chapterLen = chapterName.length;
    for (int i = 0; i < chapterLen; i++) {
      this.chapter.add(ChapterItem(chapterName[i], chapterUrl[i]));
    }
  }
}

class ChapterItem {
  String name;
  String url;
  ChapterItem(this.name, this.url);
}