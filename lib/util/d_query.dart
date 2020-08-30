import 'package:html/dom.dart';

class DQuery {
  dynamic doc;

  DQuery(dynamic doc) {
    if (doc is List<Element> || doc is Element || doc is Document || doc is List || doc is String) {
      this.doc = doc;
    } else {
      this.doc = null;
    }
  }

  dynamic find(String selector) {
    if (this.doc != null) {
      List<String> ruleList = getRuleList(selector);
      ruleList.forEach((rule) {
          int tagType = SelectorTag.get(rule);
          int propType = SelectorProp.get(rule);
          if (tagType != SelectorTag.em || propType != SelectorProp.em) {
            String tag = SelectorTag.prefixMap[tagType] + SelectorTag.getTag(rule);
            if (propType == SelectorProp.child) {
              int child = SelectorProp.getChild(rule);
              this.doc = this.query(this.doc, tag, child: child);
            } else {
              if (propType == SelectorProp.prop) {
                TagProp prop = SelectorProp.getProp(rule);
                tag += "[" + prop.key + "=" + prop.value + "]";
              }
              this.doc = this.query(this.doc, tag);
            }
          }
      });
      int attrType = SelectorAttr.get(selector);
      if (attrType == SelectorAttr.met || attrType == SelectorAttr.attr) {
        String attrStr = SelectorAttr.getAttr(selector);
        if (attrStr != null) {
          this.doc = this.attr(this.doc, attrStr, attrType);
        }
      }
    }
    return DQuery(this.doc);
  }

  dynamic query(document, String selector, {int child}) {
    // print(document.runtimeType.toString());
    if (document is Element || document is Document) {
      if (child != null) {
        List<Element> result = document.querySelectorAll(selector);
        if (result.length >= child + 1) {
          return result[child];
        }
      } else {
        List<Element> result = document.querySelectorAll(selector);
        if (result.length == 1) {
          return result[0];
        } else if (result.length > 1) {
          return result;
        }
      }
    } else if (document is List) {
      List result = [];
      for (final d in document) {
        if (d == null) {
          continue;
        }
        var temp = this.query(d, selector, child: child);
        if (temp != null) {
          result.add(temp);
        }
      }
      if (result.length == 1) {
        return result[0];
      } else if (result.length > 1) {
        return result;
      }
    }
    return null;
  }

  dynamic attr(document, String attrStr, int attrType) {
    if (document is Element || document is Document) {
      if (attrType == SelectorAttr.met) {
        if (attrStr == "text") {
          return (document as Element).text;
        }
      } else if (attrType == SelectorAttr.attr) {
        return (document as Element).attributes[attrStr];
      }
    } else if (document is List) {
      List result = [];
      for (final d in document) {
        if (d == null) {
          continue;
        }
        var temp = this.attr(d, attrStr, attrType);
        if (temp != null) {
          result.add(temp);
        }
      }
      if (result.length == 1) {
        return result[0];
      } else if (result.length > 1) {
        return result;
      }
    }
    return null;
  }
}

List<String> getRuleList(String rule) {
  rule = rule.replaceAll("'", "\"");
  List<String> ruleList = [];
  rule.split(".").forEach((item) {
    ruleList.add(item.replaceAll("@", "."));
  });
  return ruleList;
}

class SelectorTag {
  static const em = 0;
  static const tag = 1;
  static const cls = 2;
  static const id = 4;
  static const Map<int, String> regMap = {
    SelectorTag.em: "",
    SelectorTag.tag: r"^(\w+)",
    SelectorTag.cls: r"^\.(\w+)",
    SelectorTag.id: r"^\#(\w+)",
  };
  static const Map<int, String> prefixMap = {
    SelectorTag.em: "",
    SelectorTag.tag: "",
    SelectorTag.cls: ".",
    SelectorTag.id: "#",
  };

  static int get(String str) {
    if (RegExp(SelectorTag.regMap[SelectorTag.tag]).hasMatch(str)) {
      return SelectorTag.tag;
    } else if (RegExp(SelectorTag.regMap[SelectorTag.cls]).hasMatch(str)) {
      return SelectorTag.cls;
    } else if (RegExp(SelectorTag.regMap[SelectorTag.id]).hasMatch(str)) {
      return SelectorTag.id;
    }
    return SelectorTag.em;
  }

  static String getTag(String str) {
    int type = SelectorTag.get(str);
    if (type == SelectorTag.em) {
      return '';
    }
    return (new RegExp(SelectorTag.regMap[type])).firstMatch(str).group(1);
  }
}

class SelectorProp {
  static const em = 0;
  static const child = 1;
  static const prop = 2;
  static const Map<int, String> regMap = {
    SelectorProp.em: "",
    SelectorProp.child: r'\[(\d+)?\]',
    SelectorProp.prop: r'\[(\w+)\=([\"\w\:]+)?\]',
  };

  static int get(String str) {
    if (RegExp(SelectorProp.regMap[SelectorProp.child]).hasMatch(str)) {
      return SelectorProp.child;
    } else if (RegExp(SelectorProp.regMap[SelectorProp.prop]).hasMatch(str)) {
      return SelectorProp.prop;
    }
    return SelectorProp.em;
  }
  static int getChild(String selector) {
    return int.parse((new RegExp(SelectorProp.regMap[SelectorProp.child])).firstMatch(selector).group(1));
  }
  static TagProp getProp(String selector) {
    var match = (new RegExp(SelectorProp.regMap[SelectorProp.prop])).firstMatch(selector);
    return TagProp(match.group(1), match.group(2));
  }
}

class TagProp {
  String key;
  String value;
  TagProp(this.key, this.value);
}

class SelectorAttr {
  static const em = 0;
  static const met = 1;
  static const attr = 2;
  static const Map<int, String> regMap = {
    SelectorAttr.em: "",
    SelectorAttr.met: r'\:(\w+)$',
    SelectorAttr.attr: r'\((\w+)?\)$',
  };

  static int get(String str) {
    if (RegExp(SelectorAttr.regMap[SelectorAttr.met]).hasMatch(str)) {
      return SelectorAttr.met;
    } else if (RegExp(SelectorAttr.regMap[SelectorAttr.attr]).hasMatch(str)) {
      return SelectorAttr.attr;
    }
    return SelectorAttr.em;
  }

  static String getAttr(String str) {
    int attrType = SelectorAttr.get(str);
    if (attrType == SelectorAttr.met) {
      return (new RegExp(SelectorAttr.regMap[SelectorAttr.met])).firstMatch(str).group(1);
    } else if (attrType == SelectorAttr.attr) {
      return (new RegExp(SelectorAttr.regMap[SelectorAttr.attr])).firstMatch(str).group(1);
    }
    return null;
  }
}