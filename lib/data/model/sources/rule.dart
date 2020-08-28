class SourcesRule {
  String ruleString;
  String rule;
  List<String> ruleList = [];
  SourcesRule(String ruleString) {
    this.ruleString = ruleString.replaceAll("'", "\"");
    // this.rule = this.ruleString.split(".").join(" ").replaceAll("@", ".");
    this.__init();
  }

  void __init() {
    List<String> rules = this.ruleString.split(".");
    rules.forEach((rule) {
      this.ruleList.add(RuleItem(rule).rule);
    });
    this.rule = this.ruleList.join(" ");
  }

  String get() {
    return this.rule;
  }
}

class RuleItem {
  String text = '';
  String tag = '';
  String rule = '';
  int type = RuleType.tag;
  String prop;

  RuleItem(String rule) {
    this.text = rule;
    this.__init();
  }

  void __init() {
    this.type = RuleType.getRuleType(this.text);
    if (this.type != 0) {
      this.tag = (new RegExp(RuleType.regMap[this.type])).firstMatch(this.text).group(1);
      this.rule = RuleType.prefixMap[this.type] + this.tag;
    }
    if (RuleType.hasProp(this.text)) {
      this.prop = (new RegExp(RuleType.regMap[RuleType.prop])).firstMatch(this.text).group(1);
      this.rule += "[" + this.prop + "]";
    }
  }
}

class RuleType {
  static const em = 0;
  static const tag = 1;
  static const cls = 2;
  static const id = 4;
  static const prop = 8;
  static const Map<int, String> regMap = {
    RuleType.em: "",
    RuleType.tag: r"^(\w+)",
    RuleType.cls: r"^\@(\w+)",
    RuleType.id: r"^\#(\w+)",
    RuleType.prop: r'\[(.+)?\]$',
  };

  static const Map<int, String> prefixMap = {
    RuleType.em: "",
    RuleType.tag: "",
    RuleType.cls: ".",
    RuleType.id: "#",
  };

  static int getRuleType(String str) {
    if (RegExp(RuleType.regMap[RuleType.tag]).hasMatch(str)) {
      return RuleType.tag;
    } else if (RegExp(RuleType.regMap[RuleType.cls]).hasMatch(str)) {
      return RuleType.cls;
    } else if (RegExp(RuleType.regMap[RuleType.id]).hasMatch(str)) {
      return RuleType.id;
    }
    return RuleType.em;
  }

  static bool hasProp(String str) {
    return RegExp(RuleType.regMap[RuleType.prop]).hasMatch(str);
  }
}