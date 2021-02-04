class GeralUtil {
  static double limitaCasasDecimais(double value, {casasDecimais = 2}) {
    return double.parse((value).toStringAsFixed(casasDecimais));
  }

  static List mapToList(Map<String, dynamic> map) {
    List result = [];
    map.entries.forEach((e) => result.add(e.value));
    return result;
  }
}
