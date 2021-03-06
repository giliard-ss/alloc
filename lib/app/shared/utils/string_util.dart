class StringUtil {
  static bool isEmpty(String value) {
    return value == null || value.isEmpty;
  }

  static bool isNotEmpty(String value) {
    return !isEmpty(value);
  }
}
