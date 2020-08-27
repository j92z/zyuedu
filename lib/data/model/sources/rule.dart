class SourcesRule {
  String ruleString;
  List<RuleItem> ruleList;
  SourcesRule(String ruleString) {
    this.ruleString = ruleString;
    this.__init();
  }

  void __init() {
    List<String> rules = this.ruleString.split(".");
    rules.forEach((rule) {
      int ruleType = RuleType.getRuleType(rule);
      print(rule);
      print(ruleType);
    });
  }
}

class RuleItem {
  String text;
  String name;
  int type = RuleType.tag;
  int child;
  Map<String, dynamic> prop;
}

class RuleType {
  static const em = 0;
  static const tag = 1;
  static const cls = 2;
  static const id = 4;
  static const child = 8;
  static const prop = 16;

  static int getRuleType(String str) {
    int type = 0;
    if (RegExp(r"^\@\w+").hasMatch(str)) {
      type += RuleType.cls;
    } else if (RegExp(r"^\#\w+").hasMatch(str)) {
      type += RuleType.id;
    } else if (RegExp(r"^\w+").hasMatch(str)) {
      type += RuleType.tag;
    }
    if (RegExp(r"\[\w+\=\w+\]$").hasMatch(str)) {
      type += RuleType.prop;
    } else if (RegExp(r"\[\d+\]$").hasMatch(str)) {
      type += RuleType.child;
    }
    return type;
  }
}