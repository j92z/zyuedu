
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
    var firstLineNum = firstHeight ~/ (fontSize * spaceSize);
    var lineNum = height ~/ (fontSize * spaceSize);
    double count = 0;
    bool equal = false;
    List<String> list = [];
    List<String> itemList = [];
    for (var k = 0; k < oneLine.length; k++) {
      var i = oneLine[k];
      if (i == " " || i == "." || i == ",") {
        count += 0.25;
      } else if (i == "“" || i == "”") {
        count += 0.5;
      } else if (i == "\n") {
        if (itemList.isNotEmpty) {
          itemList.add(i);
          list.add(itemList.join());
        }
        itemList = [];
        count = 0;
        continue;
      } else {
        count += 1;
      }
      if (count >= textNum) {
        if (count == textNum) {
          itemList.add(i + "\n");
          equal = true;
        }
        list.add(itemList.join());
        itemList = [];
        count = 0;
      }
      if (count == textNum - 1) {
        var nextII = oneLine[k+2]??"";
        if (nextII == "，" || nextII == "。" || nextII == "！" || nextII == "？") {
          itemList.add(i + "\n");
          equal = true;
          list.add(itemList.join());
          itemList = [];
          count = 0;
        }
      }
      if (!equal) {
        itemList.add(i);
      } else {
        equal = false;
      }
      if ((pages.length == 0 && list.length >= firstLineNum) || list.length >= lineNum) {
        pages.add(list.join());
        list = [];
      }
    }
    if (itemList.isNotEmpty) {
      list.add(itemList.join());
    }
    if (list.isNotEmpty) {
      list.add(List.filled(lineNum - list.length , "\n").join());
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

