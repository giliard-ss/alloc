import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:flutter/material.dart';

class MoneyTextWidget extends StatelessWidget {
  double value;
  double fontSize;
  FontWeight fontWeight;
  Color color;
  bool showSinal;

  MoneyTextWidget(
      {this.value = 0.0, this.fontSize = 16, this.fontWeight, this.color, this.showSinal = true});

  @override
  Widget build(BuildContext context) {
    definirCor();
    return Text(
      getSinal() + GeralUtil.doubleToMoney(value, showSinalNegativo: showSinal),
      style: TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
    );
  }

  String getSinal() {
    if (!showSinal || value == 0) return "";
    return value > 0 ? "+" : "-";
  }

  definirCor() {
    if (color != null) return;

    color = Colors.grey;
    if (value < 0) color = Colors.red;
    if (value > 0) color = Colors.green;
  }
}
