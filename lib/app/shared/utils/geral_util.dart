import 'package:flutter_masked_text/flutter_masked_text.dart';

class GeralUtil {
  static double variacaoPercentualDeXparaY(double x, double y) {
    if (x == 0) return 0;
    return ((y * 100) / x) - 100;
  }

  static double limitaCasasDecimais(double value, {casasDecimais = 2}) {
    return double.parse((value).toStringAsFixed(casasDecimais));
  }

  static String doubleToMoney(double value, {leftSymbol: 'R\$ ', bool showSinalNegativo = true}) {
    var moneyController = MoneyMaskedTextController(leftSymbol: leftSymbol);

    moneyController.updateValue(value);
    return (showSinalNegativo && value < 0 ? "-" : "") + moneyController.text;
  }

  static String numToMoney(num value, {leftSymbol: 'R\$ '}) {
    if (value == null) value = 0;
    return doubleToMoney(value.toDouble(), leftSymbol: leftSymbol);
  }

  static List mapToList(Map<String, dynamic> map) {
    List result = [];
    map.entries.forEach((e) => result.add(e.value));
    return result;
  }
}
