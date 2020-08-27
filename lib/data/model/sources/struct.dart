import 'package:flutter_books/data/model/sources/rule.dart';
import 'package:html/dom.dart';

import 'package:flutter_books/util/regs.dart';

class SourcesStruct {
  String html;
  HtmlNode body;
  SourcesStruct(String html) {
    this.html = this.cleanLineBreak(html);
    this.genStruct();
  }

  void genStruct() {
    Document document = Document.html(this.html);
    List<String> rules = ["table.@fasdfasdf.qqqq[3].qwdw[name=333]"];
    SourcesRule("table.@fasdfasdf.qqqq[3].qwdw[name=333].@hh[3].#asdfas[h=1]");
    // rules.forEach((rule) {
    //   print(rule);
    // });
    // var eles = document.getElementsByTagName("table");

    // div.forEach((element) {
    //   print(element.innerHtml);
    // });
    var a = "剑来";
  }

  String cleanLineBreak(String str) {
    return str.replaceAll(new RegExp(r"[\r\n]"), "");
  }
}


class HtmlNode {
  String name;
  List<String> className;
  Map<String, String> attr;
  List<dynamic> children;
  String content;
}