import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:flutter/material.dart';

class MoneyTextWidget extends StatelessWidget {
  double value;
  double fontSize;
  FontWeight fontWeight;

  MoneyTextWidget({this.value = 0.0, this.fontSize = 16, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    if (value < 0) color = Colors.red;
    if (value > 0) color = Colors.green;

    return Text(
      (value > 0 ? "+" : "") + GeralUtil.doubleToMoney(value),
      style: TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
    );
  }
}
