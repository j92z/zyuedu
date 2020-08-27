class Regs {
  static String getHtmlByTag(String html, String tag) {
    String regString = "<$tag.*?>(.*?)</$tag>";
    RegExp htmlReg = new RegExp(regString);
    return htmlReg.firstMatch(html).group(1);
  }

  static String getRuleType(String rule) {

  }
}