class Utils {
  static String hideString(String org, {int max = 0}) {
    int len = org.length;
    if (len < 6) {
      return "*****";
    }
    if (max > 0 && len > max) {
      len = max;
    }
    int half = (len / 2).round();
    String postFix = '';
    for (int i = 0; i < half; i++) {
      postFix += '*';
    }
    return org.substring(0, half) + postFix;
  }
}
