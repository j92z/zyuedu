import 'package:html/dom.dart';
import 'package:zyuedu/data/model/sources/detail_source.dart';
import 'package:zyuedu/data/sources/stuct.dart';
import 'package:zyuedu/util/utils.dart';
import 'package:zyuedu/util/d_query.dart';

class ChapterSource {
  ChapterItem chapter;
  String html;
  String content;

  ChapterSource(this.chapter);

  Future<ChapterSource> getAsyncInfo() async {
    return await Sources()
        .chapter(this.chapter.uri.toString())
        .then((json) {
      this.html = Utils.cleanLineBreak(json['data']);
      this.genContent();
      return this;
    });
  }

  void genContent() {
    Document document = Document.html(this.html);
    String contentRuleString = "#content:innerHtml";
    this.content = DQuery(document).find(contentRuleString).doc;
    this.content = this.content.replaceAll(RegExp("&nbsp;&nbsp;"), "    ").replaceAll(RegExp("<br><br>"), "\n").replaceAll(RegExp("<p>.*?</p>"), "");
  }
}