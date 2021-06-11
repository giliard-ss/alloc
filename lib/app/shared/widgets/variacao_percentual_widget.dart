import 'package:alloc/app/shared/utils/geral_util.dart';
import 'package:flutter/material.dart';

class VariacaoPercentualWidget extends StatelessWidget {
  double value;
  final double fontSize;
  final bool withSinal;
  final int casasDecimais;
  final bool withIcon;
  final FontWeight fontWeight;
  final MainAxisAlignment mainAxisAlignment;

  VariacaoPercentualWidget(
      {this.value = 0,
      this.fontSize = 13,
      this.withSinal = true,
      this.casasDecimais = 2,
      this.withIcon = false,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.fontWeight = FontWeight.normal}) {
    value = GeralUtil.limitaCasasDecimais(value, casasDecimais: casasDecimais);
  }

  String getSinal() {
    if (!withSinal) return "";

    if (value > 0) return "+";
    //if (value < 0) return "-";
    return "";
  }

  Widget getIcon() {
    if (!withIcon || value == 0) return Container();

    Color color = value > 0 ? Colors.green : Colors.red;
    if (value > 0)
      return Icon(
        Icons.call_made_rounded,
        size: fontSize,
        color: color,
      );
    return Icon(
      Icons.south_east_rounded,
      size: fontSize,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    String sinal = getSinal();
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

    return Row(
      mainAxisAlignment: this.mainAxisAlignment,
      children: [
        Text(text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
            )),
        getIcon(),
      ],
    );
  }
}
