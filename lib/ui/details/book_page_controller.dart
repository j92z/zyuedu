


class BookPageController {
  double nextPagePanX;
  double nextPagePanY;
  double lastPagePanX;

  String content;

  BookPageController({this.nextPagePanX, this.lastPagePanX, this.nextPagePanY}) {
    this.nextPagePanX = this.nextPagePanX == null ? 0.7 : this.nextPagePanX;
    this.nextPagePanY = this.nextPagePanY == null ? 0.6 : this.nextPagePanY;
    this.lastPagePanX = this.lastPagePanX == null ? 0.3 : this.lastPagePanX;
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
}

class PanType {
  static const int next = 3;
  static const int menu = 2;
  static const int last = 1;
}

