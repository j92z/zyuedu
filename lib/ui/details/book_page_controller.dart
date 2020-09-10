


import 'package:flutter/cupertino.dart';

class BookPageController {

  static final double heightWithRatio = 38 / 31;

  double nextPagePanX;
  double nextPagePanY;
  double lastPagePanX;

  int pageNum = 1;
  List<String> pages = [];

  BookPageController({this.nextPagePanX, this.lastPagePanX, this.nextPagePanY}) {
    this.nextPagePanX = this.nextPagePanX == null ? 0.7 : this.nextPagePanX;
    this.nextPagePanY = this.nextPagePanY == null ? 0.6 : this.nextPagePanY;
    this.lastPagePanX = this.lastPagePanX == null ? 0.3 : this.lastPagePanX;
  }

  void createContent(String content, width, height, titleHeight, fontSize, spaceSize, back) {
    pages = [];
    var oneLine = content.split("");
    var firstHeight = height - titleHeight;
    var textNum = width ~/ fontSize;
    var firstLineNum = firstHeight ~/ (fontSize * heightWithRatio + spaceSize);
    var lineNum = height ~/ (fontSize * heightWithRatio + spaceSize);
    double count = 0;
    List<String> list = [];
    List<String> itemList = [];
    print(content.substring(content.length - 100));
    for (var i in oneLine) {
      if (i == " ") {
        count += 0.25;
        if (count >= textNum) {
          list.add(itemList.join());
          itemList = [];
          count = 0;
        } else {
          itemList.add(i);
        }
      } else if (i == "\n") {
        itemList.add(i);
        list.add(itemList.join());
        itemList = [];
        count = 0;
      } else {
        count += 1;
        if (count >= textNum) {
          list.add(itemList.join());
          itemList = [];
          count = 0;
        } else {
          itemList.add(i);
        }
      }
      if ((pages.length == 0 && list.length >= firstLineNum) || list.length >= lineNum) {
        pages.add(list.join());
        list = [];
      }
    }
    print(itemList);
    print(list.length);
    print(firstLineNum);
    print(lineNum);
    if (itemList.isNotEmpty) {
      list.add(itemList.join());
    }
    if (list.isNotEmpty) {
      pages.add(list.join());
    }
    pageNum = back ? pages.length : 1;
  }

  String content() {
    int i = pageNum >= pages.length ? pages.length : pageNum;
    i = i <= 1 ? 1 : i;
    return pages[i - 1]??'';
  }

  String next() {
    if (!isLast()) {
      pageNum++;
    }
    return content();
  }

  String previous() {
    if (!isFirst()) {
      pageNum--;
    }
    return content();
  }

  int getPanType(double x, double y) {
    if (x >= nextPagePanX || y >= nextPagePanY) {
      return PanType.next;
    } else if (x >= lastPagePanX) {
      return PanType.menu;
    } else {
      return PanType.last;
    }
  }

  bool isFirst() {
    return this.pageNum == 1;
  }

  bool isLast() {
    return this.pageNum >= pages.length;
  }
}

class PanType {
  static const int next = 3;
  static const int menu = 2;
  static const int last = 1;
}

