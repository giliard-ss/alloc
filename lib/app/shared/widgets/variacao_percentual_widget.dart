import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:flutter/material.dart';

class VariacaoPercentualWidget extends StatelessWidget {
  final double value;
  VariacaoPercentualWidget({this.value = 0});

  @override
  Widget build(BuildContext context) {
    String sinal = value > 0 ? "+" : "";
    Color color = Colors.grey;

    if (value < 0)
      color = Colors.red;
    else if (value > 0) color = Colors.green;

    String text = GeralUtil.limitaCasasDecimais(value).toString();

    if (text.contains(".")) {
      if (text.split(".")[1].length == 1) {
        text += "0";
      }
      text = text.replaceAll(".", ",");
    } else {
      text += ",00";
    }

    text = sinal + text + "%";

    return Text(
      text,
      style: TextStyle(fontSize: 13, color: color),
    );
  }
}
